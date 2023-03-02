if not techover.technology then techover.technology = {} end

local utils = require("__technology-overload__/" .. "utils")
local floor = math.floor
local str   = tostring

local MAX_UINT32 = 0xFFFFFFFF
local MAX_INT64  = 0x7FFFFFFFFFFFFFFF
local MAX_DOUBLE = 0x1.FFFFFFFFFFFFFP+1023

---------------------------------------------------------------------------
-- -- -- Helper Functions
---------------------------------------------------------------------------

-- @ tableIn: Table
-- @ element: any
local function tableContains(tableIn, element)
  if not tableIn then return false end
  for ___, value in pairs(tableIn) do
    if value == element then
      return true
    end
  end
  return false
end

-- Whether a Prototype/Technology has a count_formula or not
-- @ technology: Prototype/Technology
local function hasFormula(technology)
  if technology.unit.count_formula ~= nil then return true end
  return false
end

-- @ technology: Prototype/Technology
local function hasUnit(technology)
  if technology.unit ~= nil then return true end
  return false
end

-- @ technology: Prototype/Technology
local function hasCount(technology)
  if technology.unit.count ~= nil then return true end
  return false
end

-- @ technology: Prototype/Technology
local function getTechnologyUnitCount(technology)
  if hasUnit(technology) then
    if hasCount(technology) then
      return technology.unit.count
    end
  end
  return nil
end

-- @ technology: Prototype/Technology
local function getTechnologyUnitFormula(technology)
  if hasUnit(technology) then
    if hasFormula(technology) then
      return technology.unit.count_formula
    end
  end
  return nil
end

-- @ technology: Prototype/Technology
local function getTechnologyPrerequisites(technology)
  local prerequisites = {}
  for _, prerequisite in pairs(technology.prerequisites) do
    table.insert(prerequisites, data.raw.technology[prerequisite])
  end
  return prerequisites
end

-- @ technologyName: String
-- @ value: int
local function setTechnologyUnitCount(technologyName, value)
  data.raw.technology[technologyName].unit.count = value
end

-- @ technologyName: String
-- @ formula: string
local function setTechnologyUnitFormula(technologyName, formula)
  data.raw.technology[technologyName].unit.count_formula = formula
end

-- @ tech: Tech object
-- cost: number (int/float)
local function applyTechnologyCostModifier(tech, cost, formula)
  if tech.count ~= nil then
    setTechnologyUnitCount(tech.name, cost)
  end
  if tech.formula ~= nil then
    setTechnologyUnitFormula(tech.name, formula)
  end
end

-- @ technology: Prototype/Technology
local function hasPrerequisites(technology)
  if not technology then return false end
  if technology.prerequisites ~= nil then
    if #technology.prerequisites == 0 then return false end
    return true
  end
  return false
end

-- @ technology: Prototype/Technology
local function getTechnologyDepth(technology)
  -- check technology integrity
  if not technology then return 0 end
  -- check if technology's depth is already known (for opptimization)
  if technology_overload_depths[technology.name] ~= nil then
    return technology_overload_depths[technology.name]
  end
  -- compute technology's depth recursively otherwise
  local currentDepth = 1
  if hasPrerequisites(technology) and (#technology.prerequisites > 0) then
    local depths = {}
    for _, prerequisite in pairs(technology.prerequisites) do
      table.insert(depths, getTechnologyDepth(data.raw.technology[prerequisite]))
    end
    table.sort(depths)
    currentDepth = currentDepth + depths[#depths]
  end
  -- update table of depths & return value
  technology_overload_depths[technology.name] = currentDepth
  return currentDepth
end

local function populateDepths()
  for key, technology in pairs(data.raw.technology) do 
    if technology and technology_overload_depths[technology.name] == nil then
      technology_overload_depths[technology.name] = getTechnologyDepth(technology)
    end
  end

  log("=== technology_overload_depths ===")
  log(serpent.block(technology_overload_depths))
end

local function findMaxDepth()
  return math.max(0, utils.max(technology_overload_depths))
end

-- @ base: number
-- @ power: number
local function Exp(base, power)
  return base ^ power
end

-- @ currentDepth: int
-- @ p as preset
local function BaseDepth(currentDepth, p)
  if not p.applyDepth then return Exp(1, p.depthExp) end
  if p.inverseDepth then
    return Exp(p.maxDepth - currentDepth + 1, p.depthExp)
  end
  return Exp(currentDepth, p.depthExp)
end

---------------------------------------------------------------------------
-- -- -- Cost Computation
---------------------------------------------------------------------------

-- @ technology: Prototype/Technology
local function Fibonacci(technology, p)
  local currentCost = getTechnologyUnitCount(technology) or 0
  local currentDepth = getTechnologyDepth(technology)
  local prerequisiteCost = 0
  if hasPrerequisites(technology) then
    local depth = {}
    for _, prerequisiteName in pairs(technology.prerequisites) do
      local prerequisite = data.raw.technology[prerequisiteName]
      table.insert(depth, prerequisite)
      if hasPrerequisites(prerequisite) then
        for _, prerequisiteName2 in pairs(prerequisite.prerequisites) do
          table.insert(depth, data.raw.technology[prerequisiteName2])
        end
      end
    end
    local sumFibonacci = 0
    for _, tech in pairs(depth) do
      sumFibonacci = sumFibonacci + Fibonacci(tech, p)
    end
    prerequisiteCost = sumFibonacci
  end
  return floor(currentCost * p.treeCoefficient * BaseDepth(currentDepth, p) + prerequisiteCost)
end

-- @ technology: Prototype/Technology
-- @ p as preset of attributes:
  -- searchDepth: int,        refers to max depth to search. -1 means all depths
  -- treeCoefficient: double, multiplies cost by this value
  -- applyDepth: bool 0/1,    wheter to multiply depth coefficient
  -- depthExp: double,        power of the exponent base
  -- maxDepth: int,           max depth across the tech tree
  -- inverseDepth: bool 0/1,  wheter to apply reverse depth computation
local function exponentialCumulativeCost(technology, p)
  local currentCost = getTechnologyUnitCount(technology) or 0
  local currentDepth = getTechnologyDepth(technology)
  local prerequisiteCost = 0
  if hasPrerequisites(technology) and p.searchDepth then
    local depths = {}
    for _, prerequisite in pairs(technology.prerequisites) do
      table.insert(depths, exponentialCumulativeCost(data.raw.technology[prerequisite], p))
    end
    prerequisiteCost = utils.sum(depths)
  end
  return floor(currentCost * p.treeCoefficient * BaseDepth(currentDepth, p) + prerequisiteCost)
end

---------------------------------------------------------------------------
-- -- -- Difficulty Levels 
---------------------------------------------------------------------------

-- Fibonacci
local function difficultyFibonacci(techs, p)
  for _, tech in pairs(techs) do
    if tech.count ~= nil then
      setTechnologyUnitCount(tech.name, tech.ecc)
    end
    if tech.formula ~= nil then
      local formula = str(tech.ecc) .. '+(' .. tech.formula .. ')*' .. str(floor(p.treeCoefficient * BaseDepth(tech.depth, p)))
      setTechnologyUnitFormula(tech.name, formula)
    end
  end
end

-- Funnel
local function difficultyFunnel(techs, p)
  for _, tech in pairs(techs) do
    if tech.count ~= nil then
      setTechnologyUnitCount(tech.name, tech.ecc)
    end
    if tech.formula ~= nil then
      local formula = '(' .. tech.formula .. ')*' .. str(floor(BaseDepth(tech.depth, p)))
      setTechnologyUnitFormula(tech.name, formula)
    end
  end
end

-- Miserable Spoon (Funnel Squared * treeCoefficient)
local function difficultyMiserableSpoon(techs, p)
  for _, tech in pairs(techs) do
    if tech.count ~= nil then
      setTechnologyUnitCount(tech.name, tech.ecc)
    end
    if tech.formula ~= nil then
      local formula = '(' .. tech.formula .. ')*' .. str(floor(BaseDepth(tech.depth, p)))
      setTechnologyUnitFormula(tech.name, formula)
    end
  end
end

-- Spiral
local function difficultySpiral(techs, p)
  for _, tech in pairs(techs) do
    if tech.count ~= nil then
      setTechnologyUnitCount(tech.name, tech.ecc)
    end
    if tech.formula ~= nil then
      local formula = '(' .. tech.formula .. ')*' .. str(floor(BaseDepth(tech.depth, p) * p.treeCoefficient))
      setTechnologyUnitFormula(tech.name, formula)
    end
  end
end

-- Mad Spiral
local function difficultyMadSpiral(techs, p)
  for _, tech in pairs(techs) do
    if tech.count ~= nil then
      setTechnologyUnitCount(tech.name, tech.ecc)
    end
    if tech.formula ~= nil then
      local formula = str(tech.ecc) .. '+(' .. tech.formula .. ')*' .. str(floor(BaseDepth(tech.depth, p) * p.treeCoefficient))
      setTechnologyUnitFormula(tech.name, formula)
    end
  end
end

-- Tree
local function difficultyTree(techs, p)
  for _, tech in pairs(techs) do
    if tech.count ~= nil then
      setTechnologyUnitCount(tech.name, tech.ecc)
    end
    if tech.formula ~= nil then
      local formula = '(' .. tech.formula .. ')*' .. str(floor(BaseDepth(tech.depth, p) * p.treeCoefficient))
      setTechnologyUnitFormula(tech.name, formula)
    end
  end
end

-- Mad Tree
local function difficultyMadTree(techs, p)
  for _, tech in pairs(techs) do
    if tech.count ~= nil then
      setTechnologyUnitCount(tech.name, tech.ecc)
    end
    if tech.formula ~= nil then
      local formula = 'L*(' .. tech.formula .. ")*" .. str(p.treeCoefficient)
      local formula = str(tech.ecc) .. '+(' .. tech.formula .. ')*' .. str(floor(BaseDepth(tech.depth, p) * p.treeCoefficient))
      setTechnologyUnitFormula(tech.name, formula)
    end
  end
end

-- A Long Way Home
local function difficultyALongWayHome(techs, p)
  for _, tech in pairs(techs) do
    if tech.count ~= nil then
      setTechnologyUnitCount(tech.name, tech.ecc)
    end
    if tech.formula ~= nil then
      local formula = '(' .. tech.formula .. ')*' .. str(floor(BaseDepth(tech.depth, p) * p.treeCoefficient))
      setTechnologyUnitFormula(tech.name, formula)
    end
  end
end

-- Custom
local function difficultyCustom(techs, p)
  for _, tech in pairs(techs) do
    if tech.count ~= nil then
      setTechnologyUnitCount(tech.name, tech.ecc)
    end
    if tech.formula ~= nil then
      local formula = '(' .. tech.formula .. ')*' .. str(floor(BaseDepth(tech.depth, p) * p.treeCoefficient))
      setTechnologyUnitFormula(tech.name, formula)
    end
  end
end

---------------------------------------------------------------------------

techover.technology.getCount          = getTechnologyUnitCount
techover.technology.getFormula        = getTechnologyUnitFormula
techover.technology.getDepth          = getTechnologyDepth
techover.technology.getMaxDepth       = findMaxDepth
techover.technology.getExpCumCost     = exponentialCumulativeCost
techover.technology.getFibonacciCost  = Fibonacci
techover.technology.populateDepths    = populateDepths
techover.technology.None           = nil
techover.technology.Funnel         = difficultyFunnel
techover.technology.MiserableSpoon = difficultyMiserableSpoon
techover.technology.Tree           = difficultyTree
techover.technology.MadTree        = difficultyMadTree
techover.technology.Spiral         = difficultySpiral
techover.technology.MadSpiral      = difficultyMadSpiral
techover.technology.Fibonacci      = difficultyFibonacci
techover.technology.ALongWayHome   = difficultyALongWayHome
techover.technology.Custom         = difficultyCustom
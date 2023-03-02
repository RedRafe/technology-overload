-- -- Import libraries
local T      = techover.technology
local CONFIG = require("__technology-overload__/" .. "config")

-- 0. Populate tech tree depths
if not technology_overload_depths then technology_overload_depths = {} end
T.populateDepths()

-- A. get settings from startup
local difficulty      = settings.startup["to-difficulty"].value
local preset          = CONFIG.presets[difficulty]
      preset.maxDepth = T.getMaxDepth()
local database_techs  = {}

-- B. iterate data.raw and save technology info
local function computeCost(db, p, equation)
  for _, technology in pairs(data.raw.technology) do
    local tech = {}
  
    tech.name    = technology.name
    tech.count   = T.getCount(technology)
    tech.formula = T.getFormula(technology)
    tech.depth   = T.getDepth(technology)
    tech.ecc     = equation(technology, p)
  
    table.insert(db, tech)
  end
end

local function updatePresetParams()
  return {
    searchDepth     = settings.startup["to-searchDepth"].value,
    treeCoefficient = settings.startup["to-treeCoefficient"].value,
    applyDepth      = settings.startup["to-applyDepth"].value,
    depthExp        = settings.startup["to-depthExp"].value,
    inverseDepth    = settings.startup["to-inverseDepth"].value,
    maxDepth        = preset.maxDepth
  }
end

if settings.startup["to-allowCustomization"].value then
  preset = updatePresetParams()
end

-- C. apply difficulty multiplier
if difficulty == "None" then
  --pass

elseif difficulty == "Fibonacci" then
  computeCost(database_techs, preset, T.getFibonacciCost)
  T.Fibonacci(database_techs, preset)

elseif difficulty == "Funnel" then
  computeCost(database_techs, preset, T.getExpCumCost)
  T.Funnel(database_techs, preset)

elseif difficulty == "Miserable Spoon" then
  computeCost(database_techs, preset, T.getExpCumCost)
  T.MiserableSpoon(database_techs, preset)

elseif difficulty == "Spiral" then
  computeCost(database_techs, preset, T.getExpCumCost)
  T.Spiral(database_techs, preset)

elseif difficulty == "Mad Spiral" then
  computeCost(database_techs, preset, T.getExpCumCost)
  T.MadSpiral(database_techs, preset)

elseif difficulty == "Tree" then
  computeCost(database_techs, preset, T.getExpCumCost)
  T.Tree(database_techs, preset)

elseif difficulty == "Mad Tree" then
  computeCost(database_techs, preset, T.getExpCumCost)
  T.MadTree(database_techs, preset)

elseif difficulty == "A Long Way Home" then
  computeCost(database_techs, preset, T.getExpCumCost)
  T.ALongWayHome(database_techs, preset)

elseif difficulty == "Custom Exponential" then
  preset = updatePresetParams()
  computeCost(database_techs, preset, T.getExpCumCost)
  T.Custom(database_techs, preset)

elseif difficulty == "Custom Fibonacci" then
  computeCost(database_techs, preset, T.getFibonacciCost)
  T.Fibonacci(database_techs, preset)

end

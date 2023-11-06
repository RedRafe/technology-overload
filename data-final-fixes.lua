-- -- IMPORT LIBRARIES
local T      = techover.technology
local CONFIG = require 'config'

-- ============================================================================

-- Cache depth, Fibonacci's and cumulative costs to optimize recursion
if not technology_overload_depths     then technology_overload_depths     = {} end
if not technology_overload_fibonacci  then technology_overload_fibonacci  = {} end
if not technology_overload_cumulative then technology_overload_cumulative = {} end
T.cacheDepths()

-- ============================================================================

-- A. get settings from startup
local difficulty      = settings.startup['to-difficulty'].value
local preset          = CONFIG.presets[difficulty]
      preset.maxDepth = T.getMaxDepth()
local tech_db  = {}

-- B. iterate data.raw and save technology info
if settings.startup['to-allowCustomization'].value then
  preset = T.updatePresetParams()
end

-- C. apply difficulty multiplier
if difficulty == 'None' then
  --pass

elseif difficulty == 'Fibonacci' then
  T.computeCost(tech_db, preset, T.getFibonacciCost)
  T.Fibonacci(tech_db, preset)

elseif difficulty == 'Funnel' then
  T.computeCost(tech_db, preset, T.getExpCumCost)
  T.Funnel(tech_db, preset)

elseif difficulty == 'Miserable Spoon' then
  T.computeCost(tech_db, preset, T.getExpCumCost)
  T.MiserableSpoon(tech_db, preset)

elseif difficulty == 'Spiral' then
  T.computeCost(tech_db, preset, T.getExpCumCost)
  T.Spiral(tech_db, preset)

elseif difficulty == 'Mad Spiral' then
  T.computeCost(tech_db, preset, T.getExpCumCost)
  T.MadSpiral(tech_db, preset)

elseif difficulty == 'Tree' then
  T.computeCost(tech_db, preset, T.getExpCumCost)
  T.Tree(tech_db, preset)

elseif difficulty == 'Mad Tree' then
  T.computeCost(tech_db, preset, T.getExpCumCost)
  T.MadTree(tech_db, preset)

elseif difficulty == 'A Long Way Home' then
  T.computeCost(tech_db, preset, T.getExpCumCost)
  T.ALongWayHome(tech_db, preset)

elseif difficulty == 'Custom Exponential' then
  preset = T.updatePresetParams()
  T.computeCost(tech_db, preset, T.getExpCumCost)
  T.Custom(tech_db, preset)

elseif difficulty == 'Custom Fibonacci' then
  T.computeCost(tech_db, preset, T.getFibonacciCost)
  T.Fibonacci(tech_db, preset)

end

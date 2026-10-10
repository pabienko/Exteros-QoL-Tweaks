local recycler_return = require("features.recycler-return")
local fuel_stats = require("features.fuel-stats")
local roboports = require("features.roboports")

local recycler_return_enabled = settings.startup["exteros-qol-tweaks-recycler-return-enabled"]
if recycler_return_enabled and recycler_return_enabled.value then
  recycler_return.apply()
end

local fuel_stats_enabled = settings.startup["exteros-qol-tweaks-fuel-stats-enabled"]
if fuel_stats_enabled and fuel_stats_enabled.value then
  fuel_stats.apply()
end

if settings.startup["exteros-qol-tweaks-roboports-enabled"].value then
  roboports.apply()
end

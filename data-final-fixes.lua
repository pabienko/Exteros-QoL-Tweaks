local recycler_return = require("features.recycler-return")
local fuel_stats = require("features.fuel-stats")
local roboports = require("features.roboports")

if settings.startup["exteros-qol-tweaks-recycler-return-enabled"].value then
  recycler_return.apply()
end

if settings.startup["exteros-qol-tweaks-fuel-stats-enabled"].value then
  fuel_stats.apply()
end

if settings.startup["exteros-qol-tweaks-roboports-enabled"].value then
  roboports.apply()
end

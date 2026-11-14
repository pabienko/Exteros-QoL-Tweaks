local manifest_lib = require("__exteros-lib__.internal.manifest")
local lib_settings = require("__exteros-lib__.internal.settings")
local manifest = require("manifest")
local fuels = require("prototypes.fuels")

---@return ExterosLibManifest
local function manifest_for_startup()
  if mods["recycler"] then
    return manifest
  end

  local filtered = {}
  for key, value in pairs(manifest) do
    filtered[key] = value
  end

  local features = {}
  for _, feature in ipairs(manifest.features) do
    if feature.name ~= "recycler-return" then
      table.insert(features, feature)
    end
  end
  filtered.features = features

  return filtered
end

local startup_manifest = manifest_for_startup()
lib_settings.extend(startup_manifest)

---@type ExterosLibFeatureDef?
local fuel_stats_feature = nil
local fuel_stats_feature_index = nil
for index, feature in ipairs(startup_manifest.features) do
  if feature.name == "fuel-stats" then
    fuel_stats_feature = feature
    fuel_stats_feature_index = index
    break
  end
end

if fuel_stats_feature and not manifest_lib.blocked_by(fuel_stats_feature, mods) then
  local feature_order = string.format("%03d", fuel_stats_feature_index)
  for index, fuel in ipairs(fuels) do
    if not fuel.space_age or mods["space-age"] then
      local nn = string.format("%02d", index)
      ---@type string
      local name_suffix = fuel.space_age and "-space-age" or ""
      local fuel_settings = {
        {
          type = "double-setting",
          name = "exteros-tweaks-fuel-stats-" .. fuel.name .. "-energy",
          setting_type = "startup",
          default_value = fuel.energy,
          minimum_value = 0.01,
          order = feature_order .. "-002-" .. nn .. "-a",
          localised_name = { "exteros-tweaks.fuel-energy-name" .. name_suffix, { "item-name." .. fuel.name } },
          localised_description = { "exteros-tweaks.fuel-energy-description", { "item-name." .. fuel.name }, tostring(fuel.energy) }
        }
      }

      if fuel.accel ~= nil then
        table.insert(fuel_settings, {
          type = "double-setting",
          name = "exteros-tweaks-fuel-stats-" .. fuel.name .. "-accel",
          setting_type = "startup",
          default_value = fuel.accel,
          minimum_value = 0,
          maximum_value = 20,
          order = feature_order .. "-002-" .. nn .. "-b",
          localised_name = { "exteros-tweaks.fuel-accel-name" .. name_suffix, { "item-name." .. fuel.name } },
          localised_description = { "exteros-tweaks.fuel-accel-description", { "item-name." .. fuel.name }, tostring(fuel.accel) }
        })
      end

      if fuel.speed ~= nil then
        table.insert(fuel_settings, {
          type = "double-setting",
          name = "exteros-tweaks-fuel-stats-" .. fuel.name .. "-speed",
          setting_type = "startup",
          default_value = fuel.speed,
          minimum_value = 0,
          maximum_value = 20,
          order = feature_order .. "-002-" .. nn .. "-c",
          localised_name = { "exteros-tweaks.fuel-speed-name" .. name_suffix, { "item-name." .. fuel.name } },
          localised_description = { "exteros-tweaks.fuel-speed-description", { "item-name." .. fuel.name }, tostring(fuel.speed) }
        })
      end

      data:extend(fuel_settings)
    end
  end
end

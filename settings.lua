---@diagnostic disable-next-line: unresolved-require
local conflicts = require("__Exteros-QoL-System__.core.conflicts")
local fuels = require("prototypes.fuels")

---@param feature string
---@return boolean
local function blocked(feature)
  return conflicts.is_blocked(feature, mods)
end

data:extend({
  {
    type = "bool-setting",
    name = "exteros-qol-tweaks-fuel-stats-enabled",
    setting_type = "startup",
    default_value = false,
    order = "a-a"
  },
  {
    type = "bool-setting",
    name = "exteros-qol-tweaks-recycler-return-enabled",
    setting_type = "startup",
    default_value = false,
    order = "a-b"
  },
  {
    type = "bool-setting",
    name = "exteros-qol-tweaks-roboports-enabled",
    setting_type = "startup",
    default_value = false,
    order = "a-c"
  },
  {
    type = "bool-setting",
    name = "exteros-qol-tweaks-roboport-charging-quality-scaling",
    setting_type = "startup",
    default_value = false,
    order = "b-a"
  },
  {
    type = "double-setting",
    name = "exteros-qol-tweaks-roboport-charging-speed-multiplier",
    setting_type = "startup",
    default_value = 1.0,
    minimum_value = 0.1,
    maximum_value = 10.0,
    order = "b-b"
  }
})

if (mods["quality"] or mods["recycler"]) and not blocked("cheat-recycler") then
  data:extend({
    {
      type = "int-setting",
      name = "exteros-qol-cheat-recycler-return-rate",
      setting_type = "startup",
      default_value = 25,
      minimum_value = 1,
      maximum_value = 100,
      order = "d-a"
    },
    {
      type = "string-setting",
      name = "exteros-qol-cheat-recycler-scope",
      setting_type = "startup",
      default_value = "self-only",
      allowed_values = {"self-only", "all"},
      order = "d-b"
    }
  })
end

if not blocked("cheat-fuel") then
  for index, fuel in ipairs(fuels) do
    if not fuel.space_age or mods["space-age"] then
      local nn = string.format("%02d", index)
      ---@type string
      local name_suffix = fuel.space_age and "-space-age" or ""
      local fuel_settings = {
        {
          type = "double-setting",
          name = "exteros-qol-cheat-fuel-" .. fuel.name .. "-energy",
          setting_type = "startup",
          default_value = fuel.energy,
          minimum_value = 0.01,
          order = "e-" .. nn .. "-a",
          localised_name = { "exteros-qol-tweaks.fuel-energy-name" .. name_suffix, { "item-name." .. fuel.name } },
          localised_description = { "exteros-qol-tweaks.fuel-energy-description", { "item-name." .. fuel.name }, tostring(fuel.energy) }
        }
      }

      if fuel.accel ~= nil then
        table.insert(fuel_settings, {
          type = "double-setting",
          name = "exteros-qol-cheat-fuel-" .. fuel.name .. "-accel",
          setting_type = "startup",
          default_value = fuel.accel,
          minimum_value = 0,
          maximum_value = 20,
          order = "e-" .. nn .. "-b",
          localised_name = { "exteros-qol-tweaks.fuel-accel-name" .. name_suffix, { "item-name." .. fuel.name } },
          localised_description = { "exteros-qol-tweaks.fuel-accel-description", { "item-name." .. fuel.name }, tostring(fuel.accel) }
        })
      end

      if fuel.speed ~= nil then
        table.insert(fuel_settings, {
          type = "double-setting",
          name = "exteros-qol-cheat-fuel-" .. fuel.name .. "-speed",
          setting_type = "startup",
          default_value = fuel.speed,
          minimum_value = 0,
          maximum_value = 20,
          order = "e-" .. nn .. "-c",
          localised_name = { "exteros-qol-tweaks.fuel-speed-name" .. name_suffix, { "item-name." .. fuel.name } },
          localised_description = { "exteros-qol-tweaks.fuel-speed-description", { "item-name." .. fuel.name }, tostring(fuel.speed) }
        })
      end

      data:extend(fuel_settings)
    end
  end
end

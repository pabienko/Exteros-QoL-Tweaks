---@diagnostic disable-next-line: unresolved-require
local debug = require("__Exteros-QoL-System__.core.debug")

local M = {}

local ROBOPORT_TYPES = { "roboport", "roboport-equipment" }

---@param value any
---@return number?, string?
local function parse_energy(value)
  if type(value) ~= "string" then return nil end
  local number, unit = value:match("^(%d+%.?%d*)(%a+)$")
  if not number then return nil end
  return tonumber(number), unit
end

---@param value number
---@param unit string
---@return string
local function format_energy(value, unit)
  local formatted = string.format("%.6f", value)
  formatted = formatted:gsub("0+$", "")
  formatted = formatted:gsub("%.$", "")
  return formatted .. unit
end

---@param multiplier number
local function apply_charging_speed(multiplier)
  for _, t in ipairs(ROBOPORT_TYPES) do
    local protos = data.raw[t]
    if protos then
      for _, proto in pairs(protos) do
        local number, unit = parse_energy(proto.charging_energy)
        if number and unit then
          proto.charging_energy = format_energy(number * multiplier, unit)
        else
          debug.log("Prototype '" .. proto.name .. "' has no parseable charging_energy, skipping.", "tweaks")
        end
      end
    end
  end
end

local function apply_quality_scaling()
  for _, t in ipairs(ROBOPORT_TYPES) do
    local protos = data.raw[t]
    if protos then
      for _, proto in pairs(protos) do
        proto.charging_station_count_affected_by_quality = true
      end
    end
  end
end

function M.apply()
  if settings.startup["exteros-qol-tweaks-roboport-charging-quality-scaling"].value then
    apply_quality_scaling()
  end

  local multiplier = settings.startup["exteros-qol-tweaks-roboport-charging-speed-multiplier"].value --[[@as number]]
  if multiplier ~= 1.0 then
    apply_charging_speed(multiplier)
  end
end

return M

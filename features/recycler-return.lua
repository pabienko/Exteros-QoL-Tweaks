---@diagnostic disable-next-line: unresolved-require
local debug = require("__Exteros-QoL-System__.core.debug")

local M = {}

---@param recipe table
---@return boolean
local function is_pure_recycling(recipe)
  if type(recipe.categories) == "table" then
    return #recipe.categories == 1 and recipe.categories[1] == "recycling"
  end
  if recipe.category ~= "recycling" then return false end
  return recipe.additional_categories == nil or #recipe.additional_categories == 0
end

function M.apply()
  local setting = settings.startup["exteros-qol-cheat-recycler-return-rate"]
  if not setting then return end

  local rate = setting.value --[[@as number]]
  if rate == 25 then return end

  local k = rate / 25
  local scope_setting = settings.startup["exteros-qol-cheat-recycler-scope"]
  local scope = scope_setting and scope_setting.value or "self-only"

  for _, recipe in pairs(data.raw.recipe) do
    if is_pure_recycling(recipe) and recipe.ingredients and recipe.results then
      local self_recycling = #recipe.ingredients == 1 and #recipe.results == 1
        and recipe.results[1].name == recipe.ingredients[1].name

      if self_recycling then
        local result = recipe.results[1] --[[@as table]]
        if result.independent_probability ~= nil then
          result.independent_probability = rate / 100
        elseif result.probability ~= nil then
          result.probability = rate / 100
        end
      elseif scope == "all" then
        for _, result in pairs(recipe.results) do
          if result.type == "item" then
            if result.amount ~= nil then
              local expected = math.floor(result.amount) + (result.extra_count_fraction or 0)
              local new_expected = expected * k
              local new_amount = math.floor(new_expected)
              local new_fraction = new_expected - new_amount

              result.amount = new_amount
              result.extra_count_fraction = new_fraction > 0 and new_fraction or nil
            else
              debug.log("Recipe '" .. recipe.name .. "' result '" .. tostring(result.name) .. "' has no numeric amount, skipping.", "tweaks")
            end
          end
        end
      end
    end
  end
end

return M

local HUB_PER_USER = {}
local HUB_GLOBAL = {}
local HUB_GROUPS = {}

remote.add_interface("exteros-qol-addon-tweaks", {
  hub_settings = function()
    return {
      per_user = HUB_PER_USER,
      global = HUB_GLOBAL,
      title = {"mod-name.Exteros-QoL-Tweaks"},
      color = "#8FD18F",
      groups = HUB_GROUPS
    }
  end,
  set_hub_setting = function(_player_index, _name, _value, _scope) end,
})

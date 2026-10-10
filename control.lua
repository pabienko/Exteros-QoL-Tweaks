local HUB_GROUPS = {}

remote.add_interface("exteros-qol-addon-tweaks", {
  hub_settings = function()
    return {
      color = "#8FD18F",
      groups = HUB_GROUPS
    }
  end,
  set_hub_setting = function(_player_index, _name, _value, _scope) end,
})

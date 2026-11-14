return {
  format = 1,
  mod = "Exteros-QoL-Tweaks",
  prefix = "exteros-tweaks-",
  features = {
    {
      name = "fuel-stats",
      conflicts = { "AdjustableFuelStats" },
      startup = {
        { name = "enabled", type = "bool", default = false },
      },
    },
    {
      name = "recycler-return",
      conflicts = { "adjustable_recycler" },
      startup = {
        { name = "enabled", type = "bool", default = false },
        { name = "rate", type = "int", default = 25, min = 1, max = 100 },
        { name = "scope", type = "string", default = "self-only", allowed = { "self-only", "all" } },
      },
    },
    {
      name = "roboports",
      startup = {
        { name = "enabled", type = "bool", default = false },
        { name = "charging-quality-scaling", type = "bool", default = false },
        { name = "charging-speed-multiplier", type = "double", default = 1.0, min = 0.1, max = 10.0 },
      },
    },
    {
      name = "debug",
      startup = {
        { name = "enabled", type = "bool", default = false, hidden = true },
      },
    },
  },
}

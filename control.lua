local lib_event = require("__exteros-lib__.event")
local migrate = require("__exteros-lib__.internal.migrate")

migrate.register({
  version = 1,
  init = function() end,
})

lib_event.register()

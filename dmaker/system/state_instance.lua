local class = require("dmaker.system.middleclass")
local settings = require("dmaker.system.settings")

local StateInstance = class("dmaker.state")


function StateInstance:initialize(...)
	self._actions = {...}
	self._id = settings.get_next_id()
end


function StateInstance:get_id()
	return self._id
end


return StateInstance

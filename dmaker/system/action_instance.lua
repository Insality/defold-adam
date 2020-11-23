local class = require("dmaker.libs.middleclass")
local const = require("dmaker.const")

local ActionInstance = class("dmaker.action")


function ActionInstance:initialize(name, callback)
	self._name = name
	self._callback = callback or const.EMPTY_FUNCTION
end


function ActionInstance:get_name()
	return self._name
end


function ActionInstance:trigger(...)
	self._callback(self, ...)
end


function ActionInstance:event(event_name, ...)
	assert(self._state, const.ERRORS.NO_BINDED_STATE)
	self._state:event(event_name, ...)
end


function ActionInstance:set_state(state_instance)
	self._state = state_instance
end


return ActionInstance

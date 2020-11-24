local class = require("dmaker.libs.middleclass")
local const = require("dmaker.const")

local ActionInstance = class("dmaker.action")


function ActionInstance:initialize(name, trigger_callback, release_callback)
	self._name = name
	self._trigger_callback = trigger_callback or const.EMPTY_FUNCTION
	self._release_callback = release_callback
	self._state = nil

	self.context = {}
end


function ActionInstance:get_name()
	return self._name
end


function ActionInstance:trigger(...)
	self._trigger_callback(self, ...)
end


function ActionInstance:release(...)
	if not self._release_callback then
		return
	end

	self._release_callback(self, ...)
end


function ActionInstance:event(event_name, ...)
	assert(self._state, const.ERROR.NO_BINDED_STATE)
	self._state:event(event_name, ...)
end


function ActionInstance:set_state_instance(state_instance)
	self._state = state_instance
end


function ActionInstance:get_value(variable_name)
	return self._state:get_value(variable_name)
end


function ActionInstance:set_value(variable_name, value)
	return self._state:set_value(variable_name, value)
end


function ActionInstance:get_param(param)
	if type(param) == const.TYPE_TABLE and param._type == const.GET_ACTION_VALUE then
		return self:get_value(param._name)
	end
	return param
end


return ActionInstance

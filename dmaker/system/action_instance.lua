local class = require("dmaker.libs.middleclass")
local const = require("dmaker.const")

local ActionInstance = class("dmaker.action")


function ActionInstance:initialize(name, trigger_callback, release_callback)
	self._name = name
	self._trigger_callback = trigger_callback or const.EMPTY_FUNCTION
	self._release_callback = release_callback
	self._state = nil

	self._is_every_frame = false
	self._is_periodic = false
	self._periodic_timer = false
	self._is_deferred = false
	self._periodic_timer_current = false
	self._on_finish_callback = nil

	self.context = {}
end


function ActionInstance:update(dt)
	if self._is_every_frame then
		self:trigger()
	end
	if self._is_periodic then
		self._periodic_timer_current = (self._periodic_timer_current or self._periodic_timer) - dt
		if self._periodic_timer_current <= 0 then
			self:trigger()
			self._periodic_timer_current = self._periodic_timer
		end
	end
end


function ActionInstance:get_name()
	return self._name
end


function ActionInstance:trigger()
	self:release()
	self._trigger_callback(self)
	if not self._is_deferred then
		self:finished()
	end
end


function ActionInstance:release()
	self._periodic_timer_current = false
	if not self._release_callback then
		return
	end

	self._release_callback(self)
end


function ActionInstance:finished()
	local callback = self._on_finish_callback
	self._on_finish_callback = nil
	if callback then
		callback()
	end
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


function ActionInstance:get_dmaker_instance()
	return self._state:get_dmaker_instance()
end


function ActionInstance:get_param(param)
	if type(param) == const.TYPE_TABLE and param._type == const.GET_ACTION_VALUE then
		return self:get_value(param._name)
	end
	return param
end


function ActionInstance:set_every_frame(state)
	self._is_every_frame = state
	self:set_deferred(true)
end


function ActionInstance:set_periodic(seconds)
	local is_periodic = seconds and seconds > 0
	self._is_periodic = is_periodic
	self._periodic_timer = seconds
	self:set_deferred(true)
end


function ActionInstance:set_deferred(state)
	self._is_deferred = state
end


function ActionInstance:set_finish_callback(callback)
	self._on_finish_callback = callback
end


return ActionInstance

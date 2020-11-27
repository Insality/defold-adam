--- All actions created by this class.
-- The most of this API you should use only on develop your own custom actions.
-- @module ActionInstance


local class = require("adam.libs.middleclass")
local helper = require("adam.system.helper")
local const = require("adam.const")

--- Action context table
-- @tfield table context

--- The action instance name
-- @tfield string _name
-- @local

--- desc
-- @tfield function(ActionInstance) _trigger_callback
-- @local

--- desc
-- @tfield[opt] function(ActionInstance) _release_callback
-- @local

--- desc
-- @tfield StateInstance _state_instance
-- @local

--- desc
-- @tfield boolean _is_every_frame
-- @local

--- desc
-- @tfield boolean _is_deferred
-- @local

--- desc
-- @tfield boolean _is_periodic
-- @local

--- desc
-- @tfield number _periodic_timer
-- @local

--- desc
-- @tfield number _periodic_timer_current
-- @local

--


local ActionInstance = class("adam.action")


--- Action Instance constructor function
-- @tparam string name The action name. Useful for debug
-- @tparam function trigger_callback The main action function
-- @tparam[opt] function release_callback The release function. Clean up stuff, it you need
function ActionInstance:initialize(trigger_callback, release_callback)
	self._trigger_callback = trigger_callback or const.EMPTY_FUNCTION
	self._release_callback = release_callback
	self._state_instance = nil

	self._is_every_frame = false
	self._is_periodic = false
	self._periodic_timer = false
	self._periodic_timer_current = false
	self._is_deferred = false
	self._is_delayed = false
	self._delay_seconds = nil
	self._delay_seconds_current = false
	self._name = ""

	self.context = {}
end


--- Update function, called by StateInstance
-- @tparam number dt Delta time
-- @local
function ActionInstance:update(dt)
	if self._is_every_frame then
		self:trigger(true)
	end

	if self._is_periodic then
		self._periodic_timer_current = (self._periodic_timer_current or self._periodic_timer) - dt
		if self._periodic_timer_current <= 0 then
			self:trigger(true)
			self._periodic_timer_current = self._periodic_timer
		end
	end

	if self._delay_seconds_current and self._delay_seconds_current > 0 then
		self._delay_seconds_current = self._delay_seconds_current - dt
		if self._delay_seconds_current <= 0 then
			self:trigger(true)
		end
	end
end


--- Trigger event to action's FSM
-- @tparam string event_name Name of trigger event
function ActionInstance:event(event_name, ...)
	assert(self._state_instance, const.ERROR.NO_BINDED_STATE)
	self._state_instance:event(event_name, ...)
end


--- Return variable value from FSM variables
-- @tparam string variable_name The name of variable in FSM
function ActionInstance:get_value(variable_name)
	return self._state_instance:get_value(variable_name)
end


--- Set variable value in action's FSM
-- @tparam string variable_name The name of variable in FSM
-- @tparam any value New value for variable
function ActionInstance:set_value(variable_name, value)
	return self._state_instance:set_value(variable_name, value)
end


--- Check if param value is from FSM variables. If not - return itself or return variable from FSM
-- Pass this values to action args via `actions.value()`
-- @tparam any param
-- @treturn any
-- @see Actions.value
function ActionInstance:get_param(param)
	if type(param) == const.TYPE_TABLE and param._type == const.GET_ACTION_VALUE then
		return self:get_value(param._name)
	end

	return param
end


--- Set action triggered every frame
-- @tparam[opt] boolean state The every frame state
function ActionInstance:set_every_frame(state)
	self._is_every_frame = state
	self:set_deferred(true)
end


--- Set periodic trigger of action. Initial trigger not canceled
-- @tparam[opt] number seconds The time between triggers
function ActionInstance:set_periodic(seconds)
	local is_periodic = seconds and seconds > 0
	self._is_periodic = is_periodic
	self._periodic_timer = seconds
	self:set_deferred(true)
end


--- Add delay before action is triggered. Every frame and periodic trigger will start
-- after delay is happened. You should call finished method in action trigger function
-- @tparam number|nil seconds Action delay
function ActionInstance:set_delay(seconds)
	self._is_delayed = seconds and seconds > 0
	self._delay_seconds = seconds
	self:set_deferred(true)
end


--- Set action to deferred state. To complete the action `finished` should be called
-- @tparam[opt] boolean state The deferred state
function ActionInstance:set_deferred(state)
	self._is_deferred = state
end


--- Set the name of the action
-- @tparam string The action name
function ActionInstance:set_name(name)
	self._name = name
	return self
end


--- Return the name of the action
-- @treturn string The action name
function ActionInstance:get_name()
	return self._name
end


--- Function called when action is done. Never called on actions with "is_every_frame"
-- or "is_per_second". Deferred actions should call manually this function
function ActionInstance:finished()
	if self._is_every_frame or self._is_periodic then
		return
	end

	return self._state_instance:_on_action_finish()
end


--- Trigger action, called by StateInstance
-- @tparam boolean skip_delay Pass true to skip action delay. Used on periodic and every frame triggers
-- @local
function ActionInstance:trigger(skip_delay)
	self._delay_seconds_current = false

	local delay = skip_delay and 0 or self._delay_seconds
	if delay and delay > 0 then
		self._delay_seconds_current = delay
	else
		return self:_trigger_action()
	end
end


function ActionInstance:_trigger_action()
	self._trigger_callback(self)
	if not self._is_deferred then
		return self:finished()
	end
end


--- Release action (cleanup), called by StateInstance
-- @local
function ActionInstance:release()
	self._periodic_timer_current = false
	self._delay_seconds_current = false

	if self._release_callback then
		return self._release_callback(self)
	end
end


--- Return action's AdamInstance. Used internally
-- @treturn AdamInstance
-- @local
function ActionInstance:get_adam_instance()
	return self._state_instance:get_adam_instance()
end


--- Set StateInstance for this action instance. Called by StateInstance
-- @tparam StateInstance state_instance
-- @local
function ActionInstance:set_state_instance(state_instance)
	self._state_instance = state_instance
end


return ActionInstance

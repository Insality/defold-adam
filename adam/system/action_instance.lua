--- All actions created by this class.
-- The most of this API you should use only on develop your own custom actions.
-- @module ActionInstance


local class = require("adam.libs.middleclass")
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
-- @tfield function _on_finish_callback
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
	self._is_deferred = false
	self._periodic_timer_current = false
	self._on_finish_callback = nil
	self._name = ""

	self.context = {}
end


--- Update function, called by StateInstance
-- @tparam number dt Delta time
-- @local
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
	local callback = self._on_finish_callback
	self._on_finish_callback = nil
	if callback then
		callback()
	end
end


--- Trigger action, called by StateInstance
-- @local
function ActionInstance:trigger()
	self:release()
	self._trigger_callback(self)
	if not self._is_deferred then
		self:finished()
	end
end


--- Release action (cleanup), called by StateInstance
-- @local
function ActionInstance:release()
	self._periodic_timer_current = false
	if not self._release_callback then
		return
	end

	self._release_callback(self)
end


--- Set callback when action is finished. Used internally
-- @tparam function callback
-- @local
function ActionInstance:set_finish_callback(callback)
	self._on_finish_callback = callback
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

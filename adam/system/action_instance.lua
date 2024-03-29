--- All actions created by this class.
-- The most of this API you should use only on develop your own custom actions.
-- @module ActionInstance


local class = require("adam.libs.middleclass")
local const = require("adam.const")
local settings = require("adam.system.settings")

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
-- @tparam function trigger_callback The main action function
-- @tparam[opt] function release_callback The release function. Clean up stuff, it you need
function ActionInstance:initialize(trigger_callback, release_callback)
	self._trigger_callback = trigger_callback or const.EMPTY_FUNCTION
	self._release_callback = release_callback or const.EMPTY_FUNCTION

	self._state_instance = nil
	self._is_finished = false

	self._triggered_in_this_frame = false
	self._is_every_frame = false
	self._is_periodic = false
	self._periodic_timer = false
	self._periodic_timer_current = 0
	self._is_deferred = false
	self._is_delayed = false
	self._delay_seconds = nil
	self._delay_seconds_current = 0
	self._is_skip_initial_call = false
	self._is_debug = false
	self._name = ""

	self.context = nil
end


--- Copy constructor
-- @tparam ActionInstance prefab The action to copy
-- @treturn ActionInstance Copy of prefab action
function ActionInstance.static.copy(prefab)
	local action = ActionInstance(prefab._trigger_callback, prefab._release_callback)

	action._triggered_in_this_frame = prefab._triggered_in_this_frame
	action._is_finished = prefab._is_finished
	action._is_every_frame = prefab._is_every_frame
	action._is_periodic = prefab._is_periodic
	action._periodic_timer = prefab._periodic_timer
	action._periodic_timer_current = prefab._periodic_timer_current
	action._is_deferred = prefab._is_deferred
	action._is_delayed = prefab._is_delayed
	action._delay_seconds = prefab._delay_seconds
	action._delay_seconds_current = prefab._delay_seconds_current
	action._is_skip_initial_call = prefab._is_skip_initial_call
	action._is_debug = prefab._is_debug
	action._name = prefab._name

	if prefab.context then
		action.context = {}
	end

	return action
end


--- Update function, called by StateInstance
-- @tparam number dt Delta time
-- @local
function ActionInstance:update(dt)
	if self._is_finished then
		return
	end

	if self._delay_seconds_current > 0 then
		self._delay_seconds_current = self._delay_seconds_current - dt
		if self._delay_seconds_current <= 0 then
			self:_trigger_action()
		end
	else
		if self._is_periodic then
			self._periodic_timer_current = self._periodic_timer_current - dt
			if self._periodic_timer_current <= 0 then
				self:_trigger_action()
				self._periodic_timer_current = self._periodic_timer
			end
		end

		if self._is_every_frame and not self._triggered_in_this_frame then
			self:_trigger_action()
		end
	end

	self._triggered_in_this_frame = false
end


--- Trigger event to action's FSM
-- @tparam string event_name Name of trigger event
function ActionInstance:event(event_name)
	assert(self._state_instance, const.ERROR.NO_BINDED_STATE)

	if event_name then
		self._state_instance:event(event_name)
	end
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
		local value = self:get_value(param._name)
		if param._field then
			return value[param._field]
		else
			return value
		end
	end

	return param
end


--- Set action triggered every frame. Initial call will be skipped
-- @treturn ActionInstance Self
function ActionInstance:set_every_frame()
	self._is_every_frame = true
	self._is_skip_initial_call = true
	self:set_deferred(true)
	return self
end


--- Add context to this actions. It's cross call table, the second arg in
-- trigger and release callbacks
-- @treturn ActionInstance Self
function ActionInstance:set_with_context()
	self.context = {}
	return self
end



--- Set periodic trigger of action.
-- @tparam[opt] number seconds The time between triggers
-- @tparam[opt] boolean skip_initial_call If true, skip first initial call on state enter
-- @treturn ActionInstance Self
function ActionInstance:set_periodic(seconds, skip_initial_call)
	assert(seconds and seconds > 0, const.ERROR.PERIODIC_EVENT_WRONG_PARAMS)
	local is_periodic = seconds and seconds > 0
	self._is_periodic = is_periodic
	self._periodic_timer = seconds or 0
	self._periodic_timer_current = self._periodic_timer
	self:set_deferred(true)

	if skip_initial_call then
		self._is_skip_initial_call = skip_initial_call
	end

	return self
end


--- Add delay before action is triggered. Every frame and periodic trigger will start
-- after delay is happened. You should call finished method in action trigger function.
-- You can pass action.param as second argument
-- @tparam number|variable|nil seconds Action delay
-- @treturn ActionInstance Self
function ActionInstance:set_delay(seconds)
	self._is_delayed = not not seconds
	self._delay_seconds = seconds
	self:set_deferred(true)
	return self
end


--- Set action to deferred state. To complete the action `finished` should be called
-- @tparam[opt] boolean state The deferred state
function ActionInstance:set_deferred(state)
	self._is_deferred = state
end


--- Return action deferred state. If action is deferred - it can be executed in one frame
-- @treturn boolean Action deferred state
function ActionInstance:is_deferred()
	return self._is_deferred
end


--- Set the name of the action
-- @tparam string name The action name
-- @treturn ActionInstance Self
function ActionInstance:set_name(name)
	self._name = name or ""
	return self
end


--- Return the name of the action
-- @treturn string The action name
function ActionInstance:get_name()
	return self._state_instance:get_name() .. ":" .. self._name
end


--- Function called when action is done. Never called on actions with "is_every_frame"
-- or "is_periodic". Deferred actions should call manually this function
-- @tparam string trigger_event Event to trigger before finish call
function ActionInstance:finish(trigger_event)
	if self._is_every_frame or self._is_periodic then
		return
	end

	return self:force_finish(trigger_event)
end


--- Force finish action, even with "is_every_frame" or "is_periodic". This call
-- will stop any updates of this action
-- @tparam string trigger_event Event to trigger before finish call
function ActionInstance:force_finish(trigger_event)
	if self._is_finished then
		return
	end

	if self._is_debug then
		settings.log("Action finished", { name = self:get_name() })
	end
	self._is_finished = true

	-- If we will change state, drop other code execution, correct tail call
	if self:get_adam_instance():can_transition(trigger_event) then
		return self:event(trigger_event)
	else
		self:event(trigger_event)
	end

	return self._state_instance:_on_action_finish()
end


--- Trigger action, called by StateInstance
-- @local
function ActionInstance:trigger()
	if self._is_debug then
		settings.log("Action trigger call", { name = self:get_name() })
	end

	self._delay_seconds_current = 0
	self._is_finished = false

	if self._is_delayed then
		self._delay_seconds_current = self:_get_delay_seconds()
	end

	if self._delay_seconds_current == 0 then
		if self._is_skip_initial_call then
			return
		end
		return self:_trigger_action()
	end
end


--- Release action (cleanup), called by StateInstance
-- @local
function ActionInstance:release()
	if self._is_debug then
		settings.log("Action release call", { name = self:get_name() })
	end

	self._periodic_timer_current = 0
	self._delay_seconds_current = 0
	self._triggered_in_this_frame = false
	self._is_finished = false

	return self._release_callback(self, self.context)
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


--- Set debug state of action. If true, will print debug info to console
-- @tparam boolean state The debug state
-- @treturn ActionInstance Self
function ActionInstance:set_debug(state)
	self._is_debug = state
	return self
end


--- Get seconds to delay for trigger action
-- @treturn number Seconds to delay
-- @local
function ActionInstance:_get_delay_seconds()
	return self:get_param(self._delay_seconds)
end


--- Actual call of trigger callback. Used internally
-- @local
function ActionInstance:_trigger_action()
	self._triggered_in_this_frame = true

	self._trigger_callback(self, self.context)
	if not self._is_deferred then
		return self:finish()
	end
end


return ActionInstance

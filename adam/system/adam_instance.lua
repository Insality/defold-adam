--- All Adam Instances created by this class. Instantiate it via `adam.new()`.
-- @module AdamInstance

local fsm = require("adam.libs.fsm")
local class = require("adam.libs.middleclass")
local const = require("adam.const")
local settings = require("adam.system.settings")

local AdamInstance = class("adam.instance")


--- Adam Instance constructor function.
-- @tparam StateInstance initial_state The initial FSM state. It will be triggered on start
-- @tparam[opt] StateInstance[] transitions The array of next structure: {state_instance, state_instance, [event]},
-- describe transitiom from first state to second on event. By default event is adam.FINISHED
-- @tparam[opt] table variables Defined FSM variables. All variables should be defined before use
-- @tparam[opt] StateInstance final_state This state should contains only instant actions, execute on adam:final, transitions are not required
-- @treturn AdamInstance
function AdamInstance:initialize(initial_state, transitions, variables, final_state)
	self._id = nil
	self._name = ""
	self._inited = false
	self._is_active = false
	self._is_removed = nil

	self._states = {}
	self._adams = nil -- Nested Adam instances -- create empty table on first use
	self._forward_events = nil -- create empty table on first use

	self._is_debug = false
	self._current_state = nil
	self._current_depth = 0
	self._final_state = final_state

	self._input_pressed = nil -- create empty table on first use
	self._input_current = nil -- create empty table on first use
	self._input_released = nil -- create empty table on first use
	self._trigger_message = nil

	self:_init_variables(variables)
	self._fsm = self:_init_fsm(initial_state, transitions)

	for _, state in pairs(self._states) do
		state:set_adam_instance(self)
	end

	if self._final_state then
		-- TODO: Solve this, how to check instant or what
		-- assert(self._final_state:is_instant(), const.ERROR.FINAL_STATE_DEFERRED)
		self._final_state:set_adam_instance(self)
	end
end


--- Start the Adam Instance. On create FSM is not started and should be started manually.
-- On Adam Instance start system will remember url for this Adam Instance for msg.post (send event actions).
-- You can use `local adam = AdamInstance({}):start()`
-- @treturn AdamInstance
function AdamInstance:start()
	if not self._inited then
		self._inited = true
		self._is_active = true
		self._url = msg.url()
		self._fsm.init()
	end

	return self
end


--- Resume the execution of Adam Instance.
-- You can pause execution with pause method.
-- @treturn AdamInstance
function AdamInstance:resume()
	self._is_active = true
	return self
end


--- Pause the execution of Adam Instance.
-- You can resume execution with resume method.
-- @treturn AdamInstance
function AdamInstance:pause()
	self._is_active = false
	return self
end


--- Return true if Adam Instance is now working
-- @treturn boolean Is active state
function AdamInstance:is_active()
	return self._is_active
end


--- Adam update functions. Place in script/gui_script update function
-- @tparam numbet dt The delta time
function AdamInstance:update(dt)
	if not self._is_active then
		return
	end

	self._variables[const.VALUE.LIFETIME] = self._variables[const.VALUE.LIFETIME] + dt

	self._current_depth = 0
	if self._current_state then
		self._current_state:update(dt)
	end

	if self._adams then
		for i = 1, #self._adams do
			self._adams[i]:update(dt)
		end
	end

	self:_clear_input()

	if self._adams then
		for i = #self._adams, 1, -1 do
			if self._adams[i]._is_removed then
				table.remove(self._adams, i)
			end
		end
	end
end


--- Adam on_input function. Place in script/gui_script on_input function
-- @tparam hash action_id The input action_id
-- @tparam table action The input action info
function AdamInstance:on_input(action_id, action)
	if not self._is_active then
		return
	end

	self:_process_input(action_id, action)

	if self._adams then
		for i = 1, #self._adams do
			self._adams[i]:on_input(action_id, action)
		end
	end
end


--- Adam on_message function. Place in script/gui_script on_message function
-- @tparam hash message_id The message_id
-- @tparam table message The message info
-- @tparam hash sender The message sender id
function AdamInstance:on_message(message_id, message, sender)
	if not self._is_active then
		return
	end

	self:_process_message(message_id, message, sender)
end


--- Adam final function. Place in script/gui_script final function on when you wanna to finish FSM.
-- Important function, since it track global list of Adam instances
function AdamInstance:final()
	if self._is_removed then
		return
	end

	self:pause()
	self._is_removed = true

	if self._adams then
		for i = 1, #self._adams do
			self._adams[i]:final()
		end
	end

	if self._final_state then
		self._final_state:trigger()
	end
end


--- Add Adam Instance to current as nested FSM.
-- It will work, until parent instance will work. On final parent instance, it call final on
-- all nested adams
-- @tparam AdamInstance adam_instance The nested Adam Instance
-- @treturn AdamInstance Self
function AdamInstance:add(adam_instance)
	self._adams = self._adams or {}
	table.insert(self._adams, adam_instance)
	return self
end


--- Forward incoming events to other adam instance
-- @tparam AdamInstance adam_instance The adam instance to get events
-- @tparam table|string events The name of event[s] to forward
-- @tparam boolean is_consume Is event should be consumed on forward
-- @tparam AdamInstance Self
function AdamInstance:forward_events(adam_instance, events, is_consume)
	self._forward_events = self._forward_events or {}

	table.insert(self._forward_events, {
		adam = adam_instance,
		events = type(events) == "table" and events or { events },
		is_consume = is_consume
	})
	return self
end


--- Change the self context instante (the go instante instead of "." in all of action)
-- also set the game object id as FSM id. Do bind before adam:start function.
-- @tparam hash game_object The game object to bind
-- @treturn AdamInstance Self
function AdamInstance:bind(game_object)
	self._variables[const.VALUE.CONTEXT] = msg.url(game_object)
	self:set_id(game_object)
	return self
end


--- Trigger event in Adam FSM. If any transitions on this event exists, go to next state instantly
-- @tparam string event_name The trigger event name
-- @tparam[opt] table event_context The event data
function AdamInstance:event(event_name, event_context)
	if not self._is_active then
		return
	end

	if self._forward_events then
		for _, event_info in ipairs(self._forward_events) do
			for _, event in ipairs(event_info.events) do
				if event == event_name then
					event_info.adam:event(event_name, event_context)
					if event_info.is_consume then
						return
					end
				end
			end
		end
	end

	if self._is_debug then
		settings.log("Adam event", { name = self:get_name(), event = event_name })
	end

	if event_context then
		self:_process_event_context(event_name, event_context)
	end

	if self:can_transition(event_name) then
		return self._fsm[event_name]()
	end
end


--- Check available to make transition from current state with event
-- @tparam string event_name The trigger event
-- @treturn boolean True, if FSM will make transition on this event
function AdamInstance:can_transition(event_name)
	if not event_name then
		return false
	end
	return not not (self._fsm[event_name] and self._fsm.can(event_name))
end


--- Return variable value from Adam instance
-- @tparam string|variable variable_name The name of variable in FSM
-- @treturn variable
function AdamInstance:get_value(variable_name)
	if type(variable_name) == const.TYPE_TABLE and variable_name._type == const.GET_ACTION_VALUE then
		local name = variable_name._name
		assert(self._variables[name] ~= nil, const.ERROR.NO_DEFINED_VARIABLE .. name)

		local field = variable_name._field
		return field and self._variables[name][field] or self._variables[name]
	else
		assert(self._variables[variable_name] ~= nil, const.ERROR.NO_DEFINED_VARIABLE .. variable_name)
		return self._variables[variable_name]
	end
end


--- Set variable value in Adam instance
-- @tparam string|variable variable_name The name of variable in FSM
-- @tparam any value New value for variable
function AdamInstance:set_value(variable_name, value)
	if type(variable_name) == const.TYPE_TABLE and variable_name._type == const.GET_ACTION_VALUE then
		local name = variable_name._name
		assert(self._variables[name] ~= nil, const.ERROR.NO_DEFINED_VARIABLE .. name)

		local field = variable_name._field
		if field then
			self._variables[name][field] = value
		else
			self._variables[name] = value
		end
	else
		assert(self._variables[variable_name] ~= nil, const.ERROR.NO_DEFINED_VARIABLE .. variable_name)

		self._variables[variable_name] = value
		return value
	end

end


--- Return input state of pressed action
-- @tparam hash action_id The input action_id
-- @treturn table|nil The input info
-- @local
function AdamInstance:get_input_pressed(action_id)
	return self._input_pressed and self._input_pressed[hash(action_id)] or nil
end


--- Return input state of current action
-- @tparam hash action_id The input action_id
-- @treturn table|nil The input info
-- @local
function AdamInstance:get_input_current(action_id)
	return self._input_current and self._input_current[hash(action_id)] or nil
end


--- Return input state of released action
-- @tparam hash action_id The input action_id
-- @treturn table|nil The input info
-- @local
function AdamInstance:get_input_released(action_id)
	return self._input_released and self._input_released[hash(action_id)] or nil
end


--- Return last message from trigger collission
-- @treturn table|nil The last trigger message
-- @local
function AdamInstance:get_trigger_message()
	return self._trigger_message
end


--- Set id for Adam instance. Several Adam instances can have single id
-- Useful for select multiply Adam instances on fsm actions
-- @tparam hash hash The Adam Instance id
function AdamInstance:set_id(hash)
	self._id = hash
	return self
end


--- Get id of current Adam instance
-- @treturn hash The Adam Instance id
function AdamInstance:get_id()
	return self._id
end


--- Set name for Adam Instance. Useful for Debug.
-- @tparam string name The Adam Instance name
function AdamInstance:set_name(name)
	self._name = name or ""
	return self
end


--- Get name of current Adam Instance
-- @treturn string The Adam Instance name
function AdamInstance:get_name()
	return self._name
end


--- Return current adam state
-- @treturn StateInstance The current State Instance
function AdamInstance:get_current_state()
	return self._current_state
end


--- Return current game object binded to Adam (default ".")
-- @treturn url The game object id
function AdamInstance:get_self()
	return self._variables[const.VALUE.CONTEXT]
end


--- Get context url, where Adam Instance was started. Used for post messages
-- @treturn url|nil The Adam Instance url
function AdamInstance:get_url()
	return self._url and msg.url(self._url) or nil
end


--- Return true, if Adam Instance was started
-- @treturn boolean The Adam Instance inited state
function AdamInstance:is_inited()
	return self._inited
end


--- Set debug state of state. If true, will print debug info to console
-- @tparam boolean is_debug The debug state
-- @treturn AdamInstance Self
function AdamInstance:set_debug(is_debug)
	self._is_debug = is_debug
	for _, state in pairs(self._states) do
		state:set_debug(state)
	end
	return self
end


--- Parse Adam Instance params to create fsm
-- @local
function AdamInstance:_init_fsm(initial_state, transitions)
	local fsm_param = {
		initial = { state = initial_state:get_id(), event = const.INIT_EVENT, defer = true },
		events = {},
		callbacks = {}
	}

	self._states[initial_state:get_id()] = initial_state


	transitions = transitions or {}
	for _, transition in ipairs(transitions) do
		local transition1_id = transition[1] and transition[1]:get_id() or const.WILDCARD
		local transition2_id = transition[2]:get_id()
		local event_name = transition[3] or const.FINISHED

		self._states[transition1_id] = transition[1]
		self._states[transition2_id] = transition[2]
		table.insert(fsm_param.events, { from = transition1_id, to = transition2_id, name = event_name })
	end

	fsm_param.callbacks["on_leave_state"] = function(_, event, from, to)
		return self:_on_leave_state(event, from, to)
	end

	fsm_param.callbacks["on_enter_state"] = function(_, event, from, to)
		return self:_on_enter_state(event, from, to)
	end

	return fsm.create(fsm_param)
end


--- Set variable to current Adam Instance and set initial general variables
-- @local
function AdamInstance:_init_variables(variables)
	self._variables = variables or {}
	self._variables[const.VALUE.LIFETIME] = 0
	self._variables[const.VALUE.CONTEXT] = msg.url(const.SELF)
end


--- Adam callback on leave state
-- @local
function AdamInstance:_on_leave_state(event, from, to)
	if not self._is_active then
		return
	end

	if from == const.NONE_STATE then
		return
	end

	return self._states[from]:release()
end


--- Adam callback on enter state
-- @local
function AdamInstance:_on_enter_state(event, from, to)
	if not self._is_active then
		return
	end

	self._current_depth = self._current_depth + 1
	if self._current_depth >= const.MAX_STACK_DEPTH then
		print("[Adam]: Max depth error catch. Swich from states:", self._states[from]:get_name(), self._states[to]:get_name())
		error(const.ERROR.MAX_STACK_DEPTH_REACHED)
	end
	self._current_state = self._states[to]

	return self._states[to]:trigger()
end


--- Store input info to process it later
-- @local
function AdamInstance:_process_input(action_id, action)
	if not action_id then
		return
	end

	self._input_current = self._input_current or {}
	self._input_current[action_id] = action

	if action.pressed then
		self._input_pressed = self._input_pressed or {}
		self._input_pressed[action_id] = action
		self:event(const.EVENT.ACTION_PRESSED)
	end

	if action.released then
		self._input_released = self._input_released or {}
		self._input_released[action_id] = action
		self:event(const.EVENT.ACTION_RELEASED)
	end
end


--- Clear stored input info. Called as last step of update on every frame
-- @local
function AdamInstance:_clear_input()
	if self._input_pressed then
		for key in pairs(self._input_pressed) do
			self._input_pressed[key] = nil
		end
	end
	if self._input_current then
		for key in pairs(self._input_current) do
			self._input_current[key] = nil
		end
	end
	if self._input_released then
		for key in pairs(self._input_released) do
			self._input_released[key] = nil
		end
	end
end


--- Process messages to send it to Adam FSM is possile
-- @local
function AdamInstance:_process_message(message_id, message, sender)
	if message_id == const.TRIGGER_RESPONSE then
		if message.enter then
			self:event(const.EVENT.TRIGGER_ENTER, message)
		else
			self:event(const.EVENT.TRIGGER_LEAVE, message)
		end
	end
	if message_id == const.ADAM_EVENT then
		self:event(message.event, message)
	end
end


--- Store context, vary on event_name
-- @tparam string event_name The trigger event name
-- @tparam table event_context The event data
-- @local
function AdamInstance:_process_event_context(event_name, event_context)
	if event_name == const.EVENT.TRIGGER_ENTER or event_name == const.EVENT.TRIGGER_LEAVE then
		self._trigger_message = event_context
	end
end


return AdamInstance

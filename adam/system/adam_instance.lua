--- The main Adam instance. Instantiate it via `adam.new` and use it in your code.
-- @see adam
-- @module AdamInstance

local fsm = require("adam.libs.fsm")
local class = require("adam.libs.middleclass")
local const = require("adam.const")

local AdamInstance = class("adam.instance")


function AdamInstance:initialize(initial_state, transitions, variables)
	self._id = nil
	self._is_removed = nil
	self._states = {}
	self._variables = variables or {}
	self._current_state = nil
	self._current_depth = 0

	self._input_pressed = {}
	self._input_current = {}
	self._input_released = {}

	self._fsm = self:_init_fsm(initial_state, transitions)

	for _, state in pairs(self._states) do
		state:set_adam_instance(self)
	end
end


function AdamInstance:start()
	if not self._inited then
		self._inited = true
		self._fsm.init()
	end

	return self
end


function AdamInstance:update(dt)
	self._current_depth = 0
	if self._current_state then
		self._current_state:update(dt)
	end

	self:_clear_input()
end


function AdamInstance:on_input(action_id, action)
	self:_process_input(action_id, action)
end


function AdamInstance:on_message(message_id, message, sender)
	self:_process_message(message_id, message, sender)
end


function AdamInstance:final()
	self._is_removed = true
end


function AdamInstance:event(event_name)
	-- settings.log("Trigger event", { name = event_name })
	if not self._fsm[event_name] or not self._fsm.can(event_name) then
		return
	end

	return self._fsm[event_name]()
end


function AdamInstance:get_value(variable_name)
	return self._variables[variable_name]
end


function AdamInstance:set_value(variable_name, value)
	assert(self._variables[variable_name] ~= nil, const.ERROR.NO_DEFINED_VARIABLE)

	self._variables[variable_name] = value
	return value
end


function AdamInstance:get_input_pressed(action_id)
	return self._input_pressed[hash(action_id)]
end


function AdamInstance:get_input_current(action_id)
	return self._input_current[hash(action_id)]
end


function AdamInstance:get_input_released(action_id)
	return self._input_released[hash(action_id)]
end


function AdamInstance:set_id(hash)
	self._id = hash
	return self
end


function AdamInstance:get_id()
	return self._id
end


function AdamInstance:_init_fsm(initial_state, transitions)
	local fsm_param = {
		initial = { state = initial_state:get_id(), event = const.INIT_EVENT, defer = true },
		events = {},
		callbacks = {}
	}

	self._states[initial_state:get_id()] = initial_state

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


function AdamInstance:_on_leave_state(event, from, to)
	if from == const.NONE_STATE then
		return
	end
	return self._states[from]:release()
end


function AdamInstance:_on_enter_state(event, from, to)
	self._current_depth = self._current_depth + 1
	if self._current_depth >= const.MAX_STACK_DEPTH then
		print("[Adam]: Max depth error catch. Swich from states:", self._states[from]:get_name(), self._states[to]:get_name())
		error(const.ERROR.MAX_STACK_DEPTH_REACHED)
	end
	self._current_state = self._states[to]
	return self._states[to]:trigger()
end


function AdamInstance:_process_input(action_id, action)
	if not action_id then
		return
	end

	if action.pressed then
		self._input_pressed[action_id] = action
	end

	self._input_current[action_id] = action

	if action.released then
		self._input_released[action_id] = action
	end
end


function AdamInstance:_clear_input()
	self._input_pressed = {}
	self._input_current = {}
	self._input_released = {}
end


function AdamInstance:_process_message(message_id, message, sender)
	if message_id == const.TRIGGER_RESPONSE then
		-- pprint(message_id, message)
		if message.enter then
			self:event(const.EVENT.TRIGGER_ENTER)
		else
			self:event(const.EVENT.TRIGGER_LEAVE)
		end
	end
end


return AdamInstance

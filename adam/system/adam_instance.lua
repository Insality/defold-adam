--- The main Adam instance. Instantiate it via `adam.new` and use it in your code.
-- @see adam
-- @module AdamInstance

local fsm = require("adam.libs.fsm")
local class = require("adam.libs.middleclass")
local settings = require("adam.system.settings")
local const = require("adam.const")

local DmakerInstance = class("adam.instance")


function DmakerInstance:initialize(param)
	self._id = nil
	self._is_removed = nil
	self._states = {}
	self._variables = param.variables or {}
	self._current_state = nil
	self._current_depth = 0
	self._fsm = self:_init_fsm(param)

	for _, state in pairs(self._states) do
		state:set_adam_instance(self)
	end
end


function DmakerInstance:start()
	if not self._inited then
		self._inited = true
		self._fsm.init()
	end

	return self
end


function DmakerInstance:update(dt)
	self._current_depth = 0
	if self._current_state then
		self._current_state:update(dt)
	end
end


function DmakerInstance:on_input(action_id, action)
	pprint(action_id, action)
end


function DmakerInstance:final()
	self._is_removed = true
end


function DmakerInstance:event(event_name, ...)
	settings.log("Trigger event", { name = event_name })
	if self._fsm[event_name] and self._fsm.can(event_name) then
		self._fsm[event_name](...)
	end
end


function DmakerInstance:get_value(variable_name)
	return self._variables[variable_name]
end


function DmakerInstance:set_value(variable_name, value)
	assert(variable_name ~= nil, const.ERROR.NO_DEFINED_VARIABLE)

	self._variables[variable_name] = value
	return value
end


function DmakerInstance:set_id(hash)
	self._id = hash
	return self
end


function DmakerInstance:get_id()
	return self._id
end


function DmakerInstance:_init_fsm(param)
	local fsm_param = {
		initial = { state = param.initial:get_id(), event = const.INIT_EVENT, defer = true },
		events = {},
		callbacks = {}
	}

	for _, edge in ipairs(param.edges) do
		local edge1_id = edge[1] and edge[1]:get_id() or const.WILDCARD
		local edge2_id = edge[2]:get_id()
		local event_name = edge[3] or const.FINISHED

		self._states[edge1_id] = edge[1]
		self._states[edge2_id] = edge[2]
		table.insert(fsm_param.events, { from = edge1_id, to = edge2_id, name = event_name })
	end

	fsm_param.callbacks["on_leave_state"] = function(_, event, from, to, ...)
		self:_on_leave_state(event, from, to, ...)
	end

	fsm_param.callbacks["on_enter_state"] = function(_, event, from, to, ...)
		self:_on_enter_state(event, from, to, ...)
	end

	return fsm.create(fsm_param)
end


function DmakerInstance:_on_leave_state(event, from, to, ...)
	if from == const.NONE_STATE then
		return
	end
	self._states[from]:release(...)
end


function DmakerInstance:_on_enter_state(event, from, to, ...)
	self._current_depth = self._current_depth + 1
	if self._current_depth >= const.MAX_STACK_DEPTH then
		print("[Dmaker]: Max depth error catch. Swich from states:", self._states[from]:get_name(), self._states[to]:get_name())
		error(const.ERROR.MAX_STACK_DEPTH_REACHED)
	end
	self._current_state = self._states[to]
	self._states[to]:trigger(...)
end



return DmakerInstance

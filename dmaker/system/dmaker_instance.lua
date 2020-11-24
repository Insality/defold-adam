local fsm = require("dmaker.libs.fsm")
local class = require("dmaker.libs.middleclass")
local const = require("dmaker.const")

local DmakerInstance = class("dmaker.instance")


function DmakerInstance:initialize(param, variables)
	local fsm_param = {
		initial = { state = param.initial:get_id(), event = const.INIT_EVENT, defer = true },
		events = {},
		callbacks = {}
	}

	self._variables = variables or {}
	self._states = {}

	for _, edge in ipairs(param.edges) do
		local edge1_id = edge[1]:get_id()
		local edge2_id = edge[2]:get_id()
		local event_name = edge[3] or const.FINISHED
		local fsm_name = edge1_id .. "-" .. edge2_id .. "-" .. event_name

		self._states[edge1_id] = edge[1]
		self._states[edge2_id] = edge[2]
		table.insert(fsm_param.events, { from = edge1_id, to = edge2_id, name = fsm_name })
		edge[1]:set_event_link(event_name, fsm_name)
	end

	fsm_param.callbacks["on_leave_state"] = function(_, event, from, to, ...)
		if from == const.NONE_STATE then
			return
		end
		self._states[from]:release(...)
	end

	fsm_param.callbacks["on_enter_state"] = function(_, event, from, to, ...)
		self._states[to]:trigger(...)
	end

	self._fsm = fsm.create(fsm_param)

	for _, state in pairs(self._states) do
		state:set_dmaker_instance(self)
	end

	self._fsm.init()
end


function DmakerInstance:get_value(variable_name)
	return self._variables[variable_name]
end


function DmakerInstance:set_value(variable_name, value)
	assert(variable_name ~= nil, const.ERROR.NO_DEFINED_VARIABLE)
	self._variables[variable_name] = value
	return value
end


function DmakerInstance:get_fsm()
	return self._fsm
end


return DmakerInstance

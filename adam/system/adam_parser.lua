local const = require("adam.const")
local actions = require("adam.actions")
local StateInstance = require("adam.system.state_instance")

local M = {}


function M.parse(data)
	local params = {}

	local states = {}
	for state_name, state_data in pairs(data.states) do
		states[state_name] = M._parse_state(state_data)
	end

	local transitions = {}
	for _, transition in ipairs(data.transitions) do
		table.insert(transitions, { states[transition[1]], states[transition[2]], transition[3] })
	end

	params.initial = states[data.initial]
	params.transitions = transitions
	params.variables = M._parse_variables(data)

	return params
end


function M._parse_variables(data)
	local variables = {}

	for key, value in pairs(data.variables) do
		variables[key] = value
	end

	return variables
end


function M._parse_state(state_data)
	local actions_list = {}

	for _, action_data in ipairs(state_data.actions) do
		local func = actions
		for _, name in ipairs(action_data.name) do
			func = func[name]
		end

		local params = {}
		for _, data in ipairs(action_data.params) do
			if type(data) == const.TYPE_TABLE and data._type == const.GET_ACTION_VALUE then
				table.insert(params, actions.value(data._name))
			else
				table.insert(params, data)
			end
		end

		table.insert(actions_list, func(unpack(params)))
	end

	return StateInstance(unpack(actions_list))

end


return M

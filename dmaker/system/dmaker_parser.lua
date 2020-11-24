local const = require("dmaker.const")
local actions = require("dmaker.actions")
local StateInstance = require("dmaker.system.state_instance")

local M = {}


function M.parse(data)
	local params = {}

	local states = {}
	for state_name, state_data in pairs(data.states) do
		states[state_name] = M._parse_state(state_data)
	end

	local edges = {}
	for _, edge in ipairs(data.edges) do
		table.insert(edges, { states[edge[1]], states[edge[2]], edge[3] })
	end

	params.initial = states[data.initial]
	params.edges = edges
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

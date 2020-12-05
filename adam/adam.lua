--- Entry point for Defold-Adam. Create StateInstances and AdamInstances here
-- @module Adam
-- @alias adam

local const = require("adam.const")
local instances = require("adam.system.instances")
local adam_parser = require("adam.system.adam_parser")
local AdamInstance = require("adam.system.adam_instance")
local StateInstance = require("adam.system.state_instance")

local M = {}

M.FINISHED = const.FINISHED
M.ANY_STATE = const.ANY_STATE

M.VALUE_CONTEXT = const.VALUE.CONTEXT
M.VALUE_LIFETIME = const.VALUE.LIFETIME


--- Create new instance of State
-- @tparam ActionInstance ... The any amount of ActionInstance for this State
-- @treturn StateInstance
function M.state(...)
	return StateInstance(...)
end


--- Create new instance of Adam
-- @tparam StateInstance initial_state The initial FSM state. It will be triggered on start
-- @tparam[opt] StateInstance[] transitions The array of next structure: {state_instance, state_instance, [event]},
-- describe transitiom from first state to second on event. By default event is adam.FINISHED
-- @tparam[opt] table variables Defined FSM variables. All variables should be defined before use
-- @tparam[opt] StateInstance final_state This state should contains only instant actions, execute on adam:final, transitions are not required
-- @treturn AdamInstance
function M.new(initial, transitions, variables, final_state)
	local adam_instance = AdamInstance(initial, transitions, variables, final_state)

	instances.add_instance(adam_instance)
	return adam_instance
end


--- Return new Adam Instance from JSON representation
-- @tparam string json_data The Adam Instance JSON representation
-- @treturn AdamInstance The new Adam Instance
function M.parse(json_data)
	local params = adam_parser.parse(json.decode(json_data))

	local adam_instance = AdamInstance(params.initial, params.transitions, params.variables)
	instances.add_instance(adam_instance)
	return adam_instance
end


--- Return the group of actions what can be used instead single action.
-- Use it as template actions
-- @tparam ActionInstance ... The Actions for template
-- @treturn ActionInstance Structure what can be used instead single action in state description
function M.actions(...)
	return {
		_type = const.ACTIONS_TEMPLATE,
		_actions = { ... }
	}
end


--- Trigger event for all current Adam Instances
-- @tparam string event_name
function M.event(event_name)
	local all_instances = instances.get_all_instances()
	for i = 1, #all_instances do
		all_instances[i]:event(event_name)
	end
end


return M

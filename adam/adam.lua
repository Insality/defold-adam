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


--- Return state to use it in Adam FSM
function M.state(...)
	return StateInstance(...)
end


--- Create new instance of Adam FSM
function M.new(initial, transitions, variables)
	local adam_instance = AdamInstance(initial, transitions, variables)

	instances.add_instance(adam_instance)
	return adam_instance
end


function M.parse(json_data)
	local params = adam_parser.parse(json.decode(json_data))

	local adam_instance = AdamInstance(params.initial, params.transitions, params.variables)
	instances.add_instance(adam_instance)
	return adam_instance
end


return M

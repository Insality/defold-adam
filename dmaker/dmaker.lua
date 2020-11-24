--- Main module to create DMaker states and instances
-- @module dmaker

local const = require("dmaker.const")
local instances = require("dmaker.system.instances")
local dmaker_parser = require("dmaker.system.dmaker_parser")
local DmakerInstance = require("dmaker.system.dmaker_instance")
local StateInstance = require("dmaker.system.state_instance")

local M = {}

M.PROP_POS_X = "position.x"
M.PROP_POS_Y = "position.y"
M.PROP_POS_Z = "position.z"
M.PROP_SCALE_X = "scale.x"
M.PROP_SCALE_Y = "scale.y"

M.FINISHED = const.FINISHED
M.ANY_STATE = const.ANY_STATE


--- Return state to use it in dmaker FSM
function M.state(...)
	return StateInstance(...)
end


--- Create new instance of dmaker FSM
function M.new(params)
	local dmaker_instance = DmakerInstance(params)

	instances.add_instance(dmaker_instance)
	return dmaker_instance
end


function M.parse(json_data)
	local params = dmaker_parser.parse(json.decode(json_data))

	local dmaker_instance = DmakerInstance(params)
	instances.add_instance(dmaker_instance)
	return dmaker_instance
end




return M

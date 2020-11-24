local const = require("dmaker.const")
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
	return DmakerInstance(params)
end


function M.parse(json_data)
	local parsed_info = dmaker_parser.parse(json.decode(json_data))
	return DmakerInstance(parsed_info)
end


return M

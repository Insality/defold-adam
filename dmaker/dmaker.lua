local const = require("dmaker.const")
local DmakerInstance = require("dmaker.system.dmaker_instance")
local StateInstance = require("dmaker.system.state_instance")

local M = {}


M.PROP_POS_X = "position.x"
M.PROP_POS_Y = "position.y"
M.PROP_POS_Z = "position.z"
M.PROP_SCALE_X = "scale.x"
M.PROP_SCALE_Y = "scale.y"

M.FINISHED = const.FINISHED


--- Return state to use it in dmaker FSM
function M.state(...)
	return StateInstance(...)
end


--- Create new instance of dmaker FSM
function M.new(param)
	return DmakerInstance(param)
end


return M

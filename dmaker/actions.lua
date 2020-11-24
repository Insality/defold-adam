local const = require("dmaker.const")

local time = require("dmaker.actions.time")
local math = require("dmaker.actions.math")
local debug = require("dmaker.actions.debug")


local M = {}

M.time = time
M.math = math
M.debug = debug


--- Return value from FSM variables for action params
function M.value(variable_name)
	return { _name = variable_name, _type = const.GET_ACTION_VALUE }
end


return M

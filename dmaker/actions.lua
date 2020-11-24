--- Main actions entry file. Create all DMaker actions via this file
-- @module actions

local const = require("dmaker.const")

local time = require("dmaker.actions.time")
local math = require("dmaker.actions.math")
local debug = require("dmaker.actions.debug")
local fsm = require("dmaker.actions.fsm")


local M = {}

M.time = time
M.math = math
M.debug = debug
M.fsm = fsm


--- Return value from FSM variables for action params
-- @tparam string variable_name The variable name in DMaker instance
function M.value(variable_name)
	return { _name = variable_name, _type = const.GET_ACTION_VALUE }
end


return M

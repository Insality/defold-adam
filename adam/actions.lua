--- List of all predefined actions you can use
-- @module Actions
-- @alias adam.actions

local const = require("adam.const")

local M = {}

M.debug = require("adam.actions.debug")
M.device = require("adam.actions.device")
M.fsm = require("adam.actions.fsm")
M.go = require("adam.actions.go")
M.http = require("adam.actions.http")
M.input = require("adam.actions.input")
M.logic = require("adam.actions.logic")
M.math = require("adam.actions.math")
M.msg = require("adam.actions.msg")
M.sound = require("adam.actions.sound")
M.string = require("adam.actions.string")
M.time = require("adam.actions.time")
M.transform = require("adam.actions.transform")
M.vmath = require("adam.actions.vmath")


M.EVENT = const.EVENT


--- Return value from FSM variables for action params
-- @tparam string variable_name The variable name in Adam instance
-- @tparam string field The field name from variable. Useful for vector variables
function M.value(variable_name, field)
	return { _name = variable_name, _type = const.GET_ACTION_VALUE, _field = field }
end


return M

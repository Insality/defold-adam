--- List of all predefined actions you can use
-- @module Actions
-- @alias adam.actions

local const = require("adam.const")

local debug = require("adam.actions.debug")
local fsm = require("adam.actions.fsm")
local go = require("adam.actions.go")
local math = require("adam.actions.math")
local input = require("adam.actions.input")
local time = require("adam.actions.time")
local transform = require("adam.actions.transform")
local vmath = require("adam.actions.vmath")


local M = {}

M.debug = debug
M.fsm = fsm
M.go = go
M.math = math
M.input = input
M.time = time
M.transform = transform
M.vmath = vmath


M.EVENT = const.EVENT


--- Return value from FSM variables for action params
-- @tparam string variable_name The variable name in Adam instance
function M.value(variable_name)
	return { _name = variable_name, _type = const.GET_ACTION_VALUE }
end


return M

--- Main actions entry file. Create all DMaker actions via this file
-- @module Actions
-- @alias dmaker.actions

local const = require("dmaker.const")

local debug = require("dmaker.actions.debug")
local fsm = require("dmaker.actions.fsm")
local go = require("dmaker.actions.go")
local math = require("dmaker.actions.math")
local input = require("dmaker.actions.input")
local time = require("dmaker.actions.time")
local transform = require("dmaker.actions.transform")


local M = {}

M.debug = debug
M.fsm = fsm
M.go = go
M.math = math
M.input = input
M.time = time
M.transform = transform


--- Return value from FSM variables for action params
-- @tparam string variable_name The variable name in DMaker instance
function M.value(variable_name)
	return { _name = variable_name, _type = const.GET_ACTION_VALUE }
end


return M

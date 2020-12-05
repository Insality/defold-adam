--- Actions to work with sprites
-- @submodule Actions
-- @local

local const = require("adam.const")
local helper = require("adam.system.helper")
local ActionInstance = require("adam.system.action_instance")

local M = {}

-- TODO: play flipbook, animate tint, set flip

--- Add operator
-- @treturn ActionInstance
function M.func(source, value, is_every_frame)
	local action = ActionInstance(function(self)
	end)

	action:set_name("template.func")
	return action
end




return M

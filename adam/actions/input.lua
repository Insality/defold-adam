--- Actions to control the user input
-- @submodule Actions


local const = require("adam.const")
local ActionInstance = require("adam.system.action_instance")

local M = {}


function M.get_key(key_name, variable, is_every_frame)
	local action = ActionInstance("input.get_key", function(self)
		local is_pressed = 
		self:set_value(variable, is_pressed)
	end)

	if is_every_frame then
		action:set_every_frame(true)
	end

	action:set_name("input.get_key")

	return action
end


return M

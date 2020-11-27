--- Animate variables
-- @submodule Actions

local ActionInstance = require("adam.system.action_instance")


local M = {}


-- @treturn ActionInstance
function M.animate_value(source, target, time, delay, finish_event, ease_function)
	local action = ActionInstance(function(self)
		-- how can i animate table property?
	end)

	action:set_delay(delay)
	action:set_name("animation.animate_value")
	return action
end





return M

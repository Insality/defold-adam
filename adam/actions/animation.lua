--- Animate variables
-- @submodule Actions

local helper = require("adam.system.helper")
local ActionInstance = require("adam.system.action_instance")


local M = {}


-- @treturn ActionInstance
function M.animate_value(source, target, time, delay, finish_event, ease_function)
	local action = ActionInstance(function(self)
		self.context.timer_id = helper.delay(delay, function()
			-- how can i animate table property?
		end)
	end, function(self)
		if self.context.timer_id then
			timer.cancel(self.context.timer_id)
			self.context.timer_id = nil
		end
	end)

	action:set_name("animation.animate_value")
	return action
end





return M

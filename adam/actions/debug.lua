--- Useful actions for debug purposes
-- @submodule Actions

local ActionInstance = require("adam.system.action_instance")

local M = {}


--- Print text to console
-- @function actions.debug.print
-- @tparam string text The log message
function M.print(text)
	return ActionInstance("debug.print", function(self)
		print(self:get_param(text))
	end)
end


--- Instantly trigger event. Useful for test something fast by changing your FSM
-- @function actions.debug.event
-- @tparam string event_name The event to send
function M.event(event_name)
	return ActionInstance("debug.event", function(self)
		self:event(event_name)
	end)
end


return M

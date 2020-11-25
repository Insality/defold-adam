--- Useful actions for debug purposes
-- @submodule Actions

local ActionInstance = require("adam.system.action_instance")

local M = {}


--- Print text to console
-- @function actions.debug.print
-- @tparam string text The log message
-- @treturn ActionInstance
function M.print(text)
	local action = ActionInstance(function(self)
		print(self:get_param(text))
	end)

	action:set_name("debug.print")
	return action
end


--- Instantly trigger event. Useful for test something fast by changing your FSM
-- @function actions.debug.event
-- @tparam string event_name The event to send
-- @treturn ActionInstance
function M.event(event_name)
	local action = ActionInstance(function(self)
		self:event(event_name)
	end)

	action:set_name("debug.event")
	return action
end


return M

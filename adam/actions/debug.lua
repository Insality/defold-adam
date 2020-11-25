--- Useful actions for debug purposes
-- @submodule Actions

local const = require("adam.const")
local ActionInstance = require("adam.system.action_instance")

local M = {}


--- Print text to console
-- @function actions.debug.print
-- @tparam string text The log message
-- @tparam bool is_every_second Repeat this action every second
-- @treturn ActionInstance
function M.print(text, is_every_second)
	local action = ActionInstance(function(self)
		print(self:get_param(text))
	end)

	action:set_name("debug.print")
	if is_every_second then
		action:set_periodic(const.SECOND)
	end
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

--- Useful actions for debug purposes
-- @submodule Actions

local const = require("adam.const")
local ActionInstance = require("adam.system.action_instance")

local M = {}


--- Print text to console
-- @tparam string text The log message
-- @tparam bool is_every_second Repeat this action every second
-- @treturn ActionInstance
function M.print(text, is_every_second)
	local action = ActionInstance(function(self)
		print(self:get_param(text))
	end)

	if is_every_second then
		action:set_periodic(const.SECOND)
	end
	action:set_name("debug.print")
	return action
end


--- Instantly trigger event. Useful for test something fast by changing your FSM
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

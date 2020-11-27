--- Actions with time like delay or get time info
-- @submodule Actions

local ActionInstance = require("adam.system.action_instance")

local M = {}


--- Trigger event after time elapsed. Trigger event is optional
-- @function actions.time.delay
-- @tparam number seconds Amount of seconds for delay
-- @tparam[opt] string trigger_event Name of trigger event
-- @treturn ActionInstance
function M.delay(seconds, trigger_event)
	local action = ActionInstance(function(self)
		if trigger_event then
			self:event(trigger_event)
		end
		self:finished()
	end)

	action:set_delay(seconds)
	action:set_name("time.delay")
	return action
end


return M

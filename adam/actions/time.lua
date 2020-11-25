--- Actions with time like delay or get time info
-- @submodule Actions

local helper = require("adam.system.helper")
local ActionInstance = require("adam.system.action_instance")

local M = {}


--- Trigger event after time elapsed. Trigger event is optional
-- @function actions.time.delay
-- @tparam number seconds Amount of seconds for delay
-- @tparam[opt] string trigger_event Name of trigger event
-- @treturn ActionInstance
function M.delay(seconds, trigger_event)
	local action = ActionInstance(function(self)
		self.context.timer_id = helper.delay(seconds, function()
			self.context.timer_id = nil
			if trigger_event then
				self:event(trigger_event)
			end
			self:finished()
		end)
	end, function(self)
		if self.context.timer_id then
			timer.cancel(self.context.timer_id)
			self.context.timer_id = nil
		end
	end)

	action:set_deferred(true)
	action:set_name("time.delay")
	return action
end


return M

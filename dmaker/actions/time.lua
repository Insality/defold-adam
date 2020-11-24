--- Actions with time like delay or get time info
-- @submodule actions

local ActionInstance = require("dmaker.system.action_instance")

local M = {}


--- Trigger event after time elapsed
-- @function actions.time.delay
function M.delay(seconds, trigger_event)
	local action = ActionInstance("time.delay", function(self)
		self.context.timer_id = timer.delay(seconds, false, function()
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
	return action
end


return M

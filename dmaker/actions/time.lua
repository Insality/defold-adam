local ActionInstance = require("dmaker.system.action_instance")

local M = {}


--- Trigger event after time elapsed
function M.delay(seconds, trigger_event)
	return ActionInstance("time.delay", function(self)
		self.context.timer_id = timer.delay(seconds, false, function()
			self.context.timer_id = nil
			self:event(trigger_event)
		end)
	end, function(self)
		if self.context.timer_id then
			timer.cancel(self.context.timer_id)
			self.context.timer_id = nil
		end
	end)
end


return M

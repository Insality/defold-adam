local ActionInstance = require("dmaker.system.action_instance")

local M = {}


--- Trigger event after time elapsed
function M.delay(seconds, trigger_event)
	return ActionInstance("time.delay", function(self)
		local timer_id = timer.delay(seconds, false, function()
			self:event(trigger_event)
		end)
	end)
end


return M

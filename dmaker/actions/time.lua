local ActionInstance = require("dmaker.system.action_instance")

local M = {}


--- Trigger event after time elapsed
function M.delay(seconds, trigger_event)
	return ActionInstance("time.delay", function()
		local timer_id = timer.delay(seconds, false, function()
			print("Trigger event", trigger_event)
		end)
	end)
end


return M

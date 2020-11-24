local M = {}


function M.delay(delay, callback)
	if delay and delay > 0 then
		local timer_id = timer.delay(delay, false, callback)
		return timer_id
	else
		callback()
		return nil
	end
end


return M

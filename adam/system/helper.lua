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


function M.after(count, callback)
	local closure = function()
		count = count - 1
		if count == 0 then
			callback()
		end
	end

	return closure
end


return M

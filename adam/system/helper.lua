local M = {}


M.PROP_POS = "position"
M.PROP_POS_X = "position.x"
M.PROP_POS_Y = "position.y"
M.PROP_POS_Z = "position.z"
M.PROP_SCALE = "scale"
M.PROP_SCALE_X = "scale.x"
M.PROP_SCALE_Y = "scale.y"
M.PROP_SCALE_Z = "scale.z"


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

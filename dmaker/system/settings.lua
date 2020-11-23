local M = {}


function M.get_time()
	return socket.gettime()
end


function M.get_default_easing()
	return go.EASING_OUTSINE
end


function M.play_sound(sound_id)
	print("Play sound is not setup")
end


local _state_id = 0
function M.get_next_id()
	_state_id = _state_id + 1
	return tostring(_state_id)
end


return M

-- Defold ADam settings functions
-- @local


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


function M.log(string, context)
	local context_string = "{ "
	for key, value in pairs(context) do
		context_string = context_string .. key .. "-" .. value .. " "
	end
	context_string = context_string .. "}"

	print("[Adam]:", string, context_string)
end


return M

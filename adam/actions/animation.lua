--- Animate variables
-- @submodule Actions

local ActionInstance = require("adam.system.action_instance")


local M = {}


-- @treturn ActionInstance
function M.animate_value(source, target, time, delay, finish_event, ease_function)
	local action = ActionInstance(function(self)
		-- how can i animate table property?
	end)

	action:set_delay(delay)
	action:set_name("animation.animate_value")
	return action
end



-- @treturn ActionInstance
function M.play_flipbook(target_url, image, finish_event, delay)
	local action = ActionInstance(function(self)
		-- how can i animate table property?
		target_url = target_url or self:get_adam_instance():get_self()
		sprite.play_flipbook(target_url, image, function()
			self:finish(finish_event)
		end)
	end)

	action:set_delay(delay)
	action:set_name("animation.play_flipbook")
	return action
end


return M

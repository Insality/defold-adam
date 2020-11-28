--- Game Object transform actions: move, rotate, scale, etc
-- @submodule Actions

local const = require("adam.const")
local helper = require("adam.system.helper")
local settings = require("adam.system.settings")
local ActionInstance = require("adam.system.action_instance")


local M = {}


local function set_property(target_id, target_vector, is_every_frame, delay, ease_function, action_name, property, instant_set_function, instant_get_function, is_relative)
	local action = ActionInstance(function(self, context)
		local target = self:get_param(target_vector)

		if is_relative then
			target = target + instant_get_function(target_id, property)
		end

		instant_set_function(target, target_id)
		self:finish()
	end)

	if is_every_frame then
		action:set_every_frame(true)
	end

	action:set_delay(delay)
	action:set_name(action_name)
	return action
end


local function animate_property(target_id, target_vector, time, finish_event, delay, ease_function, action_name, property, instant_set_function, instant_get_function, is_relative)
	local action = ActionInstance(function(self, context)
		local target = self:get_param(target_vector)

		if is_relative then
			target = target + instant_get_function(target_id, property)
		end

		local easing = ease_function or settings.get_default_easing()
		context.animate_started = true
		go.animate(target_id, property, go.PLAYBACK_ONCE_FORWARD, target, easing, time)

		context.callback_timer_id = helper.delay(time, function()
			context.animate_started = false
			self:finish(finish_event)
		end)
	end, function(self, context)
		if context.animate_started then
			go.cancel_animations(target_id, property)
			context.animate_started = false
		end
		if context.callback_timer_id then
			timer.cancel(context.callback_timer_id)
			context.callback_timer_id = false
		end
	end)

	action:set_delay(delay)
	action:set_name(action_name)
	return action
end


--- Sets the position of a game object
-- @tparam vector3 target_vector Position vector
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt] ease ease_function The ease function to animate. Default in settings.get_default_easing
-- @treturn ActionInstance
function M.set_position(target_vector, is_every_frame, delay, ease_function)
	return set_property(".", target_vector, is_every_frame, delay, ease_function,
		"transform.set_position", const.PROP_POS, go.set_position, go.get_position, false)
end


-- @treturn ActionInstance
function M.get_position()

end


-- @treturn ActionInstance
function M.set_rotation()

end


-- @treturn ActionInstance
function M.get_rotation()

end


--- Set scale to a game object
-- @tparam vector3 target_scale Scale vector
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt] ease ease_function The ease function to animate. Default in settings.get_default_easing
-- @treturn ActionInstance
function M.set_scale(target_scale, is_every_frame, delay, ease_function)
	return set_property(".", target_scale, is_every_frame, nil, nil, delay, ease_function,
		"transform.set_scale", const.PROP_SCALE, go.set_scale, go.get_scale, false)
end


--- Animate scale to a game object
-- @tparam vector3 target_scale Scale vector
-- @tparam[opt] number time The time to translate gameobject. Incompatable with is_every_frame
-- @tparam[opt] string finish_event Name of trigger event
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt] ease ease_function The ease function to animate. Default in settings.get_default_easing
-- @treturn ActionInstance
function M.animate_scale(target_scale, time, finish_event, delay, ease_function)
	return animate_property(".", target_scale, time, finish_event, delay, ease_function,
		"transform.animate_scale", const.PROP_SCALE, go.set_scale, go.get_scale, false)
end


-- @treturn ActionInstance
function M.get_scale()

end


-- @treturn ActionInstance
function M.look_at()

end


--- Translates a game object via delta vector
-- @tparam vector3 delta_vector Vector with x/y/z params to translate
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt] ease ease_function The ease function to animate. Default in settings.get_default_easing
-- @treturn ActionInstance
function M.translate(delta_vector, is_every_frame, delay, ease_function)
	return set_property(".", delta_vector, is_every_frame, delay,
		ease_function, "transform.translate", const.PROP_POS, go.set_position, go.get_position, true)
end


return M

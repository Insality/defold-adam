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
			target = target + instant_get_function(target_id)
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
			target = target + instant_get_function(target_id)
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


local function get_property(target_id, variable, instant_get_function, is_every_frame, action_name)
	local action = ActionInstance(function(self)
		local value = instant_get_function(target_id)
		self:set_value(variable, value)
	end)

	if is_every_frame then
		action:set_every_frame(true)
	end
	action:set_name(action_name)
	return action
end


--- Sets the position of a game object
-- @function actions.transform.set_position
-- @tparam vector3 target_vector Position vector
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt] ease ease_function The ease function to animate. Default in settings.get_default_easing
-- @treturn ActionInstance
function M.set_position(target_vector, is_every_frame, delay, ease_function)
	return set_property(".", target_vector, is_every_frame, delay, ease_function,
		"transform.set_position", const.PROP_POS, go.set_position, go.get_position, false)
end


--- Animate the position of a game object
-- @function actions.transform.animate_position
-- @tparam vector3 target_vector Position vector
-- @tparam number time The time to animate
-- @tparam[opt] string finish_event Name of trigger event
-- @tparam[opt] number delay Delay before animate in seconds
-- @tparam[opt] ease ease_function The ease function to animate. Default in settings.get_default_easing
-- @treturn ActionInstance
function M.animate_position(target_vector, time, finish_event, delay, ease_function)
	return animate_property(".", target_vector, time, finish_event, delay, ease_function,
		"transform.animate_position", const.PROP_POS, go.set_position, go.get_position, false)
end


--- Get the position property of a game object and store to variable
-- @function actions.transform.get_position
-- @tparam string variable The variable to store result
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] boolean is_world_space Use get_world_position instead get_position
-- @treturn ActionInstance
function M.get_position(variable, is_every_frame, is_world_space)
	local get_func = is_world_space and go.get_world_position or go.get_position
	return get_property(".", variable,get_func, is_every_frame, "transform.get_position")
end


--- Sets the rotation of a game object
-- @function actions.transform.set_rotation
-- @tparam quaternion target_quaternion Rotation quatenion
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt] ease ease_function The ease function to animate. Default in settings.get_default_easing
-- @treturn ActionInstance
function M.set_rotation(target_quaternion, is_every_frame, delay, ease_function)
	return set_property(".", target_quaternion, is_every_frame, delay, ease_function,
		"transform.set_rotation", const.PROP_ROTATION, go.set_rotation, go.get_rotation, false)
end


--- Animate the rotation of a game object
-- @function actions.transform.animate_rotation
-- @tparam quaternion target_quaternion Rotation quaternion
-- @tparam number time The time to animate
-- @tparam[opt] string finish_event Name of trigger event
-- @tparam[opt] number delay Delay before animate in seconds
-- @tparam[opt] ease ease_function The ease function to animate. Default in settings.get_default_easing
-- @treturn ActionInstance
function M.animate_rotation(target_quaternion, time, finish_event, delay, ease_function)
	return animate_property(".", target_quaternion, time, finish_event, delay, ease_function,
		"transform.animate_rotation", const.PROP_ROTATION, go.set_rotation, go.get_rotation, false)
end


--- Get the rotation property of a game object and store to variable
-- @function actions.transform.get_rotation
-- @tparam string variable The variable to store result
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] boolean is_world_space Use get_world_rotation instead get_rotation
-- @treturn ActionInstance
function M.get_rotation(variable, is_every_frame, is_world_space)
	local get_func = is_world_space and go.get_world_rotation or go.get_rotation
	return get_property(".", variable,get_func, is_every_frame, "transform.get_rotation")
end


--- Set scale to a game object
-- @function actions.transform.set_scale
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
-- @function actions.transform.animate_scale
-- @tparam vector3 target_scale Scale vector
-- @tparam number time The time to animate
-- @tparam[opt] string finish_event Name of trigger event
-- @tparam[opt] number delay Delay before animate in seconds
-- @tparam[opt] ease ease_function The ease function to animate. Default in settings.get_default_easing
-- @treturn ActionInstance
function M.animate_scale(target_scale, time, finish_event, delay, ease_function)
	return animate_property(".", target_scale, time, finish_event, delay, ease_function,
		"transform.animate_scale", const.PROP_SCALE, go.set_scale, go.get_scale, false)
end


--- Get the scale property of a game object and store to variable
-- @function actions.transform.get_scale
-- @tparam string variable The variable to store result
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] boolean is_world_space Use get_world_scale instead get_scale
-- @treturn ActionInstance
function M.get_scale(variable, is_every_frame, is_world_space)
	local get_func = is_world_space and go.get_world_scale or go.get_scale
	return get_property(".", variable,get_func, is_every_frame, "transform.get_scale")
end


-- @treturn ActionInstance
function M.look_at()

end


--- Translates a game object via delta vector
-- @function actions.transform.translate
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

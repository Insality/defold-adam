--- Game Object transform actions: move, rotate, scale, etc
-- @submodule Actions

local const = require("adam.const")
local helper = require("adam.system.helper")
local settings = require("adam.system.settings")
local ActionInstance = require("adam.system.action_instance")


local M = {}


local function set_property(target_id, target_vector, is_every_frame, delay, action_name, property, is_relative)
	local action = ActionInstance(function(self, context)
		local value = self:get_param(target_vector)

		if is_relative then
			value = value + go.get(target_id, property)
		end

		go.set(target_id, property, value)
		self:finish()
	end)

	if is_every_frame then
		action:set_every_frame()
	end
	action:set_delay(delay)
	action:set_name(action_name)
	return action
end


local function animate_property(target_id, target_vector, time, finish_event, delay, ease_function, action_name, property, is_relative)
	local action = ActionInstance(function(self, context)
		local value = self:get_param(target_vector)

		if is_relative then
			value = value + go.get(target_id, property)
		end

		local easing = ease_function or settings.get_default_easing()
		context.animate_started = true
		go.animate(target_id, property, go.PLAYBACK_ONCE_FORWARD, value, easing, time)

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


local function get_property(target_id, variable, property, is_every_frame, action_name)
	local action = ActionInstance(function(self)
		local value = go.get(target_id, property)
		self:set_value(variable, value)
	end)

	if is_every_frame then
		action:set_every_frame()
	end
	action:set_name(action_name)
	return action
end


--- Sets the position of a game object
-- @function actions.transform.set_position
-- @tparam vector3 target_vector Position vector
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.set_position(target_vector, is_every_frame, delay, target_url)
	return set_property(target_url or const.SELF, target_vector, is_every_frame, delay,
		"transform.set_position", const.PROP_POS, go.set_position, go.get_position, false)
end


--- Add the position to a game object
-- @function actions.transform.add_position
-- @tparam vector3 delta_vector Vector with x/y/z params to translate
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.add_position(delta_vector, is_every_frame, delay, target_url)
	return set_property(target_url or const.SELF, delta_vector, is_every_frame, delay,
		"transform.add_position", const.PROP_POS, true)
end


--- Animate the position of a game object
-- @function actions.transform.animate_position
-- @tparam vector3 target_vector Position vector
-- @tparam number time The time to animate
-- @tparam[opt] string finish_event Name of trigger event
-- @tparam[opt] number delay Delay before animate in seconds
-- @tparam[opt] ease ease_function The ease function to animate. Default in settings.get_default_easing
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.animate_position(target_vector, time, finish_event, delay, ease_function, target_url)
	return animate_property(target_url or const.SELF, target_vector, time, finish_event, delay, ease_function,
		"transform.animate_position", const.PROP_POS, false)
end


--- Get the position property of a game object and store to variable
-- @function actions.transform.get_position
-- @tparam string variable The variable to store result
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.get_position(variable, is_every_frame, target_url)
	return get_property(target_url or const.SELF, variable, const.PROP_POS, is_every_frame, "transform.get_position")
end


--- Sets the rotation of a game object
-- @function actions.transform.set_rotation
-- @tparam quaternion target_quaternion Rotation quatenion
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.set_rotation(target_quaternion, is_every_frame, delay, target_url)
	return set_property(target_url or const.SELF, target_quaternion, is_every_frame, delay,
		"transform.set_rotation", const.PROP_EULER, false)
end


--- Add the rotation of a game object
-- @function actions.transform.add_rotation
-- @tparam quaternion target_quaternion Rotation quatenion
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.add_rotation(target_quaternion, is_every_frame, delay, target_url)
	return set_property(target_url or const.SELF, target_quaternion, is_every_frame, delay,
		"transform.add_rotation", const.PROP_EULER, true)
end


--- Animate the rotation of a game object
-- @function actions.transform.animate_rotation
-- @tparam quaternion target_quaternion Rotation quaternion
-- @tparam number time The time to animate
-- @tparam[opt] string finish_event Name of trigger event
-- @tparam[opt] number delay Delay before animate in seconds
-- @tparam[opt] ease ease_function The ease function to animate. Default in settings.get_default_easing
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.animate_rotation(target_quaternion, time, finish_event, delay, ease_function, target_url)
	return animate_property(target_url or const.SELF, target_quaternion, time, finish_event, delay, ease_function,
		"transform.animate_rotation", const.PROP_EULER, false)
end


--- Get the rotation property of a game object and store to variable
-- @function actions.transform.get_rotation
-- @tparam string variable The variable to store result
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.get_rotation(variable, is_every_frame, target_url)
	return get_property(target_url or const.SELF, variable, const.PROP_EULER, is_every_frame, "transform.get_rotation")
end


--- Sets the rotation of a game object
-- @function actions.transform.set_rotation
-- @tparam quaternion target_quaternion Rotation quatenion
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.set_euler(target_quaternion, is_every_frame, delay, target_url)
	return set_property(target_url or const.SELF, target_quaternion, is_every_frame, delay,
		"transform.set_rotation", const.PROP_EULER, false)
end


--- Add the rotation of a game object
-- @function actions.transform.add_rotation
-- @tparam vector3 target_vector Rotation quatenion
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.add_euler(target_vector, is_every_frame, delay, target_url)
	return set_property(target_url or const.SELF, target_vector, is_every_frame, delay,
		"transform.add_euler", const.PROP_EULER, true)
end


--- Animate the rotation of a game object with euler vector
-- @function actions.transform.animate_euler
-- @tparam vector3 target_euler Rotation quaternion
-- @tparam number time The time to animate
-- @tparam[opt] string finish_event Name of trigger event
-- @tparam[opt] number delay Delay before animate in seconds
-- @tparam[opt] ease ease_function The ease function to animate. Default in settings.get_default_easing
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.animate_euler(target_euler, time, finish_event, delay, ease_function, target_url)
	return animate_property(target_url or const.SELF, target_euler, time, finish_event, delay, ease_function,
		"transform.animate_euler", const.PROP_EULER, false)
end


--- Animate the rotation of a game object with relative euler vector
-- @function actions.transform.animate_euler_by
-- @tparam vector3 target_euler Rotation quaternion
-- @tparam number time The time to animate
-- @tparam[opt] string finish_event Name of trigger event
-- @tparam[opt] number delay Delay before animate in seconds
-- @tparam[opt] ease ease_function The ease function to animate. Default in settings.get_default_easing
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.animate_euler_by(target_euler, time, finish_event, delay, ease_function, target_url)
	return animate_property(target_url or const.SELF, target_euler, time, finish_event, delay, ease_function,
		"transform.animate_euler_by", const.PROP_EULER, true)
end


--- Get the rotation property of a game object and store to variable
-- @function actions.transform.get_euler
-- @tparam string variable The variable to store result
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.get_euler(variable, is_every_frame, target_url)
	return get_property(target_url or const.SELF, variable, const.PROP_EULER, is_every_frame, "transform.get_euler")
end


--- Set scale to a game object
-- @function actions.transform.set_scale
-- @tparam vector3 target_scale Scale vector
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.set_scale(target_scale, is_every_frame, delay, target_url)
	return set_property(target_url or const.SELF, target_scale, is_every_frame, delay,
		"transform.set_scale", const.PROP_SCALE, false)
end


--- Add scale to a game object
-- @function actions.transform.add_scale
-- @tparam vector3 target_scale Scale vector
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.add_scale(target_scale, is_every_frame, delay, target_url)
	return set_property(target_url or const.SELF, target_scale, is_every_frame, delay,
		"transform.add_scale", const.PROP_SCALE, true)
end



--- Animate scale to a game object
-- @function actions.transform.animate_scale
-- @tparam vector3 target_scale Scale vector
-- @tparam number time The time to animate
-- @tparam[opt] string finish_event Name of trigger event
-- @tparam[opt] number delay Delay before animate in seconds
-- @tparam[opt] ease ease_function The ease function to animate. Default in settings.get_default_easing
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.animate_scale(target_scale, time, finish_event, delay, ease_function, target_url)
	return animate_property(target_url or const.SELF, target_scale, time, finish_event, delay, ease_function,
		"transform.animate_scale", const.PROP_SCALE, false)
end


--- Animate scale to a game object with relative vector
-- @function actions.transform.animate_scale_by
-- @tparam vector3 target_scale Add scale vector
-- @tparam number time The time to animate
-- @tparam[opt] string finish_event Name of trigger event
-- @tparam[opt] number delay Delay before animate in seconds
-- @tparam[opt] ease ease_function The ease function to animate. Default in settings.get_default_easing
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.animate_scale_by(target_scale, time, finish_event, delay, ease_function, target_url)
	return animate_property(target_url or const.SELF, target_scale, time, finish_event, delay, ease_function,
		"transform.animate_scale_by", const.PROP_SCALE, true)
end


--- Get the scale property of a game object and store to variable
-- @function actions.transform.get_scale
-- @tparam string variable The variable to store result
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.get_scale(variable, is_every_frame, target_url)
	return get_property(target_url or const.SELF, variable, const.PROP_SCALE, is_every_frame, "transform.get_scale")
end


-- @treturn ActionInstance
function M.look_at()

end


return M

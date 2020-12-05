--- Game Object transform actions: move, rotate, scale, etc
-- @submodule Actions

local const = require("adam.const")
local helper = require("adam.system.helper")
local ActionInstance = require("adam.system.action_instance")


local M = {}


--- Sets the position of a game object
-- @function actions.transform.set_position
-- @tparam vector3 target_vector Position vector
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.set_position(target_vector, is_every_frame, delay, target_url)
	return helper.set_property(target_url, target_vector, is_every_frame, delay,
		"transform.set_position", const.PROP_POS, false)
end


--- Add the position to a game object
-- @function actions.transform.add_position
-- @tparam vector3 delta_vector Vector with x/y/z params to translate
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.add_position(delta_vector, is_every_frame, delay, target_url)
	return helper.set_property(target_url, delta_vector, is_every_frame, delay,
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
	return helper.animate_property(target_url, target_vector, time, finish_event, delay, ease_function,
		"transform.animate_position", const.PROP_POS, false)
end


--- Animate the position of a game object by a delta vector
-- @function actions.transform.animate_position_by
-- @tparam vector3 target_vector Delta position vector
-- @tparam number time The time to animate
-- @tparam[opt] string finish_event Name of trigger event
-- @tparam[opt] number delay Delay before animate in seconds
-- @tparam[opt] ease ease_function The ease function to animate. Default in settings.get_default_easing
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.animate_position_by(target_vector, time, finish_event, delay, ease_function, target_url)
	return helper.animate_property(target_url, target_vector, time, finish_event, delay, ease_function,
		"transform.animate_position_by", const.PROP_POS, true)
end


--- Get the position property of a game object and store to variable
-- @function actions.transform.get_position
-- @tparam string variable The variable to store result
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.get_position(variable, is_every_frame, target_url)
	return helper.get_property(target_url, variable, const.PROP_POS, is_every_frame, "transform.get_position")
end


--- Sets the rotation of a game object
-- @function actions.transform.set_rotation
-- @tparam quaternion target_quaternion Rotation quatenion
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.set_rotation(target_quaternion, is_every_frame, delay, target_url)
	return helper.set_property(target_url, target_quaternion, is_every_frame, delay,
		"transform.set_rotation", const.PROP_ROTATION, false)
end


--- Add the rotation of a game object
-- @function actions.transform.add_rotation
-- @tparam quaternion target_quaternion Rotation quatenion
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.add_rotation(target_quaternion, is_every_frame, delay, target_url)
	return helper.set_property(target_url, target_quaternion, is_every_frame, delay,
		"transform.add_rotation", const.PROP_ROTATION, true)
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
	return helper.animate_property(target_url, target_quaternion, time, finish_event, delay, ease_function,
		"transform.animate_rotation", const.PROP_ROTATION, false)
end


--- Animate the rotation of a game object with a delta quaternion
-- @function actions.transform.animate_rotation_by
-- @tparam quaternion target_quaternion Delta rotation quaternion
-- @tparam number time The time to animate
-- @tparam[opt] string finish_event Name of trigger event
-- @tparam[opt] number delay Delay before animate in seconds
-- @tparam[opt] ease ease_function The ease function to animate. Default in settings.get_default_easing
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.animate_rotation_by(target_quaternion, time, finish_event, delay, ease_function, target_url)
	return helper.animate_property(target_url, target_quaternion, time, finish_event, delay, ease_function,
		"transform.animate_rotation_by", const.PROP_ROTATION, true)
end


--- Get the rotation property of a game object and store to variable
-- @function actions.transform.get_rotation
-- @tparam string variable The variable to store result
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.get_rotation(variable, is_every_frame, target_url)
	return helper.get_property(target_url, variable, const.PROP_ROTATION, is_every_frame, "transform.get_rotation")
end


--- Sets the euler of a game object
-- @function actions.transform.set_euler
-- @tparam vector3 target_euler The euler vector
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.set_euler(target_euler, is_every_frame, delay, target_url)
	return helper.set_property(target_url, target_euler, is_every_frame, delay,
		"transform.set_euler", const.PROP_EULER, false)
end


--- Add the euler of a game object
-- @function actions.transform.add_euler
-- @tparam vector3 target_euler The euler vector
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.add_euler(target_euler, is_every_frame, delay, target_url)
	return helper.set_property(target_url, target_euler, is_every_frame, delay,
		"transform.add_euler", const.PROP_EULER, true)
end


--- Animate the euler of a game object with euler vector
-- @function actions.transform.animate_euler
-- @tparam vector3 target_euler The euler vector
-- @tparam number time The time to animate
-- @tparam[opt] string finish_event Name of trigger event
-- @tparam[opt] number delay Delay before animate in seconds
-- @tparam[opt] ease ease_function The ease function to animate. Default in settings.get_default_easing
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.animate_euler(target_euler, time, finish_event, delay, ease_function, target_url)
	return helper.animate_property(target_url, target_euler, time, finish_event, delay, ease_function,
		"transform.animate_euler", const.PROP_EULER, false)
end


--- Animate the euler of a game object with relative euler vector
-- @function actions.transform.animate_euler_by
-- @tparam vector3 target_euler Rotation quaternion
-- @tparam number time The time to animate
-- @tparam[opt] string finish_event Name of trigger event
-- @tparam[opt] number delay Delay before animate in seconds
-- @tparam[opt] ease ease_function The ease function to animate. Default in settings.get_default_easing
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.animate_euler_by(target_euler, time, finish_event, delay, ease_function, target_url)
	return helper.animate_property(target_url, target_euler, time, finish_event, delay, ease_function,
		"transform.animate_euler_by", const.PROP_EULER, true)
end


--- Get the euler property of a game object and store to variable
-- @function actions.transform.get_euler
-- @tparam string variable The variable to store result
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.get_euler(variable, is_every_frame, target_url)
	return helper.get_property(target_url, variable, const.PROP_EULER, is_every_frame, "transform.get_euler")
end


--- Sets the random euler of a game object
-- @function actions.transform.set_random_euler
-- @tparam[opt] boolean keep_x Set true to keep x euler angle
-- @tparam[opt] boolean keep_y Set true to keep x euler angle
-- @tparam[opt] boolean keep_z Set true to keep x euler angle
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.set_random_euler(keep_x, keep_y, keep_z, is_every_frame, delay, target_url)
	local action = ActionInstance(function(self, context)
		target_url = target_url or self:get_adam_instance():get_self()
		local random_vector = vmath.vector3(0)
		random_vector.x = keep_x and random_vector.x or math.random(360)
		random_vector.y = keep_y and random_vector.y or math.random(360)
		random_vector.z = keep_z and random_vector.z or math.random(360)

		random_vector = random_vector + go.get(target_url, const.PROP_EULER)
		go.set(target_url, const.PROP_EULER, random_vector)
		self:finish()
	end)

	if is_every_frame then
		action:set_every_frame()
	end
	action:set_delay(delay)
	action:set_name("transform.set_random_euler")
	return action
end


--- Set scale to a game object
-- @function actions.transform.set_scale
-- @tparam vector3 target_scale Scale vector
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.set_scale(target_scale, is_every_frame, delay, target_url)
	return helper.set_property(target_url, target_scale, is_every_frame, delay,
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
	return helper.set_property(target_url, target_scale, is_every_frame, delay,
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
	return helper.animate_property(target_url, target_scale, time, finish_event, delay, ease_function,
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
	return helper.animate_property(target_url, target_scale, time, finish_event, delay, ease_function,
		"transform.animate_scale_by", const.PROP_SCALE, true)
end


--- Get the scale property of a game object and store to variable
-- @function actions.transform.get_scale
-- @tparam string variable The variable to store result
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] url target_url The object to apply transform
-- @treturn ActionInstance
function M.get_scale(variable, is_every_frame, target_url)
	return helper.get_property(target_url, variable, const.PROP_SCALE, is_every_frame, "transform.get_scale")
end


-- @treturn ActionInstance
function M.look_at()

end


return M

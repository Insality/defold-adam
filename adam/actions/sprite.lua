--- Actions to work with sprites
-- @submodule Actions
-- @local

local const = require("adam.const")
local helper = require("adam.system.helper")
local ActionInstance = require("adam.system.action_instance")

local M = {}

-- TODO: play flipbook, animate tint, alpha, set flip, animate/get/set: cursor, scale, size(only get)


--- Play the flipbook for target url. Finish event play on play_flipbook finish callback.
-- The actions take minimum 1 frame.
-- @function actions.sprite.play_flipbook
-- @tparam string image The image to play
-- @tparam[opt] target_url The sprite url to play flipbook
-- @tparam[opt] string finish_event Name of trigger event
-- @tparam[opt] number delay The Time delay in seconds
-- @tparam[opt] target_component The name sprite component, by default - all sprite components in object
-- @treturn ActionInstance
function M.play_flipbook(image, target_url, finish_event, delay, target_component)
	local action = ActionInstance(function(self)
		local object_url = self:get_param(target_url) or self:get_adam_instance():get_self()

		if target_component then
			object_url = msg.url(object_url)
			object_url.fragment = target_component
		end

		sprite.play_flipbook(object_url, self:get_param(image), function()
			self:finish(finish_event)
		end)
	end)

	action:set_delay(delay)
	action:set_name("sprite.play_flipbook")
	return action
end


--- Set the tint to the sprite component
-- @function actions.sprite.set_tint
-- @tparam vector4 tint The tint vector
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt="sprite"}] target_component The name sprite component
-- @tparam[opt] url target_url The object to apply sprite
-- @treturn ActionInstance
function M.set_tint(tint, is_every_frame, delay, target_component, target_url)
	return helper.set_property(target_url, tint, is_every_frame, delay,
		"sprite.set_tint", const.PROP_TINT, false, target_component or const.SPRITE)
end


--- Add the tint to the sprite component
-- @function actions.sprite.add_tint
-- @tparam vector4 tint The tint vector
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt="sprite"}] target_component The name sprite component
-- @tparam[opt] url target_url The object to apply sprite
-- @treturn ActionInstance
function M.add_tint(tint, is_every_frame, delay, target_component, target_url)
	return helper.set_property(target_url, tint, is_every_frame, delay,
		"sprite.add_tint", const.PROP_TINT, true, target_component or const.SPRITE)
end


--- Animate the tint to the sprite component
-- @function actions.sprite.animate_tint
-- @tparam vector4 tint The tint vector
-- @tparam number time The time to animate
-- @tparam[opt] string finish_event Name of trigger event
-- @tparam[opt] number delay Delay before animate in seconds
-- @tparam[opt] ease ease_function The ease function to animate. Default in settings.get_default_easing
-- @tparam[opt="sprite"}] target_component The name sprite component
-- @tparam[opt] url target_url The object to apply sprite
-- @treturn ActionInstance
function M.animate_tint(tint, time, finish_event, delay, ease_function, target_component, target_url)
	return helper.animate_property(target_url, tint, time, finish_event, delay, ease_function,
		"sprite.animate_tint", const.PROP_TINT, false, nil, target_component or const.SPRITE)
end


--- Animate the tint of the sprite component with relative tint vector
-- @function actions.sprite.animate_tint_by
-- @tparam vector4 tint The tint vector
-- @tparam number time The time to animate
-- @tparam[opt] string finish_event Name of trigger event
-- @tparam[opt] number delay Delay before animate in seconds
-- @tparam[opt] ease ease_function The ease function to animate. Default in settings.get_default_easing
-- @tparam[opt="sprite"}] target_component The name sprite component
-- @tparam[opt] url target_url The object to apply sprite
-- @treturn ActionInstance
function M.animate_tint_by(tint, time, finish_event, delay, ease_function, target_component, target_url)
	return helper.animate_property(target_url, tint, time, finish_event, delay, ease_function,
		"sprite.animate_tint_by", const.PROP_TINT, true, nil, target_component or const.SPRITE)
end


--- Get the tint property of a game object and store to variable
-- @function actions.sprite.get_tint
-- @tparam string variable The variable to store result
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt="sprite"}] target_component The name sprite component
-- @tparam[opt] url target_url The object to apply sprite
-- @treturn ActionInstance
function M.get_tint(variable, is_every_frame, target_component, target_url)
	return helper.get_property(target_url, variable, const.PROP_TINT, is_every_frame, "sprite.get_tint", target_component or const.SPRITE)
end


--- Set the alpha to the sprite component
-- @function actions.sprite.set_alpha
-- @tparam number alpha The sprite alpha value
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt="sprite"}] target_component The name sprite component
-- @tparam[opt] url target_url The object to apply sprite
-- @treturn ActionInstance
function M.set_alpha(alpha, is_every_frame, delay, target_component, target_url)
	return helper.set_property(target_url, alpha, is_every_frame, delay,
		"sprite.set_alpha", const.PROP_TINT_ALPHA, false, target_component or const.SPRITE)
end


--- Add the alpha to the sprite component
-- @function actions.sprite.add_alpha
-- @tparam number alpha The sprite alpha value
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay Delay before translate in seconds
-- @tparam[opt="sprite"}] target_component The name sprite component
-- @tparam[opt] url target_url The object to apply sprite
-- @treturn ActionInstance
function M.add_alpha(alpha, is_every_frame, delay, target_component, target_url)
	return helper.set_property(target_url, alpha, is_every_frame, delay,
		"sprite.add_alpha", const.PROP_TINT_ALPHA, true, target_component or const.SPRITE)
end


--- Animate the alpha to the sprite component
-- @function actions.sprite.animate_alpha
-- @tparam number alpha The sprite alpha value
-- @tparam number time The time to animate
-- @tparam[opt] string finish_event Name of trigger event
-- @tparam[opt] number delay Delay before animate in seconds
-- @tparam[opt] ease ease_function The ease function to animate. Default in settings.get_default_easing
-- @tparam[opt="sprite"}] target_component The name sprite component
-- @tparam[opt] url target_url The object to apply sprite
-- @treturn ActionInstance
function M.animate_alpha(alpha, time, finish_event, delay, ease_function, target_component, target_url)
	return helper.animate_property(target_url, alpha, time, finish_event, delay, ease_function,
		"sprite.animate_alpha", const.PROP_TINT_ALPHA, false, nil, target_component or const.SPRITE)
end


--- Animate the alpha of the sprite component with relative alpha vector
-- @function actions.sprite.animate_alpha_by
-- @tparam number alpha The sprite alpha value
-- @tparam number time The time to animate
-- @tparam[opt] string finish_event Name of trigger event
-- @tparam[opt] number delay Delay before animate in seconds
-- @tparam[opt] ease ease_function The ease function to animate. Default in settings.get_default_easing
-- @tparam[opt="sprite"}] target_component The name sprite component
-- @tparam[opt] url target_url The object to apply sprite
-- @treturn ActionInstance
function M.animate_alpha_by(alpha, time, finish_event, delay, ease_function, target_component, target_url)
	return helper.animate_property(target_url, alpha, time, finish_event, delay, ease_function,
		"sprite.animate_alpha_by", const.PROP_TINT_ALPHA, true, nil, target_component or const.SPRITE)
end


--- Get the alpha property of a game object and store to variable
-- @function actions.sprite.get_alpha
-- @tparam string variable The variable to store result
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt="sprite"}] target_component The name sprite component
-- @tparam[opt] url target_url The object to apply sprite
-- @treturn ActionInstance
function M.get_alpha(variable, is_every_frame, target_component, target_url)
	return helper.get_property(target_url, variable, const.PROP_TINT_ALPHA, is_every_frame, "sprite.get_alpha", target_component or const.SPRITE)
end


--- Set vertical flip for the sprite
-- @function actions.sprite.set_vflip
-- @tparam boolean is_flip The boolean flag for flip
-- @tparam[opt] target_url The sprite url to play flipbook
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay The Time delay in seconds
-- @tparam[opt] target_component The name sprite component, by default - all sprite components in object
-- @treturn ActionInstance
function M.set_vflip(is_flip, target_url, is_every_frame, delay, target_component)
	local action = ActionInstance(function(self)
		local object_url = self:get_param(target_url) or self:get_adam_instance():get_self()

		if target_component then
			object_url = msg.url(object_url)
			object_url.fragment = target_component
		end

		sprite.set_vflip(object_url, self:get_param(is_flip))
	end)

	if is_every_frame then
		action:set_every_frame()
	end
	action:set_delay(delay)
	action:set_name("sprite.set_vflip")

	return action
end


--- Set horizontal flip for the sprite
-- @function actions.sprite.set_hflip
-- @tparam boolean is_flip The boolean flag for flip
-- @tparam[opt] target_url The sprite url to play flipbook
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] number delay The Time delay in seconds
-- @tparam[opt] target_component The name sprite component, by default - all sprite components in object
-- @treturn ActionInstance
function M.set_hflip(is_flip, target_url, is_every_frame, delay, target_component)
	local action = ActionInstance(function(self)
		local object_url = self:get_param(target_url) or self:get_adam_instance():get_self()

		if target_component then
			object_url = msg.url(object_url)
			object_url.fragment = target_component
		end

		sprite.set_hflip(object_url, self:get_param(is_flip))
	end)

	if is_every_frame then
		action:set_every_frame()
	end
	action:set_delay(delay)
	action:set_name("sprite.set_hflip")
	return action
end


return M

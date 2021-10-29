-- Several utilitary functions
-- @local

local const = require("adam.const")
local settings = require("adam.system.settings")
local ActionInstance = require("adam.system.action_instance")


local M = {}


function M.delay(delay, callback)
	if delay and delay > 0 then
		local timer_id = timer.delay(delay, false, callback)
		return timer_id
	end

	callback()
end


local NO_PADDING = {
	left = 0, right = 0, bottom = 0, top = 0,
}
-- Source: https://github.com/critique-gaming/crit/blob/master/crit/pick.lua
-- @param[type=url | string] sprite_url An URL identifying the sprite component.
-- @number x The x position of the point (in world space) to do the check on.
-- @number y The y position of the point (in world space) to do the check on.
-- @tparam[opt] PickPadding padding By how much should the hitbox of the sprite
--		be expanded or constricted.
-- @treturn boolean Returns `true` if the point hits inside the sprite and
--		`false` otherwise.
function M.pick_sprite(sprite_url, x, y, padding)
	padding = padding or NO_PADDING
	local size = go.get(sprite_url, hash("size"))

	local transform = go.get_world_transform(sprite_url)
	local pos = vmath.inv(transform) * vmath.vector4(x, y, 0, 1)
	x, y = pos.x, pos.y

	local half_width = size.x * 0.5
	local left = -half_width - padding.left
	local right = half_width + padding.right
	if x < left or x > right then return false end

	local half_height = size.y * 0.5
	local top = half_height + padding.top
	local bottom = -half_height - padding.bottom
	if y < bottom or y > top then return false end

	return true
end


function M.set_property(target_id, target_vector, is_every_frame, delay, action_name, property, is_relative, target_component)
	local action = ActionInstance(function(self, context)
		local object_id = self:get_param(target_id) or self:get_adam_instance():get_self()

		if target_component then
			object_id = msg.url(object_id)
			object_id.fragment = target_component
		end

		local value = self:get_param(target_vector)

		if is_relative then
			value = value + go.get(object_id, property)
		end

		if property == const.PROP_POS then
			go.set_position(value, object_id)
		else
			go.set(object_id, property, value)
		end

		self:finish()
	end)

	if is_every_frame then
		action:set_every_frame()
	end
	action:set_delay(delay)
	action:set_name(action_name)
	return action
end


function M.animate_property(target_id, target_vector, time, finish_event, delay, ease_function, action_name, property, is_relative, playback, target_component)
	local action = ActionInstance(function(self, context)
		local object_id = self:get_param(target_id) or self:get_adam_instance():get_self()

		if target_component then
			object_id = msg.url(object_id)
			object_id.fragment = target_component
		end

		local value = self:get_param(target_vector)

		if is_relative then
			value = value + go.get(object_id, property)
		end

		local easing = ease_function or settings.get_default_easing()
		context.animate_started = true
		go.animate(object_id, property, playback or go.PLAYBACK_ONCE_FORWARD, value, easing, time)

		context.callback_timer_id = M.delay(time, function()
			context.animate_started = false
			self:finish(finish_event)
		end)
	end, function(self, context)
		if context.animate_started then
			local object_id = self:get_param(target_id) or self:get_adam_instance():get_self()
			go.cancel_animations(object_id, property)
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


function M.get_property(target_id, variable, property, is_every_frame, action_name, target_component)
	local action = ActionInstance(function(self)
		local object_id = self:get_param(target_id) or self:get_adam_instance():get_self()

		if target_component then
			object_id = msg.url(object_id)
			object_id.fragment = target_component
		end

		local value = go.get(object_id, property)
		self:set_value(variable, value)
	end)

	if is_every_frame then
		action:set_every_frame()
	end
	action:set_name(action_name)
	return action
end


return M

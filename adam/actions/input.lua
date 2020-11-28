--- Actions to control the user input
-- @submodule Actions


local helper = require("adam.system.helper")
local ActionInstance = require("adam.system.action_instance")

local M = {}


local function get_input_status(action_id, variable, trigger_event, in_update_only, func_to_get_name)
	local action = ActionInstance(function(self)
		local adam_instance = self:get_adam_instance()
		local value = adam_instance[func_to_get_name](adam_instance, self:get_param(action_id)) and true or false
		if value then
			self:event(trigger_event)
		end
		if variable then
			self:set_value(variable, value)
		end
	end)

	if in_update_only then
		action:set_every_frame(true, true)
	end

	return action
end


local function get_sprite_status(action_id, sprite_url, variable, trigger_event, in_update_only, func_to_get_name)
	local action = ActionInstance(function(self)
		local adam_instance = self:get_adam_instance()
		local action = adam_instance[func_to_get_name](adam_instance, self:get_param(action_id))

		if action then
			local is_picked = helper.pick_sprite(sprite_url, action.x, action.y)
			if is_picked then
				self:event(trigger_event)
			end
			if variable then
				self:set_value(variable, is_picked and true or false)
			end
		else
			if variable then
				self:set_value(variable, false)
			end
		end
	end)

	if in_update_only then
		action:set_every_frame(true, true)
	end

	return action
end


--- Check is action_id is active now.
-- @function actions.input.get_action
-- @tparam string key_name The key to check
-- @tparam[opt] string variable Variable to set
-- @tparam[opt] boolean in_update_only Repeat this action every frame
-- @tparam[opt] string trigger_event The event to trigger on true condition
-- @treturn ActionInstance
function M.get_action(action_id, variable, in_update_only, trigger_event)
	local action = get_input_status(action_id, variable, trigger_event, in_update_only, "get_input_current")
	action:set_name("input.get_action")
	return action
end


--- Check is action_id was pressed.
-- @function actions.input.get_action_pressed
-- @tparam string key_name The key to check
-- @tparam[opt] string variable Variable to set
-- @tparam[opt] boolean in_update_only Repeat this action every frame
-- @tparam[opt] string trigger_event The event to trigger on true condition
-- @treturn ActionInstance
function M.get_action_pressed(action_id, variable, in_update_only, trigger_event)
	local action = get_input_status(action_id, variable, trigger_event, in_update_only, "get_input_pressed")
	action:set_name("input.get_action_pressed")
	return action
end


--- Check is action_id was released.
-- @function actions.input.get_action_released
-- @tparam string key_name The key to check
-- @tparam[opt] string variable Variable to set
-- @tparam[opt] boolean in_update_only Repeat this action every frame
-- @tparam[opt] string trigger_event The event to trigger on true condition
-- @treturn ActionInstance
function M.get_action_released(action_id, variable, in_update_only, trigger_event)
	local action = get_input_status(action_id, variable, trigger_event, in_update_only, "get_input_released")
	action:set_name("input.get_action_released")
	return action
end


--- Check is action_id is active now on sprite_url
-- @function actions.input.get_sprite_action
-- @tparam string key_name The key to check
-- @tparam url sprite_url The sprite url to check input action
-- @tparam[opt] string variable Variable to set
-- @tparam[opt] boolean in_update_only Repeat this action every frame
-- @tparam[opt] string trigger_event The event to trigger on true condition
-- @treturn ActionInstance
function M.get_sprite_action(action_id, sprite_url, variable, in_update_only, trigger_event)
	local action = get_sprite_status(action_id, sprite_url, variable, trigger_event, in_update_only, "get_input_current")
	action:set_name("input.get_sprite_action")
	return action
end


--- Check is action_id is active now on sprite_url
-- @function actions.input.get_sprite_action_pressed
-- @tparam string key_name The key to check
-- @tparam url sprite_url The sprite url to check input action
-- @tparam[opt] string variable Variable to set
-- @tparam[opt] boolean in_update_only Repeat this action every frame
-- @tparam[opt] string trigger_event The event to trigger on true condition
-- @treturn ActionInstance
function M.get_sprite_action_pressed(action_id, sprite_url, variable, in_update_only, trigger_event)
	local action = get_sprite_status(action_id, sprite_url, variable, trigger_event, in_update_only, "get_input_pressed")
	action:set_name("input.get_sprite_action_pressed")
	return action
end


--- Check is action_id is active now on sprite_url
-- @function actions.input.get_sprite_action_released
-- @tparam string key_name The key to check
-- @tparam url sprite_url The sprite url to check input action
-- @tparam[opt] string variable Variable to set
-- @tparam[opt] boolean in_update_only Repeat this action every frame
-- @tparam[opt] string trigger_event The event to trigger on true condition
-- @treturn ActionInstance
function M.get_sprite_action_released(action_id, sprite_url, variable, in_update_only, trigger_event)
	local action = get_sprite_status(action_id, sprite_url, variable, trigger_event, in_update_only, "get_input_released")
	action:set_name("input.get_sprite_action_released")
	return action
end


--- Imitate two keys as axis. Set result in variable. If both keys are pressed, result will be 0
-- @function actions.input.get_axis_actions
-- @tparam string negative_action The action_id to negative check
-- @tparam string positive_action The action_id to positive check
-- @tparam string variable Variable to set
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt=1] number multiplier The value to multiply result
-- @treturn ActionInstance
function M.get_axis_actions(negative_action, positive_action, variable, is_every_frame, multiplier)
	local action = ActionInstance(function(self)
		local adam_instance = self:get_adam_instance()
		local negative = adam_instance:get_input_current(self:get_param(negative_action))
		local positive = adam_instance:get_input_current(self:get_param(positive_action))
		local value = 0
		if negative then
			value = value - 1
		end
		if positive then
			value = value + 1
		end
		self:set_value(variable, value * self:get_param(multiplier or 1))
	end)

	if is_every_frame then
		action:set_every_frame(true)
	end

	action:set_name("input.get_axis_actions")
	return action
end


return M

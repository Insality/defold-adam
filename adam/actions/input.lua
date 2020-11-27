--- Actions to control the user input
-- @submodule Actions


local ActionInstance = require("adam.system.action_instance")

local M = {}


local function get_input_status(action_id, variable, is_every_frame, value_to_set, func_to_get_name)
	local action = ActionInstance(function(self)
		local adam_instance = self:get_adam_instance()
		local value = adam_instance[func_to_get_name](adam_instance, self:get_param(action_id)) and true or false
		if value_to_set then
			value = value and value_to_set or 0
		end
		self:set_value(variable, value)
	end)

	if is_every_frame then
		action:set_every_frame(true)
	end

	return action
end


--- Check is action_id is active now. Can set number instead of boolean on pressed key
-- @function actions.input.get_action
-- @tparam string key_name The key to check
-- @tparam string variable Variable to set
-- @tparam[opt] number value_to_set Set this number or 0 instead of true/false
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.get_action(action_id, variable, is_every_frame, value_to_set)
	local action = get_input_status(action_id, variable, is_every_frame, value_to_set, "get_input_current")
	action:set_name("input.get_action")
	return action
end


--- Check is action_id was pressed. Can set number instead of boolean on pressed key
-- @function actions.input.get_action_pressed
-- @tparam string key_name The key to check
-- @tparam string variable Variable to set
-- @tparam[opt] number value_to_set Set this number or 0 instead of true/false
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.get_action_pressed(action_id, variable, is_every_frame, value_to_set)
	local action = get_input_status(action_id, variable, is_every_frame, value_to_set, "get_input_pressed")
	action:set_name("input.get_action_pressed")
	return action
end


--- Check is action_id was released. Can set number instead of boolean on pressed key
-- @function actions.input.get_action_released
-- @tparam string key_name The key to check
-- @tparam string variable Variable to set
-- @tparam[opt] number value_to_set Set this number or 0 instead of true/false
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.get_action_released(action_id, variable, is_every_frame, value_to_set)
	local action = get_input_status(action_id, variable, is_every_frame, value_to_set, "get_input_released")
	action:set_name("input.get_action_released")
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

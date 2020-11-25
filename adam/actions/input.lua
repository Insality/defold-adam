--- Actions to control the user input
-- @submodule Actions


local const = require("adam.const")
local ActionInstance = require("adam.system.action_instance")

local M = {}


--- Check is key is pressed. Can set number instead of boolean on pressed key
-- @tparam string key_name The key to check
-- @tparam string variable Variable to set
-- @tparam[opt] number value_to_set Set this number or 0 instead of true/false
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.get_key(key_name, variable, is_every_frame, value_to_set)
	local action = ActionInstance(function(self)
		local adam_instance = self:get_adam_instance()
		local value = adam_instance:get_input_current(self:get_param(key_name)) and true or false
		if value_to_set then
			value = value and value_to_set or 0
		end
		self:set_value(variable, value)
	end)

	if is_every_frame then
		action:set_every_frame(true)
	end

	action:set_name("input.get_key")
	return action
end


--- Imitate two keys as axis. Set result in variable. If both keys are pressed, result will be 0
-- @tparam string negative_key The key to negative check
-- @tparam string positive_key The key to positive check
-- @tparam string variable Variable to set
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt=1] number multiplier The value to multiply result
-- @treturn ActionInstance
function M.get_axis_keys(negative_key, positive_key, variable, is_every_frame, multiplier)
	local action = ActionInstance(function(self)
		local adam_instance = self:get_adam_instance()
		local negative = adam_instance:get_input_current(self:get_param(negative_key))
		local positive = adam_instance:get_input_current(self:get_param(positive_key))
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

	action:set_name("input.get_axis_keys")
	return action
end


return M

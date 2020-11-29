--- Constain actions make logical expressions
-- @submodule Actions

local const = require("adam.const")
local helper = require("adam.system.helper")
local ActionInstance = require("adam.system.action_instance")

local M = {}

--- Sends an event if all the variables are true
-- @function actions.logic.all_true
-- @tparam variables[] variables_array Array of variables. Can be FSM or usual variable
-- @tparam[opt] string trigger_event The event to send if all variables are true
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.all_true(variables_array, trigger_event, is_every_frame)
	local action = ActionInstance(function(self)
		for i = 1, #variables_array do
			if not self:get_param(variables_array[i]) then
				return
			end
		end

		self:event(trigger_event)
	end)

	if is_every_frame then
		action:set_every_frame(true)
	end

	action:set_name("logic.all_true")
	return action
end


--- Sends an event if any of the variables are true
-- @function actions.logic.any_true
-- @tparam variables[] variables_array Array of variables. Can be FSM or usual variable
-- @tparam[opt] string trigger_event The event to send if any of variables are true
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.any_true(variables_array, trigger_event, is_every_frame)
	local action = ActionInstance(function(self)
		local is_any_true = false
		for i = 1, #variables_array do
			is_any_true = is_any_true or self:get_param(variables_array[i])

			if is_any_true then
				break
			end
		end

		if is_any_true then
			self:event(trigger_event)
		end
	end)

	if is_every_frame then
		action:set_every_frame(true)
	end

	action:set_name("logic.any_true")
	return action
end


--- Sends an event if all the variables are false
-- @function actions.logic.all_false
-- @tparam variables[] variables_array Array of variables. Can be FSM or usual variable
-- @tparam[opt] string trigger_event The event to send if all variables are false
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.all_false(variables_array, trigger_event, is_every_frame)
	local action = ActionInstance(function(self)
		for i = 1, #variables_array do
			if self:get_param(variables_array[i]) then
				return
			end
		end

		self:event(trigger_event)
	end)

	if is_every_frame then
		action:set_every_frame(true)
	end

	action:set_name("logic.all_false")
	return action
end


--- Tests if the value of a variable has changed.
-- Use this to send an event on change variable.
-- @function actions.logic.changed
-- @tparam variable variable The variable to test on changed
-- @tparam[opt] string trigger_event The event to send on variable change
-- @tparam[opt] string store_result Save true to this variable, if variable has changed
-- @treturn ActionInstance
function M.changed(variable, trigger_event, store_result)
	local action = ActionInstance(function(self, context)
		if context.previous_value == nil then
			context.previous_value = self:get_param(variable)
		end

		if context.previous_value ~= self:get_param(variable) then
			self:event(trigger_event)
			if store_result then
				self:set_value(store_result, true)
			end
		end

		context.previous_value = self:get_param(variable)
	end, function(self, context)
		context.previous_value = nil
	end)

	action:set_every_frame(true)
	action:set_name("logic.changed")
	return action
end


--- Send events based on the value of a variable.
-- @function actions.logic.test
-- @tparam variable variable The variable to test
-- @tparam[opt] string event_on_true The event to send if variable is true
-- @tparam[opt] string event_on_false The event to send if variable is false
-- @tparam[opt] string store_result Save true to this variable, if variable has changed
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.test(variable, event_on_true, event_on_false, is_every_frame)
	local action = ActionInstance(function(self, context)
		if self:get_param(variable) then
			return self:event(event_on_true)
		else
			return self:event(event_on_false)
		end
	end)

	if is_every_frame then
		action:set_every_frame(true)
	end

	action:set_name("logic.test")
	return action
end


return M

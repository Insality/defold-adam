--- Math actions perform different operations on FSM variables
-- @submodule Actions

local const = require("adam.const")
local ActionInstance = require("adam.system.action_instance")

local M = {}


--- Set a value to a variable
-- @function actions.math.set
-- @tparam string source Variable to set
-- @tparam number|variable value The value to set
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] boolean is_every_second Repeat this action every second
-- @treturn ActionInstance
function M.set(source, value, is_every_frame, is_every_second)
	local action = ActionInstance(function(self)
		local source_value = self:get_param(value)
		self:set_value(source, source_value)
	end)

	if is_every_frame then
		action:set_every_frame(true)
	end

	if is_every_second then
		action:set_periodic(const.SECOND)
	end

	action:set_name("math.add")
	return action
end


--- Adds a value to a variable
-- @function actions.math.add
-- @tparam string source Variable to add
-- @tparam number|variable value The value to add
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] boolean is_every_second Repeat this action every second
-- @treturn ActionInstance
function M.add(source, value, is_every_frame, is_every_second)
	local action = ActionInstance(function(self)
		local source_value = self:get_value(source) + self:get_param(value)
		self:set_value(source, source_value)
	end)

	if is_every_frame then
		action:set_every_frame(true)
	end

	if is_every_second then
		action:set_periodic(const.SECOND)
	end

	action:set_name("math.add")
	return action
end


-- @treturn ActionInstance
function M.substract()

end


--- Multiplies a variable by another value
-- @function actions.math.multiply
-- @tparam string source Variable to multiply
-- @tparam number|variable value The multiplier
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.multiply(source, value, is_every_frame)
	local action = ActionInstance(function(self)
		local source_value = self:get_value(source) * self:get_param(value)
		self:set_value(source, source_value)
	end)

	if is_every_frame then
		action:set_every_frame(true)
	end

	action:set_name("math.multiply")
	return action
end


-- @treturn ActionInstance
function M.divide()

end


-- @treturn ActionInstance
function M.clamp()

end


-- @treturn ActionInstance
function M.abs()

end


-- @treturn ActionInstance
function M.random()

end


-- @treturn ActionInstance
function M.random_boolean()

end


return M

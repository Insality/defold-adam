--- Math actions perform different operations on FSM variables
-- @submodule Actions

local const = require("adam.const")
local ActionInstance = require("adam.system.action_instance")

local M = {}


local function math_operation(source, value, is_every_frame, is_every_second, action_name, operator)
	local action = ActionInstance(function(self)
		local source_value = operator(self, self:get_value(source), self:get_param(value))
		self:set_value(source, source_value)
	end)

	if is_every_frame then
		action:set_every_frame(true)
	end

	if is_every_second then
		action:set_periodic(const.SECOND)
	end

	action:set_name(action_name)
	return action
end


--- Set a value to a variable
-- @function actions.math.set
-- @tparam string source Variable to set
-- @tparam variable value The value to set
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] boolean is_every_second Repeat this action every second
-- @treturn ActionInstance
function M.set(source, value, is_every_frame, is_every_second)
	return math_operation(source, value, is_every_frame, is_every_second, "math.set", function(self, a, b)
		return b
	end)
end


--- Adds a value to a variable
-- @function actions.math.add
-- @tparam string source Variable to add
-- @tparam variable value The value to add
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] boolean is_every_second Repeat this action every second
-- @treturn ActionInstance
function M.add(source, value, is_every_frame, is_every_second)
	return math_operation(source, value, is_every_frame, is_every_second, "math.add", function(self, a, b)
		return a + b
	end)
end


--- Subtracts a value from a variable
-- @function actions.math.substract
-- @tparam string source Variable to substract from
-- @tparam variable value The value to substract
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] boolean is_every_second Repeat this action every second
-- @treturn ActionInstance
function M.substract(source, value, is_every_frame, is_every_second)
	return math_operation(source, value, is_every_frame, is_every_second, "math.substract", function(self, a, b)
		return a - b
	end)
end


--- Multiplies a variable by another value
-- @function actions.math.multiply
-- @tparam string source Variable to multiply
-- @tparam variable value The multiplier
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.multiply(source, value, is_every_frame)
	return math_operation(source, value, is_every_frame, nil, "math.multiply", function(self, a, b)
		return a * b
	end)
end


--- Divides a value by another value
-- @function actions.math.divide
-- @tparam string source Variable to divide
-- @tparam variable value Divide by this value
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.divide(source, value, is_every_frame)
	return math_operation(source, value, is_every_frame, nil, "math.divide", function(self, a, b)
		return a / b
	end)
end


--- Clamps the value of a variable to a min/max range.
-- @function actions.math.set
-- @tparam string source Variable to set
-- @tparam number min The minimum value allowed.
-- @tparam number max The maximum value allowed.
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] boolean is_every_second Repeat this action every second
-- @treturn ActionInstance
function M.clamp(source, min, max, is_every_frame, is_every_second)
	return math_operation(source, nil, is_every_frame, nil, "math.abs", function(self, a)
		if min > max then
			min, max = max, min
		end
		return math.min(math.max(min, a), max)
	end)
end


--- Sets a float variable to its absolute value.
-- @function actions.math.abs
-- @tparam string source Variable to abs
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.abs(source, is_every_frame)
	return math_operation(source, nil, is_every_frame, nil, "math.abs", function(self, a)
		return math.abs(a)
	end)
end


--- Sets a variable to a random value between min/max.
-- @function actions.math.random
-- @tparam string source Variable to set
-- @tparam variable min Minimum value of the random number
-- @tparam variable max Maximum value of the random number.
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] boolean is_every_second Repeat this action every second
-- @treturn ActionInstance
function M.random(source, min, max, is_every_frame, is_every_second)
	return math_operation(source, min, is_every_frame, is_every_second, "math.random", function(self, a)
		return math.random(self:get_param(min), self:get_param(max))
	end)
end


--- Sets a variable to a random value true or false
-- @function actions.math.random_boolean
-- @tparam string source Variable to set
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] boolean is_every_second Repeat this action every second
-- @treturn ActionInstance
function M.random_boolean(source, is_every_frame, is_every_second)
	return math_operation(source, nil, is_every_frame, is_every_second, "math.random_boolean", function(self)
		return math.random() > 0.5
	end)
end


--- Get a cos value
-- @function actions.math.cos
-- @tparam variable value Variable to take cos
-- @tparam variable store_variable Variable to set
-- @tparam[opt] boolean is_degrees Check true, if using degrees instead of radians
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.cos(value, store_variable, is_degrees, is_every_frame)
	return math_operation(store_variable, value, is_every_frame, nil, "math.cos", function(self, a, b)
		if is_degrees then
			b = b * math.pi/180
		end
		return math.cos(b)
	end)
end


--- Get a sin value
-- @function actions.math.sin
-- @tparam variable value Variable to take sin
-- @tparam variable store_variable Variable to set
-- @tparam[opt] boolean is_degrees Check true, if using degrees instead of radians
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.sin(value, store_variable, is_degrees, is_every_frame)
	return math_operation(store_variable, value, is_every_frame, nil, "math.sin", function(self, a, b)
		if is_degrees then
			b = b * math.pi/180
		end
		return math.sin(b)
	end)
end






return M

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
		action:set_every_frame()
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
-- @function actions.math.clamp
-- @tparam string source Variable to clamp
-- @tparam variable min The minimum value allowed.
-- @tparam variable max The maximum value allowed.
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] boolean is_every_second Repeat this action every second
-- @treturn ActionInstance
function M.clamp(source, min, max, is_every_frame, is_every_second)
	return math_operation(source, nil, is_every_frame, is_every_second, "math.clamp", function(self, a)
		local min_value, max_value = self:get_param(min), self:get_param(max)
		if min_value > max_value then
			min_value, max_value = max_value, min_value
		end
		return math.min(math.max(min_value, a), max_value)
	end)
end


--- Loop value in range.
-- For example If value less of min value it turns to max
-- @function actions.math.loop
-- @tparam string source Variable to loop
-- @tparam number min The minimum value to loop.
-- @tparam number max The maximum value to loop.
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] boolean is_every_second Repeat this action every second
-- @treturn ActionInstance
function M.loop(source, min, max, is_every_frame,is_every_second)
	return math_operation(source, nil, is_every_frame, is_every_second, "math.loop", function(self, a)
		local min_value, max_value = self:get_param(min), self:get_param(max)
		while a > max_value do
			a = min_value + (a - max_value)
		end
		while a < min_value do
			a = max_value - (min_value - a)
		end
		return a
	end)
end


--- Choose min value
-- @function actions.math.min
-- @tparam string source Variable to compare
-- @tparam variable|number min Another variable
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] boolean is_every_second Repeat this action every second
-- @treturn ActionInstance
function M.min(source, second_value, is_every_frame, is_every_second)
	return math_operation(source, second_value, is_every_frame, is_every_second, "math.min", function(self, a, b)
		return math.min(a, b)
	end)
end


--- Choose max value
-- @function actions.math.max
-- @tparam string source Variable to compare
-- @tparam variable|number min Another variable
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @tparam[opt] boolean is_every_second Repeat this action every second
-- @treturn ActionInstance
function M.max(source, second_value, is_every_frame, is_every_second)
	return math_operation(source, second_value, is_every_frame, is_every_second, "math.max", function(self, a, b)
		return math.max(a, b)
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


--- Get a asin value
-- @function actions.math.asin
-- @tparam variable value Variable to take asin
-- @tparam variable store_variable Variable to set
-- @tparam[opt] boolean is_degrees Check true, if using degrees instead of radians
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.asin(value, store_variable, is_degrees, is_every_frame)
	return math_operation(store_variable, value, is_every_frame, nil, "math.asin", function(self, a, b)
		if is_degrees then
			b = math.deg(b)
		end
		return math.asin(b)
	end)
end


--- Get a acos value
-- @function actions.math.acos
-- @tparam variable value Variable to take acos
-- @tparam variable store_variable Variable to set
-- @tparam[opt] boolean is_degrees Check true, if using degrees instead of radians
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.acos(value, store_variable, is_degrees, is_every_frame)
	return math_operation(store_variable, value, is_every_frame, nil, "math.acos", function(self, a, b)
		if is_degrees then
			b = math.deg(b)
		end
		return math.acos(b)
	end)
end


--- Get a tan value
-- @function actions.math.tan
-- @tparam variable value Variable to take tan
-- @tparam variable store_variable Variable to set
-- @tparam[opt] boolean is_degrees Check true, if using degrees instead of radians
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.tan(value, store_variable, is_degrees, is_every_frame)
	return math_operation(store_variable, value, is_every_frame, nil, "math.tan", function(self, a, b)
		if is_degrees then
			b = math.deg(b)
		end
		return math.tan(b)
	end)
end


--- Get a atan value
-- @function actions.math.atan
-- @tparam variable value Variable to take atan
-- @tparam variable store_variable Variable to set
-- @tparam[opt] boolean is_degrees Check true, if using degrees instead of radians
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.atan(value, store_variable, is_degrees, is_every_frame)
	return math_operation(store_variable, value, is_every_frame, nil, "math.atan", function(self, a, b)
		if is_degrees then
			b = math.deg(b)
		end
		return math.atan(b)
	end)
end


--- Get a atan2 value
-- @function actions.math.atan2
-- @tparam variable value Variable to take atan2
-- @tparam variable store_variable Variable to set
-- @tparam[opt] boolean is_degrees Check true, if using degrees instead of radians
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.atan2(value, store_variable, is_degrees, is_every_frame)
	return math_operation(store_variable, value, is_every_frame, nil, "math.atan2", function(self, a, b)
		if is_degrees then
			b = math.deg(b)
		end
		return math.atan2(b)
	end)
end


--- Apply a math function (a, b)=>c to source variable.
-- Useful if you want do something, what is not designed in Adam.
-- @function actions.math.operator
-- @tparam variable source_variable_a First variable
-- @tparam variable variable_b Second variable
-- @tparam function operator The callback function
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.operator(source_variable_a, variable_b, operator, is_every_frame)
	return math_operation(source_variable_a, variable_b, is_every_frame, nil, "math.operator", function(self, a, b)
		return operator(a, b)
	end)
end



return M

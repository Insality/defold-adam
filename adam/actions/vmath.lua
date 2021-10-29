--- Actions with vectors on FSM variables
-- @submodule Actions

local ActionInstance = require("adam.system.action_instance")

local M = {}


--- Sets the XYZ channels of a Vector3 variable
-- @function actions.vmath.set_xyz
-- @tparam string source Variable to set
-- @tparam[opt] number value_x The x value to set. Pass nil to not change value
-- @tparam[opt] number value_y The y value to set. Pass nil to not change value
-- @tparam[opt] number value_z The z value to set. Pass nil to not change value
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.set_xyz(source, value_x, value_y, value_z, is_every_frame)
	local action = ActionInstance(function(self)
		local property = self:get_value(source)
		property.x = self:get_param(value_x) or property.x
		property.y = self:get_param(value_y) or property.y
		property.z = self:get_param(value_z) or property.z
	end)

	if is_every_frame then
		action:set_every_frame()
	end
	action:set_name("vmath.set_xyz")
	return action
end


--- Add the XYZ channels of a Vector3 variable
-- @function actions.vmath.add_xyz
-- @tparam string source Variable to add
-- @tparam[opt] number value_x The x value to add. Pass nil to not change value
-- @tparam[opt] number value_y The y value to add. Pass nil to not change value
-- @tparam[opt] number value_z The z value to add. Pass nil to not change value
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.add_xyz(source, value_x, value_y, value_z, is_every_frame)
	local action = ActionInstance(function(self)
		local property = self:get_value(source)
		property.x = property.x + (self:get_param(value_x) or 0)
		property.y = property.y + (self:get_param(value_y) or 0)
		property.z = property.z + (self:get_param(value_z) or 0)
	end)

	if is_every_frame then
		action:set_every_frame()
	end
	action:set_name("vmath.add_xyz")
	return action
end


--- Adds a Vector3 value to a Vector3 variable
-- @function actions.vmath.add
-- @tparam string source Variable to add
-- @tparam variable variable Vector3 to add
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.add(source, variable, is_every_frame)
	local action = ActionInstance(function(self)
		local property = self:get_value(source)
		local value = self:get_param(variable)
		property.x = property.x + (value.x or 0)
		property.y = property.y + (value.y or 0)
		property.z = property.z + (value.z or 0)
	end)

	if is_every_frame then
		action:set_every_frame()
	end
	action:set_name("vmath.add")
	return action
end


--- Get the XYZ channels of a Vector3 variable
-- @function actions.vmath.get_xyz
-- @tparam string source Variable to get
-- @tparam[opt] string value_x The variable to store x value. Pass nil to not store
-- @tparam[opt] string value_y The variable to store y value. Pass nil to not store
-- @tparam[opt] string value_z The variable to store z value. Pass nil to not store
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.get_xyz(source, value_x, value_y, value_z, is_every_frame)
	local action = ActionInstance(function(self)
		local property = self:get_value(source)
		if value_x then
			self:set_value(value_x, property.x)
		end
		if value_y then
			self:set_value(value_y, property.y)
		end
		if value_z then
			self:set_value(value_z, property.z)
		end
	end)

	if is_every_frame then
		action:set_every_frame()
	end
	action:set_name("vmath.get_xyz")
	return action
end


--- Get the length of vector to the store value
-- @function actions.vmath.length
-- @tparam variable variable The vector3 to get length
-- @tparam string store The variable to store euler result. Pass nil to not store
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.length(source, store, is_every_frame)
	local action = ActionInstance(function(self)
		local vector = self:get_value(source)
		self:set_value(store, vmath.length(vector))
	end)

	if is_every_frame then
		action:set_every_frame()
	end
	action:set_name("vmath.length")
	return action
end


--- Multiply a vector by a varialbe
-- @function actions.vmath.multiply
-- @tparam string source Variable vector to multiply
-- @tparam variable value The multiplier variable
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.multiply(source, value, is_every_frame)
	local action = ActionInstance(function(self)
		local property = self:get_value(source)
		self:set_value(source, property * self:get_param(value))
	end)

	if is_every_frame then
		action:set_every_frame()
	end
	action:set_name("vmath.multiply")
	return action
end


--- Get euler value between two points
-- @function actions.vmath.get_euler
-- @tparam variable from Vector3 to check from
-- @tparam variable from Vector3 to check to
-- @tparam string store The variable to store euler result. Pass nil to not store
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.get_euler(from, to, store, is_every_frame)
	local action = ActionInstance(function(self)
		local dir_vector = self:get_param(to) - self:get_param(from)
		local angle = math.atan2(dir_vector.y, dir_vector.x)
		self:set_value(store, math.deg(angle))
	end)

	if is_every_frame then
		action:set_every_frame()
	end
	action:set_name("vmath.get_euler")
	return action
end


--- Subtracts a one vector3 from another
-- @function actions.vmath.subtract
-- @tparam string source Variable vector to subtract from
-- @tparam variable value The vector to subtract
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.subtract(source, variable, is_every_frame)
	local action = ActionInstance(function(self)
		local property = self:get_value(source)
		local value = self:get_param(variable)
		property.x = property.x - (value.x or 0)
		property.y = property.y - (value.y or 0)
		property.z = property.z - (value.z or 0)
	end)

	if is_every_frame then
		action:set_every_frame()
	end
	action:set_name("vmath.subtract")
	return action
end


--- Normalize a vector variable. His length will be 1. Of length of vector - 0 it will be not changed
-- @function actions.vmath.subtract
-- @tparam string source Variable vector to normalize
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
-- @treturn ActionInstance
function M.normalize(source, is_every_frame)
	local action = ActionInstance(function(self)
		local vector = self:get_value(source)
		local length = vmath.length(vector)
		if length > 0 then
			vector.x = vector.x / length
			vector.y = vector.y / length
			vector.z = vector.z / length
			self:set_value(source, vector)
		end
	end)

	if is_every_frame then
		action:set_every_frame()
	end
	action:set_name("vmath.normalize")
	return action
end



return M

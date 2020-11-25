--- Actions with vectors on FSM variables
-- @submodule Actions

local const = require("adam.const")
local helper = require("adam.system.helper")
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

	action:set_every_frame(is_every_frame)
	action:set_name("vmath.set_xyz")
	return action
end




return M

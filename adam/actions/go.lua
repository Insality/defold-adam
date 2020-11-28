--- Defold Game Objects actions for create, delete and other manipulation
-- @submodule Actions

local ActionInstance = require("adam.system.action_instance")


local M = {}


-- @treturn ActionInstance
function M.create_object(factory_url, position, variable, delay)
	local action = ActionInstance(function(self)
		local go_id = factory.create(factory_url, position)
		if variable then
			self:set_value(variable, go_id)
		end
		self:finish()
	end)

	action:set_delay(delay)
	action:set_name("go.create_object")
	return action
end


--- Delete the current game object
-- Useful for game objects that need to kill themselves, for example a projectile that explodes on impact.
-- @function actions.go.delete_self
-- @tparam[opt] number delay Delay before delete
-- @tparam[opt] boolean not_recursive Set true to not delete children of deleted go
-- @treturn ActionInstance
function M.delete_self(delay, not_recursive)
	local action = ActionInstance(function(self)
		go.delete(".", not not_recursive)
		self:finish()
	end)

	action:set_delay(delay)
	action:set_name("go.delete_self")
	return action
end


-- @treturn ActionInstance
function M.delete_object()

end


-- @treturn ActionInstance
function M.enable_object()

end


-- @treturn ActionInstance
function M.disable_object()

end


return M

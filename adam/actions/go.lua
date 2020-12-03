--- Defold Game Objects actions for create, delete and other manipulation
-- @submodule Actions

local const = require("adam.const")
local ActionInstance = require("adam.system.action_instance")


local M = {}


--- Spawn game object via factory
-- @function actions.go.create_object
-- @tparam url factory_url The factory component to be used
-- @tparam[opt] vector3 position The position to set
-- @tparam[opt] variable variable The variable to store created game object id
-- @tparam[opt] number delay The Time delay in seconds
-- @tparam[opt] vector3 scale The scale to set
-- @tparam[opt] vector3 rotation The rotation to set
-- @tparam[opt] table properties The properties to set
-- @treturn ActionInstance
function M.create_object(factory_url, position, variable, delay, scale, rotation, properties)
	local action = ActionInstance(function(self)
		local go_id = factory.create(factory_url, self:get_param(position),
				self:get_param(rotation), self:get_param(properties), self:get_param(scale))
		if variable then
			self:set_value(variable, go_id)
		end
		self:finish()
	end)

	action:set_delay(delay)
	action:set_name("go.create_object")
	return action
end


--- Spawn game objects via collection factory
-- @function actions.go.create_objects
-- @tparam url collection_factory_url The colection factory component to be used
-- @tparam[opt] vector3 position The position to set
-- @tparam[opt] variable variable The variable to store created game object id
-- @tparam[opt] number delay The Time delay in seconds
-- @tparam[opt] vector3 scale The scale to set
-- @tparam[opt] vector3 rotation The rotation to set
-- @tparam[opt] table properties The properties to set
-- @treturn ActionInstance
function M.create_objects(collection_factory_url, position, variable, delay, scale, rotation, properties)
	local action = ActionInstance(function(self)
		local go_ids = collectionfactory.create(collection_factory_url, self:get_param(position),
				self:get_param(rotation), self:get_param(properties), self:get_param(scale))
		if variable then
			self:set_value(variable, go_ids)
		end
		self:finish()
	end)

	action:set_delay(delay)
	action:set_name("go.create_objects")
	return action
end


--- Delete the current game object
-- Useful for game objects that need to kill themselves, for example a projectile that explodes on impact.
-- @function actions.go.delete_self
-- @tparam[opt] number delay Delay before delete
-- @tparam[opt] boolean not_recursive Set true to not delete children of deleted go
-- @treturn ActionInstance
function M.delete_self(delay, not_recursive)
	local action = M.delete_object(const.SELF, delay, not_recursive)
	action:set_name("go.delete_self")
	return action
end


--- Delete the game object
-- @function actions.go.delete_object
-- @tparam[opt="."] url target The game object to delete, self by default
-- @tparam[opt] number delay Delay before delete
-- @tparam[opt] boolean not_recursive Set true to not delete children of deleted go
-- @treturn ActionInstance
function M.delete_object(target, delay, not_recursive)
	local action = ActionInstance(function(self)
		go.delete(target or const.SELF, not not_recursive)
		self:finish()
	end)

	action:set_delay(delay)
	action:set_name("go.delete_object")
	return action
end


--- Delete the game objects
-- @function actions.go.delete_objects
-- @tparam table target_ids The game objects to delete
-- @tparam[opt] number delay Delay before delete
-- @tparam[opt] boolean not_recursive Set true to not delete children of deleted go
-- @treturn ActionInstance
function M.delete_objects(target_ids, delay, not_recursive)
	local action = ActionInstance(function(self)
		for key, value in pairs(target_ids) do
			go.delete(key, not not_recursive)
		end
		self:finish()
	end)

	action:set_delay(delay)
	action:set_name("go.delete_objects")
	return action
end


--- Enable the receiving component
-- @function actions.go.enable
-- @tparam[opt="."] url target The game object to delete, self by default
-- @tparam[opt] number delay Delay before delete
-- @treturn ActionInstance
function M.enable(target, delay)
	local action = ActionInstance(function(self)
		msg.post(target or const.SELF, "enable")
		self:finish()
	end)

	action:set_delay(delay)
	action:set_name("go.enable_object")
	return action
end


--- Enable the receiving component
-- @function actions.go.disable
-- @tparam[opt="."] url target The game object to delete, self by default
-- @tparam[opt] number delay Delay before delete
-- @treturn ActionInstance
function M.disable(target, delay)
	local action = ActionInstance(function(self)
		msg.post(target or const.SELF, "disable")
		self:finish()
	end)

	action:set_delay(delay)
	action:set_name("go.disable_object")
	return action
end


return M

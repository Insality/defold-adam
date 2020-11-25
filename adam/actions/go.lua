--- Defold Game Objects actions for create, delete and other manipulation
-- @submodule Actions

local helper = require("adam.system.helper")
local ActionInstance = require("adam.system.action_instance")


local M = {}


-- @treturn ActionInstance
function M.create_object()

end


--- Delete the current game object
-- Useful for game objects that need to kill themselves, for example a projectile that explodes on impact.
-- @function actions.go.delete_self
-- @tparam[opt] number delay Delay before delete
-- @tparam[opt] boolean not_recursive Set true to not delete children of deleted go
-- @treturn ActionInstance
function M.delete_self(delay, not_recursive)
	local action = ActionInstance(function(self)
		self.context.timer_id = helper.delay(delay, function()
			go.delete(".", not not_recursive)
			self:finished()
		end)
	end, function(self)
		if self.context.timer_id then
			timer.cancel(self.context.timer_id)
			self.context.timer_id = nil
		end
	end)

	action:set_name("go.delete_self")
	action:set_deferred(true)
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

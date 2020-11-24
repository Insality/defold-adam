local ActionInstance = require("dmaker.system.action_instance")

local M = {}


--- Print string to console
function M.print(string)
	return ActionInstance("debug.print", function(self)
		print(self:get_param(string))
	end)
end


--- Trigger event on call
function M.event(event_name)
	return ActionInstance("debug.event", function(self)
		self:event(event_name)
	end)
end


return M
local ActionInstance = require("dmaker.system.action_instance")

local M = {}


--- Print string to console
function M.print(string)
	return ActionInstance("debug.print", function(self)
		print(self:get_param(string))
	end)
end


return M

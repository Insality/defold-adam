local ActionInstance = require("dmaker.system.action_instance")

local M = {}


--- Add operator
function M.add(source, value, is_every_frame, is_every_second)
	return ActionInstance("math.add", function(self)
		local source_value = self:get_value(source) + value
		self:set_value(source, source_value)
	end)
end


return M

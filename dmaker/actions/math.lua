--- Math actions perform different operations on FSM variables
-- @submodule actions

local const = require("dmaker.const")
local ActionInstance = require("dmaker.system.action_instance")

local M = {}


--- Add operator
-- @function actions.math.add
function M.add(source, value, is_every_frame, is_every_second)
	local action = ActionInstance("math.add", function(self)
		local source_value = self:get_value(source) + value
		self:set_value(source, source_value)
	end)

	if is_every_frame then
		action:set_every_frame(true)
	end

	if is_every_second then
		action:set_periodic(const.SECOND)
	end

	return action
end


return M

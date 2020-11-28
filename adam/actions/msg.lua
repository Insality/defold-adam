--- Actions to send messages
-- @submodule Actions
-- @local

local ActionInstance = require("adam.system.action_instance")

local M = {}


--- Post message via msg.post
-- @function actions.msg.post
-- @tparam url target The receiver url
-- @tparam string message_id The message id to send
-- @tparam[opt] table A lua table with message parameters to send
-- @treturn ActionInstance
function M.post(target, message_id, message, delay)
	local action = ActionInstance(function(self)
		msg.post(target, message_id, message)
		self:finish()
	end)

	action:set_delay(delay)
	action:set_name("msg.post")
	return action
end


return M

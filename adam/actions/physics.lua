--- Actions for phisycs action
-- @submodule Actions
-- @local

local const = require("adam.const")
local helper = require("adam.system.helper")
local ActionInstance = require("adam.system.action_instance")

local M = {}

-- TODO: get collision/trigger info, raycast, add/set/get physics params?
-- Not familiar with physics in Defold, need to go deeper to this :)


--- Get info about last trigger event
-- @tparam other_group string Variable to save other_group info
-- @tparam other_id string Variable to save other_id info
-- @tparam own_group string Variable to save own_group info
-- @treturn ActionInstance
function M.get_trigger_info(other_group, other_id, own_group)
	local action = ActionInstance(function(self)
		local adam_instance = self:get_adam_instance()
		local trigger_message = adam_instance:get_trigger_message()
		if not trigger_message then
			return
		end

		if other_group and trigger_message.other_group then
			self:set_value(other_group, trigger_message.other_group)
		end
		if other_id and trigger_message.other_id then
			self:set_value(other_id, trigger_message.other_id)
		end
		if own_group and trigger_message.own_group then
			self:set_value(own_group, trigger_message.own_group)
		end
	end)

	action:set_name("physics.get_trigger_info")
	return action
end




return M

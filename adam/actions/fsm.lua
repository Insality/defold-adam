--- FSM actions let you control other FSM instances
-- @submodule Actions

local instances = require("adam.system.instances")
local ActionInstance = require("adam.system.action_instance")

local M = {}

-- TODO: start/finish/random_event/

--- Send event to target Adam instance
-- @function actions.fsm.send_event
-- @tparam string|adam target The target instance for send event. If there are several instances with equal ID, event will be delivered to all of them.
-- @tparam string event_name The event to send
-- @tparam[opt] number delay Time delay in seconds
-- @tparam[opt] bool is_every_frame Repeat every frame
-- @treturn ActionInstance
function M.send_event(target, event_name, delay, is_every_frame)
	local action = ActionInstance(function(self)
		for _, instance in ipairs(instances.get_all_instances_with_id(target)) do
			instance:event(event_name)
		end
		self:finish()
	end)

	action:set_delay(delay)
	action:set_every_frame(is_every_frame)
	action:set_name("fsm.send_event")
	return action
end


--- Broadcast event to all active FSM
-- @function actions.fsm.broadcast_event
-- @tparam string event_name The event to send
-- @tparam[opt] bool is_exclude_self Don't send the event to self
-- @tparam[opt] number delay Time delay in seconds
-- @treturn ActionInstance
function M.broadcast_event(event_name, is_exclude_self, delay)
	local action = ActionInstance(function(self)
		for _, instance in ipairs(instances.get_all_instances()) do
			if not is_exclude_self or instance ~= self:get_adam_instance() then
				instance:event(event_name)
			end
		end
		self:finish()
	end)

	action:set_delay(delay)
	action:set_name("fsm.broadcast_event")
	return action
end


--- Stop the Adam Instance
-- @function actions.fsm.finish
-- @tparam target string|adam target The target instance to finish
-- @tparam[opt] number delay Time delay in seconds
function M.stop(target, delay)
	local action = ActionInstance(function(self)
		target = target or self:get_adam_instance()

		if type(target) == "string" then
			local adams = instances.get_all_instances_with_id(target)
			for i = 1, #adams do
				adams[i]:stop()
			end
		else
			target:stop()
		end
		self:finish()
	end)

	action:set_delay(delay)
	action:set_name("fsm.stop")
	return action
end


return M

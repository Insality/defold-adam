local instances = require("dmaker.system.instances")
local helper = require("dmaker.system.helper")
local ActionInstance = require("dmaker.system.action_instance")

local M = {}


--- Send event to target DMaker instance
function M.send_event(target, event_name, delay, is_every_frame)
	local action = ActionInstance("fsm.send_event", function(self)
		self.context.timer_id = helper.delay(delay, function()
			for _, instance in ipairs(instances.get_all_instances_with_id(target)) do
				instance:event(event_name)
			end
			self:finished()
		end)
	end, function(self)
		if self.context.timer_id then
			timer.cancel(self.context.timer_id)
			self.context.timer_id = nil
		end
	end)

	action:set_deferred(true)
	return action
end


--- Broadcast event to all active FSM
function M.broadcast_event(event_name, is_exclude_self, delay)
	local action = ActionInstance("fsm.broadcast_event", function(self)
		self.context.timer_id = helper.delay(delay, function()
			for _, instance in ipairs(instances.get_all_instances()) do
				if not is_exclude_self or instance ~= self:get_dmaker_instance() then
					instance:event(event_name)
				end
			end
			self:finished()
		end)
	end, function(self)
		if self.context.timer_id then
			timer.cancel(self.context.timer_id)
			self.context.timer_id = nil
		end
	end)

	action:set_deferred(true)
	return action
end


return M

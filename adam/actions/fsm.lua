--- FSM actions let you control other FSM instances
-- @submodule Actions

local const = require("adam.const")
local instances = require("adam.system.instances")
local ActionInstance = require("adam.system.action_instance")

local M = {}

-- TODO: start/finish/random_event/

-- @tparam ActionInstance action The called ActionInstance
-- @tparam string|AdamInstance|nil target The target for callbacks
-- @tparam function callback The callback for every finded AdamInstance
local function for_adam_instances(action, target, callback)
	if target == "string" then
		local adams = instances.get_all_instances_with_id(target)
		for i = 1, #adams do
			callback(adams[i])
		end
	else
		target = target or action:get_adam_instance()
		callback(target)
	end
end


local function for_all_adam_instances(action, callback)
	for _, adam in ipairs(instances.get_all_instances()) do
		callback(adam)
	end
end


local function send_context_event(target_adam, event_name)
	local current_url = msg.url()
	current_url.fragment = nil
	local target_url = target_adam:get_url()
	target_url.fragment = nil

	if current_url == target_url then
		target_adam:event(event_name)
	else
		msg.post(target_adam:get_url(), const.ADAM_EVENT, { event = event_name })
	end
end


--- Send event to target Adam instance.
-- Event inside current msg.url() context sent instantly, otherwise it send via msg.post (not instant)
-- @function actions.fsm.send_event
-- @tparam string|adam target The target instance for send event. If there are several instances with equal ID, event will be delivered to all of them.
-- @tparam string event_name The event to send
-- @tparam[opt] number delay Time delay in seconds
-- @tparam[opt] bool is_every_frame Repeat every frame
-- @treturn ActionInstance
function M.send_event(target, event_name, delay, is_every_frame)
	local action = ActionInstance(function(self)
		for_adam_instances(self, target, function(adam)
			if adam:is_inited() then
				send_context_event(adam, event_name)
			end
		end)
		self:finish()
	end)


	action:set_delay(delay)
	if is_every_frame then
		action:set_every_frame()
	end
	action:set_name("fsm.send_event")
	return action
end


--- Broadcast event to all active FSM.
-- Event inside current msg.url() context sent instantly, otherwise it send via msg.post (not instant)
-- @function actions.fsm.broadcast_event
-- @tparam string event_name The event to send
-- @tparam[opt] bool is_exclude_self Don't send the event to self
-- @tparam[opt] number delay Time delay in seconds
-- @treturn ActionInstance
function M.broadcast_event(event_name, is_exclude_self, delay)
	local action = ActionInstance(function(self)
		local current_adam_instance = self:get_adam_instance()

		for_all_adam_instances(self, function(adam)
			if not is_exclude_self or adam ~= current_adam_instance then
				if adam:is_inited() then
					send_context_event(adam, event_name)
				end
			end
		end)
		self:finish()
	end)

	action:set_delay(delay)
	action:set_name("fsm.broadcast_event")
	return action
end



--- Resume the Adam Instance
-- @function actions.fsm.resume
-- @tparam target string|adam target The target instance to resume
-- @tparam[opt] number delay Time delay in seconds
function M.resume(target, delay)
	local action = ActionInstance(function(self)
		for_adam_instances(self, target, function(adam)
			adam:resume()
		end)
		self:finish()
	end)

	action:set_delay(delay)
	action:set_name("fsm.resume")
	return action
end


--- Pause the Adam Instance
-- @function actions.fsm.pause
-- @tparam target string|adam target The target instance to pause
-- @tparam[opt] number delay Time delay in seconds
function M.pause(target, delay)
	local action = ActionInstance(function(self)
		for_adam_instances(self, target, function(adam)
			adam:pause()
		end)
		self:finish()
	end)

	action:set_delay(delay)
	action:set_name("fsm.pause")
	return action
end


--- Finalize the Adam Instance
-- @function actions.fsm.final
-- @tparam target string|adam target The target instance to finish
-- @tparam[opt] number delay Time delay in seconds
function M.finish(target, delay)
	local action = ActionInstance(function(self)
		for_adam_instances(self, target, function(adam)
			adam:final()
		end)
		self:finish()
	end)

	action:set_delay(delay)
	action:set_name("fsm.final")
	return action
end


--- Get variable from FSM.
-- If at target will be multiply FSM, no any order which FSM will be used to get value
-- @function actions.fsm.get_value
-- @tparam target string|adam target The target instance to get value
-- @tparam variable variable Name of variable to get from target FSM
-- @tparam string store_value The name of variable in current FSM to store get value
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
function M.get_value(target, variable, store_value, is_every_frame)
	local action = ActionInstance(function(self)
		for_adam_instances(self, self:get_param(target), function(adam)
			local param_name = self:get_param(variable)
			self:set_value(store_value, adam:get_value(param_name))
		end)
	end)

	if is_every_frame then
		action:set_every_frame()
	end
	action:set_name("fsm.get_value")
	return action
end


--- Get adam from adam_id
-- @function actions.fsm.get_adam
-- @tparam adam_id string The adam_id for search
-- @tparam string store_value The name of variable in current FSM to store get value
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
function M.get_adam(target, store_value, is_every_frame)
	local action = ActionInstance(function(self)
		local adam_instance = instances.instance_with_id(self:get_param(target))
		self:set_value(store_value, adam_instance)
	end)

	if is_every_frame then
		action:set_every_frame()
	end
	action:set_name("fsm.get_adam")
	return action
end


--- Set variable from FSM.
-- If at target will be multiply FSM, set value to all of them
-- @function actions.fsm.set_value
-- @tparam target string|adam target The target instance to set value
-- @tparam variable variable Name of variable to set value on target FSM
-- @tparam string source The variable in current FSM to set the variable to
-- @tparam[opt] boolean is_every_frame Repeat this action every frame
function M.set_value(target, variable, source, is_every_frame)
	local action = ActionInstance(function(self)
		for_adam_instances(self, target, function(adam)
			local param_name = self:get_param(source)
			adam:set_value(variable, self:get_value(param_name))
		end)
	end)

	if is_every_frame then
		action:set_every_frame()
	end
	action:set_name("fsm.set_value")
	return action
end


return M

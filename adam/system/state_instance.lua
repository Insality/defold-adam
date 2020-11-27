--- User to describe the states for your FSM. Contain actions what will be triggered,
-- on enter to this state.
-- @module StateInstance

local const = require("adam.const")
local class = require("adam.libs.middleclass")
local settings = require("adam.system.settings")
local ActionInstance = require("adam.system.action_instance")

local StateInstance = class("adam.state")


function StateInstance:initialize(...)
	self._actions = self:_load_actions({ ... })
	self._id = settings.get_next_id()

	self._is_can_trigger_action = false
	self._actions_in_process = 0

	for _, action in ipairs(self._actions) do
		action:set_state_instance(self)
	end
end


function StateInstance:update(dt)
	for _, action in ipairs(self._actions) do
		action:update(dt)
	end
end


--- Execute all state instance actions. Called by
-- AdamInstance on enter this state
-- @local
function StateInstance:trigger()
	-- settings.log("On enter state", { id = self:get_name() })
	if #self._actions == 0 then
		return self:event(const.FINISHED)
	end

	self._is_can_trigger_action = true
	self._actions_in_process = #self._actions

	for _, action in ipairs(self._actions) do
		if self._is_can_trigger_action then
			action:trigger()
		end
	end
end


function StateInstance:_on_action_finish()
	self._actions_in_process = self._actions_in_process - 1
	if self._actions_in_process > 0 or not self._is_can_trigger_action then
		return
	end

	return self:event(const.FINISHED)
end


--- Execute all state instance release actions. Called by
-- AdamInstance on leave from this state
-- @local
function StateInstance:release()
	-- settings.log("On leave state", { id = self:get_name() })
	self._is_can_trigger_action = false

	for _, action in ipairs(self._actions) do
		action:release()
	end
end


--- Trigger event to FSM. If state changed by one of Action, other actions below
-- of it will not executed
-- @tparam string event_name The event to send
function StateInstance:event(event_name)
	return self._adam_instance:event(event_name)
end


--- Return variable value from FSM variables. Used by ActionInstance
-- @tparam string variable_name The name of variable in FSM
-- @see ActionInstance.get_value
-- @local
function StateInstance:get_value(variable_name)
	return self._adam_instance:get_value(variable_name)
end


--- Set variable value in action's FSM. Used by ActionInstance
-- @tparam string variable_name The name of variable in FSM
-- @tparam any value New value for variable
-- @see ActionInstance.get_value
-- @local
function StateInstance:set_value(variable_name, value)
	return self._adam_instance:set_value(variable_name, value)
end


-- @tparam AdamInstance adam_instance
function StateInstance:set_adam_instance(adam_instance)
	self._adam_instance = adam_instance
	return self
end


-- @treturn AdamInstance
function StateInstance:get_adam_instance()
	return self._adam_instance
end


function StateInstance:get_id()
	return self._id
end


function StateInstance:set_name(name)
	self._name = name
	return self
end


function StateInstance:get_name()
	return self._name or self._id
end


function StateInstance:_load_actions(actions)
	local loaded_actions = {}

	for _, action in ipairs(actions) do
		if action._type == const.ACTIONS_TEMPLATE then
			local copy_actions = self:_load_actions(action._actions)
			for _, copied_action in ipairs(copy_actions) do
				table.insert(loaded_actions, ActionInstance.copy(copied_action))
			end
		else
			table.insert(loaded_actions, action)
		end
	end

	return loaded_actions
end


return StateInstance

--- All state instances created by this class.
-- Used to describe the states for your FSM. Contain actions what will be triggered.
-- @module StateInstance

local const = require("adam.const")
local class = require("adam.libs.middleclass")
local settings = require("adam.system.settings")
local ActionInstance = require("adam.system.action_instance")

local StateInstance = class("adam.state")


--- State Instance constructor function
-- @tparam ActionInstance ... The any amount of ActionInstance for this State
-- @treturn StateInstance
function StateInstance:initialize(...)
	self._actions = self:_load_actions({ ... })
	self._id = settings.get_next_id()

	self._is_can_trigger_action = false
	self._actions_in_process = 0

	self._is_debug = false

	for _, action in ipairs(self._actions) do
		action:set_state_instance(self)
	end
end


--- State Instance update function. Called by AdamInstance:update
-- @local
function StateInstance:update(dt)
	for i = 1, #self._actions do
		self._actions[i]:update(dt)
	end
end


--- Execute all state instance actions.
-- Called by AdamInstance on enter state callback
-- @local
function StateInstance:trigger()
	if self._is_debug then
		settings.log("State enter", { name = self:get_name() })
	end

	if #self._actions == 0 then
		return self:event(const.FINISHED)
	end

	self._is_can_trigger_action = true
	self._actions_in_process = #self._actions

	for index, action in ipairs(self._actions) do
		if self._is_can_trigger_action then
			-- Tail call optimization
			if index < #self._actions then
				action:trigger()
			else
				return action:trigger()
			end
		end
	end
end


--- Execute all state instance release actions.
-- Called by AdamInstance on leave state callback
-- @local
function StateInstance:release()
	if self._is_debug then
		settings.log("State release", { name = self:get_name() })
	end

	self._is_can_trigger_action = false

	for _, action in ipairs(self._actions) do
		action:release()
	end
end


--- Trigger event to FSM. If state changed by one of Action, other actions below
-- of it will not executed
-- @tparam string event_name The event to send
function StateInstance:event(event_name)
	if self._is_debug then
		settings.log("State trigger event", { name = self:get_name(), event = event_name })
	end

	return self._adam_instance:event(event_name)
end


--- Check is State can run in one frame. All actions inside this state
-- are not deferred
-- @treturn boolean True, if state triggers in one frame
function StateInstance:is_instant()
	for _, action in ipairs(self._actions) do
		if action:is_deferred() then
			return false
		end
	end
	return true
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


--- Set current AdamInstance for this StateInstance
-- @tparam AdamInstance adam_instance
-- @local
function StateInstance:set_adam_instance(adam_instance)
	self._adam_instance = adam_instance
	return self
end


--- Get the current AdamInstance, attached to this state
-- @treturn AdamInstance
function StateInstance:get_adam_instance()
	return self._adam_instance
end


--- Return current State Instance id. All State's id are unique.
-- Used to build Adam FSM transitions
function StateInstance:get_id()
	return self._id
end


--- Set name for State Instance. Useful for Debug.
-- @tparam string name The State Instance name
function StateInstance:set_name(name)
	self._name = name or ""
	return self
end


--- Get name of current State Instance
-- @treturn string The State Instance name
function StateInstance:get_name()
	return self._name or self._id
end


--- Set debug state of state. If true, will print debug info to console
-- @tparam boolean state The debug state
-- @treturn StateInstance Self
function StateInstance:set_debug(state)
	self._is_debug = state
	for _, action in pairs(self._actions) do
		action:set_debug(state)
	end
	return self
end


--- ActionInstance, triggered by this State, call this callback on finish execution
-- @local
function StateInstance:_on_action_finish()
	self._actions_in_process = self._actions_in_process - 1
	if self._actions_in_process > 0 or not self._is_can_trigger_action then
		return
	end

	if self._is_debug then
		settings.log("All actions finished", { name = self:get_name(), total = #self._actions })
	end

	return self:event(const.FINISHED)
end


--- Load list of actions. Need to proceed included action templates
-- @tparam ActionInstance[] actions The list of actions
-- @local
function StateInstance:_load_actions(actions)
	local loaded_actions = {}

	for _, action in ipairs(actions) do
		-- Actions template or use other state to copy
		if action._type == const.ACTIONS_TEMPLATE or action:isInstanceOf(StateInstance) then
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

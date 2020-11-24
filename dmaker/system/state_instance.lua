local const = require("dmaker.const")
local class = require("dmaker.libs.middleclass")
local settings = require("dmaker.system.settings")

local StateInstance = class("dmaker.state")


function StateInstance:initialize(...)
	self._actions = {...}
	self._id = settings.get_next_id()
	self._fsm = nil
	self._is_processing = false

	for _, action in ipairs(self._actions) do
		action:set_state_instance(self)
	end
end


function StateInstance:update(dt)
	for _, action in ipairs(self._actions) do
		action:update(dt)
	end
end


--- Execute on enter to this state
function StateInstance:trigger(...)
	settings.log("On enter state", { id = self:get_name() })
	self._is_processing = true

	if #self._actions == 0 then
		self:event(const.FINISHED)
		return
	end

	local on_all_end_callback = self:_after(#self._actions, function()
		if self._is_processing then
			self:event(const.FINISHED)
		end
	end)

	for _, action in ipairs(self._actions) do
		action:set_finish_callback(on_all_end_callback)
	end

	for _, action in ipairs(self._actions) do
		if self._is_processing then
			action:trigger(...)
		end
	end
end


--- Execute on leave from this state
function StateInstance:release(...)
	settings.log("On leave state", { id = self:get_name() })
	self._is_processing = false

	for _, action in ipairs(self._actions) do
		action:release(...)
		action:set_finish_callback(nil)
	end
end


function StateInstance:event(event_name, ...)
	settings.log("Trigger event", { id = self:get_name(), name = event_name })
	if self._fsm[event_name] and self._fsm.can(event_name) then
		self._fsm[event_name](...)
	end
end


function StateInstance:get_value(variable_name)
	return self._dmaker_instance:get_value(variable_name)
end


function StateInstance:set_value(variable_name, value)
	return self._dmaker_instance:set_value(variable_name, value)
end


function StateInstance:set_dmaker_instance(dmaker_instance)
	self._dmaker_instance = dmaker_instance
	self._fsm = self._dmaker_instance:get_fsm()
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


function StateInstance:_after(count, callback)
	local closure = function()
		count = count - 1
		if count == 0 then
			callback()
		end
	end

	return closure
end


return StateInstance

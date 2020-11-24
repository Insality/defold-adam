local const = require("dmaker.const")
local class = require("dmaker.libs.middleclass")
local settings = require("dmaker.system.settings")

local StateInstance = class("dmaker.state")


function StateInstance:initialize(...)
	self._actions = {...}
	self._id = settings.get_next_id()
	self._event_links = {}
	self._fsm = nil

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
	settings.log("On enter state", { id = self:get_id() })
	for _, action in ipairs(self._actions) do
		action:trigger(...)
	end

	self:event(const.FINISHED)
end


--- Execute on leave from this state
function StateInstance:release(...)
	settings.log("On leave state", { id = self:get_id() })
	for _, action in ipairs(self._actions) do
		action:release(...)
	end
end


function StateInstance:event(event_name, ...)
	settings.log("Trigger event", { id = self._id, name = event_name })
	if self._event_links[event_name] then
		self._fsm[self._event_links[event_name]](...)
	end
end


function StateInstance:get_value(variable_name)
	return self._dmaker_instance:get_value(variable_name)
end


function StateInstance:set_value(variable_name, value)
	return self._dmaker_instance:set_value(variable_name, value)
end


function StateInstance:set_event_link(event_name, fsm_name)
	self._event_links[event_name] = fsm_name
end


function StateInstance:set_dmaker_instance(dmaker_instance)
	self._dmaker_instance = dmaker_instance
	self._fsm = self._dmaker_instance:get_fsm()
end


function StateInstance:get_id()
	return self._id
end


return StateInstance

local class = require("dmaker.system.middleclass")
local const = require("dmaker.const")

local ActionInstance = class("dmaker.action")


function ActionInstance:initialize(name, callback)
	self._name = name
	self._callback = callback or const.EMPTY_FUNCTION
end


function ActionInstance:get_name()
	return self._name
end


function ActionInstance:trigger(...)
	self._callback(...)
end


return ActionInstance

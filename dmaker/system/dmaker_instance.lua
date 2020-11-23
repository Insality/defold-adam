local fsm = require("dmaker.system.fsm")
local class = require("dmaker.system.middleclass")

local DmakerInstance = class("dmaker.instance")


function DmakerInstance:initialize(param)
	local fsm_param = {
		initial = param.initial:get_id(),
		events = {}
	}

	for _, edge in ipairs(param.edges) do
		local edge1_id = edge[1]:get_id()
		local edge2_id = edge[2]:get_id()
		local name = edge1_id .. "-" .. edge2_id
		table.insert(fsm_param.events, { from = edge1_id, to = edge2_id, name = name })
	end

	self._fsm = fsm.create(fsm_param)

	print("init fsm", self._fsm.current)
end


return DmakerInstance

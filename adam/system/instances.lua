-- Utility module to track all Adam Instances. Used in actions.fsm to control all of them
-- @local

local M = {}

local _instances = {}


local function get_instances()
	for i = #_instances, 1, -1 do
		if _instances[i]._is_deleted then
			table.remove(_instances, i)
		end
	end

	return _instances
end


function M.get_all_instances()
	return get_instances()
end


function M.get_all_instances_with_id(adam_id)
	local instances = M.get_all_instances()

	local result = {}
	for i = 1, #instances do
		if instances[i].get_id() == adam_id then
			table.insert(result, instances[i])
		end
	end

	return result
end


function M.add_instance(instance)
	table.insert(_instances, instance)
end


return M

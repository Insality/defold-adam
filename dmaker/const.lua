local M = {}

M.NONE_STATE = "none"
M.INIT_EVENT = "init"
M.FINISHED = "finished"
M.ANY_STATE = nil
M.WILDCARD = "*"
M.EMPTY_FUNCTION = function() end
M.GET_ACTION_VALUE = "dmaker:get_action_value"
M.TYPE_TABLE = "table"
M.SECOND = 1
M.MAX_STACK_DEPTH = 10000

M.ERROR = {
	NO_BINDED_STATE = "No binded state instance to action instance",
	NO_DEFINED_VARIABLE = "The variable for FSM is not defined",
	MAX_STACK_DEPTH_REACHED = "The DMaker reached max depth stack in one frame"
}

return M

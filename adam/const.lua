local M = {}

M.NONE_STATE = "none"
M.INIT_EVENT = "init"
M.FINISHED = "finished"
M.ANY_STATE = nil
M.WILDCARD = "*"
M.EMPTY_FUNCTION = function() end
M.GET_ACTION_VALUE = "adam:get_action_value"
M.TYPE_TABLE = "table"
M.SECOND = 1
M.MAX_STACK_DEPTH = 5000

M.TRIGGER_RESPONSE = hash("trigger_response")

M.EVENT = {
	TRIGGER_ENTER = "trigger_enter",
	TRIGGER_LEAVE = "trigger_leave",
}

M.ERROR = {
	NO_BINDED_STATE = "No binded state instance to action instance",
	NO_DEFINED_VARIABLE = "The variable for FSM is not defined",
	MAX_STACK_DEPTH_REACHED = "The Adam FSM reached max depth stack in one frame",
	WRONG_TIME_PARAMS_EVERY_FRAME = "Action can not executed every frame and have time to execute",
}

return M

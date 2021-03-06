-- Defold Adam constants
-- @local

local M = {}

M.PROP_POS = "position"
M.PROP_POS_X = "position.x"
M.PROP_POS_Y = "position.y"
M.PROP_POS_Z = "position.z"
M.PROP_ROTATION = "rotation"
M.PROP_ROTATION_X = "rotation.x"
M.PROP_ROTATION_Y = "rotation.y"
M.PROP_ROTATION_Z = "rotation.z"
M.PROP_EULER = "euler"
M.PROP_EULER_X = "euler.x"
M.PROP_EULER_Y = "euler.y"
M.PROP_EULER_Z = "euler.z"
M.PROP_SCALE = "scale"
M.PROP_SCALE_X = "scale.x"
M.PROP_SCALE_Y = "scale.y"
M.PROP_SCALE_Z = "scale.z"
M.PROP_TINT = "tint"
M.PROP_TINT_ALPHA = "tint.w"

M.SECOND = 1
M.MAX_STACK_DEPTH = 10000
M.EMPTY_FUNCTION = function() end

M.NONE_STATE = "none"
M.INIT_EVENT = "init"
M.FINISHED = "finished"
M.TYPE_TABLE = "table"
M.SPRITE = "sprite"

M.ANY_STATE = nil
M.WILDCARD = "*"
M.SELF = "."

M.ACTIONS_TEMPLATE = "adam:actions_template"
M.GET_ACTION_VALUE = "adam:get_action_value"

M.TRIGGER_RESPONSE = hash("trigger_response")
M.ADAM_EVENT = hash("adam:event")

M.EVENT = {
	TRIGGER_ENTER = "adam:trigger_enter",
	TRIGGER_LEAVE = "adam:trigger_leave",
	ACTION_PRESSED = "adam:action_pressed",
	ACTION_RELEASED = "adam:action_released"
}

M.VALUE = {
	CONTEXT = "adam:value:context",
	LIFETIME = "adam:value:lifetime"
}

M.ERROR = {
	NO_BINDED_STATE = "No binded state instance to action instance",
	NO_DEFINED_VARIABLE = "The variable for FSM is not defined: ",
	MAX_STACK_DEPTH_REACHED = "The Adam FSM reached max depth stack in one frame",
	WRONG_TIME_PARAMS_EVERY_FRAME = "Action can not executed every frame and have time to execute",
	NO_VALUE_IN_FSM = "The variable is not defined in Adam Instance",
	PERIODIC_EVENT_WRONG_PARAMS = "In set_periodic function seconds should be > 0",
	TIME_DELAY_WRONG = "Delay time for action should be more or equal than 0",
	FINAL_STATE_DEFERRED = "The final state for Adam should contains only instant actions"
}


return M

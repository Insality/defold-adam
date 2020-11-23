local M = {}

M.INIT_EVENT = "init"
M.FINISHED = "finished"
M.EMPTY_FUNCTION = function() end

M.ERRORS = {
	NO_BINDED_STATE = "No binded state instance to action instance"
}

return M

local adam = require("adam.adam")
local actions = require("adam.actions")
-- example how to use adam without scripts

local M = {}

function M.create(go_id)
	local initial = adam.state(
		actions.transform.get_euler("current_euler"),
		actions.vmath.get_xyz("current_euler", nil, nil, "angle"),
		actions.math.add("angle", 90),
		actions.math.cos(actions.value("angle"), "angle_move_x", true),
		actions.math.sin(actions.value("angle"), "angle_move_y", true),
		actions.vmath.set_xyz("move_vector", actions.value("angle_move_x"), actions.value("angle_move_y")),
		actions.vmath.multiply("move_vector", actions.value("speed"))
	)

	local fly = adam.state(
		actions.transform.add_position(actions.value("move_vector"), true, 0, go_id),
		actions.time.delay(1, "destroy")
	)

	local destroy = adam.state(
		actions.fsm.finish()
	)

	local destroy_print = adam.state(
		actions.debug.print("im destroyed from collision!"),
		destroy
	)

	local final_state = adam.state(
		actions.go.delete_self()
	)

	local fsm = adam.new(initial, {
		{initial, fly},
		{fly, destroy_print, actions.EVENT.TRIGGER_ENTER },
		{fly, destroy, "destroy"}
	}, {
		speed = 15,
		angle = 0,
		move_vector = vmath.vector3(0),
		angle_move_x = 0,
		angle_move_y = 0,
		current_euler = vmath.vector3(0)
	}, final_state)

	return fsm
end

return M

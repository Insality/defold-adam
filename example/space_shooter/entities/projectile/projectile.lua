local adam = require("adam.adam")
local actions = require("adam.actions")
-- example how to use adam without scripts

local M = {}

function M.create(go_id, impact_image, parent_id)
	local initial = adam.state(
		actions.transform.get_euler("current_euler"),
		actions.transform.get_position("position"),
		actions.vmath.get_xyz("current_euler", nil, nil, "angle"),
		actions.math.add("angle", 90),
		actions.math.cos(actions.value("angle"), "angle_move_x", true),
		actions.math.sin(actions.value("angle"), "angle_move_y", true),
		actions.vmath.set_xyz("move_vector", actions.value("angle_move_x"), actions.value("angle_move_y")),
		actions.vmath.multiply("move_vector", actions.value("speed"))
	)

	local fly = adam.state(
		actions.vmath.add(actions.value("position"), actions.value("move_vector"), true),
		-- actions.math.loop(actions.value("position", "x"), 0-64, 960+64, true),
		-- actions.math.loop(actions.value("position", "y"), 0-64, 640+64, true),
		actions.transform.set_position(actions.value("position"), true),
		actions.logic.compare(actions.value(adam.VALUE_LIFETIME), 1, nil, nil, "destroy", true)
	)

	local check_destroy = adam.state(
		actions.physics.get_trigger_info(nil, "other_id"),
		actions.logic.equals(actions.value("other_id"), parent_id, nil, "destroy")
	)

	local destroy = adam.state(
		actions.sprite.play_flipbook(impact_image),
		actions.transform.set_random_euler(true, true),
		actions.fsm.finish(nil, 0.1)
	)

	local final_state = adam.state(
		actions.go.delete_self()
	)

	local fsm = adam.new(initial, {
		{initial, fly},
		{fly, check_destroy, actions.EVENT.TRIGGER_ENTER },
		{check_destroy, destroy, "destroy"},
		{check_destroy, fly},
		{fly, destroy, "destroy"}
	}, {
		speed = 15,
		angle = 0,
		move_vector = vmath.vector3(0),
		position = vmath.vector3(0),
		other_id = "",
		angle_move_x = 0,
		angle_move_y = 0,
		current_euler = vmath.vector3(0)
	}, final_state)

	return fsm
end

return M

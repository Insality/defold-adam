local adam = require("adam.adam")
local actions = require("adam.actions")
local entity_adam = require("example.crowd.entity_adam")


local M = {}


local get_distance_to_target = adam.actions(
	actions.vmath.set_xyz("delta_vector", actions.value("player_position", "x"), actions.value("player_position", "y"), nil, true),
	actions.vmath.subtract("delta_vector", actions.value("position"), true),
	actions.vmath.set_xyz("delta_vector", nil, nil, 0, true),
	actions.vmath.length("delta_vector", "distance", true),
	actions.debug.print(actions.value("delta_vector"), true),
	actions.debug.print(actions.value("distance"), true)
)

local get_move_vector = adam.actions(
	actions.vmath.set_xyz("move_vector", actions.value("delta_vector", "x"), actions.value("delta_vector", "y"), nil, true),
	actions.vmath.length(actions.value("move_vector"), "move_speed", true)
)


M.create_adam = function(game_object, player_object)
	local control = adam.actions(
		actions.transform.get_position("move_vector", true, actions.value("target_object")),
		actions.vmath.subtract("move_vector", actions.value("position"), true),
		actions.vmath.length("move_vector", "distance", true),
		actions.vmath.normalize("move_vector", true),
		actions.vmath.multiply("move_vector", actions.value("move_koef"), true),
		actions.vmath.multiply("move_vector", 3, true),
		actions.vmath.length("move_vector", "move_speed", true)
		-- entity_adam
	)

	local initial = adam.state(
		entity_adam.initial,
		actions.fsm.get_adam(actions.value("player_adam_id"), "player_adam"),
		-- link on position vector
		actions.fsm.get_value(actions.value("player_adam"), "position", "player_position")
	)

	local idle = adam.state(
		entity_adam.on_idle,
		get_distance_to_target,
		get_move_vector,

		actions.logic.compare(actions.value("move_speed"), 0, nil, "move", "move", true)
	)

	local move = adam.state(
		entity_adam.on_move_entity,

		get_move_vector,
		entity_adam.on_move_entity,
		actions.logic.compare(actions.value("move_speed"), 0, "idle", nil, nil, true)
	)

	local enemy_adam = adam.new(initial,
		{
			{initial, idle},

			{idle, move, "move"},
			{move, idle, "idle"},
		},
		{
			move_speed = 0,
			move_koef = 1,
			z_pos = 0,
			distance = 0,
			move_vector = vmath.vector3(0.2, 0, 0),
			position = vmath.vector3(0),
			target_object = player_object,
			is_flip = false,
			anim_run = "enemy_run",
			anim_idle = "enemy_idle",
			player_adam_id = "player",
			player_adam = false,
			player_position = vmath.vector3(0),
			delta_vector = vmath.vector3(0)
		}
	)
	enemy_adam:bind(game_object)
	enemy_adam:start()

	return enemy_adam
end


return M

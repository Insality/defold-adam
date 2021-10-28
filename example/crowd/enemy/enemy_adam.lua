local adam = require("adam.adam")
local actions = require("adam.actions")


local M = {}

local function flip_comparator(current_value, speed)
	if speed == 0 then
		return current_value
	end
	return speed < 0
end


M.create_adam = function(game_object, player_object)
	local control = adam.actions(
		actions.vmath.length("move_vector", "move_speed", true),
		actions.vmath.add("position", actions.value("move_vector"), true),
		actions.math.set("z_pos", actions.value("position", "y"), true),
		actions.math.divide("z_pos", -1000, true),
		actions.math.add("z_pos", 0.5, true),
		actions.math.set(actions.value("position", "z"), actions.value("z_pos"), true),
		actions.transform.set_position(actions.value("position"), true)
	)

	local idle = adam.state(
		control,
		actions.logic.compare(actions.value("move_speed"), 0, nil, "move", "move", true),
		actions.sprite.play_flipbook("enemy_idle")
	)

	local move = adam.state(
		actions.transform.get_position("move_vector", true, actions.value("target_object")),
		actions.vmath.subtract("move_vector", actions.value("position"), true),
		actions.vmath.normalize("move_vector", true),
		actions.vmath.multiply("move_vector", 3, true),
		control,
		actions.math.operator("is_flip", actions.value("move_vector", "x"), flip_comparator, true),
		actions.logic.compare(actions.value("move_speed"), 0, "idle", nil, nil, true),
		actions.sprite.set_hflip(actions.value("is_flip"), nil, true),
		actions.sprite.play_flipbook("enemy_run")
	)

	local enemy_adam = adam.new(idle,
		{
			{idle, move, "move"},
			{move, idle, "idle"},
		},
		{
			move_speed = 0,
			z_pos = 0,
			move_vector = vmath.vector3(0.2, 0, 0),
			position = go.get_position(game_object),
			target_object = player_object,
			is_flip = false,
		}
	):start()
	enemy_adam:bind(game_object)

	return enemy_adam
end


return M

local adam = require("adam.adam")
local actions = require("adam.actions")
local entity_adam = require("example.crowd.entity_adam")


local M = {}
local all_enemy_adam_instances = {}


local get_distance_to_target = adam.actions(
	actions.vmath.set_xyz("delta_vector", actions.value("player_position", "x"), actions.value("player_position", "y"), nil, true),
	actions.vmath.subtract("delta_vector", actions.value("position"), true),
	actions.vmath.set_xyz("delta_vector", nil, nil, 0, true),
	actions.vmath.length("delta_vector", "distance", true),
	actions.vmath.normalize("delta_vector", true)
)

local get_move_vector = adam.actions(
	actions.vmath.set_xyz("move_vector", actions.value("delta_vector", "x"), actions.value("delta_vector", "y"), nil, true),
	actions.vmath.multiply("move_vector", actions.value("speed"), true),
	actions.vmath.length(actions.value("move_vector"), "move_speed", true)
)


-- @tparam my_adam_instance AdamInstance
local temp_dist = vmath.vector3(0)
local function check_collisions_operator(comp_vector, my_position, my_adam_instance)
	local diameter = my_adam_instance:get_value("radius") * 2

	comp_vector.x = 0
	comp_vector.y = 0

	for i = 1, #all_enemy_adam_instances do
		-- check all other enemies
		local enemy = all_enemy_adam_instances[i]
		if enemy ~= my_adam_instance then
			local other_pos = enemy:get_value("position")

			-- distance vector
			temp_dist.x = other_pos.x - my_position.x
			temp_dist.y = other_pos.y - my_position.y
			local dist = vmath.length(temp_dist)

			-- normalize
			if dist > 0 then
				temp_dist.x = temp_dist.x / dist
				temp_dist.y = temp_dist.y / dist

				if dist < diameter then
					comp_vector.x = comp_vector.x + (-temp_dist.x + (math.random() - 0.5)/5)
					comp_vector.y = comp_vector.y + (-temp_dist.y + (math.random() - 0.5)/5)
				end
			end
		end
		-- if we moving, other not - add compensation move vector to other
		-- if both stay or move - add half compensation to both
	end

	return comp_vector
end


local check_collisions = adam.actions(
	actions.math.operator("comp_vector", actions.value("position"), check_collisions_operator, true),
	actions.vmath.normalize("comp_vector", true),
	actions.vmath.multiply("comp_vector", 10, true),
	actions.vmath.add("move_vector", actions.value("comp_vector"), true),
	actions.vmath.length(actions.value("move_vector"), "move_speed", true)
)


M.create_adam = function(game_object, player_object)
	local initial = adam.state(
		entity_adam.initial,
		actions.fsm.get_adam(actions.value("player_adam_id"), "player_adam"),
		-- link on position vector
		actions.fsm.get_value(actions.value("player_adam"), "position", "player_position")
	)

	local idle = adam.state(
		entity_adam.on_idle,
		get_distance_to_target,
		actions.vmath.set_xyz("move_vector", 0, 0, nil, true),

		check_collisions,

		actions.logic.compare(actions.value("distance"), 130, nil, "move_away", "move_to", true),
		actions.logic.compare(actions.value("move_speed"), 0, nil, nil, "move", true)
	)

	local move = adam.state(
		actions.vmath.set_xyz("move_vector", 0, 0, nil, true),
		check_collisions,
		entity_adam.on_move_entity,
		actions.logic.compare(actions.value("move_speed"), 0, "idle", nil, nil, true)
	)

	local move_to = adam.state(
		get_distance_to_target,
		get_move_vector,
		check_collisions,
		entity_adam.on_move_entity,
		actions.logic.compare(actions.value("distance"), 250, "idle", "idle", nil, true)
	)

	local move_away = adam.state(
		get_distance_to_target,
		get_move_vector,
		actions.vmath.multiply(actions.value("move_vector"), -1, true),
		check_collisions,
		entity_adam.on_move_entity,

		actions.logic.compare(actions.value("distance"), 200, "idle", nil, "idle", true)
	)

	local enemy_adam = adam.new(initial,
		{
			{initial, idle},

			-- {idle, move_to, "move_to"},
			{idle, move, "move"},
			{idle, move_away, "move_away"},

			{move, idle, "idle"},
			{move_to, idle, "idle"},
			{move_away, idle, "idle"},
		},
		{
			move_speed = 0,
			move_koef = 1,
			z_pos = 0,
			speed = 5,
			radius = 20,
			distance = 0,
			comp_vector = vmath.vector3(0),
			move_vector = vmath.vector3(0),
			position = vmath.vector3(0),
			target_object = player_object,
			is_flip = false,
			anim_run = "enemy_run",
			anim_idle = "enemy_idle",
			player_adam_id = "player",
			player_adam = false,
			player_position = true,
			delta_vector = vmath.vector3(0)
		}
	)
	enemy_adam:bind(game_object)
	enemy_adam:start()

	table.insert(all_enemy_adam_instances, enemy_adam)

	return enemy_adam
end


return M

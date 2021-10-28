local adam = require("adam.adam")
local actions = require("adam.actions")

local M = {}


local function flip_comparator(current_value, speed)
	if speed == 0 then
		return current_value
	end
	return speed < 0
end


M.initial = adam.state(
	actions.transform.get_position("position")
)


-- Input: (move_vector, anim_run, anim_idle) Output: (position, is_flip)
M.on_move_entity = adam.actions(
	-- Move
	actions.vmath.add("position", actions.value("move_vector"), true),
	actions.math.set("z_pos", actions.value("position", "y"), true),
	actions.math.divide("z_pos", -1000, true),
	actions.math.add("z_pos", 0.5, true),
	actions.math.set(actions.value("position", "z"), actions.value("z_pos"), true),

	-- Restrict
	actions.math.clamp(actions.value("position", "x"), 16, 960-16, true),
	actions.math.clamp(actions.value("position", "y"), 16, 640-64, true),

	-- Set
	actions.transform.set_position(actions.value("position"), true),

	-- View
	actions.math.operator("is_flip", actions.value("move_vector", "x"), flip_comparator, true),
	actions.sprite.set_hflip(actions.value("is_flip"), nil, true),
	actions.sprite.play_flipbook(actions.value("anim_run"))
)


M.on_idle = adam.state(
	actions.sprite.play_flipbook(actions.value("anim_idle"))
)



return M

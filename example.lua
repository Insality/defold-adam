local dmaker = require("dmaker")


local PREPARE_FOR_BATTLE = dmaker.state(
	dmaker.sound.play("battle"),
	dmaker.msg.post("path-gui?", "appear_boss_gui", "params?"),
	dmaker.event("idle")
)

local PREPARE_LAMP_1 = dmaker.state(
	dmaker.animation.play_flipbook("firelamp1"),
	dmaker.sound.play("firelight"),
	dmaker.time.delay(1, "on_lamp_next")
)

local PREPARE_LAMP_2 = dmaker.state(
	dmaker.animation.play_flipbook("firelamp2"),
	dmaker.sound.play("firelight"),
	dmaker.time.delay(1, "on_lamp_next")
)

local PREPARE_LAMP_3 = dmaker.state(
	dmaker.animation.play_flipbook("firelamp3"),
	dmaker.sound.play("firelight"),
	dmaker.time.delay(1, "on_lamp_next")
)

local foobar = dmaker.new({
	edges = {
		{dmaker.INITIAL_STATE, PREPARE_FOR_BATTLE},
		{PREPARE_FOR_BATTLE, PREPARE_LAMP_1},
		{PREPARE_LAMP_1, PREPARE_LAMP_2},
		{PREPARE_LAMP_2, PREPARE_LAMP_3},
	}
})

foobar.INITIAL(

)

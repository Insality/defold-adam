local adam = require("adam.adam")
local actions = require("adam.actions")
local mock = require("deftest.mock.mock")


local events = {
	INITIAL = function() end,
	DELAY = function() end,
	DELAY_UPDATE = function() end,
	PER_FRAME = function() end,
	PER_SECOND = function() end,
	ALL_TOGETHER = function() end,
	PER_FRAME_SKIP_INITIAL = function() end,
	PER_SECOND_SKIP_INITIAL = function() end,
}

return function()
	describe("Actions time behaviour (delay, per_frame, periodic, etc)", function()
		local adam_instance
		before(function()
			mock.mock(events)

			-- Note: this type of definition actions only for tests (I'm mean :set_delay(),
			-- :set_every_frame() and others). Actions, what's not designed for deferred
			-- activation will never finish in this case. If you want use this, be careful.

			local initial = adam.state(actions.debug.callback(events.INITIAL))
			local delay = adam.state(actions.debug.callback(events.DELAY):set_delay(0.5))
			local delay_update = adam.state(actions.debug.callback(events.DELAY_UPDATE):set_delay(1):set_every_frame(true))
			local per_frame = adam.state(actions.debug.callback(events.PER_FRAME):set_every_frame(true))
			local per_second = adam.state(actions.debug.callback(events.PER_SECOND):set_periodic(1))
			local all_together = adam.state(actions.debug.callback(events.ALL_TOGETHER):set_delay(1):set_every_frame(true):set_periodic(0.5))
			local per_frame_skip_initial = adam.state(actions.debug.callback(events.PER_FRAME_SKIP_INITIAL):set_every_frame(true, true))
			local per_second_skip_initial = adam.state(actions.debug.callback(events.PER_SECOND_SKIP_INITIAL):set_periodic(1, true))


			adam_instance = adam.new(initial, {
				{initial, delay, "delay"},
				{initial, delay_update, "delay_update"},
				{initial, per_frame, "per_frame"},
				{initial, per_second, "per_second"},
				{initial, per_second_skip_initial, "per_second_skip_initial"},
				{initial, all_together, "all_together"},
				{initial, per_frame_skip_initial, "per_frame_skip_initial"},
				{adam.FROM_ANY, initial, "initial"}
			})
		end)

		after(function()
			adam_instance:final()
			mock.unmock(events)
		end)

		test("Actions delay behaviour", function()
			adam_instance:start()
			assert_equal(events.DELAY.calls, 0)
			adam_instance:event("delay")
			assert_equal(events.DELAY.calls, 0)
			adam_instance:update(0.25)
			assert_equal(events.DELAY.calls, 0)
			adam_instance:update(0.25)
			assert_equal(events.DELAY.calls, 1)
		end)

		test("Actions delay + per_frame behaviour", function()
			adam_instance:start()
			assert_equal(events.DELAY_UPDATE.calls, 0)
			adam_instance:event("delay_update")
			assert_equal(events.DELAY_UPDATE.calls, 0)
			adam_instance:update(0.5)
			assert_equal(events.DELAY_UPDATE.calls, 0)
			adam_instance:update(0.25)
			assert_equal(events.DELAY_UPDATE.calls, 0)
			adam_instance:update(0.25)
			assert_equal(events.DELAY_UPDATE.calls, 1)
			adam_instance:update(0.1)
			assert_equal(events.DELAY_UPDATE.calls, 2)
			adam_instance:update(0.001)
			assert_equal(events.DELAY_UPDATE.calls, 3)
			adam_instance:update(1)
			assert_equal(events.DELAY_UPDATE.calls, 4)
		end)

		test("Actions per frame behaviour", function()
			adam_instance:start()
			assert_equal(events.PER_FRAME.calls, 0)
			adam_instance:event("per_frame")
			assert_equal(events.PER_FRAME.calls, 1)
			adam_instance:update(0) -- this frame event was triggered, skip one
			assert_equal(events.PER_FRAME.calls, 1)
			adam_instance:update(0)
			assert_equal(events.PER_FRAME.calls, 2)
			adam_instance:update(0)
			assert_equal(events.PER_FRAME.calls, 3)
		end)

		test("Actions per second behaviour", function()
			adam_instance:start()
			assert_equal(events.PER_SECOND.calls, 0)
			adam_instance:event("per_second")
			assert_equal(events.PER_SECOND.calls, 1)
			adam_instance:update(0) -- this frame event was triggered, skip one
			assert_equal(events.PER_SECOND.calls, 1)
			adam_instance:update(0)
			assert_equal(events.PER_SECOND.calls, 1)
			adam_instance:update(0.5)
			assert_equal(events.PER_SECOND.calls, 1)
			adam_instance:update(0.5)
			assert_equal(events.PER_SECOND.calls, 2)
			adam_instance:update(1)
			assert_equal(events.PER_SECOND.calls, 3)
			adam_instance:update(0.9)
			assert_equal(events.PER_SECOND.calls, 3)
			adam_instance:update(0.1)
			assert_equal(events.PER_SECOND.calls, 4)
			adam_instance:update(10) -- One per update anyway
			assert_equal(events.PER_SECOND.calls, 5)
		end)

		test("Actions all together behaviour", function()
			adam_instance:start()
			assert_equal(events.ALL_TOGETHER.calls, 0)
			adam_instance:event("all_together")
			assert_equal(events.ALL_TOGETHER.calls, 0)
			adam_instance:update(0)
			adam_instance:update(0.5)
			assert_equal(events.ALL_TOGETHER.calls, 0)
			adam_instance:update(0.5)
			assert_equal(events.ALL_TOGETHER.calls, 1) -- delay worked
			adam_instance:update(0)
			adam_instance:update(0)
			adam_instance:update(0)
			assert_equal(events.ALL_TOGETHER.calls, 4) -- per frame
			adam_instance:update(0.5)
			assert_equal(events.ALL_TOGETHER.calls, 5) -- per frame + periodic triggered, but once per update
			adam_instance:update(0.4)
			assert_equal(events.ALL_TOGETHER.calls, 6)
			adam_instance:update(0.1)
			assert_equal(events.ALL_TOGETHER.calls, 7) -- again
		end)

		test("Actions per frame + skip initial behaviour", function()
			adam_instance:start()
			assert_equal(events.PER_FRAME_SKIP_INITIAL.calls, 0)
			adam_instance:event("per_frame_skip_initial")
			assert_equal(events.PER_FRAME_SKIP_INITIAL.calls, 0)
			adam_instance:update(0)
			assert_equal(events.PER_FRAME_SKIP_INITIAL.calls, 1)
			adam_instance:update(0)
			assert_equal(events.PER_FRAME_SKIP_INITIAL.calls, 2)
		end)

		test("Actions per second + skip initial behaviour", function()
			adam_instance:start()
			assert_equal(events.PER_SECOND_SKIP_INITIAL.calls, 0)
			adam_instance:event("per_second_skip_initial")
			assert_equal(events.PER_SECOND_SKIP_INITIAL.calls, 0)
			adam_instance:update(0)
			assert_equal(events.PER_SECOND_SKIP_INITIAL.calls, 0)
			adam_instance:update(1)
			assert_equal(events.PER_SECOND_SKIP_INITIAL.calls, 1)
			adam_instance:update(0.5)
			assert_equal(events.PER_SECOND_SKIP_INITIAL.calls, 1)
			adam_instance:update(0.5)
			assert_equal(events.PER_SECOND_SKIP_INITIAL.calls, 2)
			adam_instance:update(10) -- One per update anyway
			assert_equal(events.PER_SECOND_SKIP_INITIAL.calls, 3)
		end)
	end)
end

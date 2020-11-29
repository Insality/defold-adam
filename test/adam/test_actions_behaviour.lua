local adam = require("adam.adam")
local actions = require("adam.actions")
local mock = require("deftest.mock.mock")


local events = {
	INITIAL = function() end,
	INITIAL2 = function() end,
	INITIAL3 = function() end,
	STATE1 = function() end,
	STATE12 = function() end,
	STATE2 = function() end,
}

return function()
	describe("Basic actions behaviour", function()
		local adam_instance
		before(function()
			mock.mock(events)
			local initial = adam.state(
				actions.debug.callback(events.INITIAL),
				actions.debug.callback(events.INITIAL2),
				actions.debug.callback(events.INITIAL3)
			)
			local state1 = adam.state(
				actions.debug.callback(events.STATE1),
				actions.debug.event("to_state_2"),
				actions.debug.callback(events.STATE12)
			):set_name("state1")
			local state2 = adam.state(actions.debug.callback(events.STATE2)):set_name("state2")

			adam_instance = adam.new(initial, {
				{initial, state1},
				{state1, state2, "to_state_2"},
			})
		end)

		after(function()
			adam_instance:final()
			mock.unmock(events)
		end)

		test("States execute all actions on enter", function()
			assert_equal(events.INITIAL.calls, 0)
			assert_equal(events.INITIAL2.calls, 0)
			assert_equal(events.INITIAL3.calls, 0)
			adam_instance:start()
			assert_equal(events.INITIAL.calls, 1)
			assert_equal(events.INITIAL2.calls, 1)
			assert_equal(events.INITIAL3.calls, 1)
		end)

		test("States drop execution on changing state", function()
			adam_instance:start()
			assert_equal(events.STATE1.calls, 1)
			assert_equal(events.STATE12.calls, 0)
			assert_equal(adam_instance:get_current_state():get_name(), "state2")
		end)
	end)
end

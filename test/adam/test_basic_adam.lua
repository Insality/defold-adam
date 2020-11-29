local adam = require("adam.adam")
local actions = require("adam.actions")
local mock = require("deftest.mock.mock")


local events = {
	INITIAL = function() end,
	STATE1 = function() end,
	STATE2 = function() end,
	FROMANY = function() end,
}

return function()
	describe("Basic Adam systems", function()
		local adam_instance
		before(function()
			mock.mock(events)
			local initial = adam.state(actions.debug.callback(events.INITIAL))
			local state1 = adam.state(actions.debug.callback(events.STATE1)):set_name("state1")
			local state2 = adam.state(actions.debug.callback(events.STATE2)):set_name("state2")
			local from_any = adam.state(actions.debug.callback(events.FROMANY))
			adam_instance = adam.new(initial, {
				{initial, state1},
				{state1, state2, "to_state_2"},
				{adam.ANY_STATE, from_any, "from_any"},
				{from_any, state1, adam.FINISHED}
			})
		end)

		after(function()
			adam_instance:final()
			mock.unmock(events)
		end)

		test("Adam not start before start call", function()
			assert_equal(events.INITIAL.calls, 0)
			assert_equal(events.STATE1.calls, 0)
			adam_instance:start()
		end)

		test("Adam instantly work with FINISHED events", function()
			adam_instance:start()
			assert_equal(events.INITIAL.calls, 1)
			assert_equal(events.STATE1.calls, 1)
			assert_equal(events.STATE2.calls, 0)
		end)

		test("Adam can trigger events from outside", function()
			adam_instance:start()
			assert_equal(events.INITIAL.calls, 1)
			assert_equal(events.STATE1.calls, 1)
			assert_equal(events.STATE2.calls, 0)
			adam_instance:event("to_state_2")
			assert_equal(events.STATE2.calls, 1)
			assert_equal(adam_instance:get_current_state():get_name(), "state2")
		end)

		test("Adam not transitions to state without transition edge", function()
			adam_instance:start()
			assert_true(adam_instance:can_transition("to_state_2"))
			adam_instance:event("to_state_2")
			adam_instance:event("to_state_2")
			assert_false(adam_instance:can_transition("to_state_2"))
			assert_equal(events.STATE2.calls, 1)
			assert_false(adam_instance:can_transition("to_state_1"))
			adam_instance:event("to_state_1")
			assert_equal(events.STATE1.calls, 1)
			adam_instance:event(adam.FINISHED)
			assert_equal(events.STATE1.calls, 1)
			assert_equal(events.STATE2.calls, 1)
			assert_equal(adam_instance:get_current_state():get_name(), "state2")
		end)

		test("Adam can have transitions fromm Any state", function()
			adam_instance:start()
			assert_equal(events.FROMANY.calls, 0)
			adam_instance:event("from_any")
			assert_equal(events.FROMANY.calls, 1)
			assert_equal(adam_instance:get_current_state():get_name(), "state1")
			adam_instance:event("to_state_2")
			assert_equal(events.STATE2.calls, 1)
		end)
	end)
end

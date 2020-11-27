local adam = require("adam.adam")
local actions = require("adam.actions")

return function()
	describe("Math actions", function()
		local adam_instance, state_instance
		before(function()
			state_instance = adam.state()
			adam_instance = adam.new(state_instance, {}, { value = 0 })
		end)

		after(function()
			adam_instance:final()
		end)

		test("Action Math Set", function()
			local math_action = actions.math.add("value", 1)
			math_action:set_state_instance(state_instance)
			math_action:trigger()
			assert_equal(2, adam_instance:get_value("value"))
		end)
	end)
end

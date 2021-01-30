# Custom Actions

Custom actions is required for some logic you need in your project. Custom actions are easy to create and use.


## How to use

All custom actions used in same way, as actions from `actions.*` module

For example, you have custom action `move_camera(x, y, time)`:

```lua
local adam = require("adam.adam")
local actions = require("adam.actions")

local state = adam.state(
	actions.debug.print("This is just basic action"),
	move_camera(500, 300, 2) -- no any difference
)
```


## How to create

All actions are created via `ActionInstance` class. You can see any basic action for reference, but in general, it's look like this:

```lua
local ActionInstance = require("adam.system.action_instance")

local move_camera = function(x, y, time)
	local action = ActionInstance(function(self)
		print("This is action trigger callback")

		-- If you want use variables in arguments, use special getter:
		local camera_target = vmath.vector3(self:get_param(x), self:get_param(y), 0)

		-- You can get variable from Adam:
		local variable = self:get_value("variable_name")

		-- You can set variable from Adam:
		self:set_value("variable_name", 200)

		-- Time argument in this function is usual variable, not from Adam Instance
		gui.animate("/camera", "position", camera_target, gui.EASING_OUTSINE, time, 0, function()
			-- Pass User events with `self:event` function
			self:event("camera_moved")

			-- Call `self:finish` function, if you actions is not instant (deferred flag is true)
			self:finish()
		end)
	end, function(self)
		print("This is optional action release callback")
		print("Called when State switching or action is finished")
	end)

	action:set_name("myfunc.move_camera") -- Setting name is optional, but recommended for debug stuff
	action:set_every_frame() -- Optional, this one set action run every frame, also set it as deferred action
	action.set_periodic(1) -- Optional, this one set action run every one second, also set it as deferred action
	action.set_delay(1) -- Optional, this one set delay on action, also set it as deferred action.
	action.set_deferred(true) -- Mark action as not instant. To finish it you should call `self:finish()`

	return action
end

```


## Action Instance API

Full ActionInstance API you [can see here](https://insality.github.io/defold-adam/modules/ActionInstance.html)

Action have context on their execution time. It's a simple table to store variables. You can clean up it in release callback, if you use it. Context is passed as second argument:

```lua
local ActionInstance = require("adam.system.action_instance")

local move_camera = function(x, y, time)
	local action = ActionInstance(function(self, context)
		print("This is action trigger callback")
		context.last_time = time
	end, function(self, context)
		print("This is optional action release callback")
	end)

	return action
end

```


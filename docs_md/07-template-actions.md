# Template Actions

Template Actions - is a several actions united to one. It's useful for reuse once writed set of actions or make more clean code.

For example you write player movement logic, but your player should move in different state. You can write template for this behaviour in reuse it in all other states as one single action.


## Create template actions

You can create Template Actions with `adam.action(...)`. When you use this Template Action on declaring state, it will convert it to the list of actions.


```lua
local adam = require("adam.adam")

local input_action = adam.actions(
	actions.input.get_axis_actions("key_a", "key_d", "rotate_power", true, 4),
	actions.vmath.add_xyz("current_euler", nil, nil, actions.value("rotate_power"), true)
)

-- And now you can use it in other state:
local some_state = adam.state(
	input_action,
	action.debug.print("Some other actions can be here")
)
```


## Use template actions

As you created your Template Actions, you can use it as usual actions on State instantiate. But you have to remember, you should describe used variables inside this actions. For example from above, you should declare next variables: `current_euler` and `rotate_power`.


## Use template actions with parameters

Sometimes, you want to add parameters in you Template Actions. You can do it with usual lua functions:

```lua
...
local input_action = function(key_left, key_right, speed)
	return adam.actions(
		actions.input.get_axis_actions(key_left, key_right, "rotate_power", true, speed),
		actions.vmath.add_xyz("current_euler", nil, nil, actions.value("rotate_power"), true)
	)
end

local some_state = adam.state(
	input_action("key_a", "key_d", 10)
)
```


## Use states as template actions

You also can use other state as a Template Actions inside other state. Just use State Instance as Action:

```lua
local adam = require("adam.adam")

local input_state = adam.state(
	actions.input.get_axis_actions("key_a", "key_d", "rotate_power", true, 4),
	actions.vmath.add_xyz("current_euler", nil, nil, actions.value("rotate_power"), true)
)

-- And now you can use it in other state:
local some_state = adam.state(
	input_state,
	action.debug.print("Some other actions can be here")
)
```

There is no difference with `adam.actions`. But `adam.state` can be used inside Adam Instance describing
# Variables

## Overview

Variables are named containers for a value. For use variables inside FSM you should to declare it on Adam Instance create. Actions can use variables instead of values by name.


## Usage

All variables used by `actions.value(variable_name)` function. You should pass it instead of constant. For example:

```lua
local actions = require("adam.actions")
...
-- Usual constant usage
actions.time.delay(2),
-- Variable usage
actions.time.delay(actions.value("time_delay"))
...

```


## User variables

For use variables in you Adam Instance, you have to declare it. If you will try undeclared variablem you will get error: 

`The variable for FSM is not defined: {variable_name}`

Variables are declared on Adam Instance creating:

```lua
local adam = require("adam.adam")

self.adam = adam.new(initial,
	{
		{initial, idle},
		{idle, die}
	},
	{
		name = "Bob"
		health = 100,
		is_enemy = true,
		velocity = vmath.vector3(0),
	})
```


## Adam variables

Every Adam Instance already have several variables, which you can use:

```
adam.VALUE_CONTEXT - the url of adam instance (or binded game object). Used for check context event passing
adam.VALUE_LIFETIME - The fsm lifetime in seconds. Don't increasing while adam is inactive
```

Usage example:

```lua
local adam = require("adam.adam")

actions.value(adam.VALUE_LIFETIME)
```


### Usual variables, any type

Variables - just a container without any logic, so you can use any type of variables inside: number, string, tables, vectors or your custom objects. They are all used with `actions.value(variable_name)` method.


### Vector channels usage

For more comfort usage vector variables, you can get the field inside of this vector (or any other table value) with second argument in `actions.value` method:

```lua
	actions.value("position"), # This will return vector "position"
	actions.value("position", "x"), # This will return the "x" field of variable "position"
```
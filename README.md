
## IN DEVELOPMENT

![](media/adam-logo.png)
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/insality/defold-adam/Run%20tests)](https://github.com/Insality/defold-adam/actions)
[![codecov](https://codecov.io/gh/Insality/defold-adam/branch/main/graph/badge.svg?token=VIN9pcSlpF)](https://codecov.io/gh/Insality/defold-adam)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/insality/defold-adam)
---
The FSM plugin for Defold to describe states like Playmaker in Unity with predefined actions


## Features

Defold Adam has next features:

- **Powerful** Finite State Machine to describe any behaviour you want
- **Easy to start**: A lot of predefined actions with good API reference and annotations
- **Enough for game**: Ability to build any game logic just via state machine (like playmaker and bolt in Unity)
- **Rich features**: reusable action templates and nested FSM
- **Comfort**: Any action describes in one line of code. It provides fast developing, easy reading and less bugs
- **Performance**: Good performance even with a lot of instances of FSM
- **Code as Data**: Ability to load your FSM as JSON (from resources, from web, etc)
- **Visual Editor**: not provided now, but who knows?


## Setup

### Dependency

You can use the **Defold-Adam** extension in your own project by adding this project as a [Defold library dependency](https://www.defold.com/manuals/libraries/). Open your game.project file and in the dependencies field under project add:

> [https://github.com/Insality/defold-adam/archive/master.zip](https://github.com/Insality/defold-adam/archive/master.zip)

Or point to the ZIP file of a [specific release](https://github.com/Insality/defold-adam/releases).


## Basic usage

To use **Adam**, you should do next:

- Describe your states with actions via create State instances: `adam.state`

- Describe transitions between states via create Adam instances: `adam.new`

The most basic code look like this:
```lua
local adam = require("adam.adam")
local actions = require("adam.actions")


function init(self)
	-- Empty state
	local initial = adam.state()

	-- The state with one instant action
	local hello = adam.state(
		actions.debug.print("Hello guys")
	)

	-- The adam instance itself
	self.adam = adam.new(initial,
		{
			{initial, hello, adam.FINISHED}	-- Third parameter is optional, it's FINISHED by default
		}
	)
end


--- The final call is important!
function final(self)
	self.adam:final()
end


--- The update call is important!
function update(self, dt)
	self.adam:update(dt)
end


--- If you are using input, you should `acquire_input_focus` by youself
-- `adam:on_input` using for all input interactions (actions.input module)
function on_input(self, action_id, action)
	self.adam:on_input(action_id, action)
end


--- On message used for physics responces and other stuff
function on_message(self, message_id, message, sender)
	self.adam:on_message(message_id, message, sender)
end

```


## Custom actions

Short description how to create your custom actions and how to use it in code. Full instruction in other document


## Learn more

- Core Concepts / Glossary
- States
- Events
- Actions
- Variables
- Custom Actions
- Template Actions
- Nested State Machines
- JSON representation
- EmmyLua annotations
- Performance hints/tests (is possible to use one FSM to control a lot of entities?)
- Usage examples
- FAQ


## Examples

List of created examples and their code from `/examples`


## License

Developed and supported by [Insality](https://github.com/Insality)

---

Used libraries:

- [lua-fsm](https://github.com/unindented/lua-fsm)
- [middleclass](https://github.com/kikito/middleclass)


## Issues and suggestions

If you have any issues, questions or suggestions please [create an issue](https://github.com/Insality/defold-adam/issues) or contact me: [insality@gmail.com](mailto:insality@gmail.com)


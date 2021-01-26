# Events

## System events

System events - events, which defined inside Adam Instances. They will be triggered in some event, usually triggered from outside (input, physics, etc)


### Basic

The most basic event - State finished event. When all Actions are finished inside the State, the State will get `adam.FINISHED` event. If some Action are deferred and have no finish condition, this event will be not triggered.

By default, on describing State transitions, this event is `adam.FINISHED`:

```lua
local adam = require("adam.adam")

self.adam = adam.new(initial,
{
	{initial, idle},
	{idle, die},
	{idle, die, adam.FINISHED}, # Similar to {idle, die}
}}

```


### Input

There is two System Input events:

```
local actions = require("adam.actions")

actions.EVENT.ACTION_PRESSED -- on any input pressed action
actions.EVENT.ACTION_RELEASED -- on any input released action
```

They will trigger instantly as Adam will get input with any pressed/released action. Maybe less usefull, that `actions.input` actions (which can get input state of specific action), but sometimes you can need this.


### Physics

There is two System Physics events:

```
local actions = require("adam.actions")

actions.EVENT.TRIGGER_ENTER -- on any trigger enter event
actions.EVENT.TRIGGER_LEAVE -- on any trigger leave event
```

When Adam Instance get this event, you can get more info about collision with `action.physics.get_trigger_info(other_group, other_id, own_group)` action.

Usage example:

```lua
local adam = require("adam.adam")
local actions = require("adam.actions")

local adam = adam.new(initial, {
	{initial, fly}
	{fly, check_destroy, actions.EVENT.TRIGGER_ENTER},
	{check_destroy, destroy, "destroy"},
	{check_destroy, fly}
}):start()
```


### Other

## User events

User events is a events you trigger with all other actions or directly with `actions.fsm.*` actions. 

For example, `actions.time.delay(seconds, event_name)` will trigger event `event_name` after seconds delay.

And `actions.fsm.broadcast_event(event_name, is_exclude_self, delay)` will trigger event `event_name` on all active Adam Instances.

You can point user events in Adam Instance State transitions:

Here `go_dance` and `stop_dance` is a user events.

```lua
local adam = require("adam.adam")
local actions = require("adam.actions")

local adam = adam.new(initial, {
	{initial, idle}
	{idle, dance, "go_dance"},
	{dance, idle, "stop_dance"}
}):start()
```

### Global events

If you want to trigger global event for all Adam Instances, you can trigger it via `adam.event(event_name)`. This function will trigger _event_name_ for all current Adam Instances in the game.
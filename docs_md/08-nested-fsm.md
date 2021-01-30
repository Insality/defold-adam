# Nested Adam Instances

## Overview

Nested Adam Instance - is a usual Adam Instance, but it runs inside already created other one Adam Instance.

You can add Adam Instance as nested with "adam_instance:add(adam_instance)". As usual Adam Instance, you have to run in manually with `adam_instance:start()`


## Nested Lifecycle

Nested Adam Instance will run until parent Adam Instance is running. You have to don't declare ':update', ':on_input' and ':final' functions. It forwarded by default to all nested instances.

Nested `update` and `on_input` functions runs after the parent functions call. The `final` functions runs before parent `final` function. You can stop Nested FSM with `:pause` or manual call `:final` function.


## Events

Messages and events is not forwarded to Nested FSM by default. You should do it manually with list of allowed events


### Forward Events

You can setup forwarded events with `adam:forward_events(nested_fsm, events, is_consume)`. Events can be string or array of strings. If `is_consume` is true and some event should be forwarded, it will be not pass to other nested FSM and parent FSM

```lua
self.parent_adam:forward_events(nested_fsm, actions.EVENT.TRIGGER_ENTER, true)
```


## Nested per state

-- TODO: Add nested FSM for state lifecycle?



# States

## Action container

States contains list of Actions, which will be executed, when State become active.


## Execution order

Actions insite state executed from first to the last. If some events are delayer or have repeat logic (every frame or second) it will executed in same order.


## Execution interrupt

If some action will trigger event, which cause transition in current Adam Instance, all next actions will be not executed.


## Initial state

Adam instance have initial state. This is state, which will be executed on `adam:start` method.


## Final state

In Adam Instances you can setup the final state. Final state is state, what will executed on `adam:final`.
It can be useful to do something at the end of FSM lifecycle.


Please note next:
- Final state should contains only instant actions. No deferred actions allowed (they will not executed)
- You can have no transitions to final state. It will be executed without any transition
- Final state executed at end of final step. Nested adam instances will execute their final methods first
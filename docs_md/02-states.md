# States

## Action container


## Execution order


## Execution interrupt


## Final state

In Adam Instances you can setup the final state. Final state is state, what will executed on `adam:final`.
It can be useful to do something at the end of FSM lifecycle.

Final event features:
- Final state should contains only instant actions. No deferred actions allowed (they will not executed)
- You can have no transitions to final state. It will be executed without any transition
- Final state executed at end of final step. Nested adam instances will execute their final methods first
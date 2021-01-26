# Actions

## Action life cycle

## Finished event

## Deferred actions

Deferred action - action is not instant and have custom logic to finish. For example - delayed actions. This action will execute and finish after delay. Actions can be deferred and no have finish conditions - they will not trigger finish event to complete the State (for example action with every frame logic).


### Delayed Events

A lof of actions can be delayed, this mean action will be executed after some seconds of delay. You can use variables instead of constants in action logic.


### Every Frame

Some actions can be triggered every frame. This type of actions have no finish conditions and lasts forever(until states will be changed in other way). If in State you have several every frame actions, they will keep their execution order.


### Periodic events

The logic is similar to Every Frame actions, but they have time between their execution. For example - trigger action every second. This actions also deferred and have no condition to finish.
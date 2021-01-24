# Tips

## Some advices

- Every place, where you need to point the name of variable to set/get value, you can use
actions.value("variable_name", "variable_field")
It is useful for vectors variable to escape extract value step. You can directly work with
vectors channels
For example, velocity is a vector3. You can get x field via `actions.value("velocity", "x")`

- You can change the context of FSM to any game object. It will change self context in several actions and get triggers from this game object (for example - physic's triggers). For this you need to attach _adam_event_propagate.script_ to this object

- All events are trigger immediatly. But if context between two FSM are different, the event will be posted via `msg.post`, so it will be not immediate.
This type of event can be send via `fsm.send_event` of `fsm.broadcast_event`

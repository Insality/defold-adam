# Tips

## Some advices

- Every place, where you need to point the name of variable to set/get value, you can use
actions.value("variable_name", "variable_field")
It is useful for vectors variable to escape extract value step. You can directly work with
vectors channels

- You can change the context of FSM to any game object. It will change self context in several actions and get triggers from this game object (for example - physic's triggers). For this you need to attach _adam_event_propagate.script_ to this object
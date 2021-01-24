# Core concepts

## FSM

## Actions

## Variables

## Events


# Glossary

*FSM* - Finite State Machine

*Adam* - The Defold-Adam library

*Adam Instance* - The instance of Adam FSM

*Adam Instance Context* - The script (or game object), where Adam Instance is running

*State* - FSM contains State, State contains actions to be executed on entering in this state.

*State Instance* - Instance of Adam State. State Instance can be run only in Adam Instance.

*Action* - Action is a code, which can be executed on entering to the state.

*Action Instance* - Instance of some action. Actions can have the inner state, while running. Action Instance can exists only in State Instance.

*Event* - All transitions inside Adam FSM are triggered by Events. There are default events (ex. adam.FINISHED) and user events (any user string)

*Variable* - Named container for value inside Adam Instance. This variable can be accessed from Adam Instance, State Instance or Action Instance

*Custom Action* - The action, created by user. Generally, there is no difference in logic between basic actions and custom actions

*Template Action* - The set of actions in one actions. Created by `adam.actions`. Can be used as usual action. Can be used inside get functions to make template actions with paremeters

*Nested Adam* - Adam Instance can be run inside other Adam Instance. This one called as Nested Adam Instance

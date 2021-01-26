# Core concepts

## FSM
A Finite State Machine (FSM) organizes transitions between states. In one time always only one state. Adam is a FSM with logic upon it. Adam describes states and transitions between them.


## States
The actions container. States start own execution on entering in this state. All actions start execution from their declare order and can be interrupted.


## Actions
Action is a piece of code what will be executed in this action. Action can use variables, can be repeated(every frame, every second) and delayed (with several seconds, for example). Actions can be deferred - this mean action is not instant and have their finish condition (again, delayer actions).


## Variables
Variables are named containers for a value. For use variables inside FSM you should to declare it on Adam Instance create. Actions can use variables instead of values by name.


## Events
All transitions between states are triggered by Events. Events can be system (like default Adam event - adam.FINISHED) or user events, for example key pressed event. Usually, all transitions are instant, so in one frame Adam can complete several states.


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

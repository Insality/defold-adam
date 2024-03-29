-- luacheck: ignore


---@class ActionInstance
---@field _is_deferred boolean desc
---@field _is_every_frame boolean desc
---@field _is_periodic boolean desc
---@field _name string The action instance name
---@field _periodic_timer number desc
---@field _periodic_timer_current number desc
---@field _release_callback function(ActionInstance) desc
---@field _state_instance StateInstance desc
---@field _trigger_callback function(ActionInstance) desc
---@field context table Action context table
---@field static ActionInstance.static Submodule
local ActionInstance = {}

--- Trigger event to action's FSM
---@param event_name string Name of trigger event
function ActionInstance.event(event_name) end

--- Function called when action is done.
---@param trigger_event string Event to trigger before finish call
function ActionInstance.finish(trigger_event) end

--- Force finish action, even with "is_every_frame" or "is_periodic".
---@param trigger_event string Event to trigger before finish call
function ActionInstance.force_finish(trigger_event) end

--- Return the name of the action
---@return string The action name
function ActionInstance.get_name() end

--- Check if param value is from FSM variables.
---@param param any
---@return any
function ActionInstance.get_param(param) end

--- Return variable value from FSM variables
---@param variable_name string The name of variable in FSM
function ActionInstance.get_value(variable_name) end

--- Action Instance constructor function
---@param trigger_callback function The main action function
---@param release_callback function The release function. Clean up stuff, it you need
function ActionInstance.initialize(trigger_callback, release_callback) end

--- Return action deferred state.
---@return boolean Action deferred state
function ActionInstance.is_deferred() end

--- Set debug state of action.
---@param state boolean The debug state
---@return ActionInstance Self
function ActionInstance.set_debug(state) end

--- Set action to deferred state.
---@param state boolean The deferred state
function ActionInstance.set_deferred(state) end

--- Add delay before action is triggered.
---@param seconds number|variable|nil Action delay
---@return ActionInstance Self
function ActionInstance.set_delay(seconds) end

--- Set action triggered every frame.
---@return ActionInstance Self
function ActionInstance.set_every_frame() end

--- Set the name of the action
---@param name string The action name
---@return ActionInstance Self
function ActionInstance.set_name(name) end

--- Set periodic trigger of action.
---@param seconds number The time between triggers
---@param skip_initial_call boolean If true, skip first initial call on state enter
---@return ActionInstance Self
function ActionInstance.set_periodic(seconds, skip_initial_call) end

--- Set variable value in action's FSM
---@param variable_name string The name of variable in FSM
---@param value any New value for variable
function ActionInstance.set_value(variable_name, value) end

--- Add context to this actions.
---@return ActionInstance Self
function ActionInstance.set_with_context() end


---@class ActionInstance.static
local ActionInstance__static = {}

--- Copy constructor
---@param prefab ActionInstance The action to copy
---@return ActionInstance Copy of prefab action
function ActionInstance__static.copy(prefab) end


---@class AdamInstance
local AdamInstance = {}

--- Add Adam Instance to current as nested FSM.
---@param adam_instance AdamInstance The nested Adam Instance
---@return AdamInstance Self
function AdamInstance.add(adam_instance) end

--- Change the self context instante (the go instante instead of "." in all of action)  also set the game object id as FSM id.
---@param game_object hash The game object to bind
---@return AdamInstance Self
function AdamInstance.bind(game_object) end

--- Check available to make transition from current state with event
---@param event_name string The trigger event
---@return boolean True, if FSM will make transition on this event
function AdamInstance.can_transition(event_name) end

--- Trigger event in Adam FSM.
---@param event_name string The trigger event name
---@param event_context table The event data
function AdamInstance.event(event_name, event_context) end

--- Adam final function.
function AdamInstance.final() end

--- Forward incoming events to other adam instance
---@param adam_instance AdamInstance The adam instance to get events
---@param events table|string The name of event[s] to forward
---@param is_consume boolean Is event should be consumed on forward
---@param Self AdamInstance
function AdamInstance.forward_events(adam_instance, events, is_consume, Self) end

--- Return current adam state
---@return StateInstance The current State Instance
function AdamInstance.get_current_state() end

--- Get id of current Adam instance
---@return hash The Adam Instance id
function AdamInstance.get_id() end

--- Get name of current Adam Instance
---@return string The Adam Instance name
function AdamInstance.get_name() end

--- Return current game object binded to Adam (default ".")
---@return url The game object id
function AdamInstance.get_self() end

--- Get context url, where Adam Instance was started.
---@return url|nil The Adam Instance url
function AdamInstance.get_url() end

--- Return variable value from Adam instance
---@param variable_name string|variable The name of variable in FSM
---@return variable
function AdamInstance.get_value(variable_name) end

--- Adam Instance constructor function.
---@param initial_state StateInstance The initial FSM state. It will be triggered on start
---@param transitions StateInstance[] The array of next structure: {state_instance, state_instance, [event]},  describe transitiom from first state to second on event. By default event is adam.FINISHED
---@param variables table Defined FSM variables. All variables should be defined before use
---@param final_state StateInstance This state should contains only instant actions, execute on adam:final, transitions are not required
---@return AdamInstance
function AdamInstance.initialize(initial_state, transitions, variables, final_state) end

--- Return true if Adam Instance is now working
---@return boolean Is active state
function AdamInstance.is_active() end

--- Return true, if Adam Instance was started
---@return boolean The Adam Instance inited state
function AdamInstance.is_inited() end

--- Adam on_input function.
---@param action_id hash The input action_id
---@param action table The input action info
function AdamInstance.on_input(action_id, action) end

--- Adam on_message function.
---@param message_id hash The message_id
---@param message table The message info
---@param sender hash The message sender id
function AdamInstance.on_message(message_id, message, sender) end

--- Pause the execution of Adam Instance.
---@return AdamInstance
function AdamInstance.pause() end

--- Resume the execution of Adam Instance.
---@return AdamInstance
function AdamInstance.resume() end

--- Set debug state of state.
---@param is_debug boolean The debug state
---@return AdamInstance Self
function AdamInstance.set_debug(is_debug) end

--- Set id for Adam instance.
---@param hash hash The Adam Instance id
function AdamInstance.set_id(hash) end

--- Set name for Adam Instance.
---@param name string The Adam Instance name
function AdamInstance.set_name(name) end

--- Set variable value in Adam instance
---@param variable_name string|variable The name of variable in FSM
---@param value any New value for variable
function AdamInstance.set_value(variable_name, value) end

--- Start the Adam Instance.
---@return AdamInstance
function AdamInstance.start() end

--- Adam update functions.
---@param dt numbet The delta time
function AdamInstance.update(dt) end


---@class StateInstance
local StateInstance = {}

--- Trigger event to FSM.
---@param event_name string The event to send
function StateInstance.event(event_name) end

--- Get the current AdamInstance, attached to this state
---@return AdamInstance
function StateInstance.get_adam_instance() end

--- Return current State Instance id.
function StateInstance.get_id() end

--- Get name of current State Instance
---@return string The State Instance name
function StateInstance.get_name() end

--- State Instance constructor function
---@param ... ActionInstance The any amount of ActionInstance for this State
---@return StateInstance
function StateInstance.initialize(...) end

--- Check is State can run in one frame.
---@return boolean True, if state triggers in one frame
function StateInstance.is_instant() end

--- Set debug state of state.
---@param state boolean The debug state
---@return StateInstance Self
function StateInstance.set_debug(state) end

--- Set name for State Instance.
---@param name string The State Instance name
function StateInstance.set_name(name) end


---@class actions
---@field debug actions.debug Submodule
---@field fsm actions.fsm Submodule
---@field go actions.go Submodule
---@field input actions.input Submodule
---@field logic actions.logic Submodule
---@field math actions.math Submodule
---@field msg actions.msg Submodule
---@field sprite actions.sprite Submodule
---@field time actions.time Submodule
---@field transform actions.transform Submodule
---@field vmath actions.vmath Submodule
local actions = {}


---@class actions.debug
local actions__debug = {}

--- Call callback on event trigger
---@param callback function The callback to call
---@param delay number Time in seconds
---@return ActionInstance
function actions__debug.callback(callback, delay) end

--- Instantly trigger event.
---@param event_name string The event to send
---@return ActionInstance
function actions__debug.event(event_name) end

--- Print text to console
---@param text string The log message
---@param is_every_frame boolean Repeat this action every frame
---@param is_every_second bool Repeat this action every second
---@return ActionInstance
function actions__debug.print(text, is_every_frame, is_every_second) end


---@class actions.fsm
local actions__fsm = {}

--- Broadcast event to all active FSM.
---@param event_name string The event to send
---@param is_exclude_self bool Don't send the event to self
---@param delay number Time delay in seconds
---@return ActionInstance
function actions__fsm.broadcast_event(event_name, is_exclude_self, delay) end

--- Finalize the Adam Instance
---@param string target |adam target The target instance to finish
---@param delay number Time delay in seconds
function actions__fsm.final(string, delay) end

--- Get adam from adam_id
---@param string adam_id The adam_id for search
---@param store_value string The name of variable in current FSM to store get value
---@param is_every_frame boolean Repeat this action every frame
function actions__fsm.get_adam(string, store_value, is_every_frame) end

--- Get variable from FSM.
---@param string target |adam target The target instance to get value
---@param variable variable Name of variable to get from target FSM
---@param store_value string The name of variable in current FSM to store get value
---@param is_every_frame boolean Repeat this action every frame
function actions__fsm.get_value(string, variable, store_value, is_every_frame) end

--- Pause the Adam Instance
---@param string target |adam target The target instance to pause
---@param delay number Time delay in seconds
function actions__fsm.pause(string, delay) end

--- Resume the Adam Instance
---@param string target |adam target The target instance to resume
---@param delay number Time delay in seconds
function actions__fsm.resume(string, delay) end

--- Send event to target Adam instance.
---@param target string|adam The target instance for send event. If there are several instances with equal ID, event will be delivered to all of them.
---@param event_name string The event to send
---@param delay number Time delay in seconds
---@param is_every_frame bool Repeat every frame
---@return ActionInstance
function actions__fsm.send_event(target, event_name, delay, is_every_frame) end

--- Set variable from FSM.
---@param string target |adam target The target instance to set value
---@param variable variable Name of variable to set value on target FSM
---@param source string The variable in current FSM to set the variable to
---@param is_every_frame boolean Repeat this action every frame
function actions__fsm.set_value(string, variable, source, is_every_frame) end


---@class actions.go
local actions__go = {}

--- Spawn game object via factory
---@param factory_url url The factory component to be used
---@param position vector3 The position to set
---@param variable variable The variable to store created game object id
---@param delay number The Time delay in seconds
---@param scale vector3 The scale to set
---@param rotation vector3 The rotation to set
---@param properties table The properties to set
---@return ActionInstance
function actions__go.create_object(factory_url, position, variable, delay, scale, rotation, properties) end

--- Spawn game objects via collection factory
---@param collection_factory_url url The colection factory component to be used
---@param position vector3 The position to set
---@param variable variable The variable to store created game object id
---@param delay number The Time delay in seconds
---@param scale vector3 The scale to set
---@param rotation vector3 The rotation to set
---@param properties table The properties to set
---@return ActionInstance
function actions__go.create_objects(collection_factory_url, position, variable, delay, scale, rotation, properties) end

--- Delete the game object
---@param target url The game object to delete, self by default
---@param delay number Delay before delete
---@param not_recursive boolean Set true to not delete children of deleted go
---@return ActionInstance
function actions__go.delete_object(target, delay, not_recursive) end

--- Delete the game objects
---@param target_ids table The game objects to delete
---@param delay number Delay before delete
---@param not_recursive boolean Set true to not delete children of deleted go
---@return ActionInstance
function actions__go.delete_objects(target_ids, delay, not_recursive) end

--- Delete the current game object  Useful for game objects that need to kill themselves, for example a projectile that explodes on impact.
---@param delay number Delay before delete
---@param not_recursive boolean Set true to not delete children of deleted go
---@return ActionInstance
function actions__go.delete_self(delay, not_recursive) end

--- Disable the receiving component
---@param target url The game object to delete, self by default
---@param delay number Delay before delete
---@return ActionInstance
function actions__go.disable(target, delay) end

--- Enable the receiving component
---@param target url The game object to delete, self by default
---@param delay number Delay before delete
---@return ActionInstance
function actions__go.enable(target, delay) end


---@class actions.input
local actions__input = {}

--- Check is action_id is active now.
---@param action_id string The key to check
---@param variable string Variable to set
---@param in_update_only boolean Repeat this action every frame, skip initial call
---@param trigger_event string The event to trigger on true condition
---@return ActionInstance
function actions__input.get_action(action_id, variable, in_update_only, trigger_event) end

--- Check is action_id was pressed.
---@param action_id string The key to check
---@param variable string Variable to set
---@param in_update_only boolean Repeat this action every frame, skip initial call
---@param trigger_event string The event to trigger on true condition
---@return ActionInstance
function actions__input.get_action_pressed(action_id, variable, in_update_only, trigger_event) end

--- Check is action_id was released.
---@param action_id string The key to check
---@param variable string Variable to set
---@param in_update_only boolean Repeat this action every frame, skip initial call
---@param trigger_event string The event to trigger on true condition
---@return ActionInstance
function actions__input.get_action_released(action_id, variable, in_update_only, trigger_event) end

--- Imitate two keys as axis.
---@param negative_action string The action_id to negative check
---@param positive_action string The action_id to positive check
---@param variable string Variable to set
---@param is_every_frame boolean Repeat this action every frame, skip initial call
---@param multiplier number The value to multiply result
---@return ActionInstance
function actions__input.get_axis_actions(negative_action, positive_action, variable, is_every_frame, multiplier) end

--- Check is action_id is active now on sprite_url
---@param action_id string The key to check
---@param sprite_url url The sprite url to check input action
---@param variable string Variable to set
---@param in_update_only boolean Repeat this action every frame, skip initial call
---@param trigger_event string The event to trigger on true condition
---@return ActionInstance
function actions__input.get_sprite_action(action_id, sprite_url, variable, in_update_only, trigger_event) end

--- Check is action_id is active now on sprite_url
---@param action_id string The key to check
---@param sprite_url url The sprite url to check input action
---@param variable string Variable to set
---@param in_update_only boolean Repeat this action every frame, skip initial call
---@param trigger_event string The event to trigger on true condition
---@return ActionInstance
function actions__input.get_sprite_action_pressed(action_id, sprite_url, variable, in_update_only, trigger_event) end

--- Check is action_id is active now on sprite_url
---@param action_id string The key to check
---@param sprite_url url The sprite url to check input action
---@param variable string Variable to set
---@param in_update_only boolean Repeat this action every frame, skip initial call
---@param trigger_event string The event to trigger on true condition
---@return ActionInstance
function actions__input.get_sprite_action_released(action_id, sprite_url, variable, in_update_only, trigger_event) end


---@class actions.logic
local actions__logic = {}

--- Sends an event if all the variables are false
---@param variables_array variables[] Array of variables. Can be FSM or usual variable
---@param trigger_event string The event to send if all variables are false
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__logic.all_false(variables_array, trigger_event, is_every_frame) end

--- Sends an event if all the variables are true
---@param variables_array variables[] Array of variables. Can be FSM or usual variable
---@param trigger_event string The event to send if all variables are true
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__logic.all_true(variables_array, trigger_event, is_every_frame) end

--- Sends an event if any of the variables are true
---@param variables_array variables[] Array of variables. Can be FSM or usual variable
---@param trigger_event string The event to send if any of variables are true
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__logic.any_true(variables_array, trigger_event, is_every_frame) end

--- Tests if the value of a variable has changed.
---@param variable variable The variable to test on changed
---@param trigger_event string The event to send on variable change
---@param store_result string Save true to this variable, if variable has changed
---@return ActionInstance
function actions__logic.changed(variable, trigger_event, store_result) end

--- Send events based on the variables comparsion (numbers)
---@param variable_a variable The first variable to compare
---@param variable_b variable The second variable to compare
---@param event_equal string The event to send if variable_a equals to variable_b (within tolerance)
---@param event_less string The event to send if variable_a less than variable_b
---@param event_greater string The event to send if variable_a greater than variable_b
---@param is_every_frame boolean Repeat this action every frame
---@param tolerance number The tolerance for comparsion
---@return ActionInstance
function actions__logic.compare(variable_a, variable_b, event_equal, event_less, event_greater, is_every_frame, tolerance) end

--- Check equals on two variables
---@param variable_a variable The first variable to compare
---@param variable_b variable The second variable to compare
---@param event_equal string The event to send if variable_a equals to variable_b
---@param event_not_equal string The event to send if variable_a not equals variable_b
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__logic.equals(variable_a, variable_b, event_equal, event_not_equal, is_every_frame) end

--- Send events based on the value of a variable.
---@param variable variable The variable to test
---@param event_on_true string The event to send if variable is true
---@param event_on_false string The event to send if variable is false
---@param store_result string Save true to this variable, if variable has changed
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__logic.test(variable, event_on_true, event_on_false, store_result, is_every_frame) end


---@class actions.math
local actions__math = {}

--- Sets a float variable to its absolute value.
---@param source string Variable to abs
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__math.abs(source, is_every_frame) end

--- Get a acos value
---@param value variable Variable to take acos
---@param store_variable variable Variable to set
---@param is_degrees boolean Check true, if using degrees instead of radians
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__math.acos(value, store_variable, is_degrees, is_every_frame) end

--- Adds a value to a variable
---@param source string Variable to add
---@param value variable The value to add
---@param is_every_frame boolean Repeat this action every frame
---@param is_every_second boolean Repeat this action every second
---@return ActionInstance
function actions__math.add(source, value, is_every_frame, is_every_second) end

--- Get a asin value
---@param value variable Variable to take asin
---@param store_variable variable Variable to set
---@param is_degrees boolean Check true, if using degrees instead of radians
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__math.asin(value, store_variable, is_degrees, is_every_frame) end

--- Get a atan value
---@param value variable Variable to take atan
---@param store_variable variable Variable to set
---@param is_degrees boolean Check true, if using degrees instead of radians
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__math.atan(value, store_variable, is_degrees, is_every_frame) end

--- Get a atan2 value
---@param value variable Variable to take atan2
---@param store_variable variable Variable to set
---@param is_degrees boolean Check true, if using degrees instead of radians
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__math.atan2(value, store_variable, is_degrees, is_every_frame) end

--- Clamps the value of a variable to a min/max range.
---@param source string Variable to clamp
---@param min variable The minimum value allowed.
---@param max variable The maximum value allowed.
---@param is_every_frame boolean Repeat this action every frame
---@param is_every_second boolean Repeat this action every second
---@return ActionInstance
function actions__math.clamp(source, min, max, is_every_frame, is_every_second) end

--- Get a cos value
---@param value variable Variable to take cos
---@param store_variable variable Variable to set
---@param is_degrees boolean Check true, if using degrees instead of radians
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__math.cos(value, store_variable, is_degrees, is_every_frame) end

--- Divides a value by another value
---@param source string Variable to divide
---@param value variable Divide by this value
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__math.divide(source, value, is_every_frame) end

--- Loop value in range.
---@param source string Variable to loop
---@param min number The minimum value to loop.
---@param max number The maximum value to loop.
---@param is_every_frame boolean Repeat this action every frame
---@param is_every_second boolean Repeat this action every second
---@return ActionInstance
function actions__math.loop(source, min, max, is_every_frame, is_every_second) end

--- Choose max value
---@param source string Variable to compare
---@param min variable|number Another variable
---@param is_every_frame boolean Repeat this action every frame
---@param is_every_second boolean Repeat this action every second
---@return ActionInstance
function actions__math.max(source, min, is_every_frame, is_every_second) end

--- Choose min value
---@param source string Variable to compare
---@param min variable|number Another variable
---@param is_every_frame boolean Repeat this action every frame
---@param is_every_second boolean Repeat this action every second
---@return ActionInstance
function actions__math.min(source, min, is_every_frame, is_every_second) end

--- Multiplies a variable by another value
---@param source string Variable to multiply
---@param value variable The multiplier
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__math.multiply(source, value, is_every_frame) end

--- Apply a math function (a, b, adam_instance)=>c to source variable.
---@param source_variable_a variable First variable A
---@param variable_b variable Second variable B
---@param operator function The callback function
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__math.operator(source_variable_a, variable_b, operator, is_every_frame) end

--- Sets a variable to a random value between min/max.
---@param source string Variable to set
---@param min variable Minimum value of the random number
---@param max variable Maximum value of the random number.
---@param is_every_frame boolean Repeat this action every frame
---@param is_every_second boolean Repeat this action every second
---@return ActionInstance
function actions__math.random(source, min, max, is_every_frame, is_every_second) end

--- Sets a variable to a random value true or false
---@param source string Variable to set
---@param is_every_frame boolean Repeat this action every frame
---@param is_every_second boolean Repeat this action every second
---@return ActionInstance
function actions__math.random_boolean(source, is_every_frame, is_every_second) end

--- Set a value to a variable
---@param source string Variable to set
---@param value variable The value to set
---@param is_every_frame boolean Repeat this action every frame
---@param is_every_second boolean Repeat this action every second
---@return ActionInstance
function actions__math.set(source, value, is_every_frame, is_every_second) end

--- Get a sin value
---@param value variable Variable to take sin
---@param store_variable variable Variable to set
---@param is_degrees boolean Check true, if using degrees instead of radians
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__math.sin(value, store_variable, is_degrees, is_every_frame) end

--- Subtracts a value from a variable
---@param source string Variable to subtract from
---@param value variable The value to subtract
---@param is_every_frame boolean Repeat this action every frame
---@param is_every_second boolean Repeat this action every second
---@return ActionInstance
function actions__math.subtract(source, value, is_every_frame, is_every_second) end

--- Get a tan value
---@param value variable Variable to take tan
---@param store_variable variable Variable to set
---@param is_degrees boolean Check true, if using degrees instead of radians
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__math.tan(value, store_variable, is_degrees, is_every_frame) end


---@class actions.msg
local actions__msg = {}

--- Post message via msg.post
---@param target url The receiver url
---@param message_id string The message id to send
---@param message table A lua table with message parameters to send
---@param delay number Time in seconds
---@return ActionInstance
function actions__msg.post(target, message_id, message, delay) end


---@class actions.sprite
local actions__sprite = {}

--- Add the alpha to the sprite component
---@param alpha number The sprite alpha value
---@param is_every_frame boolean Repeat this action every frame
---@param delay number Delay before translate in seconds
---@param The target_component name sprite component
---@param target_url url The object to apply sprite
---@return ActionInstance
function actions__sprite.add_alpha(alpha, is_every_frame, delay, The, target_url) end

--- Add the tint to the sprite component
---@param tint vector4 The tint vector
---@param is_every_frame boolean Repeat this action every frame
---@param delay number Delay before translate in seconds
---@param The target_component name sprite component
---@param target_url url The object to apply sprite
---@return ActionInstance
function actions__sprite.add_tint(tint, is_every_frame, delay, The, target_url) end

--- Animate the alpha to the sprite component
---@param alpha number The sprite alpha value
---@param time number The time to animate
---@param finish_event string Name of trigger event
---@param delay number Delay before animate in seconds
---@param ease_function ease The ease function to animate. Default in settings.get_default_easing
---@param The target_component name sprite component
---@param target_url url The object to apply sprite
---@return ActionInstance
function actions__sprite.animate_alpha(alpha, time, finish_event, delay, ease_function, The, target_url) end

--- Animate the alpha of the sprite component with relative alpha vector
---@param alpha number The sprite alpha value
---@param time number The time to animate
---@param finish_event string Name of trigger event
---@param delay number Delay before animate in seconds
---@param ease_function ease The ease function to animate. Default in settings.get_default_easing
---@param The target_component name sprite component
---@param target_url url The object to apply sprite
---@return ActionInstance
function actions__sprite.animate_alpha_by(alpha, time, finish_event, delay, ease_function, The, target_url) end

--- Animate the tint to the sprite component
---@param tint vector4 The tint vector
---@param time number The time to animate
---@param finish_event string Name of trigger event
---@param delay number Delay before animate in seconds
---@param ease_function ease The ease function to animate. Default in settings.get_default_easing
---@param The target_component name sprite component
---@param target_url url The object to apply sprite
---@return ActionInstance
function actions__sprite.animate_tint(tint, time, finish_event, delay, ease_function, The, target_url) end

--- Animate the tint of the sprite component with relative tint vector
---@param tint vector4 The tint vector
---@param time number The time to animate
---@param finish_event string Name of trigger event
---@param delay number Delay before animate in seconds
---@param ease_function ease The ease function to animate. Default in settings.get_default_easing
---@param The target_component name sprite component
---@param target_url url The object to apply sprite
---@return ActionInstance
function actions__sprite.animate_tint_by(tint, time, finish_event, delay, ease_function, The, target_url) end

--- Get the alpha property of a game object and store to variable
---@param variable string The variable to store result
---@param is_every_frame boolean Repeat this action every frame
---@param The target_component name sprite component
---@param target_url url The object to apply sprite
---@return ActionInstance
function actions__sprite.get_alpha(variable, is_every_frame, The, target_url) end

--- Get the tint property of a game object and store to variable
---@param variable string The variable to store result
---@param is_every_frame boolean Repeat this action every frame
---@param The target_component name sprite component
---@param target_url url The object to apply sprite
---@return ActionInstance
function actions__sprite.get_tint(variable, is_every_frame, The, target_url) end

--- Play the flipbook for target url.
---@param image string The image to play
---@param The target_url name sprite component, by default - all sprite components in object
---@param finish_event string Name of trigger event
---@param delay number The Time delay in seconds
---@param The target_component name sprite component, by default - all sprite components in object
---@return ActionInstance
function actions__sprite.play_flipbook(image, The, finish_event, delay, The) end

--- Set the alpha to the sprite component
---@param alpha number The sprite alpha value
---@param is_every_frame boolean Repeat this action every frame
---@param delay number Delay before translate in seconds
---@param The target_component name sprite component
---@param target_url url The object to apply sprite
---@return ActionInstance
function actions__sprite.set_alpha(alpha, is_every_frame, delay, The, target_url) end

--- Set horizontal flip for the sprite
---@param is_flip boolean The boolean flag for flip
---@param The target_url name sprite component, by default - all sprite components in object
---@param is_every_frame boolean Repeat this action every frame
---@param delay number The Time delay in seconds
---@param The target_component name sprite component, by default - all sprite components in object
---@return ActionInstance
function actions__sprite.set_hflip(is_flip, The, is_every_frame, delay, The) end

--- Set the tint to the sprite component
---@param tint vector4 The tint vector
---@param is_every_frame boolean Repeat this action every frame
---@param delay number Delay before translate in seconds
---@param The target_component name sprite component
---@param target_url url The object to apply sprite
---@return ActionInstance
function actions__sprite.set_tint(tint, is_every_frame, delay, The, target_url) end

--- Set vertical flip for the sprite
---@param is_flip boolean The boolean flag for flip
---@param The target_url name sprite component, by default - all sprite components in object
---@param is_every_frame boolean Repeat this action every frame
---@param delay number The Time delay in seconds
---@param The target_component name sprite component, by default - all sprite components in object
---@return ActionInstance
function actions__sprite.set_vflip(is_flip, The, is_every_frame, delay, The) end


---@class actions.time
local actions__time = {}

--- Trigger event after time elapsed.
---@param seconds number|variable Amount of seconds for delay
---@param trigger_event string Name of trigger event
---@return ActionInstance
function actions__time.delay(seconds, trigger_event) end

--- Trigger event after amount of frames.
---@param frames number Amount of frames to wait
---@param trigger_event string Name of trigger event
---@return ActionInstance
function actions__time.frames(frames, trigger_event) end

--- Trigger event after random time elapsed.
---@param min_seconds number|variable Minimum amount of seconds for delay
---@param max_seconds number|variable Maximum amount of seconds for delay
---@param trigger_event string Name of trigger event
---@return ActionInstance
function actions__time.random_delay(min_seconds, max_seconds, trigger_event) end


---@class actions.transform
local actions__transform = {}

--- Add the euler of a game object
---@param target_euler vector3 The euler vector
---@param is_every_frame boolean Repeat this action every frame
---@param delay number Delay before translate in seconds
---@param target_url url The object to apply transform
---@return ActionInstance
function actions__transform.add_euler(target_euler, is_every_frame, delay, target_url) end

--- Add the position to a game object
---@param delta_vector vector3 Vector with x/y/z params to translate
---@param is_every_frame boolean Repeat this action every frame
---@param delay number Delay before translate in seconds
---@param target_url url The object to apply transform
---@return ActionInstance
function actions__transform.add_position(delta_vector, is_every_frame, delay, target_url) end

--- Add the rotation of a game object
---@param target_quaternion quaternion Rotation quatenion
---@param is_every_frame boolean Repeat this action every frame
---@param delay number Delay before translate in seconds
---@param target_url url The object to apply transform
---@return ActionInstance
function actions__transform.add_rotation(target_quaternion, is_every_frame, delay, target_url) end

--- Add scale to a game object
---@param target_scale vector3 Scale vector
---@param is_every_frame boolean Repeat this action every frame
---@param delay number Delay before translate in seconds
---@param target_url url The object to apply transform
---@return ActionInstance
function actions__transform.add_scale(target_scale, is_every_frame, delay, target_url) end

--- Animate the euler of a game object with euler vector
---@param target_euler vector3 The euler vector
---@param time number The time to animate
---@param finish_event string Name of trigger event
---@param delay number Delay before animate in seconds
---@param ease_function ease The ease function to animate. Default in settings.get_default_easing
---@param target_url url The object to apply transform
---@return ActionInstance
function actions__transform.animate_euler(target_euler, time, finish_event, delay, ease_function, target_url) end

--- Animate the euler of a game object with relative euler vector
---@param target_euler vector3 Rotation quaternion
---@param time number The time to animate
---@param finish_event string Name of trigger event
---@param delay number Delay before animate in seconds
---@param ease_function ease The ease function to animate. Default in settings.get_default_easing
---@param target_url url The object to apply transform
---@return ActionInstance
function actions__transform.animate_euler_by(target_euler, time, finish_event, delay, ease_function, target_url) end

--- Animate the position of a game object
---@param target_vector vector3 Position vector
---@param time number The time to animate
---@param finish_event string Name of trigger event
---@param delay number Delay before animate in seconds
---@param ease_function ease The ease function to animate. Default in settings.get_default_easing
---@param target_url url The object to apply transform
---@return ActionInstance
function actions__transform.animate_position(target_vector, time, finish_event, delay, ease_function, target_url) end

--- Animate the position of a game object by a delta vector
---@param target_vector vector3 Delta position vector
---@param time number The time to animate
---@param finish_event string Name of trigger event
---@param delay number Delay before animate in seconds
---@param ease_function ease The ease function to animate. Default in settings.get_default_easing
---@param target_url url The object to apply transform
---@return ActionInstance
function actions__transform.animate_position_by(target_vector, time, finish_event, delay, ease_function, target_url) end

--- Animate the rotation of a game object
---@param target_quaternion quaternion Rotation quaternion
---@param time number The time to animate
---@param finish_event string Name of trigger event
---@param delay number Delay before animate in seconds
---@param ease_function ease The ease function to animate. Default in settings.get_default_easing
---@param target_url url The object to apply transform
---@return ActionInstance
function actions__transform.animate_rotation(target_quaternion, time, finish_event, delay, ease_function, target_url) end

--- Animate the rotation of a game object with a delta quaternion
---@param target_quaternion quaternion Delta rotation quaternion
---@param time number The time to animate
---@param finish_event string Name of trigger event
---@param delay number Delay before animate in seconds
---@param ease_function ease The ease function to animate. Default in settings.get_default_easing
---@param target_url url The object to apply transform
---@return ActionInstance
function actions__transform.animate_rotation_by(target_quaternion, time, finish_event, delay, ease_function, target_url) end

--- Animate scale to a game object
---@param target_scale vector3 Scale vector
---@param time number The time to animate
---@param finish_event string Name of trigger event
---@param delay number Delay before animate in seconds
---@param ease_function ease The ease function to animate. Default in settings.get_default_easing
---@param target_url url The object to apply transform
---@return ActionInstance
function actions__transform.animate_scale(target_scale, time, finish_event, delay, ease_function, target_url) end

--- Animate scale to a game object with relative vector
---@param target_scale vector3 Add scale vector
---@param time number The time to animate
---@param finish_event string Name of trigger event
---@param delay number Delay before animate in seconds
---@param ease_function ease The ease function to animate. Default in settings.get_default_easing
---@param target_url url The object to apply transform
---@return ActionInstance
function actions__transform.animate_scale_by(target_scale, time, finish_event, delay, ease_function, target_url) end

--- Get the euler property of a game object and store to variable
---@param variable string The variable to store result
---@param is_every_frame boolean Repeat this action every frame
---@param target_url url The object to apply transform
---@return ActionInstance
function actions__transform.get_euler(variable, is_every_frame, target_url) end

--- Get the position property of a game object and store to variable
---@param variable string The variable to store result
---@param is_every_frame boolean Repeat this action every frame
---@param target_url url The object to apply transform
---@return ActionInstance
function actions__transform.get_position(variable, is_every_frame, target_url) end

--- Get the rotation property of a game object and store to variable
---@param variable string The variable to store result
---@param is_every_frame boolean Repeat this action every frame
---@param target_url url The object to apply transform
---@return ActionInstance
function actions__transform.get_rotation(variable, is_every_frame, target_url) end

--- Get the scale property of a game object and store to variable
---@param variable string The variable to store result
---@param is_every_frame boolean Repeat this action every frame
---@param target_url url The object to apply transform
---@return ActionInstance
function actions__transform.get_scale(variable, is_every_frame, target_url) end

--- Sets the euler of a game object
---@param target_euler vector3 The euler vector
---@param is_every_frame boolean Repeat this action every frame
---@param delay number Delay before translate in seconds
---@param target_url url The object to apply transform
---@return ActionInstance
function actions__transform.set_euler(target_euler, is_every_frame, delay, target_url) end

--- Sets the position of a game object
---@param target_vector vector3 Position vector
---@param is_every_frame boolean Repeat this action every frame
---@param delay number Delay before translate in seconds
---@param target_url url The object to apply transform
---@return ActionInstance
function actions__transform.set_position(target_vector, is_every_frame, delay, target_url) end

--- Sets the random euler of a game object
---@param keep_x boolean Set true to keep x euler angle
---@param keep_y boolean Set true to keep x euler angle
---@param keep_z boolean Set true to keep x euler angle
---@param is_every_frame boolean Repeat this action every frame
---@param delay number Delay before translate in seconds
---@param target_url url The object to apply transform
---@return ActionInstance
function actions__transform.set_random_euler(keep_x, keep_y, keep_z, is_every_frame, delay, target_url) end

--- Sets the rotation of a game object
---@param target_quaternion quaternion Rotation quatenion
---@param is_every_frame boolean Repeat this action every frame
---@param delay number Delay before translate in seconds
---@param target_url url The object to apply transform
---@return ActionInstance
function actions__transform.set_rotation(target_quaternion, is_every_frame, delay, target_url) end

--- Set scale to a game object
---@param target_scale vector3 Scale vector
---@param is_every_frame boolean Repeat this action every frame
---@param delay number Delay before translate in seconds
---@param target_url url The object to apply transform
---@return ActionInstance
function actions__transform.set_scale(target_scale, is_every_frame, delay, target_url) end


---@class actions.vmath
local actions__vmath = {}

--- Adds a Vector3 value to a Vector3 variable
---@param source string Variable to add
---@param variable variable Vector3 to add
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__vmath.add(source, variable, is_every_frame) end

--- Add the XYZ channels of a Vector3 variable
---@param source string Variable to add
---@param value_x number The x value to add. Pass nil to not change value
---@param value_y number The y value to add. Pass nil to not change value
---@param value_z number The z value to add. Pass nil to not change value
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__vmath.add_xyz(source, value_x, value_y, value_z, is_every_frame) end

--- Get euler value between two points
---@param from variable Vector3 to check to
---@param from variable Vector3 to check to
---@param store string The variable to store euler result. Pass nil to not store
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__vmath.get_euler(from, from, store, is_every_frame) end

--- Get the XYZ channels of a Vector3 variable
---@param source string Variable to get
---@param value_x string The variable to store x value. Pass nil to not store
---@param value_y string The variable to store y value. Pass nil to not store
---@param value_z string The variable to store z value. Pass nil to not store
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__vmath.get_xyz(source, value_x, value_y, value_z, is_every_frame) end

--- Get the length of vector to the store value
---@param variable variable The vector3 to get length
---@param store string The variable to store euler result. Pass nil to not store
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__vmath.length(variable, store, is_every_frame) end

--- Multiply a vector by a varialbe
---@param source string Variable vector to multiply
---@param value variable The multiplier variable
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__vmath.multiply(source, value, is_every_frame) end

--- Sets the XYZ channels of a Vector3 variable
---@param source string Variable to set
---@param value_x number The x value to set. Pass nil to not change value
---@param value_y number The y value to set. Pass nil to not change value
---@param value_z number The z value to set. Pass nil to not change value
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__vmath.set_xyz(source, value_x, value_y, value_z, is_every_frame) end

--- Subtracts a one vector3 from another
---@param source string Variable vector to subtract from
---@param value variable The vector to subtract
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__vmath.subtract(source, value, is_every_frame) end

--- Normalize a vector variable.
---@param source string Variable vector to normalize
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__vmath.subtract(source, is_every_frame) end


---@class adam
local adam = {}

--- Return the group of actions what can be used instead single action.
---@param ... ActionInstance The Actions for template
---@return ActionInstance Structure what can be used instead single action in state description
function adam.actions(...) end

--- Trigger event for all current Adam Instances
---@param event_name string
function adam.event(event_name) end

--- Create new instance of Adam
---@param initial_state StateInstance The initial FSM state. It will be triggered on start
---@param transitions StateInstance[] The array of next structure: {state_instance, state_instance, [event]},  describe transitiom from first state to second on event. By default event is adam.FINISHED
---@param variables table Defined FSM variables. All variables should be defined before use
---@param final_state StateInstance This state should contains only instant actions, execute on adam:final, transitions are not required
---@return AdamInstance
function adam.new(initial_state, transitions, variables, final_state) end

--- Return new Adam Instance from JSON representation
---@param json_data string The Adam Instance JSON representation
---@return AdamInstance The new Adam Instance
function adam.parse(json_data) end

--- Create new instance of State
---@param ... ActionInstance The any amount of ActionInstance for this State
---@return StateInstance
function adam.state(...) end


---@class adam.actions
local adam__actions = {}

--- Add operator
---@param source unknown
---@param value unknown
---@param is_every_frame unknown
---@return ActionInstance
function adam__actions.func(source, value, is_every_frame) end

--- Get info about last trigger event
---@param string other_group Variable to save own_group info
---@param string other_id Variable to save own_group info
---@param string own_group Variable to save own_group info
---@return ActionInstance
function adam__actions.get_trigger_info(string, string, string) end

--- Return value from FSM variables for action params
---@param variable_name string The variable name in Adam instance
---@param field string The field name from variable. Useful for vector variables
function adam__actions.value(variable_name, field) end



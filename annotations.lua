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

--- Set debug state of action.
---@param state boolean The debug state
---@return ActionInstance Self
function ActionInstance.set_debug(state) end

--- Set action to deferred state.
---@param state boolean The deferred state
function ActionInstance.set_deferred(state) end

--- Add delay before action is triggered.
---@param seconds number|nil Action delay
function ActionInstance.set_delay(seconds) end

--- Set action triggered every frame.
---@param state boolean The every frame state
---@param skip_initial_call boolean If true, skip first initial call on state enter
function ActionInstance.set_every_frame(state, skip_initial_call) end

--- Set the name of the action
---@param name string The action name
function ActionInstance.set_name(name) end

--- Set periodic trigger of action.
---@param seconds number The time between triggers
---@param skip_initial_call boolean If true, skip first initial call on state enter
function ActionInstance.set_periodic(seconds, skip_initial_call) end

--- Set variable value in action's FSM
---@param variable_name string The name of variable in FSM
---@param value any New value for variable
function ActionInstance.set_value(variable_name, value) end


---@class ActionInstance.static
local ActionInstance__static = {}

--- Copy constructor
---@param prefab ActionInstance The action to copy
---@return ActionInstance Copy of prefab action
function ActionInstance__static.copy(prefab) end


---@class AdamInstance
local AdamInstance = {}

--- Check available to make transition from current state with event
---@param event_name string The trigger event
---@return boolean True, if FSM will make transition on this event
function AdamInstance.can_transition(event_name) end

--- Trigger event in Adam FSM.
---@param event_name string The trigger event name
function AdamInstance.event(event_name) end

--- Adam final function.
function AdamInstance.final() end

--- Get id of current Adam instance
---@return hash The Adam Instance id
function AdamInstance.get_id() end

--- Return variable value from Adam instance
---@param variable_name string The name of variable in FSM
---@return variable
function AdamInstance.get_value(variable_name) end

--- Adam Instance constructor function.
---@param initial_state StateInstance The initial FSM state. It will be triggered on start
---@param transitions StateInstance[] The array of next structure: {state_instance, state_instance, [event]},  describe transitiom from first state to second on event. By default event is adam.FINISHED
---@param variables table Defined FSM variables. All variables should be defined before use
---@return AdamInstance
function AdamInstance.initialize(initial_state, transitions, variables) end

--- Adam on_input function.
---@param action_id hash The input action_id
---@param action table The input action info
function AdamInstance.on_input(action_id, action) end

--- Adam on_message function.
---@param message_id hash The message_id
---@param message table The message info
---@param sender hash The message sender id
function AdamInstance.on_message(message_id, message, sender) end

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
---@param variable_name string The name of variable in FSM
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
---@field math actions.math Submodule
---@field msg actions.msg Submodule
---@field time actions.time Submodule
---@field transform actions.transform Submodule
---@field vmath actions.vmath Submodule
local actions = {}


---@class actions.debug
local actions__debug = {}

--- Instantly trigger event.
---@param event_name string The event to send
---@return ActionInstance
function actions__debug.event(event_name) end

--- Print text to console
---@param text string The log message
---@param is_every_second bool Repeat this action every second
---@return ActionInstance
function actions__debug.print(text, is_every_second) end


---@class actions.fsm
local actions__fsm = {}

--- Broadcast event to all active FSM
---@param event_name string The event to send
---@param is_exclude_self bool Don't send the event to self
---@param delay number Time delay in seconds
---@return ActionInstance
function actions__fsm.broadcast_event(event_name, is_exclude_self, delay) end

--- Send event to target Adam instance
---@param target string|adam The target instance for send event. If there are several instances with equal ID, event will be delivered to all of them.
---@param event_name string The event to send
---@param delay number Time delay in seconds
---@param is_every_frame bool Repeat every frame
---@return ActionInstance
function actions__fsm.send_event(target, event_name, delay, is_every_frame) end


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

--- Delete the current game object  Useful for game objects that need to kill themselves, for example a projectile that explodes on impact.
---@param delay number Delay before delete
---@param not_recursive boolean Set true to not delete children of deleted go
---@return ActionInstance
function actions__go.delete_self(delay, not_recursive) end

--- Enable the receiving component
---@param target url The game object to delete, self by default
---@param delay number Delay before delete
---@return ActionInstance
function actions__go.disable_object(target, delay) end

--- Enable the receiving component
---@param target url The game object to delete, self by default
---@param delay number Delay before delete
---@return ActionInstance
function actions__go.enable_object(target, delay) end


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


---@class actions.math
local actions__math = {}

--- Sets a float variable to its absolute value.
---@param source string Variable to abs
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__math.abs(source, is_every_frame) end

--- Adds a value to a variable
---@param source string Variable to add
---@param value varible The value to add
---@param is_every_frame boolean Repeat this action every frame
---@param is_every_second boolean Repeat this action every second
---@return ActionInstance
function actions__math.add(source, value, is_every_frame, is_every_second) end

--- Divides a value by another value
---@param source string Variable to divide
---@param value varible Divide by this value
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__math.divide(source, value, is_every_frame) end

--- Multiplies a variable by another value
---@param source string Variable to multiply
---@param value varible The multiplier
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__math.multiply(source, value, is_every_frame) end

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
---@param value varible The value to set
---@param is_every_frame boolean Repeat this action every frame
---@param is_every_second boolean Repeat this action every second
---@return ActionInstance
function actions__math.set(source, value, is_every_frame, is_every_second) end

--- Clamps the value of a variable to a min/max range.
---@param source string Variable to set
---@param min number The minimum value allowed.
---@param max number The maximum value allowed.
---@param is_every_frame boolean Repeat this action every frame
---@param is_every_second boolean Repeat this action every second
---@return ActionInstance
function actions__math.set(source, min, max, is_every_frame, is_every_second) end

--- Subtracts a value from a variable
---@param source string Variable to substract from
---@param value varible The value to substract
---@param is_every_frame boolean Repeat this action every frame
---@param is_every_second boolean Repeat this action every second
---@return ActionInstance
function actions__math.substract(source, value, is_every_frame, is_every_second) end


---@class actions.msg
local actions__msg = {}

--- Post message via msg.post
---@param target url The receiver url
---@param message_id string The message id to send
---@param message table A lua table with message parameters to send
---@param delay number Time in seconds
---@return ActionInstance
function actions__msg.post(target, message_id, message, delay) end


---@class actions.time
local actions__time = {}

--- Trigger event after time elapsed.
---@param seconds number Amount of seconds for delay
---@param trigger_event string Name of trigger event
---@return ActionInstance
function actions__time.delay(seconds, trigger_event) end

--- Trigger event after amount of frames.
---@param frames number Amount of frames to wait
---@param trigger_event string Name of trigger event
---@return ActionInstance
function actions__time.frames(frames, trigger_event) end


---@class actions.transform
local actions__transform = {}

--- Animate scale to a game object
---@param target_scale vector3 Scale vector
---@param time number The time to translate gameobject. Incompatable with is_every_frame
---@param finish_event string Name of trigger event
---@param delay number Delay before translate in seconds
---@param ease_function ease The ease function to animate. Default in settings.get_default_easing
---@return ActionInstance
function actions__transform.animate_scale(target_scale, time, finish_event, delay, ease_function) end

--- Sets the position of a game object
---@param target_vector vector3 Position vector
---@param is_every_frame boolean Repeat this action every frame
---@param delay number Delay before translate in seconds
---@param ease_function ease The ease function to animate. Default in settings.get_default_easing
---@return ActionInstance
function actions__transform.set_position(target_vector, is_every_frame, delay, ease_function) end

--- Set scale to a game object
---@param target_scale vector3 Scale vector
---@param is_every_frame boolean Repeat this action every frame
---@param delay number Delay before translate in seconds
---@param ease_function ease The ease function to animate. Default in settings.get_default_easing
---@return ActionInstance
function actions__transform.set_scale(target_scale, is_every_frame, delay, ease_function) end

--- Translates a game object via delta vector
---@param delta_vector vector3 Vector with x/y/z params to translate
---@param is_every_frame boolean Repeat this action every frame
---@param delay number Delay before translate in seconds
---@param ease_function ease The ease function to animate. Default in settings.get_default_easing
---@return ActionInstance
function actions__transform.translate(delta_vector, is_every_frame, delay, ease_function) end


---@class actions.vmath
local actions__vmath = {}

--- Sets the XYZ channels of a Vector3 variable
---@param source string Variable to set
---@param value_x number The x value to set. Pass nil to not change value
---@param value_y number The y value to set. Pass nil to not change value
---@param value_z number The z value to set. Pass nil to not change value
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__vmath.set_xyz(source, value_x, value_y, value_z, is_every_frame) end


---@class adam
local adam = {}

--- Create new instance of Adam FSM
---@param initial unknown
---@param transitions unknown
---@param variables unknown
function adam.new(initial, transitions, variables) end

--- Return state to use it in Adam FSM
---@param ... unknown
function adam.state(...) end


---@class adam.actions
local adam__actions = {}

--- Add operator
---@param source unknown
---@param value unknown
---@param is_every_frame unknown
---@return ActionInstance
function adam__actions.func(source, value, is_every_frame) end

--- Return value from FSM variables for action params
---@param variable_name string The variable name in Adam instance
function adam__actions.value(variable_name) end



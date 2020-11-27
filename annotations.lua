-- luacheck: ignore


---@class ActionInstance
---@field _is_deferred boolean desc
---@field _is_every_frame boolean desc
---@field _is_periodic boolean desc
---@field _name string The action instance name
---@field _on_finish_callback function desc
---@field _periodic_timer number desc
---@field _periodic_timer_current number desc
---@field _release_callback function(ActionInstance) desc
---@field _state_instance StateInstance desc
---@field _trigger_callback function(ActionInstance) desc
---@field context table Action context table
local ActionInstance = {}

--- Trigger event to action's FSM
---@param event_name string Name of trigger event
function ActionInstance.event(event_name) end

--- Function called when action is done.
function ActionInstance.finished() end

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
---@param name string The action name. Useful for debug
---@param trigger_callback function The main action function
---@param release_callback function The release function. Clean up stuff, it you need
function ActionInstance.initialize(name, trigger_callback, release_callback) end

--- Set action to deferred state.
---@param state boolean The deferred state
function ActionInstance.set_deferred(state) end

--- Set action triggered every frame
---@param state boolean The every frame state
function ActionInstance.set_every_frame(state) end

--- Set the name of the action
---@param The string action name
function ActionInstance.set_name(The) end

--- Set periodic trigger of action.
---@param seconds number The time between triggers
function ActionInstance.set_periodic(seconds) end

--- Set variable value in action's FSM
---@param variable_name string The name of variable in FSM
---@param value any New value for variable
function ActionInstance.set_value(variable_name, value) end


---@class StateInstance
local StateInstance = {}

--- Trigger event to FSM.
---@param event_name string The event to send
function StateInstance.event(event_name) end


---@class actions
---@field debug actions.debug Submodule
---@field fsm actions.fsm Submodule
---@field go actions.go Submodule
---@field input actions.input Submodule
---@field template actions.template Submodule
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

--- Delete the current game object  Useful for game objects that need to kill themselves, for example a projectile that explodes on impact.
---@param delay number Delay before delete
---@param not_recursive boolean Set true to not delete children of deleted go
---@return ActionInstance
function actions__go.delete_self(delay, not_recursive) end


---@class actions.input
local actions__input = {}

--- Imitate two keys as axis.
---@param negative_key string The key to negative check
---@param positive_key string The key to positive check
---@param variable string Variable to set
---@param is_every_frame boolean Repeat this action every frame
---@param multiplier number The value to multiply result
---@return ActionInstance
function actions__input.get_axis_keys(negative_key, positive_key, variable, is_every_frame, multiplier) end

--- Check is key is pressed.
---@param key_name string The key to check
---@param variable string Variable to set
---@param value_to_set number Set this number or 0 instead of true/false
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function actions__input.get_key(key_name, variable, value_to_set, is_every_frame) end


---@class actions.template
local actions__template = {}

--- Add operator
---@return ActionInstance
function actions__template.func() end


---@class actions.time
local actions__time = {}

--- Trigger event after time elapsed.
---@param seconds number Amount of seconds for delay
---@param trigger_event string Name of trigger event
---@return ActionInstance
function actions__time.delay(seconds, trigger_event) end


---@class actions.transform
local actions__transform = {}

--- Sets the position of a game object
---@param target_vector vector3 Position vector
---@param is_every_frame boolean Repeat this action every frame
---@param time number The time to translate gameobject. Incompatable with is_every_frame
---@param finish_event string Name of trigger event
---@param delay number Delay before translate in seconds
---@param ease_function ease The ease function to animate. Default in settings.get_default_easing
---@return ActionInstance
function actions__transform.set_position(target_vector, is_every_frame, time, finish_event, delay, ease_function) end

--- Set scale to a game object
---@param target_scale vector3 Scale vector
---@param is_every_frame boolean Repeat this action every frame
---@param time number The time to translate gameobject. Incompatable with is_every_frame
---@param finish_event string Name of trigger event
---@param delay number Delay before translate in seconds
---@param ease_function ease The ease function to animate. Default in settings.get_default_easing
---@return ActionInstance
function actions__transform.set_scale(target_scale, is_every_frame, time, finish_event, delay, ease_function) end

--- Translates a game object via delta vector
---@param delta_vector vector3 Vector with x/y/z params to translate
---@param is_every_frame boolean Repeat this action every frame
---@param time number The time to translate gameobject. Incompatable with is_every_frame
---@param finish_event string Name of trigger event
---@param delay number Delay before translate in seconds
---@param ease_function ease The ease function to animate. Default in settings.get_default_easing
---@return ActionInstance
function actions__transform.translate(delta_vector, is_every_frame, time, finish_event, delay, ease_function) end


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

--- Sets a float variable to its absolute value.
---@param source string Variable to abs
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function adam__actions.abs(source, is_every_frame) end

--- Adds a value to a variable
---@param source string Variable to add
---@param value varible The value to add
---@param is_every_frame boolean Repeat this action every frame
---@param is_every_second boolean Repeat this action every second
---@return ActionInstance
function adam__actions.add(source, value, is_every_frame, is_every_second) end

--- Clamps the value of a variable to a min/max range.
---@param source string Variable to set
---@param min number The minimum value allowed.
---@param max number The maximum value allowed.
---@param is_every_frame boolean Repeat this action every frame
---@param is_every_second boolean Repeat this action every second
---@return ActionInstance
function adam__actions.clamp(source, min, max, is_every_frame, is_every_second) end

--- Divides a value by another value
---@param source string Variable to divide
---@param value varible Divide by this value
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function adam__actions.divide(source, value, is_every_frame) end

--- Multiplies a variable by another value
---@param source string Variable to multiply
---@param value varible The multiplier
---@param is_every_frame boolean Repeat this action every frame
---@return ActionInstance
function adam__actions.multiply(source, value, is_every_frame) end

--- Sets a variable to a random value between min/max.
---@param source string Variable to set
---@param min variable Minimum value of the random number
---@param max variable Maximum value of the random number.
---@param is_every_frame boolean Repeat this action every frame
---@param is_every_second boolean Repeat this action every second
---@return ActionInstance
function adam__actions.random(source, min, max, is_every_frame, is_every_second) end

--- Sets a variable to a random value true or false.
---@param source string Variable to set
---@param is_every_frame boolean Repeat this action every frame
---@param is_every_second boolean Repeat this action every second
---@return ActionInstance
function adam__actions.random_boolean(source, is_every_frame, is_every_second) end

--- Set a value to a variable
---@param source string Variable to set
---@param value varible The value to set
---@param is_every_frame boolean Repeat this action every frame
---@param is_every_second boolean Repeat this action every second
---@return ActionInstance
function adam__actions.set(source, value, is_every_frame, is_every_second) end

--- Subtracts a value from a variable
---@param source string Variable to substract from
---@param value varible The value to substract
---@param is_every_frame boolean Repeat this action every frame
---@param is_every_second boolean Repeat this action every second
---@return ActionInstance
function adam__actions.substract(source, value, is_every_frame, is_every_second) end

--- Return value from FSM variables for action params
---@param variable_name string The variable name in Adam instance
function adam__actions.value(variable_name) end



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
---@field _trigger_callback function<ActionInstance> desc
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
---@field math actions.math Submodule
---@field time actions.time Submodule
local actions = {}


---@class actions.debug
local actions__debug = {}

--- Instantly trigger event.
---@param event_name string The event to send
function actions__debug.event(event_name) end

--- Print text to console
---@param text string The log message
function actions__debug.print(text) end


---@class actions.fsm
local actions__fsm = {}

--- Broadcast event to all active FSM
---@param event_name string The event to send
---@param is_exclude_self bool Don't send the event to self
---@param delay number Time delay in seconds
function actions__fsm.broadcast_event(event_name, is_exclude_self, delay) end

--- Send event to target DMaker instance
---@param target string|dmaker The target instance for send event. If there are several instances with equal ID, event will be delivered to all of them.
---@param event_name string The event to send
---@param delay number Time delay in seconds
---@param is_every_frame bool Repeat every frame
function actions__fsm.send_event(target, event_name, delay, is_every_frame) end


---@class actions.math
local actions__math = {}

--- Add operator
---@param source string The variable name from DMaker instance
---@param value number|variable The number or Dmaker variable to add
---@param is_every_frame boolean Check true, if action should be called every frame
---@param is_every_second boolean Check true, if action should be called every second. Initial call is not skipped
function actions__math.add(source, value, is_every_frame, is_every_second) end


---@class actions.time
local actions__time = {}

--- Trigger event after time elapsed.
---@param seconds number Amount of seconds for delay
---@param trigger_event string Name of trigger event
function actions__time.delay(seconds, trigger_event) end


---@class dmaker
local dmaker = {}

--- Create new instance of dmaker FSM
---@param params unknown
function dmaker.new(params) end

--- Return state to use it in dmaker FSM
---@param ... unknown
function dmaker.state(...) end


---@class dmaker.actions
local dmaker__actions = {}

--- Return value from FSM variables for action params
---@param variable_name string The variable name in DMaker instance
function dmaker__actions.value(variable_name) end



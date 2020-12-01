--- Actions with time like delay or get time info
-- @submodule Actions

local const = require("adam.const")
local ActionInstance = require("adam.system.action_instance")

local M = {}


--- Trigger event after time elapsed. Trigger event is optional
-- @function actions.time.delay
-- @tparam number|variable seconds Amount of seconds for delay
-- @tparam[opt] string trigger_event Name of trigger event
-- @treturn ActionInstance
function M.delay(seconds, trigger_event)
	local action = ActionInstance(function(self)
		self:finish(trigger_event)
	end)

	action:set_delay(seconds)
	action:set_name("time.delay")
	return action
end


--- Trigger event after random time elapsed. Trigger event is optional
-- @function actions.time.random_delay
-- @tparam number|variable min_seconds Minimum amount of seconds for delay
-- @tparam number|variable max_seconds Maximum amount of seconds for delay
-- @tparam[opt] string trigger_event Name of trigger event
-- @treturn ActionInstance
function M.random_delay(min_seconds, max_seconds, trigger_event)
	local action = ActionInstance(function(self)
		self:finish(trigger_event)
	end)

	action:set_delay(min_seconds)

	-- Dirty hack here!
	---@override
	action._get_delay_seconds = function(self)
		local delay_min = self:get_param(min_seconds)
		local delay_max = self:get_param(max_seconds)
		if delay_min > delay_max then
			delay_min, delay_max = delay_max, delay_min
		end
		assert(delay_min >= 0 and delay_max >= 0, const.ERROR.TIME_DELAY_WRONG)
		return math.random() * (delay_max - delay_min) + delay_min
	end

	action:set_name("time.random_delay")
	return action
end


--- Trigger event after amount of frames. Trigger event is optional
-- @function actions.time.frames
-- @tparam number frames Amount of frames to wait
-- @tparam[opt] string trigger_event Name of trigger event
-- @treturn ActionInstance
function M.frames(frames, trigger_event)
	local action = ActionInstance(function(self, context)
		if frames <= 0 then
			self:force_finish()
		end

		if context.frames == nil then
			context.frames = frames
		end

		if context.frames >= 0 then
			context.frames = context.frames - 1
			if context.frames < 0 then
				self:event(trigger_event)
				self:force_finish()
			end
		end
	end, function(self, context)
		context.frames = nil
	end)

	action:set_every_frame()
	action:set_name("time.frames")
	return action
end


return M

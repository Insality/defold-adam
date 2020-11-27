--- Actions with time like delay or get time info
-- @submodule Actions

local ActionInstance = require("adam.system.action_instance")

local M = {}


--- Trigger event after time elapsed. Trigger event is optional
-- @function actions.time.delay
-- @tparam number seconds Amount of seconds for delay
-- @tparam[opt] string trigger_event Name of trigger event
-- @treturn ActionInstance
function M.delay(seconds, trigger_event)
	local action = ActionInstance(function(self)
		if trigger_event then
			self:event(trigger_event)
		end
		self:finished()
	end)

	action:set_delay(seconds)
	action:set_name("time.delay")
	return action
end


--- Trigger event after amount of frames. Trigger event is optional
-- @function actions.time.frames
-- @tparam number frmes Amount of frames to wait
-- @tparam[opt] string trigger_event Name of trigger event
-- @treturn ActionInstance
function M.frames(frames, trigger_event)
	local action = ActionInstance(function(self, context)
		if frames <= 0 then
			self:finished()
		end

		if context.frames == nil then
			context.frames = frames
		end

		if context.frames >= 0 then
			context.frames = context.frames - 1
			if context.frames < 0 then
				if trigger_event then
					self:event(trigger_event)
				end
				self:finished()
			end
		end
	end, function(self, context)
		context.frames = nil
	end)

	action:set_every_frame(true)
	action:set_name("time.frames")
	return action
end


return M

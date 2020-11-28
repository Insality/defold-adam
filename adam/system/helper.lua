-- Several utilitary functions
-- @local

local M = {}


function M.delay(delay, callback)
	if delay and delay > 0 then
		local timer_id = timer.delay(delay, false, callback)
		return timer_id
	end

	callback()
end


local NO_PADDING = {
	left = 0, right = 0, bottom = 0, top = 0,
}
--- Source: https://github.com/critique-gaming/crit/blob/master/crit/pick.lua
-- @param[type=url | string] sprite_url An URL identifying the sprite component.
-- @number x The x position of the point (in world space) to do the check on.
-- @number y The y position of the point (in world space) to do the check on.
-- @tparam[opt] PickPadding padding By how much should the hitbox of the sprite
--		be expanded or constricted.
-- @treturn boolean Returns `true` if the point hits inside the sprite and
--		`false` otherwise.
function M.pick_sprite(sprite_url, x, y, padding)
	padding = padding or NO_PADDING
	local size = go.get(sprite_url, hash("size"))

	local transform = go.get_world_transform(sprite_url)
	local pos = vmath.inv(transform) * vmath.vector4(x, y, 0, 1)
	x, y = pos.x, pos.y

	local half_width = size.x * 0.5
	local left = -half_width - padding.left
	local right = half_width + padding.right
	if x < left or x > right then return false end

	local half_height = size.y * 0.5
	local top = half_height + padding.top
	local bottom = -half_height - padding.bottom
	if y < bottom or y > top then return false end

	return true
end


return M

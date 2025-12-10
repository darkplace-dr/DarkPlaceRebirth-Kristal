---@class RimshotBall : Bullet
---@overload fun(...) : RimshotBall
local RimshotTriangle, super = Class(Bullet, "tenna/rimshot_triangle")

function RimshotTriangle:init(x, y)
    super.init(self, x, y, "battle/bullets/tenna/triangle")

    self:setScale(1)
    self:setColor(ColorUtils.mergeColor(COLORS.red, COLORS.white, 0.8))
    self.alpha = 0
	
    self.tp = 1

    self.physics.speed = 3
    self.physics.match_rotation = true
end

return RimshotTriangle
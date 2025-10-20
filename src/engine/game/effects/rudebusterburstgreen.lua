---@class RudeBusterBurstGreen : Sprite
---@overload fun(...) : RudeBusterBurstGreen
local RudeBusterBurstGreen, super = Class(Sprite)

function RudeBusterBurstGreen:init(x, y, angle, slow)
    super.init(self, "effects/rudebuster/beam_green", x, y)

    self:setOrigin(0.5, 0.5)
    self:setScale(2)

    self:fadeOutSpeedAndRemove()
    self:play(1/15, true)

    self.rotation = angle
    self.physics.speed = 25
    self.physics.match_rotation = true

    self.slow = slow
end

function RudeBusterBurstGreen:update()
    local slow_down = self.slow and 0.8 or 0.75

    self.physics.speed = self.physics.speed * (slow_down ^ DTMULT)
    self.scale_x = self.scale_x * (0.8 ^ DTMULT)

    super.update(self)
end

return RudeBusterBurstGreen
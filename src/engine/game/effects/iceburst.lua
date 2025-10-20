---@class IceBeamBurst : Sprite
---@overload fun(...) : IceBeamBurst
local IceBeamBurst, super = Class(Sprite)

function IceBeamBurst:init(red, x, y, angle, slow)
    super.init(self, red and "effects/icebeam/arrow_s" or "effects/icebeam/arrow_s", x, y)

    self:setOrigin(0.5, 0.5)
    self:setScale(2)

    self:fadeOutSpeedAndRemove()
    self:play(1/15, true)

    self.rotation = angle
    self.physics.speed = 25
    self.physics.match_rotation = true

    self.slow = slow
end

function IceBeamBurst:update()
    local slow_down = self.slow and 0.8 or 0.75

    self.physics.speed = self.physics.speed * (slow_down ^ DTMULT)
    self.scale_x = self.scale_x * (0.8 ^ DTMULT)

    super.update(self)
end

return IceBeamBurst
-- Isn't actually an AfterImage
local OrganikkPillarAfterImage, super = Class(Sprite)

function OrganikkPillarAfterImage:init(sprite, fade, speed)
    super.init(self, sprite)

    self.alpha = fade
    self:fadeOutSpeedAndRemove(speed)
    self:addFX(MaskFX(Game.battle.arena))
    self.graphics.grow_x = 0.25
end

-- function OrganikkPillarAfterImage:draw()
--     love.graphics.setBlendMode("add")
--     love.graphics.setDefaultFilter("linear", "linear")
--     super.draw(self)
--     love.graphics.setDefaultFilter("nearest", "nearest")
--     love.graphics.setBlendMode("alpha")
-- end

return OrganikkPillarAfterImage
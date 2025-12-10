-- Isn't actually an AfterImage
local OrganikkPillarAfterImage, super = Class(Sprite)

function OrganikkPillarAfterImage:init(sprite, fade, speed)
    super.init(self, sprite)

    self.alpha = fade
    self:fadeOutSpeedAndRemove(speed)
    self.graphics.grow_x = 0.25
    self.start_color = self.color
end

function OrganikkPillarAfterImage:draw()
    -- For some reason MaskFX doesnt work
    -- Needs updating since this doesn't work
    love.graphics.stencil(function ()
        if Game.battle.arena then
            -- Draw.pushShader(Kristal.Shaders["Mask"], {})
            -- love.graphics.push("transform")
            -- love.graphics.applyTransform(Game.battle.arena:getFullTransform())
            Game.battle.arena:draw()
        --     love.graphics.pop()
        --     Draw.popShader()
        end
    end, "replace", 1)
    love.graphics.setStencilTest("equal", 1)
    love.graphics.setBlendMode("add")
    love.graphics.setDefaultFilter("linear", "linear")
    self.color = ColorUtils.mergeColor(self.start_color, COLORS.black, self.alpha)
    super.draw(self)
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setBlendMode("alpha")
    love.graphics.setStencilTest()
end

return OrganikkPillarAfterImage
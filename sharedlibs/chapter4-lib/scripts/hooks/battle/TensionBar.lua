---@class TensionBar : TensionBar
local TensionBar, super = Utils.hookScript(TensionBar)

function TensionBar:flash(...)
    -- I just know there will be a better implementation from Kristal
    if super.flash then
        return super.flash(self, ...)
    end
    if self.flashfx then
        self:removeFX(self.flashfx)
    end
    self.flashfx = ColorMaskFX()
    self:addFX(self.flashfx)
end

function TensionBar:update()
    super.update(self)
    if self.flashfx then
        self.flashfx.amount = self.flashfx.amount - (DTMULT/7)
        if self.flashfx.amount < 0 then
            self:removeFX(self.flashfx)
            self.flashfx = nil
        end
    end
end

--- Creates sparkles around the bar (these appear by default when the soul collects "treasure")
---@param r? number
---@param g? number
---@param b? number
function TensionBar:sparkle(r, g, b)
    self.stage.timer:everyInstant(1/30, function()
        if self:isRemoved() then return false end
        for i = 1, 2 do
            local x, y = self:getRelativePos(
                ((love.math.random() * self.width)),
                (love.math.random() * self.height)
            )
            local sparkle = HealSparkle(x, y)
            sparkle.layer = self.layer + 0.1
            if r and g and b then
                sparkle:setColor(r, g, b)
            else
                sparkle:setColor(1,1,1)
            end
            sparkle:setScale(1)
            sparkle.graphics.fade = sparkle.graphics.fade * 2
            self.parent:addChild(sparkle)
            sparkle.physics.speed_x = 0
            sparkle.spin = 0
            sparkle.rotation = 0
        end
    end, 4)
end

return TensionBar
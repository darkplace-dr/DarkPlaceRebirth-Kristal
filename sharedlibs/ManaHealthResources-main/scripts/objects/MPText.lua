---@class MPText : Object
---@overload fun(...) : MPText
local MPText, super = Class(Object)

function MPText:init(text, x, y, color)
    super.init(self, x, y)
    self.text = text
    self:setOrigin(0, 0)
    self.color = color or ManaHealthResources.PALETTE["mana_msg"]
    self.physics.speed_y = -5
    self.alpha = 1
    self.parallax_x = 0
    self.parallax_y = 0
    self.font = Assets.getFont("main")
    self.timer = Timer()
    self:addChild(self.timer)

    self.timer:after(8/30, function()
        self:fadeOutSpeedAndRemove(1 / 8)
    end)
end

function MPText:draw()
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, 0, 0)

    Draw.setColor(1, 1, 1, 1)
    super.draw(self)
end

return MPText
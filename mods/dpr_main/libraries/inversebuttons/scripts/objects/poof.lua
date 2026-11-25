---@class poof : Object
---@overload fun(...) : poof
local poof, super = Class(Object)

function poof:init(x, y)
    super.init(self, x, y)

    self.alpha = 1.2
    self:fadeOutSpeedAndRemove(0.1)

    self.layer = 99

    self.timer = 0
end

function poof:update()
    self.timer = self.timer + DTMULT

    super.update(self)
end

function poof:draw()
    if self.copy == true then
    love.graphics.setColor(0.5,0.55,0.65,self.alpha)
    else
    love.graphics.setColor(0.7,0.4,0.7,self.alpha)
    end
    love.graphics.setLineWidth(4)
    love.graphics.circle("line", 0, 0, 61 - ((self.timer + 10) * 4), 32)

    super.draw(self)
end

return poof

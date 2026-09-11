---@class EbottCloud : Object
---@overload fun(...) : EbottCloud
local EbottCloud, super = Class(Object)

function EbottCloud:init(asset, x, y, speed, parallax_x, parallax_y)
    super.init(self, x, y)

    self.asset = asset
    self.speed = speed or 0.2

    self:setParallax(parallax_x or 0.6, parallax_y or 0.9)

    self.initial_y = y
end

function EbottCloud:update()
    self.x = self.x + (self.speed * DTMULT)

    if (self.x + self.asset:getWidth()) > (Game.world.width + self.asset:getWidth()) then
       self.x = -(self.asset:getWidth() * 2)
    end
end

function EbottCloud:draw()
    love.graphics.draw(self.asset, 0, 0, 0, 2, 2)
end

return EbottCloud

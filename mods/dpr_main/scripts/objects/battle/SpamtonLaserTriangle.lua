---@class Rectangle : Object
---@overload fun(...) : Rectangle
local SpamtonLaserTriangle, super = Class(Object)

function SpamtonLaserTriangle:init(x, y, point_a, point_b, point_c, point_d, point_e, point_f)
    super.init(self, x, y)
    self.point_a = point_a
    self.point_b = point_b
    self.point_c = point_c
    self.point_d = point_d
    self.point_e = point_e
    self.point_f = point_f
    self.color = {1, 1, 1}
end

function SpamtonLaserTriangle:draw()
	-- Giving the coordinates directly.
	love.graphics.polygon("fill", self.point_a,self.point_b,self.point_c,self.point_d,self.point_e,self.point_f)

    Draw.setColor(1, 1, 1, 1)
    super.draw(self)
end

return SpamtonLaserTriangle
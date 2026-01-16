local HolyFire, super = Class(Bullet)

function HolyFire:init(x, y, angle, dist)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/guei/holyfire")

    self.sprite:play(1/10, true)
    self:setScale(1)

    self.angle = angle
	self.dist = dist
	self:setOriginExact(15, 22)
    self:setHitbox(13, 16, 18-13, 23-16)
end

return HolyFire
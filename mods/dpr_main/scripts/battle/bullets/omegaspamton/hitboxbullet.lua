local HitboxBullet, super = Class(Bullet)

function HitboxBullet:init(x, y, hx, hy, hw, hh)
    super.init(self, x, y)
	
    self.visible = false
	self:setScale(1,1)
    self:setHitbox(0, 0, 1, 1)
end

return HitboxBullet
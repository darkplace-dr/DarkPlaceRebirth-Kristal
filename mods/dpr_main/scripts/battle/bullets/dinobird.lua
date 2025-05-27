local DinoBird, super = Class(Bullet)

function DinoBird:init(x, y, dir, speed)
    super.init(self, x, y)

	self:setSprite("battle/bullets/dinobird", 1/4)
	self:setHitbox(8, 6, 8, 8)
    self.physics.direction = dir
    self.physics.speed = speed
    self:setScale(2)
	self:setOrigin(0.5, 1)
    self.destroy_on_hit = false
	
	self.type = 0
end

return DinoBird
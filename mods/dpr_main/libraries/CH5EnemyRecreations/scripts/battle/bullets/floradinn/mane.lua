local Mane, super = Class(Bullet)

function Mane:init(x, y, dir)
    super.init(self, x, y, "battle/bullets/floradinn/triangle")

	self:setScale(1, 1)
	self.sprite.visible = false
	self.collidable = false
	self.timer = 0
	self.bullets = 2
	self.open_side = 1
	self.physics.speed_y = -1
	self.frame = 0
	self.spell = 2
	self.fadetarg = 1
	self.alpha = 0
	self.targx = self.x
	self.targy = self.y
	self.triangles = {}
	self.alarm_timer = -99
end

function Mane:update()
	self.alarm_timer = self.alarm_timer - DTMULT
	if self.alarm_timer ~= -99 and self.alarm_timer < 0 then
		Assets.playSound("explosion_firework", 0.8)
		for _, bullet in ipairs(self.triangles) do
			bullet.physics.direction = bullet.rotation
			bullet.physics.speed = (bullet.offset / 3.6) - 1
			bullet.destroy_on_hit = true
			bullet.grazed = false
			bullet.collidable = true
			bullet:setColor({1, 242/255, 25/255})
		end
		self:remove()
		return
	end
	for _, bullet in ipairs(self.triangles) do
		bullet.x = self.x + MathUtils.lengthDirX(bullet.offset, -bullet.rotation)
		bullet.y = self.y + MathUtils.lengthDirY(bullet.offset, -bullet.rotation)
	end	
	if self.physics.speed_x ~= 0 or self.physics.speed_y ~= 0 then	
		self.physics.speed, self.physics.direction = self:getSpeedDir()
		self.physics.speed_x = 0
		self.physics.speed_y = 0
	end
    super.update(self)
end

function Mane:draw()
    super.draw(self)
	love.graphics.push()
	love.graphics.origin()
	Draw.setColor(1, 0, 0, 1)
	love.graphics.setLineWidth(2)
	love.graphics.circle("line", self.targx, self.targy, 32)
	love.graphics.pop()
end

return Mane
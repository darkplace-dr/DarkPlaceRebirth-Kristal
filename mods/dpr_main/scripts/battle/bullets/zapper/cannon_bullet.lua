local CannonBullet, super = Class(Bullet)

function CannonBullet:init(x, y)
    super.init(self, x, y, "battle/bullets/diamond")

	self:setScale(1, 1)
    self.collider = PolygonCollider(self, {{11, 16}, {16, 14}, {21, 16}, {16, 18}})
	self.spin = 0
	self.spinspeed = 0
	self.speed_goal = 0
	self.speed_goal_change = 0
	self.speed_set = false
	self.tp = 5.6
	if Game.battle.encounter.volume_up then
		self:setScale(1.5)
		self.tp = 9.6
	end
	self.paused = false
	self.fade_timer = 0
end

function CannonBullet:update()
	super.update(self)
	if Game.battle.wave_timer >= Game.battle.wave_length - 1/30 then
		self:remove()
	end
	if self.paused then return end
	if not self.speed_set then
		self.speed_goal = self.physics.speed * 0.33
		self.speed_goal_change = math.abs(self.physics.speed - self.speed_goal) * 0.125
		self.speed_set = true
	end
	if self.x < -80 then
		self:remove()
	end
	if self.x > 760 then
		self:remove()
	end
	if self.y < -80 then
		self:remove()
	end
	if self.y > 580 then
		self:remove()
	end
	self.physics.speed = MathUtils.approach(self.physics.speed, self.speed_goal, self.speed_goal_change * DTMULT)
	self.spin = self.spin + DTMULT
	if self.spin >= 2 then
		self.rotation = self.rotation + math.rad(22.5)
		self.spin = 0
	end
	if Game.battle.arena and self.x < Game.battle.arena.left - 20 then
		self.fade_timer = self.fade_timer + DTMULT
		if self.fade_timer >= 1 then
			self.alpha = self.alpha * 0.8
			self.fade_timer = 0
		end
	end
end

return CannonBullet
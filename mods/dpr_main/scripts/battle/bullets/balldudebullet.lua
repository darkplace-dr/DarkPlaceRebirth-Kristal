local BallDudeBullet, super = Class(Bullet)

function BallDudeBullet:init(x, y, dir, speed)
    super.init(self, x, y, "battle/bullets/balldudebullet")

    self.physics.direction = dir
    self.physics.speed = speed

	self.destroy_on_hit = false

	-- god I wish for the sweet release of death
	self.supertimer = 0

	self.mercy_cooldown = 0

	--self.collider = Collider(self, Hitbox(self, 0, 0, 16, 16))
end

function BallDudeBullet:update()
	if self.supertimer < 30 then
        local x, y = self:getRelativePos(self.width / 2, self.height / 2)
        self.physics.direction = MathUtils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)
		self.rotation = MathUtils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)
	elseif self.supertimer >= 30 and self.physics.speed == 0 then
		self.physics.speed = 5
	end

	if self.x < Game.battle.arena:getLeft() then
		self.physics.direction = self.physics.direction + math.rad(90)
	end
	if self.x > Game.battle.arena:getRight() then
		self.physics.direction = self.physics.direction + math.rad(90)
	end
	if self.y < Game.battle.arena:getTop() then
		self.physics.direction = self.physics.direction + math.rad(90)
	end
	if self.y > Game.battle.arena:getBottom() then
		self.physics.direction = self.physics.direction + math.rad(90)
	end

	if self.wave.racket1bullet ~= nil and self.collider:collidesWith(self.wave.racket1bullet) then
		if self.attacker and self.mercy_cooldown == 0 then
			self.attacker:addMercy(3)
			self.mercy_cooldown = 3
		end
		self.physics.direction = self.physics.direction + math.rad(180)
	end

	if self.wave.racket2bullet ~= nil and self.collider:collidesWith(self.wave.racket2bullet) then
		if self.attacker and self.mercy_cooldown == 0 then
			self.attacker:addMercy(3)
			self.mercy_cooldown = 3
		end
		self.physics.direction = self.physics.direction + math.rad(180)
	end

	self.supertimer = self.supertimer + DTMULT

	self.mercy_cooldown = MathUtils.approach(self.mercy_cooldown, 0, DTMULT)

    super.update(self)
end

return BallDudeBullet
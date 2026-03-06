local ZapperCannonManager, super = Class(Bullet)

function ZapperCannonManager:init(x, y)
    super.init(self, x, y, "battle/enemies/zapper/cannon")
	self.image_index = 1
    self.sprite:stop()
    self.sprite:setFrame(1)
	
	self.attacker = 0
	self.attackerid = nil
	self.skipme = false
	self.xoff = -18
	self.yoff = -28

	self:setOrigin(0, 0)
	
	if not Game.battle.arena then
		self.aim_x = 320
		self.aim_y = 170 + 20
	else
		self.aim_x = Game.battle.arena.left + 4
		self.aim_y = Game.battle.arena.y + MathUtils.randomInt(-30, 30)
	end
	self.aim_angle = MathUtils.angle(self.x + 40, self.y + 82, self.aim_x, self.aim_y)
	self.reload = 32
	self.fire_timer = 16
	self.anim_timer = 12
	self.skipfire = false
	self.play_animation = false
end

function ZapperCannonManager:update()
    super.update(self)
	if self.play_animation then
		self.image_index = MathUtils.approach(self.image_index, #self.sprite.frames, 0.5 * DTMULT)
		if self.image_index >= #self.sprite.frames then
			self.image_index = 5
			self.play_animation = false
		end
	end
	if self.anim_timer > 0 then
		self.anim_timer = self.anim_timer - DTMULT
		self.image_index = MathUtils.approach(self.image_index, 5, 0.5 * DTMULT)
	end
	if Game.battle.wave_timer >= Game.battle.wave_length - 12/30 and not self.skipme then
		self.skipme = true
		local attacker_x, attacker_y = self.attackerid:getRelativePos(0, 30)
		Game.battle.timer:lerpVar(self, "x", self.x, attacker_x - 18, 12, 1, "out")
		Game.battle.timer:lerpVar(self, "y", self.y, attacker_y - 28, 12, 1, "out")
	end
	self.fire_timer = self.fire_timer - DTMULT
	if self.fire_timer <= 0 and not self.skipfire then
		Game.battle.timer:after(8/30, function()
			if Game.battle.arena then
				self.aim_y = Game.battle.arena.y + MathUtils.randomInt(-40, 40)
			end
			self.aim_angle = MathUtils.angle(self.x + 40, self.y + 82, self.aim_x, self.aim_y)
			Assets.playSound("explosion_firework", 1, 1.2)
			Assets.playSound("wing")
			local t_speed = 5.5
			local t_off = t_speed * 0.5
			local enemies = Game.battle:getActiveEnemies()
			for _, enemy in ipairs(enemies) do
				if enemy.id == "shuttah" then
					t_speed = 4.2
					t_off = t_speed * 0.75
				end
			end
			local circ_depth = 6
			if Game.battle.encounter.volume_up then
				t_speed = 5.5
				t_off = 3
				for _, wave in ipairs(Game.battle.waves) do
					if wave.id == "zapper/laser" then
						circ_depth = circ_depth - 1
					end
				end
			end
			local bullet = self.wave:spawnBullet("zapper/cannon_bullet", self.x + 40, self.y + 82)
			bullet.physics.direction = self.aim_angle
			bullet.physics.speed = t_speed * 2.5
			bullet.damage = 55
			for a = 0, circ_depth - 1 do
				local t_aim = self.aim_angle
				local t_hspeed = (MathUtils.lengthDirX(t_speed, -t_aim) - MathUtils.lengthDirX(t_off, -(t_aim + math.rad((60 * a) + 60)))) * 2.5
				local t_vspeed = (MathUtils.lengthDirY(t_speed, -t_aim) - MathUtils.lengthDirY(t_off, -(t_aim + math.rad((60 * a) + 60)))) * 2.5
				local bullet = self.wave:spawnBullet("zapper/cannon_bullet", self.x + 40, self.y + 82)
				bullet.physics.speed_x = t_hspeed
				bullet.physics.speed_y = t_vspeed
				bullet.physics.speed, bullet.physics.direction = bullet:getSpeedDir()
				bullet.physics.speed_x = 0
				bullet.physics.speed_y = 0
				bullet.damage = 55
			end
		end)
		self.play_animation = true
		if Game.battle.wave_timer < Game.battle.wave_length - (self.reload * 2)/30 then
			self.fire_timer = self.reload
		else
			self.skipfire = true
		end
	end
	if self.skipme then
		self.image_index = MathUtils.approach(self.image_index, 1, 0.5 * DTMULT)
	end
    self.sprite:setFrame(math.floor(self.image_index))
end

function ZapperCannonManager:startAnimation()
	if self.attacker == 0 then
		self.yoff = self.yoff - 24
	end
	if self.attacker == 2 then
		self.yoff = self.yoff + 24
	end
    local enemies = Game.battle:getActiveEnemies()
    for _, enemy in ipairs(enemies) do
		if enemy.id == "shuttah" then
			self.yoff = 0
		end
	end
	Game.battle.timer:lerpVar(self, "x", self.x, self.x - self.xoff, 12, 1, "out")
	Game.battle.timer:lerpVar(self, "y", self.y, self.y - self.yoff, 12, 1, "out")
end

return ZapperCannonManager
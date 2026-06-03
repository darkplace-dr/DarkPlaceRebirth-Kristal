local ZapperLaserManager, super = Class(Bullet)

function ZapperLaserManager:init(x, y)
    super.init(self, x, y, "battle/enemies/zapper/cannon")
    self.sprite:stop()
    self.sprite:setFrame(1)
	
	self.sameattack = 0
	self.sameattacker = 0
	self.attackerid = nil
	self.skipme = false
	self.xoff = -18
	self.yoff = -28
	self:setOrigin(0, 0)
	
	self.top = Game.battle.arena.top
	self.bound = Game.battle.arena.bottom
	self.reflect_angle = 0
	self.segment_max = 12
	self.segment = self.segment_max
	self.scale_goal = 1
	self.nuisance = 0
	self.fire_timer = 30
	self.layer_offset = 0
	Game.battle.timer:after(14/30, function()
	    local flash_sprite = Sprite("battle/enemies/zapper/lens_flash")
		flash_sprite:setOrigin(0.5, 0.5)
		flash_sprite:setPosition(self.x + 72, self.y + 20)
		flash_sprite.layer = self.layer + 0.01
		flash_sprite:play(1 / 15, false, function(s) s:remove(); end)
		self.wave:addChild(flash_sprite)
		Assets.playSound("spell_cure_slight_smaller", 1, 1.25)
	end)
end

function ZapperLaserManager:update()
    super.update(self)
	if Game.battle.wave_timer >= Game.battle.wave_length - 12/30 and not self.skipme then
		self.skipme = true
		local attacker_x, attacker_y = self.attackerid:getRelativePos(0, 30)
		Game.battle.timer:lerpVar(self, "x", self.x, attacker_x - 18, 12, 1, "out")
		Game.battle.timer:lerpVar(self, "y", self.y, attacker_y - 28, 12, 1, "out")
	end
	self.fire_timer = self.fire_timer - DTMULT
	if self.fire_timer <= 0 and not self.skipfire then
		local diff, aim_true
		if self.segment == self.segment_max then
			local choice = {}
			if self.y + 22 > self.top then
				table.insert(choice, -1)
			end
			if self.y + 22 < self.bound then
				table.insert(choice, 1)
			end
			local direct = TableUtils.pick(choice)
			local inter
			if direct == 1 then
				inter = self.bound
			else
				inter = self.top
			end
			if Game.battle.soul then
				diff = inter - Game.battle.soul.y
				self.reflect_angle = MathUtils.angle(self.x + 68, self.y + 22, Game.battle.soul.x, inter + diff)
			end
			local force_aim = 0
			if self.wave.linedraw then
				force_aim = self.wave.linedraw.force_aim_counter
			end
			aim_true = false
			if (not (MathUtils.random(99) < (force_aim * 25))) and math.abs(MathUtils.angleDiff(math.rad(180), self.reflect_angle)) < math.rad(65) then
				if MathUtils.randomInt(3) == 0 then
					self.reflect_angle = self.reflect_angle + MathUtils.randomInt(-8, 8)
				end
				local intersection = self:linesIntersect(self.x + 68, self.y + 22, self.x + 68 + MathUtils.lengthDirX(480, -self.reflect_angle), self.y + 22 + MathUtils.lengthDirY(480, -self.reflect_angle), Game.battle.arena.x - 165, inter, Game.battle.arena.x + 165, inter, true)
				if intersection <= 0 or intersection > 1 then
					if direct == 1 then
						inter = self.top
					else
						inter = self.bound
					end
					if Game.battle.soul then
						diff = inter - Game.battle.soul.y
						self.reflect_angle = MathUtils.angle(self.x + 68, self.y + 22, Game.battle.soul.x, inter + diff)
					end
				end
				
				if math.abs(MathUtils.angleDiff(math.rad(180), self.reflect_angle)) < math.rad(65) then
					for _, wave in ipairs(Game.battle.waves) do
						if wave.linedraw then
							wave.linedraw.force_aim_counter = wave.linedraw.force_aim_counter + 1
						end
					end
				else
					aim_true = true
				end
			else
				aim_true = true
			end
			
			if aim_true then
				self.reflect_angle = MathUtils.angle(self.x + 68, self.y + 22, Game.battle.soul.x, Game.battle.soul.y)
				for _, wave in ipairs(Game.battle.waves) do
					if wave.linedraw then
						wave.linedraw.force_aim_counter = 0
					end
				end
				
				if MathUtils.randomInt(2) ~= 0 then
					local imprecision = MathUtils.random(-22.5, 22.5)
					for angl = 3, 0, -1 do
						local imprecision_offset = imprecision * (angl / 3)
						local imprecise_angle = self.reflect_angle + math.rad(imprecision_offset)
						
						local collider = LineCollider(self, 68, 22, 68 + MathUtils.lengthDirX(480, -imprecise_angle), 22 + MathUtils.lengthDirY(480, -imprecise_angle))
						if Game.battle.arena:collidesWith(collider) then
							if math.abs(MathUtils.angleDiff(math.rad(180), imprecise_angle)) > math.rad(65) then
							else
								self.reflect_angle = imprecise_angle
								break
							end
						end
					end
				end
			end
			
			if self.nuisance == 1 then
				self.reflect_angle = MathUtils.clamp(reflect_angle, math.rad(125), math.rad(235))
			end
			Assets.playSound("heartshot", 1.4, 0.5)
		end
		local bullet = self.wave:spawnBullet("zapper/laser_bullet", self.x + 68, self.y + 22)
		bullet.physics.direction = self.reflect_angle
		bullet.physics.speed = 11 - (1 * self.nuisance * self.sameattack) - (1 * self.sameattack)
		bullet.rotation = bullet.physics.direction
		bullet.damage = 55
		bullet.layer = BATTLE_LAYERS["bullets"] + self.layer_offset - (self.sameattacker * 0.1)
		bullet.image_yscale_goal = self.scale_goal
		self.layer_offset = self.layer_offset - 1
		if self.segment == self.segment_max then
			bullet.first = true
		end
		if self.segment % 2 == 0 and self.segment > 3 then
			bullet.do_bounce_image = true
		end
		if Game.battle.encounter.volume_up then
			bullet.scale_y = bullet.scale_y * 1.5
			bullet.image_yscale_goal = bullet.image_yscale_goal * 1.5
			bullet.tp = 2.4
		end
		self.segment = self.segment - 1
		if self.segment < 5 then
			self.scale_goal = self.scale_goal - 0.2
		end
		if self.segment > 0 then
			self.fire_timer = 1
		elseif Game.battle.wave_timer < Game.battle.wave_length - (12 + self.segment_max + ((2 + (10 * self.sameattack) + (self.nuisance * 6)) * 2))/30 then
			self.fire_timer = 2 + (10 * self.sameattack) + (self.nuisance * 2)
			self.segment = self.segment_max
			self.scale_goal = 1
			self.layer_offset = 0
		else
			self.skipfire = true
		end
	end
end

function ZapperLaserManager:startAnimation()
	self.segment_max = 6 + (2 * self.sameattack)
	self.segment = self.segment_max
	if self.sameattacker == 0 then
		self.xoff = self.xoff + 8
		self.yoff = self.yoff - 32
	end
	if self.sameattacker == 2 then
		self.xoff = self.xoff - 8
		self.yoff = self.yoff + 32
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

function ZapperLaserManager:linesIntersect(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
	local ua = 0
	local ux = arg2 - arg0
	local uy = arg3 - arg1
	local vx = arg6 - arg4
	local vy = arg7 - arg5
	local wx = arg0 - arg4
	local wy = arg1 - arg5
	local ud = (vy * ux) - (vx * uy)
	if ud ~= 0 then
		ua = ((vx * wy) - (vy * wx)) / ud
		if arg8 then
			local ub = ((ux * wy) - (uy * wx)) / ud
			
			if ua < 0 or ua > 1 or ub < 0 or ub > 1 then
				ua = 0
			end
		end
	end
	return ua
end

return ZapperLaserManager
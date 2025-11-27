local ShadowguyTommyGun, super = Class(Wave)

function ShadowguyTommyGun:init()
    super.init(self)
	
	self.time = 200/30
	self.type = 0
    self.enemies = self:getAttackers()
	self.sameattack = 0
	if #self.enemies > 1 then
		self.sameattack = #self.enemies-1
	end
	self.count = love.math.random(0, 4)
	self.rep = 1
	self.guntimer = 0
	self.firing = false
	self.timer2 = Timer()
end

function ShadowguyTommyGun:update()
	super.update(self)
	if Game.battle.wave_timer > Game.battle.wave_length - 13/30 then
		self.guntimer = self.guntimer - DTMULT
		for _, enemy in ipairs(self.enemies) do
			enemy.x = MathUtils.lerp(enemy.x, enemy.xx, (12 - self.guntimer)/12)
		end
	elseif Game.battle.arena then
		self.guntimer = self.guntimer + DTMULT
		if self.guntimer < 14 then
			for _, enemy in ipairs(self.enemies) do
				enemy.x = MathUtils.lerp(enemy.x, Game.battle.arena.right + 122 + 62, 0.16*DTMULT)
			end
		else
			self.guntimer = 12
			self.firing = true
		end
	end
end

function ShadowguyTommyGun:onEnd()
	super.onEnd(self)
	for _, enemy in ipairs(self.enemies) do
		if enemy.mercy >= 100 then
			enemy:setAnimation("spared")
		else
			enemy:setAnimation("idle")
		end
		enemy.layer = BATTLE_LAYERS["battlers"]
		for _,dmg in ipairs(Game.stage:getObjects(DamageNumber)) do
			if dmg.parent == enemy.parent then
				dmg.layer = enemy.layer
			end
		end
		enemy.sprite.gun_rot = math.rad(180)
		enemy.sprite.gun:setFrame(1)
	end
end

function ShadowguyTommyGun:onStart()
	super.onStart(self)
	for _, enemy in ipairs(self.enemies) do
		enemy.xx = enemy.x
		enemy:setAnimation("firing")
		enemy.layer = BATTLE_LAYERS["above_bullets"]
		for _,dmg in ipairs(Game.stage:getObjects(DamageNumber)) do
			if dmg.parent == enemy.parent then
				dmg.layer = enemy.layer
			end
		end
		enemy.sprite.gun_rot = math.rad(180)
		enemy.sprite.gun:setFrame(1)
		if love.math.random(1, 8) == 1 then
			Assets.stopAndPlaySound("glock", 0.6)
		end
		self.timer:script(function(wait)
			wait(14/30)
			while Game.battle.wave_timer < Game.battle.wave_length - 29/30 do
				local actor = enemy.sprite
				local gun = actor.gun
				enemy:setAnimation("firing")
				actor.true_x = actor.x
				local maxbullets = 12
				if (#Game.battle.enemies == 3 and #Game.battle.waves == 2) or (#Game.battle.enemies == 2 and #Game.battle.waves == 3) or self.sameattack >= 1 then
					maxbullets = 6
				end
				if  (#Game.battle.enemies == 3 and #Game.battle.waves == 3) or self.sameattack >= 2 then
					maxbullets = 4
				end
				for i = 1, maxbullets do
					Assets.stopAndPlaySound("gunshot_b", 0.7, 0.95 + (MathUtils.random(10) / 100))
					local bullet_speed = 4 + MathUtils.random(2)
					if #Game.battle.waves >= 2 or self.sameattack >= 1 then
						bullet_speed = 4 + MathUtils.random(1)
					end
					self.timer:script(function(wait)
						actor.x = actor.x - 1
						actor.gunshake = 6
						gun:setFrame(1)
						wait(1/30)
						actor.x = actor.x + 1
						actor.gunshake = 0
						wait(1/30)
						gun:setFrame(2)
					end)
					
					self.rep = 1
					if self.type == 1 then
						self.rep = 5
					end
					while self.rep > 0 do
						local x, y = enemy.x - enemy.sprite.texture:getWidth() + 6 + (math.cos(actor.gun_rot) * actor.gunshake), enemy.y - 58*2 + 63 + (math.sin(actor.gun_rot) * actor.gunshake)
						actor.gun_rot = MathUtils.angle(x, y, Game.battle.arena.x, Game.battle.arena.y) - math.rad(30) + math.rad(love.math.random(0,60))
						if self.type == 1 then
							actor.gun_rot = math.rad(120 - love.math.random(0,90))
						end
						
						self.count = self.count + 1
						if self.count == 5 and #Game.battle.waves < 3 then
							self.count = -10
							actor.gun_rot = MathUtils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y) + math.rad(6) - math.rad(love.math.random(0,12))
						end
						local x, y = enemy.x - enemy.sprite.texture:getWidth() + 6 + (math.cos(actor.gun_rot) * 60), enemy.y - 58*2 + 64 + (math.sin(actor.gun_rot) * 60)
						--x, y = gun:getRelativePos(9, 32, Game.battle)
						local bullet = self:spawnBullet("shadowguy/tommygun_bullet", x, y)
						bullet.physics.direction = actor.gun_rot
						bullet.physics.speed = bullet_speed
						bullet.rotation = actor.gun_rot
						self.rep = self.rep - 1
					end
					if #Game.battle.waves == 3 or self.sameattack >= 2 then
						wait(8/30)
					elseif #Game.battle.waves == 2 or self.sameattack >= 1 then
						wait(4/30)
					elseif #Game.battle.waves == 1 then
						wait(2/30)
					end
				end
				
				enemy:setAnimation("reload")
				wait((10 + (love.math.random(0,1) * 5) + 4 * self.sameattack)/30)
			end
		end)
	end
end

return ShadowguyTommyGun
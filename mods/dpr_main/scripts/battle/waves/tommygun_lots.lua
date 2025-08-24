local ShadowguyTommyGun, super = Class(Wave)

function ShadowguyTommyGun:init()
    super.init(self)
	
	self.time = 200/30
	self.type = 0
    self.enemies = self:getAttackers()
	self.count = love.math.random(0, 4)
	self.guntimer = 0
	self.firing = false
	self.timer2 = Timer()
end

function ShadowguyTommyGun:update()
	super.update(self)
	if Game.battle.wave_timer > Game.battle.wave_length - 13/30 then
		self.guntimer = self.guntimer - DTMULT
		for _, enemy in ipairs(self.enemies) do
			enemy.x = Utils.lerp(enemy.x, enemy.xx, (12 - self.guntimer)/12)
		end
	elseif Game.battle.arena then
		self.guntimer = self.guntimer + DTMULT
		if self.guntimer < 14 then
			for _, enemy in ipairs(self.enemies) do
				enemy.x = Utils.lerp(enemy.x, Game.battle.arena.right + 122 + 62, 0.16*DTMULT)
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
	Assets.stopAndPlaySound("glock", 0.6)
	for i, enemy in ipairs(self.enemies) do
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
		self.timer:script(function(wait)
			wait(14/30)
			wait((i-1)/120)
			local actor = enemy.sprite
			local gun = actor.gun
			enemy:setAnimation("firing")
			actor.true_x = actor.x
			local maxbullets = 12
			Assets.playSound("gunshot_b", 0.4, 0.95 + (Utils.random(10) / 100))
			local bullet_speed = 4 + Utils.random(2)
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
			
			local x, y = enemy.x - enemy.sprite.texture:getWidth() + 6 + (math.cos(actor.gun_rot) * actor.gunshake), enemy.y - 58*2 + 63 + (math.sin(actor.gun_rot) * actor.gunshake)
			actor.gun_rot = Utils.angle(x, y, Game.battle.arena.x, Game.battle.arena.y) - math.rad(30) + math.rad(love.math.random(0,60))
			if self.type == 1 then
				actor.gun_rot = math.rad(120 - love.math.random(0,90))
			end
			
			self.count = self.count + 1
			if self.count == 5 then
				self.count = -10
				actor.gun_rot = Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y) + math.rad(6) - math.rad(love.math.random(0,12))
			end
			local x, y = enemy.x - enemy.sprite.texture:getWidth() + 6 + (math.cos(actor.gun_rot) * 60), enemy.y - 58*2 + 64 + (math.sin(actor.gun_rot) * 60)
			--x, y = gun:getRelativePos(9, 32, Game.battle)
			local bullet = self:spawnBullet("shadowguy/tommygun_bullet", x, y)
			bullet.physics.direction = actor.gun_rot
			bullet.physics.speed = bullet_speed
			bullet.rotation = actor.gun_rot
			wait(3/30)
			enemy:setAnimation("reload")
		end)
	end
end

return ShadowguyTommyGun
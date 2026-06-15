local ShadowguySax, super = Class(Wave)

function ShadowguySax:init()
    super.init(self)

	self.time = 200/30
    self.enemies = self:getAttackers()
	self.sameattack = #self.enemies
	if #self.enemies == #Game.battle.enemies then
		self:setArenaSize(142/2, 142)
		self:setArenaOffset(20, 0)
	end
	self.ratio = 1
	if #Game.battle.enemies == 2 then
		self.ratio = 1.6
	elseif #Game.battle.enemies == 3 then
		self.ratio = 2.3
	end
end

function ShadowguySax:onStart()
	super.onStart(self)
	
	for _, enemy in ipairs(Game.battle.enemies) do
		enemy.layer = BATTLE_LAYERS["above_bullets"]
		for _,dmg in ipairs(Game.stage:getObjects(DamageNumber)) do
			if dmg.parent == enemy.parent then
				dmg.layer = enemy.layer + 1
			end
		end
		for _,dmg in ipairs(Game.stage:getObjects(RecruitMessage)) do
			if dmg.parent == enemy.parent then
				dmg.layer = enemy.layer + 1
			end
		end
	end
	for _, enemy in ipairs(self.enemies) do
		enemy:setAnimation('sax_b')
		enemy.sprite:play(1/5)
	end	

	for sameattacker = 1, #self.enemies do
		local btimer = 40*self.ratio
		if self.sameattack > 1 then
			btimer = btimer - 25
		end
		self.timer:after(((sameattacker-1)*5)/30, function()
			self.timer:everyInstant(btimer/30, function()
				if self.enemies[sameattacker] then
					self:doSax(self.enemies[sameattacker])
				end
			end)
		end)
	end
end

function ShadowguySax:doSax(attacker)
	local attacker = attacker
	local warning = nil
	local warning2 = nil
	local xx, yy = attacker:getRelativePos(0, 0)
	warning = self:spawnObject(ShadowguySaxWarning(xx+22,yy+84), 0, 0)
	warning.attacker = attacker
	warning.layer = BATTLE_LAYERS["above_arena"]
	if self.sameattack > 1 then
		warning.shoot_speed = 1
		warning.timer2 = warning.shoot_speed
		warning.bullet_count = 5
		warning.attack_wait_time = 0.8
		warning.path_lifetime = 1.7
		warning.grow_speed = 0.05
		warning.fade_speed = 0.2
		
		warning2 = self:spawnObject(ShadowguySaxWarning(xx+22,yy+84), 0, 0)
		warning2.attacker = attacker
		warning2.layer = BATTLE_LAYERS["above_arena"]
		warning2.shoot_speed = 1
		warning2.timer2 = warning2.shoot_speed
		warning2.bullet_count = 5
		warning2.attack_wait_time = 0.8
		warning2.path_lifetime = 1.7
		warning2.grow_speed = 0.05
		warning2.fade_speed = 0.2
		warning2:startSax()
	end
	warning:startSax()
end

function ShadowguySax:onEnd()
	super.onEnd(self)
	for _, enemy in ipairs(self.enemies) do
		enemy:resetSprite()
		if enemy:canSpare() or enemy.temporary_mercy + enemy.mercy >= 100 then
			enemy:onSpareable()
		end
	end	
	for _, enemy in ipairs(Game.battle.enemies) do
		enemy.layer = BATTLE_LAYERS["battlers"]
		for _,dmg in ipairs(Game.stage:getObjects(DamageNumber)) do
			if dmg.parent == enemy.parent then
				dmg.layer = enemy.layer + 1
			end
		end
		for _,dmg in ipairs(Game.stage:getObjects(RecruitMessage)) do
			if dmg.parent == enemy.parent then
				dmg.layer = enemy.layer + 1
			end
		end
	end
end

return ShadowguySax
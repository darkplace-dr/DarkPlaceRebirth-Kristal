local ShadowguySax, super = Class(Wave)

function ShadowguySax:init()
    super.init(self)

	self.time = 200/30
    self.enemies = self:getAttackers()
	self.sameattack = 0
	self.sameattacker = 0
	if #self.enemies > 1 then
		self.sameattack = #self.enemies-1
	end
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
	
	self.notsameattacker = false
	Game:setFlag("shadowguySaxAmt", 0)
	for i = 1, #self.enemies do
		if self.sameattack >= 1 then
			if not self.notsameattacker then
				self.sameattacker = Game:getFlag("shadowguySaxAmt", 0)
				self.notsameattacker = true
			end
			Game:setFlag("shadowguySaxAmt", Game:getFlag("shadowguySaxAmt", 0)+1)
		end
	end
	for _, enemy in ipairs(self.enemies) do
		enemy:setAnimation('sax_b')
		enemy.layer = BATTLE_LAYERS["above_bullets"]
		for _,dmg in ipairs(Game.stage:getObjects(DamageNumber)) do
			if dmg.parent == enemy.parent then
				dmg.layer = enemy.layer
			end
		end
	end	

	local btimer = 40*self.ratio
	if self.sameattack > 1 then
		btimer = btimer - 25
	end
	for i = 1, #self.enemies do
		self.timer:after(((i-1)*5)/30, function()
			self.timer:everyInstant(btimer/30, function()
				if self.enemies[i] then
					self:doSax(self.enemies[i])
				end
			end)
		end)
	end
end

function ShadowguySax:doSax(attacker)
	local attacker = attacker
	local warning = nil
	local warning2 = nil
	warning = self:spawnObject(ShadowguySaxWarning(), (attacker.x/2)-17,(attacker.y/2)-11.5)	
	warning.layer = BATTLE_LAYERS["above_arena"]
	if self.sameattack >= 1 or #Game.battle.enemies == 1 then
		warning.shoot_speed = 1
		warning.timer2 = warning.shoot_speed
		warning.bullet_count = 5
		warning.attack_wait_time = 0.8
		warning.path_lifetime = 1.7
		warning.grow_speed = 0.05
		warning.fade_speed = 0.2
		warning:startSax()
		
		warning2 = self:spawnObject(ShadowguySaxWarning(), (attacker.x/2)-17,(attacker.y/2)-11.5)	
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
	end
	Game:setFlag("shadowguySaxAmt", 0)
end

return ShadowguySax
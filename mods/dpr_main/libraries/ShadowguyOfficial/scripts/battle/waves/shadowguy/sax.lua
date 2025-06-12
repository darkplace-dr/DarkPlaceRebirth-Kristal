local ShadowguySax, super = Class(Wave)

function ShadowguySax:init()
    super.init(self)

	self.time = 200/30
    self.enemies = self:getAttackers()
	self.sameattack = 0
	if #self.enemies > 1 then
		self.sameattack = #self.enemies-1
	end
	self.sameattacker = 0
	if Utils.containsValue(self.enemies, Game.battle.enemies[3]) then
		self.sameattacker = self.sameattack - 1
	elseif Utils.containsValue(self.enemies, Game.battle.enemies[2]) then
		for i,enemy in ipairs(Game.battle:getActiveEnemies()) do
			local wave = enemy.selected_wave
			if type(wave) == "table" and wave.id == self.id or wave == self.id then
				self.sameattacker = i
			end
		end
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
	
	for _, enemy in ipairs(self.enemies) do
		enemy:setAnimation('sax_b')
		enemy.layer = BATTLE_LAYERS["above_bullets"]
	end	

	local btimer = 40*self.ratio-(self.sameattacker*5)
	if self.sameattack > 1 then
		btimer = btimer - 25
	end
    self.timer:everyInstant(btimer/30, function()
        -- Get all enemies that selected this wave as their attack
        local attackers = self:getAttackers()

        -- Loop through all attackers
		local warning = nil
		local warning2 = nil
        for _, attacker in ipairs(attackers) do
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
	end)
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
	end
end

return ShadowguySax
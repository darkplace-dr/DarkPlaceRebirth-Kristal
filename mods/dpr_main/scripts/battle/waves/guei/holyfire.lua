local Basic, super = Class(Wave)

function Basic:init()
    super.init(self)

    self.time = 200/30
    self.enemies = self:getAttackers()
	self.sameattack = 0
	self.sameattacker = 0
	if #self.enemies > 1 then
		self.sameattack = #self.enemies-1
	end
	self.ratio = 1
	if #Game.battle.enemies == 2 then
		self.ratio = 1.6
	elseif #Game.battle.enemies == 3 then
		self.ratio = 2.3
	end
	self.flame_active = false
	self.btimer = 0
	self.made = false
	self.flames_made = 0
	self.spawn_flame = true
end

function Basic:onStart()
	self.notsameattacker = false
	Game:setFlag("gueiHolyFire", 0)
	for i = 1, #self.enemies do
		if self.sameattack >= 1 then
			if not self.notsameattacker then
				self.sameattacker = Game:getFlag("gueiHolyFire", 0)
				self.notsameattacker = true
			end
			Game:setFlag("gueiHolyFire", Game:getFlag("gueiHolyFire", 0)+1)
		end
	end
	self.flame_active = true
end

function Basic:onEnd()
	super.onEnd(self)
	self.flame_active = false
end

function Basic:update()
    -- Code here gets called every frame
    super.update(self)
	if not self.flame_active then return end
	if not self.made then
		self.made = true
		self.btimer = 40
	end
	if self.btimer - 40 >= math.ceil(24 * self.ratio) then
		self.btimer = self.btimer - math.ceil(24 * self.ratio)
		self.spawn_flame = true
	end
	if self.btimer - 40 >= 10 * self.sameattacker and self.spawn_flame then
		local dist = 135 + MathUtils.random(20)
		local dir
		if self.sameattack == 1 then
			dir = 15 + MathUtils.random(30) + (60 * love.math.random(2))
		elseif self.sameattack == 2 then
			dir = 15 + MathUtils.random(30) + (120 * self.sameattacker)
		else
			dir = 15 + MathUtils.random(20) + (65 * self.sameattacker)
		end
		self.flames_made = self.flames_made + 1
		local bullets = 2
		if self.ratio == 1 then
			bullets = 3
		end
        local a = self:spawnBullet("guei/holyfirespawner", Game.battle.arena.x + (dist * math.cos(-dir)), Game.battle.arena.y + ((dist * 0.75) * math.sin(-dir)), bullets, self.flames_made)
		a.speedtarg = 6
		a.widthmod = 1.25
		self.spawn_flame = false
	end
	self.btimer = self.btimer + DTMULT
end

return Basic
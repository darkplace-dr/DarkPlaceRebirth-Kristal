local SpotlightController, super = Class(Bullet)

function SpotlightController:init(x, y)
    super.init(self, x, y, "battle/bullets/smallbullet")
	self.can_graze = false
	self.collidable = false
    self:setHitbox(nil)
    self.sprite.visible = false
	self.remove_offscreen = false
	self.max_radius = 140
	self.spotlight_radius = 1.5707963267948966 -- WTF?
	self.counter = 0
	self.counter_speed = 1
	self.counter_speed_goal = TableUtils.pick({-2, 2})
	self.alert = false
	self.spot_rate = 0.1
	self.timer = 0
	self.attackers = 0
	self.enemies = 0
	self.eye_power = 0
end

function SpotlightController:onCollide()
	return
end

function SpotlightController:onRemove(parent)
	Game.battle.timer:cancel(self.spot_timer)
	super.onRemove(self, parent)
end

function SpotlightController:setInfo()
    Game.battle.timer:lerpVar(self, "counter_speed", self.counter_speed_goal * 0.5, self.counter_speed_goal, 24)
	local dir = 28
	local len = 150
	for aa = 0, 5 do
		self.wave:spawnBullet("mizzle/spotlight_eye", self.x + MathUtils.lengthDirX(len, math.rad(dir + (30 * aa))), self.y + MathUtils.lengthDirY(len, math.rad(dir + (30 * aa))))
	end
	self.spotlight = {}
	self.spotlight[1] = self.wave:spawnBullet("mizzle/spotlight", self.x, self.y)
	self.spotlight[2] = self.wave:spawnBullet("mizzle/spotlight", self.x, self.y)
	self.spotlight[3] = self.wave:spawnBullet("mizzle/spotlight", self.x, self.y)
	self.spot_timer = Game.battle.timer:script(function(wait)
		wait(32/30)
		local frames
		if self.eye_power == 0 then
			frames = 45 - ((3 - self.attackers) * 7)
		else
			frames = 30
		end
		while true do
			self:setSpotlightGoal(Game.battle.arena.x + MathUtils.randomInt(-40, 40), Game.battle.arena.y + MathUtils.randomInt(-40, 40), 1.5707963267948966, self.counter_speed_goal, frames)
			wait(frames/30)
			self:setSpotlightGoal(self.x, self.y, 1.5707963267948966, self.counter_speed_goal, frames)
			wait(frames/30)
		end
	end)
	if self.enemies == self.attackers then
		self.eye_power = 0
	else
		self.eye_power = self.enemies - self.attackers
	end
	for _, enemy in ipairs(Game.battle.enemies) do
		if enemy.id == "balthizard" then
			if self.enemies >= 2 then
				self.eye_power = 1
			end
		end
	end
	if self.enemies == self.attackers then
		for _, light in ipairs(self.spotlight) do
			light.scale_x = light.scale_x - ((3 - self.attackers) * 0.15)
			light.scale_y = light.scale_y - ((3 - self.attackers) * 0.15)
		end
	end
	
	self:updateSpotlights()
end

function SpotlightController:setSpotlightGoal(x, y, rad_goal, cnt_spd, speed)
    Game.battle.timer:lerpVar(self, "spotlight_radius", self.spotlight_radius, self.spotlight_radius + rad_goal, speed)
    Game.battle.timer:lerpVar(self, "counter_speed", self.counter_speed, cnt_spd, speed)
	if self.eye_power == 0 then
	    Game.battle.timer:lerpVar(self, "x", self.x, x, speed, 1, "out")
	    Game.battle.timer:lerpVar(self, "y", self.y, y, speed, 1, "out")
	end
end

function SpotlightController:update()
    super.update(self)
	self.timer = self.timer + DTMULT
	if self.eye_power == 0 then
		self.counter = self.counter + (self.counter_speed * math.sin(self.spotlight_radius)) * DTMULT
	else
		self.counter = self.counter + self.counter_speed * DTMULT
	end
	self:updateSpotlights()
	
	if not self.alert then
		Object.startCache()
		for _, light in ipairs(self.spotlight) do
			if light:collidesWith(Game.battle.soul) then
				Game.battle.wave_timer = 0
				Game.battle.wave_length = 180/30
				for _, enemy in ipairs(Game.battle.enemies) do
					if enemy.id == "mizzle" then
						enemy:setTired(false)
					end
				end
				for _, wave in ipairs(Game.battle.waves) do
					for _, bullet in ipairs(wave.bullets) do
						if bullet:isBullet("mizzle/spotlight_eye") then
							bullet.con = 1
						elseif not bullet:isBullet("mizzle/spotlight") and not bullet:isBullet("mizzle/spotlightcontroller") then
							bullet:remove()
						end
					end
				end
				Assets.playSound("rocket")
				self.alert = true
				Object.endCache()
				return
			end
		end
		Object.endCache()
	end
end

function SpotlightController:updateSpotlights()
	if not self.alert then
		if self.eye_power == 0 then
			for aa = 0, 2 do
				self.spotlight[aa+1].x = self.x + MathUtils.lengthDirX(math.sin(self.spotlight_radius) * self.max_radius, -math.rad(self.counter + (120 * aa)))
				self.spotlight[aa+1].y = self.y + MathUtils.lengthDirY(math.sin(self.spotlight_radius) * self.max_radius, -math.rad(self.counter + (120 * aa)))
			end
		elseif self.eye_power == 1 then
			for aa = 0, 2 do
				self.spotlight[aa+1].x = self.x + (math.sin(self.timer * 0.02) * 30) + MathUtils.lengthDirX(110, -math.rad(self.counter + (120 * aa)))
				self.spotlight[aa+1].y = self.y + (math.cos(self.timer * 0.02) * 30) + MathUtils.lengthDirY(110, -math.rad(self.counter + (120 * aa)))
			end
		else
			for aa = 0, 2 do
				self.spotlight[aa+1].x = self.x + MathUtils.lengthDirX(120, -math.rad(self.counter + (120 * aa)))
				self.spotlight[aa+1].y = self.y + MathUtils.lengthDirY(120, -math.rad(self.counter + (120 * aa)))
			end
		end
	else
		for _, light in ipairs(self.spotlight) do
			light.x = MathUtils.approach(light.x, Game.battle.soul.x, MathUtils.clamp(math.abs(light.x - Game.battle.soul.x) * self.spot_rate, 3, 10))
			light.y = MathUtils.approach(light.y, Game.battle.soul.y, MathUtils.clamp(math.abs(light.y - Game.battle.soul.y) * self.spot_rate, 3, 10))
		end
		
		self.spot_rate = MathUtils.approach(self.spot_rate, 1, 0.025 * DTMULT)
	end
end

return SpotlightController
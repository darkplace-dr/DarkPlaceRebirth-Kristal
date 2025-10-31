local Jackolantern, super = Class(Bullet)

function Jackolantern:init(x, y, ptype)
    -- Last argument = sprite path
    super.init(self, x, y)

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed

	self.tp = 0
	self.type = ptype or 0
	self:setOrigin(0.5,0.5)
	self:setScale(0,0)
	self.timer = -12
	self.text = nil
    self:setSprite("battle/bullets/jackenstein/jackolantern/guywhoappearswhenyouhavetakentoolonginaghosthouse", 0, false)
	self.path = {}
	self.fully_aggro = false
	self.speed_scale = false
	self.hits = 0
	self:setHitbox(7, 26, 94-7, 76-26)
	self.can_hit = false
	self.remove_offscreen = false
	self.destroy_on_hit = false
	self.path = nil
	self.path_options = {}
end

function Jackolantern:getDamage()
	local dmg = super.getDamage(self)
	if Game.battle.encounter.scaredy_cat then
		return MathUtils.round(dmg * 1.5)
	else
		return dmg
	end
end

function Jackolantern:setText(text, shake)
	if shake then
		self.text:setText("[spacing:-2][shake:"..math.max(0, (StringUtils.len(text) / 6)-1).."]"..text)
	else
		self.text:setText("[spacing:-2]"..text)
	end
end

function Jackolantern:onAdd(parent)
    super.onAdd(self, parent)

	Game.battle.timer:tween(19/30, self, {scale_x = 1, scale_y = 1}, "out-elastic")
	if Game.battle.encounter.scaredy_cat then
		Game.battle.timer:after(1/30, function()
			Assets.playSound("taking_too_long_fast", 0.8)
			self.text = Text("", SCREEN_WIDTH/2, 24, SCREEN_WIDTH, 16, {auto_size = true})
			self.text:setOrigin(0.5, 0)
			self.text:setLayer(self.layer + 1)
			self.text.font = "main_mono"
			Game.battle:addChild(self.text)
			local text = "YOUR"
			self:setText(text, true)
			Game.battle.timer:script(function(wait)
				wait((12/30)/2.5)
				text = text.." TAKING"
				self:setText(text, true)
				wait((14/30)/2.5)
				text = text.." TOO"
				self:setText(text, true)
				wait((10/30)/2.5)
				text = text.." LONG"
				self:setText(text, true)
			end)
		end)
		Game.battle.timer:after(15/30, function()
			Assets.playSound("jackolantern_laugh")
			self.text:remove()
			for _,arena in ipairs(Game.stage:getObjects(GhostHouseArena)) do
				arena:setColor(COLORS["red"])
			end
			for _,lock in ipairs(Game.stage:getObjects(GhostHouseLock)) do
				lock:setColor(COLORS["red"])
			end
			self.sprite:play(2/30, true)
			self.physics.speed_y = 0.5
			self.can_hit = true
		end)

	else
		Game.battle.soul.speed = 0
		Game.battle.timer:after(13/30, function()
			Assets.playSound("taking_too_long", 0.8)
			self.text = Text("", SCREEN_WIDTH/2, 24, SCREEN_WIDTH, 16, {auto_size = true})
			self.text:setOrigin(0.5, 0)
			self.text:setLayer(self.layer + 1)
			self.text.font = "main_mono"
			Game.battle:addChild(self.text)
			local text = "YOUR"
			self:setText(text, true)
			Game.battle.timer:script(function(wait)
				wait(12/30)
				text = text.." TAKING"
				self:setText(text, true)
				wait(14/30)
				text = text.." TOO"
				self:setText(text, true)
				wait(10/30)
				text = text.." LONG"
				self:setText(text, true)
			end)
		end)
		Game.battle.timer:after(87/30, function()
			Assets.playSound("jackolantern_laugh")
			self.text:remove()
			for _,arena in ipairs(Game.stage:getObjects(GhostHouseArena)) do
				arena:setColor(COLORS["red"])
			end
			for _,lock in ipairs(Game.stage:getObjects(GhostHouseLock)) do
				lock:setColor(COLORS["red"])
			end
			self.sprite:play(2/30, true)
			self.physics.speed_y = 0.5
			if self.path then
				self:slidePath(self.path, self.path_options or {})
			end
			Game.battle.soul.speed = 4
			self.can_hit = true
		end)
	end
end

function Jackolantern:update()
    super.update(self)
	
	if self.fully_aggro then
		self.physics.friction = 0.65 + (0.25 * self.hits)
		if MathUtils.dist(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y) > 30 or self.physics.speed < 5 then
			self.physics.direction = MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y) - math.rad(15 + MathUtils.random(30))
			self.physics.speed = 13 + (4 * self.hits)
			
			if self.speed_scale and self.hits == 0 and MathUtils.dist(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y) < 240 then
				self.physics.speed = math.log(240 - MathUtils.dist(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)) / math.log(3)
			end
		end
	end
end

function Jackolantern:onDamage(soul)
	self.damage = 20 - math.floor(self.hits / 2)
	super.onDamage(self, soul)
	self.hits = self.hits + 1
	if self.hits >= 12 then
		Game.battle.wave_timer = Game.battle.wave_length - 1/30
	end
	soul.inv_timer = math.min(soul.inv_timer, (10 - math.floor(self.hits / 2))/30)
	if not self.fully_aggro then
		self.fully_aggro = true
		self:resetPhysics()
		self.physics.direction = MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
		self.physics.friction = 0.1
		self.physics.speed = 6
	end
end
function Jackolantern:onCollide(soul)
	if not self.can_hit then
		return
	end
	super.onCollide(self, soul)
end

return Jackolantern
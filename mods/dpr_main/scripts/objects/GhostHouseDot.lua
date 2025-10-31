local GhostHouseDot, super = Class(Object)

function GhostHouseDot:init(x, y)
    super.init(self, x, y, 8, 8)
	self:setOrigin(0.5, 0.5)
	self:setLayer(BATTLE_LAYERS["bullets"])
    self.sprite = Sprite("battle/ghost_house/dot", 0, 0)
	self.sprite:setLayer(self.layer)
	self:addChild(self.sprite)
	self.float = 0
	self.suck = 0
	self.pitch = 1
	self.collider = Hitbox(self, 0, 0, 8, 8)
	self.x_start = self.x
	self.y_start = self.y
	self.damage = 0
end

function GhostHouseDot:getDamage()
	return 0
end

function GhostHouseDot:update()
    super.update(self)
	if self.float >= 0 then
		self.float = self.float + 0.23 * DTMULT
	end
	self.pitch = MathUtils.approach(self.pitch, 1, 0.003*DTMULT)
	self.sprite.y = 1.5 * math.sin(self.float + (self.x_start / 4) + (self.y_start / 80))
	if self.suck > 0 then
		local scaredy_cat = 0
		if Game.battle.encounter.scaredy_cat then
			scaredy_cat = 1
		end
		self.suck = self.suck * (1.15 + (0.05 * scaredy_cat))
		self.x = self.x + math.cos(MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)) * math.sqrt(self.suck) * DTMULT
		self.y = self.y + math.sin(MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)) * math.sqrt(self.suck) * DTMULT
	end
end

function GhostHouseDot:onCollide(soul)
	super.onCollide(soul)
	Game:giveTension(1)
	Assets.playSound("swallow", self.pitch)
	for _,dot in ipairs(Game.stage:getObjects(GhostHouseDot)) do
		dot.pitch = dot.pitch + 0.1
	end
	self:remove()
end

return GhostHouseDot
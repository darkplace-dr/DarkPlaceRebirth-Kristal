local RiverWave, super = Class(Event)

function RiverWave:init(data)
    super.init(self, data)

    local properties = data and data.properties or {}
	self.x = MathUtils.round(self.x / 2) * 2
	self.y = MathUtils.round(self.y / 2) * 2
    self:setSprite("world/events/riverwave/still")
	self:setOrigin(0.5, 1)
	self.sprite:setFrame(MathUtils.round((self.x + self.y) * 16))
	self.sprite:play(1/5, true)
	self.can_fly = properties["fly"] ~= false
	self.con = 0
end

function RiverWave:update()
	super.update(self)
	if self.con == 0 and self.can_fly then
		local dist = 999
		if Game.world.player then
			dist = MathUtils.dist(self.x, self.y, Game.world.player.x, Game.world.player.y)
		end
		if dist < 120 then
			self.con = 1
			Assets.stopAndPlaySound("wing", 0.7, MathUtils.random(0.7, 1.1))
			Assets.stopAndPlaySound("crow", 0.8, MathUtils.random(1, 1.2))
		end
	end
	if self.con == 1 then
		self.sprite:setFrame(1)
		self:setSprite("world/events/riverwave/fly")
		self.sprite:play(1/10)
		Game.world.timer:tween(15/30, self.sprite, {anim_speed = 1/3})
		self.physics.gravity_direction = -math.pi / 2
		self.physics.gravity = MathUtils.random(0.25, 1)
		self.physics.speed_x = MathUtils.random(1, 3) * TableUtils.pick({-1, 1})
		self.con = 2
		self:setLayer(WORLD_LAYERS["above_events"])
	end
	if self.con == 2 then
		if self.y < -40 then
			self:remove()
		end
	end
end

return RiverWave
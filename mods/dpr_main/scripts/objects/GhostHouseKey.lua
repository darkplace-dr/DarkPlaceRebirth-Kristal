local GhostHouseKey, super = Class(Object)

function GhostHouseKey:init(x, y)
    super.init(self, x, y, 16, 24)
    self:setOrigin(0.5, 0.5)
	self.light = LightJackenstein(self.x, self.y, 36, 18, {1,1,1})
    self.light.alpha = 1
    Game.battle:addChild(self.light)
    self.sprite = Sprite("battle/ghost_house/key", 0, 0)
	self.sprite:setLayer(self.layer)
	self:addChild(self.sprite)
	self.float = 0
	self.sway = 0
	self.tutu = 0
	self.collider = CircleCollider(self, 0, 4, 16)
	self.damage = 0
end

function GhostHouseKey:getDamage()
	return 0
end

function GhostHouseKey:update()
    super.update(self)
	self.float = self.float + 0.04 * DTMULT
	self.sway = self.sway + 0.063 * DTMULT
	self.sprite.y = 3 * math.sin(self.float)
	self.sprite.rotation = -math.rad((15 - (7 * self.tutu)) * math.sin(self.sway))
end

function GhostHouseKey:onCollide(soul)
	super.onCollide(soul)
	Game:giveTension(5)
	Assets.playSound("coin")
	for flip = 1, -1, -2 do
		for dir = 0, 360, 36 do
			local sparkle = Game.battle:addChild(Sprite("effects/incense_sparkle/sparkle", self.x, self.y))
			sparkle.layer = 999
			sparkle.alpha = 1
			sparkle:setScale(0.5, 0.5)
			sparkle:play(1/2, true)
			sparkle.physics.speed = 5 + (flip * 1.5)
			sparkle.physics.direction = -math.rad(dir)
			sparkle.physics.friction = sparkle.physics.speed / (24 + sparkle.physics.speed)
			Game.battle.timer:tween(18/30, sparkle.physics, {direction = sparkle.physics.direction + math.rad(120 * flip)}, "out-cubic")
			Game.battle.timer:tween((20+math.ceil(sparkle.physics.speed/3))/30, sparkle, {alpha = 0}, "in-linear")
			Game.battle.timer:after(25 / 30, function ()
				sparkle:remove()
			end)
		end
	end
	for _,lock in ipairs(Game.stage:getObjects(GhostHouseLock)) do
		lock.collider = nil
		local rot = lock.rotation
		Game.battle.timer:tween(72/30, lock, {rotation = rot - math.rad(135 * MathUtils.sign(lock.width))}, "in-out-elastic")
		Game.battle.timer:tween(24/30, self.light, {x = lock.x - (6 * lock.width)}, "out-back")
		Game.battle.timer:tween(24/30, self.light, {y = lock.y + (lock.height*lock.bar_sprite:getHeight()/2)}, "out-back")
		Game.battle.timer:tween(24/30, self.light, {radius = self.light.radius + 16}, "out-cubic")
		Game.battle.timer:tween(24/30, self.light, {radius_2 = self.light.radius_2 + 16}, "out-cubic")
	end
	for _,exit in ipairs(Game.stage:getObjects(GhostHouseExit)) do
		Game.battle.timer:after(2, function ()
			exit:createExitArrow()
		end)
	end
	for _,trigger in ipairs(Game.stage:getObjects(GhostHouseTrigger)) do
		trigger.active = true
	end
	self:remove()
end

return GhostHouseKey
local SmallBullet, super = Class(Bullet)

function SmallBullet:init(x, y, bullets, count)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/smallbullet")
	self.timer = 0
	self.bullets = bullets or 2
	self.speedtarg = 6
	self.widthmod = 1
	self.count = count or 1
	self.turn = 1.5 * Utils.sign((self.count % 2) - 0.5)
    self:setHitbox(nil)
    self.sprite.visible = false

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = 0
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = 0
    self.subs = {}
	self.con = 0
	self.remove_offscreen = false
end


function SmallBullet:onCollide()
	return
end

function SmallBullet:onAdd(parent)
    super.onAdd(self, parent)
	for i = 1, self.bullets do
		table.insert(self.subs, self.wave:spawnBullet("guei/holyfire", x, y, ((360 / self.bullets) * i-1), 0))
    end
end

function SmallBullet:onRemove(parent)
    super.onRemove(self, parent)
	for _, bul in ipairs(self.subs) do
		bul:remove()
        TableUtils.removeValue(self.subs, bul)
    end
end

function SmallBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update
    super.update(self)
	self.timer = self.timer + DTMULT
	for _, bul in ipairs(self.subs) do
		if self.timer > 10 then
			bul.visible = true
		elseif self.timer % 2 >= 1 then
			bul.visible = true
		else
			bul.visible = false
		end
		bul.angle = bul.angle + self.turn*DTMULT
		bul.dist = MathUtils.approach(bul.dist, (15 + (10 * self.bullets)) * self.widthmod, ((self.widthmod * 3) / math.sqrt(bul.dist + 1))*DTMULT)
		bul.x = self.x + bul.dist * math.cos(math.rad(-bul.angle))
		bul.y = self.y + (bul.dist * 0.66) * math.sin(math.rad(-bul.angle))
	end
	if self.timer >= 10 and self.con == 0 then
		self.physics.direction = Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
		self.con = 1
	elseif self.timer >= 10 and self.con == 1 then
		self.physics.speed = MathUtils.approach(self.physics.speed, self.speedtarg, (self.speedtarg/60)*DTMULT)
		self.turn = MathUtils.approach(self.turn, 7 * MathUtils.sign(self.turn), 0.1*DTMULT)
	end
end

return SmallBullet
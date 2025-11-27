local HolyFireSpawner, super = Class(Bullet)

function HolyFireSpawner:init(x, y, bullets, count)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/smallbullet")
	self.timer = 0
	self.bullets = bullets or 2
	self.speedtarg = 6
	self.widthmod = 1
	self.count = count or 1
	self.turn = 1.5 * MathUtils.sign((self.count % 2) - 0.5)
    self:setHitbox(nil)
    self.sprite.visible = false

    self.physics.direction = 0
    self.physics.speed = 0
    self.subs = {}
	self.con = 0
	self.remove_offscreen = false
end

function HolyFireSpawner:onCollide()
	return
end

function HolyFireSpawner:onAdd(parent)
    super.onAdd(self, parent)
    for i = 1, self.bullets do
        table.insert(self.subs, self.wave:spawnBullet("guei/holyfire", 0, 0, math.rad((360 / self.bullets) * i-1), 0))
    end
end

function HolyFireSpawner:onRemove(parent)
    super.onRemove(self, parent)
	for _, bul in ipairs(self.subs) do
		bul:remove()
        TableUtils.removeValue(self.subs, bul)
    end
end

function HolyFireSpawner:update()
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
		bul.angle = bul.angle + math.rad(self.turn) * DTMULT
		bul.dist = MathUtils.approach(bul.dist, (15 + (10 * self.bullets)) * self.widthmod, ((self.widthmod * 3) / math.sqrt(bul.dist + 1))*DTMULT)
		bul.x = self.x + MathUtils.lengthDirX(bul.dist, bul.angle)
		bul.y = self.y + MathUtils.lengthDirY((bul.dist * 0.66), bul.angle)
	end

	if self.timer >= 10 and self.con == 0 then
		self.physics.direction = Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
		self.con = 1
	elseif self.timer >= 10 and self.con == 1 then
		self.physics.speed = MathUtils.approach(self.physics.speed, self.speedtarg, (self.speedtarg/45)*DTMULT)
		self.turn = MathUtils.approach(self.turn, 7 * MathUtils.sign(self.turn), 0.1*DTMULT)
	end
end

return HolyFireSpawner
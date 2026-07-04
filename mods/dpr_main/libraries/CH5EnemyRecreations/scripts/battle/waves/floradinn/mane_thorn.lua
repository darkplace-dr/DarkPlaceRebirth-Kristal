local ManeThorn, super = Class(Wave)

function ManeThorn:init()
	super.init(self)

    self.time = 200/30
	self.btimer = {0, 0, 0}
	self.special = {0, 0, 0}
	self.did_special = {true, true, true}
	self.last_anim = {nil, nil, nil}
end

function ManeThorn:onStart()
	super.onStart(self)
	for i, attacker in ipairs(self:getAttackers()) do
		self.last_anim[i] = attacker.sprite.anim
		attacker:setAnimation("mane")
	end
end

function ManeThorn:onEnd()
	super.onEnd(self)
	for i, attacker in ipairs(self:getAttackers()) do
		attacker.sprite.last_anim = self.last_anim[i]
		attacker:setAnimation(self.last_anim[i])
	end
end

function ManeThorn:update()
    local ratio = self:getEnemyRatio()
	for i, attacker in ipairs(self:getAttackers()) do
		self.btimer[i] = self.btimer[i] + DTMULT
        local target_fps = 1 / 30
        local target_btimer = math.floor(self.btimer[i] / target_fps) * target_fps
		if target_btimer % math.ceil(31 * math.pow(ratio, 1.28)) == (25 * i) and Game.battle.wave_timer <= (Game.battle.wave_length - 60/30) then
			attacker.sprite.maneanimcon = 1
			self.did_special[i] = false
			self.special[i] = 10
		end
		self.special[i] = self.special[i] - DTMULT
		if self.special[i] <= 1 and not self.did_special[i] then
			Assets.playSound("board_throw", 0.7)
			attacker.sprite.maneanimcon = 1
			local triangle_count = 12
			local xx, yy = attacker:getRelativePos(0, 0)
			local mane = self:spawnBullet("floradinn/mane", xx + 32, yy + 32)
			mane.alarm_timer = 45
			mane.targx = Game.battle.arena.x + ((45 + MathUtils.random(40)) * TableUtils.pick({1, -1}))
			mane.targx = Game.battle.arena.y + ((45 + MathUtils.random(40)) * TableUtils.pick({1, -1}))
			mane.physics.speed_x = (mane.targx - mane.x) / mane.alarm_timer
			mane.physics.speed_y = (mane.targy - mane.y) / mane.alarm_timer
			mane.physics.gravity = 0.35
			mane.physics.speed_y = mane.physics.speed_y - ((mane.physics.gravity * mane.alarm_timer) / 2)
			for tempnum = 0, triangle_count / 2 do
				local flip = -1 + ((triangle_count % 2 and tempnum == 0) and 1 or 0)
				while flip <= 1 do
					local bullet = self:spawnBullet("floradinn/mane_bullet", mane.x, mane.y)
					bullet.damage = 92
					bullet.attacker = nil
					bullet.offset = 24 - (6 * (tempnum % 2))
					local rot = 90 + (flip * 360 * ((tempnum + 0.5) / triangle_count))
					bullet.rotation = -math.rad(rot)
					bullet.x = mane.x + MathUtils.lengthDirX(bullet.offset, -math.rad(rot))
					bullet.y = mane.y + MathUtils.lengthDirY(bullet.offset, -math.rad(rot))
					bullet.collidable = false
					bullet.destroy_on_hit = false
					bullet:setColor(ColorUtils.mergeColor(COLORS.black, COLORS.yellow, 0.3))
					bullet.layer = mane.layer + 0.02 - (bullet.offset / 24) * 0.02
					table.insert(mane.triangles, bullet)
					flip = flip + 2
				end
			end
			self.did_special[i] = true
		end
    end
end

function ManeThorn:getEnemyRatio()
    local enemies = #Game.battle:getActiveEnemies()
    if enemies <= 1 then
        return 1
    elseif enemies == 2 then
        return 1.6
    elseif enemies >= 3 then
        return 2.3
    end
end

return ManeThorn
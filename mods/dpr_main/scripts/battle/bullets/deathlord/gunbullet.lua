local DeathLordGunBullet, super = Class(Bullet)

function DeathLordGunBullet:init(x, y, dir, speed)
    super.init(self, x, y, "battle/bullets/deathlord/gunbullet")
	self.rotation = dir
	self.physics.match_rotation = true
	self.physics.speed = speed
	self.trail_count = 0
end

function DeathLordGunBullet:update()
	super.update(self)
	if self.physics.speed ~= 0 then
		self.trail_count = math.min(self.trail_count + math.floor(MathUtils.dist(self.x, self.y, self.last_x, self.last_y)/4), math.floor(self.physics.speed/2))
	end
	if self.x <= Game.battle.arena.left - 10 and self.collidable then
		self.collidable = false
		self:fadeOutSpeedAndRemove(0.2)
	end
end

function DeathLordGunBullet:onGraze(first)
	super.onGraze(self, first)
	if Game.battle.enemies[1].graze_challenge then
		local amt = first and 3 or 1
		Game.battle.enemies[1]:addTemporaryMercy(amt, true, {0, 100}, (function() return Game.battle.enemies[1].showtempmercy == false end))
	end
end

function DeathLordGunBullet:draw()
    if self.sprite.texture and self.trail_count > 0 then
        local r, g, b, a = self:getDrawColor()
        for i = 0, self.trail_count do
            Draw.setColor(r, g, b, (a - (i / self.trail_count)) * 0.4)
            Draw.draw(self.sprite.texture, -i * 2, 0)
        end
    end
	super.draw(self)
end

return DeathLordGunBullet
local SaxNoteBullet, super = Class(Bullet, "shadowguy/saxnote")

function SaxNoteBullet:init(x, y)
    super.init(self, x, y)

    self:setSprite("bullets/shadowguy/note")
	self:setScale(1)
	self:setOrigin(0.5, 0.5)
	
    self:setHitbox(6, 6, 12, 12)
	self.path_prog = 0
	self.removing = false
	self.remove_offscreen = true
	self.x_start = self.x
	self.y_start = self.y
	self.timer = 0
end

function SaxNoteBullet:update()
	super.update(self)

	if self.timer >= 1 then
		local orient = math.rad(0)
		local x0, y0 = self.path:getPosition(0).x, self.path:getPosition(0).y
		local spd = self.path:getPosition(self.path_prog).speed/100
		self.path_prog = self.path_prog + (21 * (spd/self.path.length))*DTMULT
		local xn, yn = self.path:getPosition(self.path_prog).x, self.path:getPosition(self.path_prog).y
		local xx, yy = xn - x0, yn - y0
		local newx = self.x_start + ((xx * math.cos(orient)) + (yy * math.sin(orient)))
		local newy = self.y_start + ((yy * math.cos(orient)) - (xx * math.sin(orient)))
		local xsp, ysp = newx - self.x, newy - self.y
		self.x = newx
		self.y = newy
		self.physics.direction = Utils.angle(0, 0, xsp, ysp)
		self.rotation = self.physics.direction - math.rad(180)
		if self.x < Game.battle.arena.x - 140 and not self.removing then
			self:fadeOutAndRemove(10/30)
			self.removing = true
		end
	else
		self.timer = 1
	end
end

return SaxNoteBullet
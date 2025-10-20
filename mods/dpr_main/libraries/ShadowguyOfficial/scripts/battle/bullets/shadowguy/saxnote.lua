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
end

function SaxNoteBullet:update()
	super.update(self)

	local x1, y1 = self.path:getPosition(self.path_prog).x, self.path:getPosition(self.path_prog).y
	self.path_prog = self.path_prog + 0.03*DTMULT
	local x2, y2 = self.path:getPosition(self.path_prog).x, self.path:getPosition(self.path_prog).y
	
	self.x = self.xx+x1
	self.y = self.yy+y1
	self.rotation = Utils.angle(x1, y1, x2, y2) - math.rad(180)
	if self.x < Game.battle.arena.x - 140 and not self.removing then
		self:fadeOutAndRemove(10/30)
		self.removing = true
	end
end

return SaxNoteBullet
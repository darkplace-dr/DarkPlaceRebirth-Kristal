local ProphecyGroundShard, super = Class(Sprite)

function ProphecyGroundShard:init(x, y)
    super.init(self, "world/firework/shine", x, y)
	self:setScale(2)
	self.physics.speed_y = 4
	self:play(1/6)
	self:setFrame(MathUtils.randomInt(1, 4))
	self.ytarg = Game.world.camera.y
	self.fadeoutmode = false
	self.siner = 8
end

function ProphecyGroundShard:update()
    super.update(self)
	if self.siner >= 8 then
		local afterimage = AfterImage(self, 0.5)
		afterimage.layer = self.layer + 1
		afterimage:setScale(0.5)
		self:addChild(afterimage)
		self.siner = 0
	end
	self.siner = self.siner + DTMULT
	if self.fadeoutmode then
		self.alpha = self.alpha - 0.05 * DTMULT
		if self.alpha <= 0 then
			self.remove()
		end
	else
		if self.y >= self.ytarg and TableUtils.pick({0, 1}) == 0 then
			self:remove()
		end
	end
end

return ProphecyGroundShard
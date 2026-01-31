local TutorialBullet, super = Class(Sprite)

function TutorialBullet:init(x, y, puzboy)
    super.init(self, "battle/bullets/guei/diamond", x, y)

    self:setOrigin(0.5, 0.5)
    self:setParallax(0,0)
	self.fade = false
	self.puzboy = puzboy or nil
	self.ticked = false
end

function TutorialBullet:update()
	self.rotation = self.physics.direction
	if self.y > SCREEN_HEIGHT/2 - 20 or self.x < SCREEN_WIDTH / 2 - 120 or self.x > SCREEN_WIDTH /2 + 120 then
		self.fade = true
	end
	if self.fade then
		self.alpha = self.alpha * (0.6 * DTMULT)
		if self.alpha < 0.01 then
			self:remove()
		end
	end
	if not self.ticked and self.puzboy then
		if MathUtils.dist(self.x, self.y, self.puzboy.x, self.puzboy.y) < 40 and self.y > 205 then
			self.ticked = true
			self.puzboy.graze_sprite.alpha = 1
			Assets.playSound("graze")
		end
	end
    super.update(self)
end

return TutorialBullet
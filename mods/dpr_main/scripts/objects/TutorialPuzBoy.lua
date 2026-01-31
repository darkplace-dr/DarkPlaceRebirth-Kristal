local TutorialPuzBoy, super = Class(Sprite)

function TutorialPuzBoy:init(x, y)
    super.init(self, "player/puzboy", x, y)

    self:setOrigin(0.5, 0.5)
    self:setParallax(0,0)
	self.con = 0
	self.alpha = 0
	self.fade = false
    self.graze_sprite = Sprite("player/puzboy_outline", self.x, self.y)
    self.graze_sprite:setParallax(0,0)
    self.graze_sprite:setOrigin(0.5, 0.5)
	self.graze_sprite.alpha = 0
    Game.world:addChild(self.graze_sprite)
end

function TutorialPuzBoy:onRemove(parent)
	super.onRemove(self, parent)
	if self.graze_sprite then
		self.graze_sprite:remove()
	end
end

function TutorialPuzBoy:update()
	if self.fade then
		self.alpha = self.alpha * (0.9 * DTMULT)
		self.scale_x = self.scale_x * (0.8 * DTMULT)
		self.scale_y = self.scale_y * (0.8 * DTMULT)
		if self.alpha < 0.01 then
			self:remove()
		end
	end
	if self.con == 0 then
		self.graze_sprite.layer = self.layer - 0.1
		self.alpha = self.alpha + 0.1 * DTMULT
		if self.alpha >= 1 then
			self.alpha = 1
			self.con = 1
		end
	end
	if self.con == 1 then
		if self.x < 380 then
			self.x = self.x + DTMULT
		else
			self.con = 2
		end
	end
	if self.con == 2 then
		if self.x > 260 then
			self.x = self.x - DTMULT
		else
			self.con = 1
		end
	end
	self.graze_sprite.x = self.x
	self.graze_sprite.y = self.y
	self.graze_sprite.alpha = self.graze_sprite.alpha - 0.1 * DTMULT
    super.update(self)
end

return TutorialPuzBoy
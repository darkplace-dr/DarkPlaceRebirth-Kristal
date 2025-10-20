local PopupAd, super = Class(Object)

function PopupAd:init(x, y)
    super.init(self, x, y)
	self.tex = Assets.getTexture("battle/bullets/omegaspamton/ad_spamton")
	self:setHitbox(0,0,self.tex:getWidth(), self.tex:getHeight())
	self.width = self.tex:getWidth()
	self.height = self.tex:getWidth()
	self.layer = BATTLE_LAYERS["above_bullets"]
	self:setScale(1,1)
	self:setOrigin(0.5,0.5)
	self.timer = 0
	self.scale = 0
	self.scalespeed = 1
	self.state = -1
end

function PopupAd:update()
    super.update(self)
	if self.state == -1 then
		self.scale = self.scale + (0.25 * self.scalespeed) * DTMULT
		if self.scale > 1 then
			self.scale = 1.2
			self.state = 0
		end
		self:setScale(self.scale, self.scale)
	elseif self.state == 0 then
		self.scale = 1
		self.state = 1
		self:setScale(self.scale, self.scale)
	elseif self.state == 2 then
		self.scale = self.scale - (0.25 * self.scalespeed) * DTMULT
		self:setScale(self.scale, self.scale)
		if self.scale <= 0 then
			self:remove()
		end
	end
	if self:clicked(1) and self.state == 1 then
		self.state = 2
	end
end

function PopupAd:draw()
    super.draw(self)
	Draw.setColor(0,0,0,0.5)
	Draw.rectangle("fill", 2, 2, ((self.tex:getWidth() * self.scale) / 2) + 2, ((self.tex:getHeight() * self.scale) / 2) + 2)
	Draw.setColor(1,1,1,1)
	Draw.draw(self.tex,0,0,0,1,1,0.5,0.5)
    if DEBUG_RENDER then
        self.collider:draw(0, 0, 1, 1)
    end
end

return PopupAd
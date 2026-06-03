local ShadowguyHat, super = Class(Sprite)

function ShadowguyHat:init(enemy, callback_func)
    super.init(self, "npcs/shadowguy/idle_hat_black", 0, 0)

	self:stop()
	self:setFrame(1)
	self:setScale(2,2)
	self:setOrigin(0,0)
	self.con = 0
	self.timer = 0
	self.enemy = enemy or nil
	self.callback_function = callback_func or nil
end

function ShadowguyHat:update()
	super.update(self)
	local xx, yy = self.enemy:getRelativePos(0, 0)
	if self.con == 0 then
		self.x = xx
		
		for i = 1, 4 do
			if self.y - 4 < yy then
				self.y = self.y + DTMULT
			elseif self.con == 0 then
				self.con = 1
				self:shake()
				Assets.playSound("equip")
				self:setFrame(2)
				self.enemy:setAnimation("idle_nothat")
			end
		end
	end
	if self.con == 1 then
		if self.y - 4 < yy then
			self.y = self.y + DTMULT
		end
		self.timer = self.timer + DTMULT
		if self.timer >= 11 then
			if self.callback_function then
				self.callback_function()
			end
			self.enemy:resetSprite()
			if self.enemy:canSpare() or self.enemy.temporary_mercy + self.enemy.mercy >= 100 then
				self.enemy:onSpareable()
			end
			self:remove()
		end
	end
end

return ShadowguyHat
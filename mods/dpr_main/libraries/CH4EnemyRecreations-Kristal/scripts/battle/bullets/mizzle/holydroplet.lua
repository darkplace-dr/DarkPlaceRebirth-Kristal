local HolyDroplet, super = Class(Bullet, "mizzle/holydroplet")

function HolyDroplet:init(x, y)
    super.init(self, x, y, "battle/bullets/mizzle/holydroplet")

    self:setScale(1)
    self:setOriginExact(16, 18)

    self.tp = (1/3) / 2.5
	self.sprite.visible = false
	
	self.outline_tex = Assets.getTexture("battle/bullets/mizzle/holydroplet_outline")
end

function HolyDroplet:update()
    super.update(self)
end

function HolyDroplet:onGraze(success)
	if success then
		Assets.stopAndPlaySound("graze") -- Stop graze sound spam
	end
end

return HolyDroplet 
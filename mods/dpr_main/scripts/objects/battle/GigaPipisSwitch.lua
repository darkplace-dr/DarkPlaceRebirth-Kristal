local GigaPipisSwitch, super = Class(Object)

function GigaPipisSwitch:init(x, y, active, type, id)
    super.init(self, x, y)
	
    self.sprite = Sprite("battle/bullets/omegaspamton/pipis/glowtile")
	self.sprite:setScale(2)
	self.sprite:play(1/8)
	self:addChild(self.sprite)
	self:setHitbox(0,0,16,16)
	self.switch_id = id or 1
	self.switch_type = type or "once"
	self.switch_active = active or true
	if not self.switch_active then
		self.sprite:setSprite("battle/bullets/omegaspamton/pipis/glowtile_off")
	end
	self.switch_pressed = false
end

function GigaPipisSwitch:update()
    super.update(self)
	if self.switch_active then
		Object.startCache()
		if not self.switch_pressed then
			if Game.battle.soul and self:collidesWith(Game.battle.soul) then
				Assets.playSound("instanoise")
				self.switch_pressed = true
				self.sprite:setSprite("battle/bullets/omegaspamton/pipis/glowtile_on")
			end
		else
			if Game.battle.soul and self:collidesWith(Game.battle.soul) and self.switch_type == "hold" then
				self.switch_pressed = false
				self.sprite:setSprite("battle/bullets/omegaspamton/pipis/glowtile")
				self.sprite:play(1/8)
			end
		end
		Object.endCache()
	end
end

function GigaPipisSwitch:setSwitchActive(active)
    self.switch_active = active
	if not self.switch_active then
		self.sprite:setSprite("battle/bullets/omegaspamton/pipis/glowtile_off")
	else
		self.sprite:setSprite("battle/bullets/omegaspamton/pipis/glowtile")
		self.sprite:play(1/8)
	end
end

function GigaPipisSwitch:draw()
    super.draw(self)
	
	if DEBUG_RENDER then
	    self.collider:draw(1, 0, 1)
	end
end

return GigaPipisSwitch
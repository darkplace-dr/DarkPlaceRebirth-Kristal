local ShadowguyGunBullet, super = Class(Bullet, "shadowguy/tommygun_bullet")

function ShadowguyGunBullet:init(x, y)
    super.init(self, x, y)
	
	self:setHitbox(8, 16, 14, 1)
    self:setSprite("bullets/shadowguy/tommygun_bullet")
	self:setScale(1)
	self:setOriginExact(16, 14)
	self.physics.match_rotation = true
	
	self._destroy = false
end

function ShadowguyGunBullet:update()
	super.update(self)
	
	if self._destroy then return end
	
	local arena = Game.battle.arena
	
	if self.x < arena:getLeft() then
		local timer = Timer()
		timer:tween(10/30, self, {alpha = 0}, nil, function()
			self:remove()
		end)
		
		self:addChild(timer)
		self._destroy = true
	end
end

return ShadowguyGunBullet
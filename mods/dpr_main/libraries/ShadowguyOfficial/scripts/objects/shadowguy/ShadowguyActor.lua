local ShadowguyActor, super = Class(ActorSprite)

function ShadowguyActor:init(actor)
    super.init(self, actor)
	
	local gun = Sprite("npcs/shadowguy/gun", 6, 63)
	gun:setOriginExact(34, 33)
	gun:setFrame(1)
	gun.visible = false
	gun.layer = self.layer - 4
	self.draw_children_below = self.layer
	
	self.gun = gun
	self.gunshake = 0
	self.gun_rot = math.rad(180)
	self:addChild(gun)
end

function ShadowguyActor:update()
	super.update(self)
	
	local x = self.texture:getWidth()/2-6
	local y = 63/2

	self.gun.rotation = self.gun_rot + math.rad(180)
	self.gun.x = x + (math.cos(self.gun_rot) * self.gunshake)
	self.gun.y = y + (math.sin(self.gun_rot) * self.gunshake)
end

return ShadowguyActor
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
	
	local socks = SharpshootTarget("npcs/shadowguy/idle_socks", 0, 0)
	socks:setScale(2)
	socks:setHitbox(7, 49, 32, 9)
	socks.visible = false
	socks.rotation_origin_x = 0.5
	socks.rotation_origin_y = 0.5
	
	Utils.hook(socks, "update", function(orig, obj)
		orig(obj)
		
		local main = obj.copyMov
		
		if main and not obj.spare then
			local x, y = main:getRelativePos(0, 0, Game.battle)
			obj.x = x
			obj.y = y
			obj.sprite:setFrame(self.frame)
		end
	end)
	
	self.socks = socks
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
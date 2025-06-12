local ShadowguyActor, super = Class(ActorSprite)

function ShadowguyActor:init(actor)
    super.init(self, actor)
	
	local gun = Sprite("npcs/shadowguy/gun", -12, -2)
	gun:setFrame(1)
	gun.visible = false
	gun.layer = self.layer - 4
	gun.rotation_origin_x = 0.5
	gun.rotation_origin_y = 0.5
	self.draw_children_below = self.layer
	
	self.gun = gun
	self.gunshake = 0
	self.gun_rot = math.rad(180)
	self:addChild(gun)
	
	local socks = SharpshootTarget("npcs/shadowguy/idle_socks", 0, 0)
	socks:setScale(2)
	socks:setHitbox(7, 49, 32, 9)
	socks.visible = false
	-- socks.layer = self.layer + 4
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
	
	-- socks:play(1, true)
	-- Utils.hook(socks, "draw", function(orig, obj)
	
		-- orig(obj)
	-- end)
	
	self.socks = socks
	
	-- self:addChild(socks)
end

function ShadowguyActor:update()
	super.update(self)
	
	self.gun.x = self.x + -12 + (math.cos(self.gun_rot - math.rad(180)) * self.gunshake)
	self.gun.y = self.y + -2 + (math.sin(self.gun_rot - math.rad(180)) * self.gunshake)
	self.gun.rotation = self.gun_rot - math.rad(180)
	if self.gunshake > 0 then
		self.gunshake = 0
	end
	-- self.socks.anim_routine = self.anim_routine
end

return ShadowguyActor
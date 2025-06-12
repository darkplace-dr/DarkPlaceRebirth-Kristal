---@class GreenRoomWall : Object
---@GreenRoomWall fun(...) : Object
local GreenRoomPlatter, super = Class(Event)

function GreenRoomPlatter:init(data)
    super.init(self, data)

	local properties = data.properties or {}
	self:setSprite("world/events/greenroom_platter/platter_1")
	if Game:getFlag("tvfloor_greenroom_platterinteracts", 0) == 9 then
		self:setSprite("world/events/greenroom_platter/platter_2")
	end
	self.solid = false
	self.jumping = false
	self.siner = 0
	self.interactable = properties["interactable"] or false
end
 
function GreenRoomPlatter:interact()
	super.interact(self)
	if self.interactable then
		self:doJump()
		return true
	end
	return false
end

function GreenRoomPlatter:doJump()
	Assets.playSound("wing")
	self.lid = Sprite("world/events/greenroom_platter/platter_3")
	self.lid:setScale(2,2)
	self.lid.layer = self.layer + 1
	self:addChild(self.lid)
	self:setSprite("world/events/greenroom_platter/platter_2")
	self.ystart = self.lid.y
	self.jumping = true
end

function GreenRoomPlatter:update()
	if self.jumping then
		self.siner = self.siner + DTMULT
		local height = math.sin(self.siner / 7.5) * 80
		self.lid.y = self.ystart - height
		if self.siner >= 10 and height <= 0 then
			height = 0
			self.siner = 0
			self.jumping = false
			Assets.playSound("metalhit")
			self.lid.y = self.ystart
			self.lid:remove()
			self:setSprite("world/events/greenroom_platter/platter_1")
		end
	end
end

function GreenRoomPlatter:doBananaJump()
	Assets.playSound("wing")
	self.lid = Sprite("world/events/greenroom_platter/platter_3", self.x, self.y)
	self.lid:setScale(2,2)
	self.lid.layer = self.layer + 2
	self.lid.physics.speed_y = -8
	self.lid.physics.friction = -0.4
	Game.world:addChild(self.lid)
	self:setSprite("world/events/greenroom_platter/platter_2")
end

return GreenRoomPlatter
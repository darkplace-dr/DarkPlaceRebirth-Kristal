local SteelCage, super = Class(Interactable)

function SteelCage:init(data)
    super.init(self, data.x, data.y, data.shape, data.properties)

    self.solid = true
    local properties = data and data.properties or {}

	self.flag = properties["flag"] or nil
    self.text = properties["text"] and TiledUtils.parsePropertyMultiList("text", properties) or {"* (Perhaps if you play part of a bar,[wait:5] the bars will part.)"}
	self.flyaway = properties["flyaway"] or true
	
    self:setSprite("world/events/steelcage/steelstaff")
	self.flip_x = properties["flipx"] or false
end

function SteelCage:onRemove(parent)
	if self.flyaway then
		local afterimage = Sprite("world/events/steelcage/steelstaff", self.x, self.y)
		afterimage:setScale(2)	
		if self.flip_x then
			afterimage:setOrigin(1, 0)
			afterimage.scale_x = -2
		end
		afterimage.layer = self.layer
		afterimage.physics.gravity = -0.5
		afterimage:fadeOutSpeedAndRemove(0.04)
		Game.world:addChild(afterimage)
	end
    super.onRemove(self, parent)
end

return SteelCage
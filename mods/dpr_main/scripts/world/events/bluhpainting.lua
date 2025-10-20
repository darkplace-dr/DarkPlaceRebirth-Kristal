local BluhPainting, super = Class(Event)

function BluhPainting:init(data)
    super.init(self, data.x, data.y, {data.width, data.height})

    self:setOrigin(0, 0)
    self:setSprite("world/events/floor2/spr_cc_lancerpainting_1")
    self.bluh = false
end

function BluhPainting:onInteract()
	if self.bluh == true then
		return
	end
    Assets.playSound("bluh")
    self:setSprite("world/events/floor2/spr_cc_lancerpainting_2")
	self.bluh = true
end

return BluhPainting
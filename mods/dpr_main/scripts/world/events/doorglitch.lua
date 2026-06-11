local DoorGlitch, super = Class(Event)

function DoorGlitch:init(data)
    super.init(self, data)

    self.sprite = Sprite("world/events/floor2/door/glitch")
    self.sprite:setScale(2)
    self:addChild(self.sprite)

    self.solid = false
end

return DoorGlitch
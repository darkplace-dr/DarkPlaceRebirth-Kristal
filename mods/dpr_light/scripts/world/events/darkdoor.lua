local DarkDoor, super = Class(Event)

function DarkDoor:init(data)
    super.init(self, data.x, data.y, {data.width, data.height})
    self:setSprite("world/events/darkdoor")
    self.sprite:stop()
end

return DarkDoor
local ManDoor, super = Class(Event)

function ManDoor:canOpen()
    local ev = Game.world.map:getEvent("doorglitch")
    if ev then
        return false
    else
        return true
    end
end

function ManDoor:init(data)
    super.init(self, data)

    self.sprite = Sprite("world/events/floor2/door/empty")
    self.sprite:setScale(2)
    self:addChild(self.sprite)

    self.solid = true
end

function ManDoor:onInteract(player, dir)
    Game.world:startCutscene("floor2.mandoor", self, dir)
    return true
end

return ManDoor
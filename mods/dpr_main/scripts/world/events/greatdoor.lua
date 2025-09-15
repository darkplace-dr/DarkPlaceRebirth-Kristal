local GreatDoor, super = Class(Event)

function GreatDoor:init(data)
    super.init(self, data)

    self:setSprite("world/events/greatdoor/closed")
    self.solid = true
end

function GreatDoor:onInteract(player, dir)
    Game.world:startCutscene("greatdoor")
end

function GreatDoor:open()
    Assets.playSound("impact")
    Game.world.camera:shake(6, 0)
    self:setSprite("world/events/greatdoor/white")
end

function GreatDoor:close()
    Assets.playSound("impact")
    Game.world.camera:shake(6, 0)
    self:setSprite("world/events/greatdoor/closed")
end

return GreatDoor
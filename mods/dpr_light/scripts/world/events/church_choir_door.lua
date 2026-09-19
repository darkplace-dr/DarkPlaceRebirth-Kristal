local ChurchChoirDoor, super = Class(Event)

function ChurchChoirDoor:init(data)
    super.init(self, data)

    self:setOrigin(0, 0)
    self:setSprite("world/events/church_choir_door_1")

    --[[Game.world.timer:after(1/30, function()
        self.layer = 0.4
    end)]]
end

function ChurchChoirDoor:onInteract(player, dir)
    Game.world:startCutscene(function(cutscene)
        cutscene:text("* (It's a door. A large person could fit inside.)")
    end)
    return true
end

return ChurchChoirDoor
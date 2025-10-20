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
        Assets.playSound("dooropen")
        self:setSprite("world/events/church_choir_door_2")
        cutscene:wait(1)
        cutscene:text("* (It appears to be some kind of Halloween decoration.)")
        Assets.playSound("doorclose")
        self:setSprite("world/events/church_choir_door_1")
        cutscene:wait(0.5)
    end)
    return true
end

return ChurchChoirDoor
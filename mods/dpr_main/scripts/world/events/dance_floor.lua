local DanceFloor, super = Class(Event)

function DanceFloor:init(data)
    super.init(self, data)

    self.spr = Sprite("world/events/dance_floor")
    self.spr:setScale(2)
    self.spr:setOrigin(0.5)
    self:addChild(self.spr)
    self.solid = false
    
    Game.world.timer:every(1, function()
        self.spr.rotation = self.spr.rotation + math.rad(180)
    end)
end

return DanceFloor

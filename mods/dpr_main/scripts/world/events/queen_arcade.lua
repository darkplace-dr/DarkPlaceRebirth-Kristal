local QueenArcade, super = Class(Event)

function QueenArcade:init(data)
    super.init(self, data.center_x, data.center_y, data.width, data.height)

    self:setOrigin(0.5, 0.5)
    self:setSprite("minigames/queen_arcade")
	
    self.solid = true
end

function QueenArcade:onInteract()
    Game.world:startCutscene("floor2.queen_arcade")
end

return QueenArcade
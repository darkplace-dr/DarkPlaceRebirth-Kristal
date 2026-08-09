local DarkShapesSpeedUp, super = Class(Wave)

function DarkShapesSpeedUp:init()
    super.init(self)

    self.time = 360/30
end

function DarkShapesSpeedUp:onStart()
    Game.battle:swapSoul(FlashlightSoul())

    local darkshape_manager = self:spawnObject(DarkShapeManager())
    darkshape_manager:patternToUse("speedup")
end

function DarkShapesSpeedUp:onEnd()
    if Game.battle.soul.ominous_loop then
		Game.battle.soul.ominous_loop:stop()
	end
end

return DarkShapesSpeedUp
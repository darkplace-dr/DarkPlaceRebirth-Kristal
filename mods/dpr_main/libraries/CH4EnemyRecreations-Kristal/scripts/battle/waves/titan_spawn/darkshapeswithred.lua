local DarkShapesWithRed, super = Class(Wave)

function DarkShapesWithRed:init()
    super.init(self)

    self.time = 360/30
end

function DarkShapesWithRed:onStart()
    Game.battle:swapSoul(FlashlightSoul())

    local darkshape_manager = self:spawnObject(DarkShapeManager())
    darkshape_manager:patternToUse("default")
end

function DarkShapesWithRed:onEnd()
    if Game.battle.soul.ominous_loop then
		Game.battle.soul.ominous_loop:stop()
	end
end

return DarkShapesWithRed
local DarkShapesIntro, super = Class(Wave)

function DarkShapesIntro:init()
    super.init(self)

    self.time = 360/30
end

function DarkShapesIntro:onStart()
    Game.battle:swapSoul(FlashlightSoul())

    local darkshape_manager = self:spawnObject(DarkShapeManager())
    darkshape_manager:patternToUse("intro")
end

function DarkShapesIntro:onEnd()
    if Game.battle.soul.ominous_loop then
		Game.battle.soul.ominous_loop:stop()
	end
end

return DarkShapesIntro
return {
	start = function(cutscene, event)
        local hero = cutscene:getCharacter("hero")
	Game.world.music:pause()
        hero:setFacing("down")
        cutscene:wait(1)
        local ocean = Music("ocean")
        ocean:play()
        cutscene:wait(5)
        hero:setSprite("landed_2")
        Game.world:addChild(RippleEffect(hero.x, hero.y, 50, 240, 10));
        Assets.playSound("step1")
        cutscene:wait(4)
        hero:setSprite("walk")
        Game.world:addChild(RippleEffect(hero.x, hero.y, 50, 240, 10));
        Assets.playSound("step2")
        cutscene:wait(4)
        ocean:stop()
        Game.world.music:resume()
        Assets.playSound("ominous_cancel")
        Game:getQuest("wherethefuck"):unlock()
	end
}
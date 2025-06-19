return {
	start = function(cutscene, event)
        local hero = cutscene:getCharacter("hero")
	    Game.world.music:pause()
        cutscene:wait(1)
        local ocean = Music("ocean")
        ocean:play()
        cutscene:wait(5)

        Assets.playSound("reverse_splat")
        cutscene:wait(4)
        ocean:stop()
        Game.world.music:resume()
        Assets.playSound("ominous_cancel")
        Game:getQuest("wherethefuck"):unlock()
	end
}
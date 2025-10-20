return {
	satan = function(cutscene, event)
		local satan = cutscene:getCharacter('satan')
        cutscene:detachCamera()
        cutscene:look(satan, "left")
        cutscene:panTo(300,300)
        local player = Game.world.player
        cutscene:walkTo(player, 440, 320)
        cutscene:setSpeaker(satan)
        cutscene:text("...", "faceless", "satan", { top = true })
        cutscene:text("...", "satan", "satan", { top = true })
        cutscene:text("...", "satan", "satan", { top = true })
        cutscene:wait(2)
        cutscene:look(satan, "right")
        cutscene:wait(2)
        cutscene:text("...", "satan", "satan", { top = true })
        cutscene:text("...", "satan", "satan", { top = true })
        cutscene:text("[noskip]eW91IHJlYWxseSB0cmFuc2xhdGVkIHRoaXM/Pz8gbG9sbGxsbGwgaSBtaWdodCBwdXQgc29tZSBraW5kIG9mIGFyZyBoZXJlIGxhdGVyIG9yIHNtdGg=", "faceless", "satan", { auto = true, top = true })
        cutscene:walkTo(satan, 440, 320, 8)
        cutscene:wait(7)
        cutscene:mapTransition("hub_fuseroom", "entry")
	end,
}
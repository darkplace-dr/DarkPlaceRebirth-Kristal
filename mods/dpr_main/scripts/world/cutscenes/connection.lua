return {

    fake = function(cutscene)
        cutscene:board_text("\"WHEN THE PARTY CONSISTS OF JUST HEROIC AND PINK,\"")
        cutscene:board_text("\"YOU SHALL REACH...\"")
        cutscene:board_text("\"A CONNECTION.\"")
    end,
	
    legacyconnection = function(cutscene)
		Game.world.music:stop()
		Kristal.hideBorder(0)
		Assets.playSound("quiztime")
		local blue = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
		blue:setParallax(0)
		blue:setColor(ColorUtils.hexToRGB("#3F48CC"))
		blue.layer = WORLD_LAYERS["top"] - 2
		Game.world:addChild(blue)
		local text = Text("LEGACY CONNECTION UNSUPPORTED", 0, 220, nil, nil, {
			font = "8bit",
			align = "center"
		})
		text:setParallax(0)
		text.layer = WORLD_LAYERS["top"] - 1
		Game.world:addChild(text)
		cutscene:wait(5)
		blue:remove()
		text:remove()
		Kristal.showBorder(0)
        Game.world:loadMap(Game.world.map.id, "spawn", "down")
    end,
	
    connectiontransition = function(cutscene)
        if #Game.party == 2 and Game.party[1].id == "hero" and Game.party[2].id == "susie" then
    	    Game.world:mapTransition("floor3/connection", "entryup")
        else
    	    Game.world:mapTransition("connection/fake", "entryup")
        end
    end,

}
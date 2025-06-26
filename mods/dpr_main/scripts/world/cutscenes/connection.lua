return {

    fake = function(cutscene)
        cutscene:board_text("\"WHEN THE PARTY CONSISTS OF JUST HEROIC AND PINK,\"")
        cutscene:board_text("\"YOU SHALL REACH...\"")
        cutscene:board_text("\"A CONNECTION.\"")
    end,
	
    connectiontransition = function(cutscene)
        if #Game.party == 2 and Game.party[1].id == "hero" and Game.party[2].id == "susie" then
    	    Game.world:mapTransition("floor3/connection", "entryup")
        else
    	    Game.world:mapTransition("connection/fake", "entryup")
        end
    end,

}
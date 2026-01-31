return {
    diamond_store = function(cutscene)
        Game.world:shopTransition("diamond_store")
    end,
    bin_codes = function(cutscene)

        cutscene:text("* There appears to be some advertisements for codes here.")

        cutscene:text("* (yo whaddup. go to \"[color:red]DESSHERE[color:reset]\".)")

        cutscene:text("* (Hello! Go to \"[color:red]SLIDER[color:reset]\" for lotsa fun!)")
		
        cutscene:text("* (Do you have horrible internet? Visit \"[color:black]WIFIDOWN[color:reset]\" now to resolve all of your network troubles!)")

        cutscene:text("* (Want to fight bosses you've previously fought?[wait:10]\nGo to \"[color:yellow]BOSSRUSH[color:reset]\"!)")
		
        cutscene:text("* It looks like until someone posts another ad,[wait:10] that's all there is here.")

    end,
}
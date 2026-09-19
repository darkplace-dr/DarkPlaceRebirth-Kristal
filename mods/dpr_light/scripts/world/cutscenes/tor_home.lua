return {
    ---@param cutscene WorldCutscene
    chairiel = function(cutscene, event, player)
        local name = Game.world.player.actor.name
        if name == "Kris" then
            cutscene:text("* (It's Chairiel,[wait:5] the beloved living room chair.)/%")
        else
            cutscene:text("* (It's a living room chair.)\n* (Seems quite beloved.)")
		end
    end,

    fridge = function(cutscene, event, player)
        local name = Game.world.player.actor.name
        if name == "HERO" then
            cutscene:text("* There's nothing good to eat the fridge.[wait:5] Unless you want moldy fruit.", "neutral_closed", "hero")
        elseif name == "Kris" then
            cutscene:text("* There's a photo on the fridge.[wait:5] It's of you,[wait:5] your mother, and your brother.")
        end
    end,

    oven = function(cutscene, event, player)
        local name = Game.world.player.actor.name
        if name == "HERO" then
            cutscene:text("* I used an oven once. \n* It nearly killed me.", "neutral_closed", "hero")
        else
            cutscene:text("* There's some cinnamony batter caked on the stovetop.")
        end
    end,
	
	dragon_book = function(cutscene, event, player)
        local name = Game.world.player.actor.name
        if name == "HERO" then
            cutscene:text("* \"How to Draw Dragons...?\"", "neutral_closed", "hero")
            cutscene:text("* (...)", "suspicious", "hero")
            cutscene:text("* ...[wait:5] Those look nothing like dragons.", "annoyed", "hero")
        elseif name == "Kris" then
            cutscene:text("* (...[wait:5] How to Draw Dragons is at the bottom of the drawer.)")
            cutscene:text("* (The purple character on the cover is dressed...[wait:5] immodestly.)")
            cutscene:text("* (...)")
            cutscene:text("* (Your brother will never return this book.)")
        else
            cutscene:text("* (A copy of How to Draw Dragons is in the drawer.)")
            cutscene:text("* (The cover is...[wait:5] interesting,[wait:5] to say the least.)")
            cutscene:text("* (... seems like it hasn't been returned in a long time.)")
        end
	end,

	mirror = function(cutscene, event, player)
        local name = Game.world.player.actor.name
        if name == "HERO" then
            cutscene:text("* Yeah,[wait:5] that's definitely me.", "neutral_smile", "hero")
        elseif name == "Kris" then
            cutscene:text("* (It's what they call \"you.\")")
        else
            cutscene:text("* (It's just you.)")
        end
	end,

    template = function(cutscene, event)
    end,
}

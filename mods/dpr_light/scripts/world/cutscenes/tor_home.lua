return {
    ---@param cutscene WorldCutscene
    chairiel = function(cutscene, event, player)
        local name = Game.world.player.actor.name
        if name == "HERO" then
            --cutscene:text("* ...") -- if kris has nothing to say about sofasgore then hero has nothing to say about chairiel
        elseif name == "Kris" then
            cutscene:text("* (It's Chairiel!)[wait:5]* (The beloved living room chair!)")
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
        elseif name == "Kris" then
            cutscene:text("* (Mom didn't cooked anything today.)")
        end
    end,

    template = function(cutscene, event)
    end,
}

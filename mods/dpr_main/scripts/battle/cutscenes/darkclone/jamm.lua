return {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `BattleCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene BattleCutscene
    xaction = function(cutscene, battler, enemy)
        if not Game.battle.j_action then
            Game.battle.j_action = 0
        end
        Game.battle.j_action = Game.battle.j_action + 1
        if Game.battle.j_action == 1 then
            cutscene:text("* Jamm tried talking with the enemy.")
            cutscene:text("* What... even are you?", "suspicious", "jamm")
            cutscene:text("* What are you doing, looking like me...?", "nervous_left", "jamm")
            cutscene:text("* A-and why are you... here...?", "nervous", "jamm")
            cutscene:text("* But it wasn't effective.")
        elseif Game.battle.j_action == 2 then
            cutscene:text("* Jamm tried to reason with the enemy.")
            cutscene:text("* Can't we look for another way to do this?", "worried", "jamm")
            cutscene:text("* How about we just sit down and talk this out?", "relief", "jamm")
            cutscene:text("* I could brew some hot chocolate for us.", "relief", "jamm")
            cutscene:text("* ...", "worried", "jamm")
            cutscene:text("* No bite, huh?", "worried_down", "jamm")
            cutscene:text("* But it wasn't looking to talk.")
        elseif Game.battle.j_action >= 3 then
            cutscene:text("* Jamm tried to analyze the enemy.")
            if enemy.health == enemy.max_health then
                cutscene:text("* (It doesn't seem very interested in talking...)", "nervous", "jamm")
                cutscene:text("* (Right then.)\n* (I'll show it what I can do.)", "smug", "jamm")
                cutscene:text("* (My skills seem very important here...)", "smug", "jamm")
            elseif enemy.weak then
                cutscene:text("* (It looks tired after those attacks...)", "smug", "jamm")
                cutscene:text("* (Now's my chance!)\n* (I should really use DarkSling!)", "smug", "jamm")
            else
                cutscene:text("* But it wasn't effective.")
            end
        end
    end,
}

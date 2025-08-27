return {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `BattleCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene BattleCutscene
    xaction = function(cutscene, battler, enemy)
        if not Game.battle.b_action then
            Game.battle.b_action = 0
        end
        Game.battle.b_action = Game.battle.b_action + 1
        if Game.battle.b_action == 1 then
            cutscene:text("* Brenda tried talking with the enemy.")
            cutscene:text("* Who...[wait:10] Who are you?", "suspicious", "brenda")
            cutscene:text("* How did you get in my room?[wait:10]\n* Why do you look like me?", "suspicious_b", "brenda")
            cutscene:text("* ...", "dissapointed", "brenda")
            cutscene:text("* But it wasn't effective.")
        elseif Game.battle.b_action == 2 then
            cutscene:text("* Brenda tried to reason with the enemy.")
            cutscene:text("* We...[wait:5] we don't have to fight,[wait:5] okay?", "smile_b", "brenda")
            cutscene:text("* I...[wait:10] I don't know why you look like me,[wait:5] but...", "down", "brenda")
            cutscene:text("* ...", "neutral", "brenda")
            cutscene:text("* Ugh,[wait:5] are you even listening to me?", "angry_b", "brenda")
            cutscene:text("* But it wasn't effective.")
        elseif Game.battle.b_action >= 3 then
            cutscene:text("* Brenda tried to analyze the enemy.")
            if enemy.health == enemy.max_health then
                cutscene:text("* (Well,[wait:5] looks like talking won't work.)", "dissapointed", "brenda")
                cutscene:text("* (Guess I'll just have to fight instead.)", "pissed", "brenda")
            elseif enemy.powder_immunity_knowledge == true and enemy.powder_immunity == true then
                cutscene:text("* (Oh great,[wait:5] Powderkeg isn't working anymore either!)", "angry", "brenda")
                cutscene:text("* (Perhaps a few bullets would loosen them up.)", "smug", "brenda")
            elseif enemy.defense >= Game:getPartyMember("brenda"):getStat("defense") + 10 then
                cutscene:text("* (Damnit,[wait:5] is it getting more resilient?)", "angry", "brenda")
                cutscene:text("* (Maybe I just gotta change my attacking strategy?)", "suspicious", "brenda")
            else
                cutscene:text("* But it wasn't effective.")
            end
        end
    end,
}
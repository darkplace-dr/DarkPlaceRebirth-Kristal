return {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `BattleCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene BattleCutscene
    refuse = function(cutscene, battler, enemy)
        if battler.chara.id == "len" then
            local battle = Game.battle
            local turn_count = battle.turn_count
            if turn_count == 1 then
                cutscene:text("* I-[wait:5]I can't fight like this!", "dumb", battler.actor)
            elseif turn_count == 2 then
                cutscene:text("* Nope,[wait:5] still nope...", "nervous", battler.actor)
            end
        end

        cutscene:text("* (" .. battler.chara.name .. " refuses to act.)")
    end,
}
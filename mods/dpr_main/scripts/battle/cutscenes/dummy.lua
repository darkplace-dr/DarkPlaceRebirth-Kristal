return {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `BattleCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene BattleCutscene
    susie_punch = function(cutscene, battler, enemy)
        -- Open textbox and wait for completion
        cutscene:text("* Susie threw a punch at\nthe dummy.")

        -- Hurt the target enemy for 1 damage
        Assets.playSound("damage")
        enemy:hurt(1, battler)
        -- Wait 1 second
        cutscene:wait(1)

        -- Susie text
        cutscene:text("* You,[wait:5] uh,[wait:5] look like a weenie.[wait:5]\n* I don't like beating up\npeople like that.", "nervous_side", "susie")

        if cutscene:getCharacter("ralsei") then
            -- Ralsei text, if he's in the party
            cutscene:text("* Aww,[wait:5] Susie!", "blush_pleased", "ralsei")
        end
    end,
    tattle = function(cutscene, battler, enemy)
        local tex = "."
        if Game:hasPartyMember("hero") then tex = ", Hero." end
        cutscene:text("* That's a training dummy" ..tex, "face", "suzy")
        cutscene:text("* Not much to say other than it's a dummy. [wait:5]\n[face:smile_b]* Duh!", "neutral", "suzy")
        cutscene:text("* It's attacks are really easy to dodge.\n* So you should be fine.", "smile", "suzy")
        local p = Game.party[1]
        if p:getHealth() < p:getStat("health")/4 then
           cutscene:text("* Too bad you suck at dodging.", "smile_b", "suzy")
        end

    end
}
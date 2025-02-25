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
        cutscene:text("* That's a training dummy, Hero!", nil, "suzy_lw")
        cutscene:text("* Like the name implies,[wait:5] It's only purpose is to be used like a training dummy. [wait:5]* Duh!", nil, "suzy_lw")
        cutscene:text("* So try your best to break it in half![wait:10] * Or don't...", nil, "suzy_lw")

    end
}
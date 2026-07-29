return {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `WorldCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene WorldCutscene
    empty = function(cutscene, event)
        -- Open textbox and wait for completion

        -- If we have Susie, play a cutscene
        local susie = cutscene:getCharacter("susie")
        local hero = cutscene:getCharacter("hero")
        if susie and hero then
            -- Detach camera and followers (since characters will be moved)

            -- All text from now is spoken by Susie
            cutscene:setSpeaker(susie)
            cutscene:text("* Hey,[wait:5]"..Game.party[1]:getName().." are you sure there\nis anything here?", "nervous")
            cutscene:setSpeaker(hero)
            cutscene:text("* Uh yeah it is very empty... do you think\n we should be scared?", "neutral_closed")
        elseif hero then
            cutscene:setSpeaker(hero)
            cutscene:text("* Wow uh this place is very empty...do you think we should be scared?", "neutral_closed")
        else
            cutscene:text("* (You feel nervous because of how empty this place is)")
        end
    end,
    boss_start = function(cutscene, event)
        cutscene:detachFollowers()
        local susie = cutscene:getCharacter("susie")
        local party = Game.world:getPlayerAndFollowers()
        if party[1] ~= nil then
        cutscene:walkTo(party[1], 280, 280, 5, "right")
    end
        if party[2] ~= nil then
        cutscene:walkTo(party[2], 320, 360, 5, "right")
    end
        if party[3] ~= nil then
        cutscene:walkTo(party[3], 280, 440, 5, "right")
    end
        if party[4] ~= nil then
        cutscene:walkTo(party[4], 240, 360, 5, "right")
    end
    cutscene:wait(5)
    if susie then
        cutscene:setSpeaker(susie)
        cutscene:text("* Ooo look a cool egg-", "smile")
        Assets.playSound("grab")
        Game.world:spawnNPC("room3_friend", 600, 360)
        cutscene:setSpeaker("room3_friend")
        cutscene:text("* YOU THINK YOU CAN JUST WALTZ INTO MY HOME AND TAKE MY PROTEIN.")
        cutscene:setSpeaker(susie)
        cutscene:text("* This is your home? But it looks so... unfinished...", "nervous")
        cutscene:setSpeaker("room3_friend")
        cutscene:text("* WHAT LIKE I HAVE THE TIME TO MAKE MY HOME LOOK NICE.")
        cutscene:text("* BUT ALAS IT IS TIME TO FIGHT YOU.")
        cutscene:setSpeaker(susie)
        cutscene:text("* What???", "nervous")
        local encounter = cutscene:startEncounter("room3_friend", true, { { "room3_friend", event } })

        -- we're done
        local defeated_enemies = encounter:getDefeatedEnemies()
        -- grab the way we defeated them
        local done_state = defeated_enemies[1].done_state

        -- we defeated them with violence
        if done_state == "VIOLENCED" or done_state == "KILLED" or done_state == "FROZEN" then
        cutscene:text("* this scene isnt done yet? what do you mean hero", "neutral", "susie")
        cutscene:alignFollowers()
        cutscene:attachFollowers()
        else
        cutscene:setSpeaker("room3_friend")
        cutscene:text("* YOU REALLY THOUGHT IT WOULD BE THAT EASY.")
        cutscene:setSpeaker(susie)
        cutscene:text("* It was though.", "smirk")
        cutscene:setSpeaker("room3_friend")
        cutscene:text("*")
        cutscene:walkTo("room3_friend", 999, 999, 0.01, "right")
        cutscene:setSpeaker(susie)
        cutscene:text("* wait wait let me do something Ralsei did a lot.", "smirk")
        cutscene:text("* okay", "neutral")
        cutscene:alignFollowers()
        cutscene:attachFollowers()
    end
        else
        cutscene:text("* (you pick up the egg)")
        Assets.playSound("grab")
        Game.world:spawnNPC("room3_friend", 600, 360)
        cutscene:setSpeaker("room3_friend")
        cutscene:text("* YOU THINK YOU CAN JUST WALTZ INTO MY HOME AND TAKE MY PROTEIN.")
        cutscene:text("* (you question the cat about this unfinished looking place)")
        cutscene:setSpeaker("room3_friend")
        cutscene:text("* WHAT LIKE I HAVE THE TIME TO MAKE MY HOME LOOK NICE.")
        cutscene:text("* BUT ALAS IT IS TIME TO FIGHT YOU.")
                local encounter = cutscene:startEncounter("room3_friend", true, { { "room3_friend", event } })
        -- we're done
        local defeated_enemies = encounter:getDefeatedEnemies()
        -- grab the way we defeated them
        local done_state = defeated_enemies[1].done_state

        -- we defeated them with violence
        if done_state == "VIOLENCED" or done_state == "KILLED" or done_state == "FROZEN" then
        cutscene:text("* this scene isnt done yet? what do you mean hero", "neutral", "susie")
        cutscene:alignFollowers()
        cutscene:attachFollowers()
        else
        elsecutscene:setSpeaker("room3_friend")
        cutscene:text("* YOU REALLY THOUGHT IT WOULD BE THAT EASY.")
        cutscene:text("* (you inform the cat that it was)")
        cutscene:text("*")
        cutscene:walkTo("room3_friend", 999, 999, 0.01, "right")
        cutscene:text("* (okay)")
        cutscene:alignFollowers()
        cutscene:attachFollowers()
    end
    end
    end,
}
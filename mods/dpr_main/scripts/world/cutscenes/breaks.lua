return {
    -- MAKE SURE TO END YOUR CUTSCENE WITH cutscene:gotoCutscene("breaks.after", actor1, actor2)
    hero_susie = function(cutscene, hero, susie)
        -- entire thing is a placeholder
        cutscene:text("* break dialogue", "surprise_smile", "susie")
        susie:explode()
        cutscene:wait(2)
        cutscene:gotoCutscene("breaks.after", { hero, susie })
    end,
    susie_dess = function(cutscene, susie, dess)
        cutscene:text("") -- placeholder
        cutscene:gotoCutscene("breaks.after", { susie, dess })
    end,
    ceroba_jamm = function(cutscene, ceroba, jamm)
        cutscene:text("* Say,[wait:5] Jamm...[wait:10]\n* I was wondering.", "neutral", "ceroba")
        cutscene:text("* What made you pick a slingshot out of all things?", "surprised", "ceroba")
        cutscene:text("* I dunno,[wait:5] what made you pick a katana?", "side_smile", "jamm")
        cutscene:text("* Hmm...[wait:10]\n* Well,[wait:5] for starters...", "closed_eyes", "ceroba")
        cutscene:text("* It can be wielded fastly.[wait:5] Doing many quick cuts in a few swings.", "smile", "ceroba")
        cutscene:text("* Another point is that it's effective for blocking.", "smile_alt", "ceroba")
        cutscene:text("* And...[wait:5] It's just something I was comfortable to hold.", "neutral", "ceroba")
        cutscene:text("* Oh,[wait:5] it's also something that has a connection to Japanese culture.", "surprised", "ceroba")
        cutscene:text("* And I am...", "snarky", "ceroba")
        cutscene:text("* Well,[wait:5] a fan of it.", "happy", "ceroba")
        cutscene:text("* There you go.[wait:5] One of mine was among yours.", "smile", "jamm")
        cutscene:text("* Huh?", "surprised", "ceroba")
        cutscene:text("* I feel comfortable with it.[wait:5] I feel like it fits me just right.", "smirk", "jamm")

        local susie = Game.world:spawnNPC("susie", 980, 320)
        cutscene:wait(cutscene:walkToSpeed(susie, 810, susie.y, 6))
        susie:setSprite("walk_back_arm/left")
        cutscene:text("* Heh,[wait:5] just like my ax fits ME.", "smile", "susie")

        local hero = Game.world:spawnNPC("hero", 980, 440)
        cutscene:wait(cutscene:walkToSpeed(hero, 810, hero.y, 6))
        cutscene:text("* And like my sword fits ME!", "happy", "hero")

        cutscene:text("* I suppose I get that,[wait:5] then...", "smile_alt", "ceroba")
        
        cutscene:look(jamm, "right")
        
        cutscene:resetSprite(susie)
        cutscene:walkToSpeed(susie, 980, susie.y, 6)
        cutscene:wait(cutscene:walkToSpeed(hero, 980, hero.y, 6))
        
        cutscene:text("* Also,[wait:5] don't tell the others,[wait:5] but...", "neutral", "jamm")
        cutscene:look(jamm, "left")
        cutscene:text("* I'm kinda ass at melee combat.", "nervous", "jamm")

        cutscene:gotoCutscene("breaks.after", { ceroba, jamm, susie, hero })
    end,
    onetwotwofive = function(cutscene, dess)
        cutscene:text("* Hey look at my impersonations.", "teehee", "dess")
        cutscene:text("* \"Oh look im a circle\"", "zenore-old_impersonation", "dess")
        local zenore = cutscene:spawnNPC("zenore", 1160, 360)
        cutscene:walkTo(zenore, 724, 382, 0.5, "left")
        cutscene:text("* HEY, I'M NOT A CIRCLE!", "annoyed", "zenore")
        cutscene:walkTo(zenore, 1160, 360, 0, "right")
        zenore:remove()
        if Game:hasUnlockedPartyMember("jamm") then
            cutscene:text("* \"Hey look im a dess hater\"", "jamm_impersonation", "dess")
            local jamm = cutscene:spawnNPC("jamm", 640, 600)
            cutscene:walkTo(jamm, 724, 382, 0.5, "up")
            cutscene:wait(0.5)
            cutscene:walkTo(jamm, 724, 382, 0, "left")
            cutscene:text("* DESS", "furious", "jamm")
            cutscene:walkTo(jamm, 640, 600, 0, "down")
            jamm:remove()
        end
        cutscene:text("* \"hello im a badly named person who doesn't know [funnytext:ut, ut_intronoise, 0, 0, 92, 4]\"", "hero_impersonation", "dess")
        cutscene:text("* \"Oh BOOHOO my sister dessapeared :sob: :sob: :sob:\"", "sister_impersonation", "dess")
        if Game:hasUnlockedPartyMember("ceroba") then
            cutscene:text("* \"[color:yellow]yellow[color:reset]\"", "ceroba_impersonation", "dess")
            local ceroba = cutscene:spawnNPC("ceroba", 640, 600)
            cutscene:walkTo(ceroba, 724, 382, 0.5, "up")
            cutscene:wait(0.5)
            cutscene:walkTo(ceroba, 724, 382, 0, "left")
            cutscene:text("* ... what", "question", "ceroba")
            cutscene:walkTo(ceroba, 640, 600, 0, "down")
            ceroba:remove()
        end
        cutscene:text("* \"[color:red]99999999999999999999999\n999999999999999999999999\n999999999999999999999999[color:reset]\"", "noportrait_impersonation", "dess")
        local chara = cutscene:getCharacter("chara")
        cutscene:walkTo(chara, 724, 382, 0.3, "right")
        cutscene:text("* I do NOT do that", nil, "chara")
        cutscene:walkTo(chara, 872, 260.667, 0.3, "left")
        cutscene:wait(0.3)
        cutscene:walkTo(chara, 872, 260.667, 0, "down")
        cutscene:text("* \"I am Susie deltarune~~~\"", "susie_impersonation", "dess")
        local susie = cutscene:spawnNPC("susie", 1160, 360)
        cutscene:walkTo(susie, 724, 382, 0.5, "left")
        cutscene:text("* I like sealing fountains too~~~", "surprise_smile", "susie")
        cutscene:walkTo(susie, 1160, 360, 0, "right")
        susie:explode()
        cutscene:gotoCutscene("breaks.after", { dess })
    end,
    after = function(cutscene, to_remove)
        cutscene:wait(cutscene:fadeOut(0.5))

        for _, actor in ipairs(to_remove) do
            actor:remove()
        end

        local tx, ty = Game.world.camera:getTargetPosition()
        Game.world:setCameraAttached(true)
        Game.world.camera:setPosition(tx, ty)

        local x, y = Game.world.map:getMarker("break_camera_target")
        x, y = x - 160, y - 40
        Game.world.player:setPosition(x, y)
        Game.world.player:setFacing("down")
        Game.world.player.alpha = 1
        for i, follower in ipairs(Game.world.followers) do
            if i == 1 then
                follower:setPosition(x - 34, y - 12)
            elseif i == 2 then
                follower:setPosition(x + 36, y - 10)
            elseif i == 3 then
                follower:setPosition(x, y - 20)
            end
            follower:setFacing("down")
            follower.alpha = 1
        end
        cutscene:interpolateFollowers()

        cutscene:wait(cutscene:fadeIn(0.5))
    end
}

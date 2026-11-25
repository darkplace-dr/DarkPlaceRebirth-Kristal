return {
    -- MAKE SURE TO END YOUR CUTSCENE WITH cutscene:gotoCutscene("breaks.after", actor1, actor2)
    hero_susie = function(cutscene, hero, susie)
        -- entire thing is a plceholder
        cutscene:text("* break dialogue", "surprise_smile", "susie")
        susie:explode()
        cutscene:wait(2)
        cutscene:gotoCutscene("breaks.after", hero, susie)
    end,
    susie_dess = function(cutscene, susie, dess)
        cutscene:text("") -- placeholder
        cutscene:gotoCutscene("breaks.after", susie, dess)
    end,
    onetwotwofive = function(cutscene, dess, zenore, hero, jamm)
        cutscene:text("* Hey look at my impersonations.", "teehee", "dess")
        cutscene:text("* \"Oh look im a circle\"", "zenore-old_impersonation", "dess")
        local zenore = cutscene:spawnNPC("zenore", 1160, 360)
        cutscene:walkTo(zenore, 724, 382,0.5, "left")
        cutscene:text("* HEY, I'M NOT A CIRCLE!", "annoyed", "zenore")
        cutscene:walkTo(zenore, 1160, 360,0, "right")
        zenore:remove()
        cutscene:text("* \"Hey look im a dess hater\"", "jamm_impersonation", "dess")
        local jamm = cutscene:spawnNPC("jamm", 640, 600)
        cutscene:walkTo(jamm, 724, 382,0.5, "up")
        cutscene:wait(0.5)
        cutscene:walkTo(jamm, 724, 382,0, "left")
        cutscene:text("* DESS", "furious", "jamm")
        cutscene:walkTo(jamm, 640, 600,0, "down")
        jamm:remove()
        cutscene:text("* \"hello im a badly named person who doesn't know [funnytext:ut,ut_intronoise,0,0,92,4]\"", "hero_impersonation","dess")
        cutscene:text("* \"Oh BOOHOO my sister dessapeared :sob: :sob: :sob:\"", "sister_impersonation", "dess")
        cutscene:text("* \"[color:yellow]yellow[color:reset]\"", "ceroba_impersonation", "dess")
        local ceroba = cutscene:spawnNPC("ceroba", 640, 600)
        cutscene:walkTo(ceroba, 724, 382,0.5, "up")
        cutscene:wait(0.5)
        cutscene:walkTo(ceroba, 724, 382,0, "left")
        cutscene:text("* ... what", "question", "ceroba")
        cutscene:walkTo(ceroba, 640, 600,0, "down")
        ceroba:remove()
        cutscene:text("* \"[color:red]99999999999999999999999\n999999999999999999999999\n999999999999999999999999[color:reset]\"", "noportrait_impersonation","dess")
        local chara = cutscene:getCharacter("chara")
        cutscene:walkTo(chara, 724, 382,0.3, "right")
        cutscene:text("* I do NOT do that", "", "chara")
        cutscene:walkTo(chara, 872, 260.667,0.3, "left")
        cutscene:wait(0.3)
        cutscene:walkTo(chara, 872, 260.667,0, "down")
        cutscene:text("* \"I am Susie deltarune~~~\"", "susie_impersonation", "dess")
        local susie = cutscene:spawnNPC("susie", 1160, 360)
        cutscene:walkTo(susie, 724, 382,0.5, "left")
        cutscene:text("* I like sealing fountains too~~~", "surprise_smile", "susie")
        cutscene:walkTo(susie, 1160, 360,0, "right")
        susie:explode()
        cutscene:gotoCutscene("breaks.after", dess, dess)
    end,
    after = function(cutscene, actor1, actor2)
        cutscene:wait(cutscene:fadeOut(0.5))

        actor1:remove()
        actor2:remove()

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
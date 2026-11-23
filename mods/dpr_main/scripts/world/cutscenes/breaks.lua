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
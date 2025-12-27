local greyarea, super = Class(Map)

function greyarea:onEnter()
    Game.stage:setWeather("rain_prewarmed", false, true)


    if not Game:getFlag("greyarea_exit_to") then
        local error_message = "* You're not supposed to be here."
        local buttonlist = {"..."}


        love.window.showMessageBox("???", error_message, buttonlist)
        love.window.showMessageBox("???", "* Goodbye.", buttonlist)



        -- have to remember if your dumb or not somehow
        local f = "greyareastubborness"
        local stub = Game:getFlag(f)

        -- if you're on you're own then i don't care
        local me = Game:getPartyMember("len")
        if me then
            -- gotta make sure to override whatever the host intended, even if its inmoral
            love.window.showMessageBox("???", error_message, buttonlist)
            love.window.showMessageBox("???", "* Goodbye.", buttonlist)

            -- pushing code
            love.window.showMessageBox("Len", "* ...", buttonlist)
            if not stub then
                love.window.showMessageBox("Len", "* Look i don't know how you got here but...", buttonlist)
                love.window.showMessageBox("Len", "* I refuse to die because of your curiosity", buttonlist)
                love.window.showMessageBox("Len", "* Please don't try it again", buttonlist)
            elseif stub == 1 then
                love.window.showMessageBox("Len", "* Are you doing it on purpose?", buttonlist)
                love.window.showMessageBox("Len", "* I already told you to not do it again", buttonlist)
                love.window.showMessageBox("Len", "* Please, PLEASE don't try it again", buttonlist)
            elseif stub == 2 then
                love.window.showMessageBox("Len", "* ...", buttonlist)
                love.window.showMessageBox("Len", "* ...Please stop", buttonlist)
                love.window.showMessageBox("Len", "* ...PLEASE JUST STOP", buttonlist)
            elseif stub == 3 then
                love.window.showMessageBox("Len", "* STOP", buttonlist)
            elseif stub >= 4 and stub <= 10 then
                love.window.showMessageBox("Len", "* Don't you have anything better to do?", buttonlist)
            elseif stub == 100 then
                love.window.showMessageBox("Len", "* You either have the most patience in the world or put up a macro", buttonlist)
                love.window.showMessageBox("Len", "* Either way, you're wasting your time here", buttonlist)
                love.window.showMessageBox("Len", "* The game just closes by itself", buttonlist)
                love.window.showMessageBox("Len", "* You'll lose all your data if you're debugging", buttonlist)
                love.window.showMessageBox("Len", "* So please...", buttonlist)
                love.window.showMessageBox("Len", "* Just stop.", buttonlist)
            end
            if stub == 5 then
                love.window.showMessageBox("Len", "* ...Yes, i took that one from Flowey", buttonlist)
                love.window.showMessageBox("Len", "* ...Seriosly tho, stop, please, PLEASE", buttonlist)
            end
            Game:addFlag(f, 1)
            Game:swapIntoMod("dpr_main", false, "floor1/main")
            -- Note to self: Don't forget to return (very important)
            return
        end
        love.event.quit()
    end


    local savedData = Noel:loadNoel()
    if not savedData then
        local sunkist = "brella"

        if Game:isDessMode() then
            sunkist = "dess_mode/walk/down_1"
        end

        Game.world:spawnNPC("noel", 2820, 2180, {cutscene = "noel.meet", sprite = sunkist})
    end
end

function greyarea:onExit()
    Game.stage:resetWeather(true)
end

function greyarea:update()
    if Game.world.player:getCurrentSpeed(false) >= 60 then
        local eye = Game:getFlag("greyarea_exit_to")
        Game.world:mapTransition(eye[1], eye[2], eye[3])
    end

    if Kristal.Overlay.quit_timer > 0.8 and not Game.world.cutscene then
        Kristal.Overlay.quit_timer = -1.5
        local eye = Game:getFlag("greyarea_exit_to")
        Game.world:mapTransition(eye[1], eye[2], eye[3])
        --print(Kristal.Overlay.quit_timer)
    end

    if Input.pressed("menu") and not Game.world.cutscene then
        local eye = Game:getFlag("greyarea_exit_to")
        Game.world:mapTransition(eye[1], eye[2], eye[3])
    end

    if Game.world.player.x <= 360 then
        Game.world.player.x = Game.world.player.x + 5060
        for _,follower in ipairs(Game.world.followers) do
            follower.x = follower.x + 5060
            for _,point in ipairs(follower.history) do
                point.x = point.x + 5060
            end
        end
    elseif Game.world.player.x >= 5420 then
        Game.world.player.x = Game.world.player.x - 5060
        for _,follower in ipairs(Game.world.followers) do
            follower.x = follower.x - 5060
            for _,point in ipairs(follower.history) do
                point.x = point.x - 5060
            end
        end
    end
    if Game.world.player.y <= 280 then
        Game.world.player.y = Game.world.player.y + 3780
        for _,follower in ipairs(Game.world.followers) do
            follower.y = follower.y + 3780
            for _,point in ipairs(follower.history) do
                point.y = point.y + 3780
            end
        end
    elseif Game.world.player.y >= 4060 then
        Game.world.player.y = Game.world.player.y - 3780
        for _,follower in ipairs(Game.world.followers) do
            follower.y = follower.y - 3780
            for _,point in ipairs(follower.history) do
                point.y = point.y - 3780
            end
        end
    end

    super.update(self)
end

return greyarea

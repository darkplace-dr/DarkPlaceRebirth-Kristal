local greyarea, super = Class(Map)

function greyarea:onEnter()
    Game.stage:setWeather("rain", false, true)


    if not Game:getFlag("greyarea_exit_to") then
        local error_message = "* You're not supposed to be here."
        local buttonlist = {"..."}


        love.window.showMessageBox("???", error_message, buttonlist)
        love.window.showMessageBox("???", "* Goodbye.", buttonlist)



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
    Game.stage:resetWeather()
end

function greyarea:update()
    if Game.world.player.walk_speed >= 60 then
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

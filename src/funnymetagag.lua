Game.world.timer:after(0, function()
    ---@diagnostic disable-next-line: param-type-mismatch
    Game.world:startCutscene(function(cs)
        local machine = Game.world:getEvent("dpr")
        cs:text("* (Just as you start to walk away, the machine lights up with a message.)")
        cs:text("* Thanks for attempting to play Dark Place: REBIRTH!")
        cs:text("* We have a special offer for you![wait:5]\n* Do you want to accept?")
        if cs:choicer({"Yes", "Heck no!"}) == 1 then
            Assets.playSound("wing")
            machine:shake(2)
            cs:wait(1)
            cs:text("* (Something is coming out of the machine...)")
            cs:wait(.2)

            Game.world.player:explode()
            Game.world.music:stop()

            Game.stage.timer:after(2, function()
                local rect = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                rect:setColor(0, 0, 0)
                rect:setLayer(100000)
                rect.alpha = 0
                Game.stage:addChild(rect)

                Game.stage.timer:tween(2, rect, {alpha = 1}, "linear", function()
                    rect:remove()
                    Game:gameOver(0, 0)
                    Game.gameover.soul:remove()
                    Game.gameover.soul = nil
                    Game.gameover.screenshot = nil
                    Game.gameover.timer = 150
                    Game.gameover.current_stage = 4
                end)
            end)
        end
    end)
end)

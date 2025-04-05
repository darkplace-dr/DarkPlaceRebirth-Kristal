return {
    d = function(cutscene, event)
        local stall = cutscene:getCharacter("machine")
        stall:setSprite("on")
        cutscene:text("* The machine turns on, each of the four buttons have text on them.")
        local opinion = cutscene:choicer({"Play", "Rules", "Donate", "Shut off"})
        if opinion == 1 then
            Game:setFlag("NEXTROUNDMINIGAME", false)
            cutscene:text("* ROUND 1")
            local choice = love.math.random(1, 2)
            if choice == 1 then
                cutscene:wait(1)
            end
            if choice == 2 then
                cutscene:wait(1.2)
            end
            if not Input.down("up") and not Input.down("down") and not Input.down("left") and not Input.down("right") then
                local dir = love.math.random(1, 4)
                if dir == 1 then
                    Assets.playSound("bell_bounce_short")
                    stall:setSprite("up")
                    cutscene:wait(0.45)
                    if Input.down("up") and not Input.down("down") and not Input.down("left") and not Input.down("right") then
                        Assets.playSound("levelup")
                        Game:setFlag("NEXTROUNDMINIGAME", true)
                        stall:setSprite("won")
                        cutscene:text("* Good job!")
                    else
                        Assets.playSound("bluh")
                        stall:setSprite("lost")
                        cutscene:text("* You lost!")
                    end
                end
                if dir == 2 then
                    Assets.playSound("bell_bounce_short")
                    stall:setSprite("down")
                    cutscene:wait(0.45)
                    if not Input.down("up") and Input.down("down") and not Input.down("left") and not Input.down("right") then
                        Assets.playSound("levelup")
                        Game:setFlag("NEXTROUNDMINIGAME", true)
                        stall:setSprite("won")
                        cutscene:text("* Good job!")
                    else
                        Assets.playSound("bluh")
                        stall:setSprite("lost")
                        cutscene:text("* You lost!")
                    end
                end
                if dir == 3 then
                    Assets.playSound("bell_bounce_short")
                    stall:setSprite("left")
                    cutscene:wait(0.45)
                    if not Input.down("up") and not Input.down("down") and Input.down("left") and not Input.down("right") then
                        Assets.playSound("levelup")
                        Game:setFlag("NEXTROUNDMINIGAME", true)
                        stall:setSprite("won")
                        cutscene:text("* Good job!")
                    else
                        Assets.playSound("bluh")
                        stall:setSprite("lost")
                        cutscene:text("* You lost!")
                    end
                end
                if dir == 4 then
                    Assets.playSound("bell_bounce_short")
                    stall:setSprite("right")
                    cutscene:wait(0.45)
                    if not Input.down("up") and not Input.down("down") and not Input.down("left") and Input.down("right") then
                        Assets.playSound("levelup")
                        Game:setFlag("NEXTROUNDMINIGAME", true)
                        stall:setSprite("won")
                        cutscene:text("* Good job!")
                    else
                        Assets.playSound("bluh")
                        stall:setSprite("lost")
                        cutscene:text("* You lost!")
                    end
                end
            else
                Assets.playSound("bluh")
                stall:setSprite("lost")
                cutscene:text("* Don't push the button before the signal is shown! You lost!")
            end

            if Game:getFlag("NEXTROUNDMINIGAME") then
                stall:setSprite("on")
                Game:setFlag("NEXTROUNDMINIGAME", false)
                cutscene:text("* ROUND 2")
                local choice = love.math.random(1, 3)
                if choice == 1 then
                    cutscene:wait(0.6)
                end
                if choice == 2 then
                    cutscene:wait(0.7)
                end
                if choice == 3 then
                    cutscene:wait(0.8)
                end
                if not Input.down("up") and not Input.down("down") and not Input.down("left") and not Input.down("right") then
                    local dir = love.math.random(1, 4)
                    if dir == 1 then
                        Assets.playSound("bell_bounce_short")
                        stall:setSprite("up")
                        cutscene:wait(0.38)
                        if Input.down("up") and not Input.down("down") and not Input.down("left") and not Input.down("right") then
                            Assets.playSound("levelup")
                            Game:setFlag("NEXTROUNDMINIGAME", true)
                            stall:setSprite("won")
                            cutscene:text("* Good job!")
                        else
                            Assets.playSound("bluh")
                            stall:setSprite("lost")
                            cutscene:text("* You lost!")
                        end
                    end
                    if dir == 2 then
                        Assets.playSound("bell_bounce_short")
                        stall:setSprite("down")
                        cutscene:wait(0.38)
                        if not Input.down("up") and Input.down("down") and not Input.down("left") and not Input.down("right") then
                            Assets.playSound("levelup")
                            Game:setFlag("NEXTROUNDMINIGAME", true)
                            stall:setSprite("won")
                            cutscene:text("* Good job!")
                        else
                            Assets.playSound("bluh")
                            stall:setSprite("lost")
                            cutscene:text("* You lost!")
                        end
                    end
                    if dir == 3 then
                        Assets.playSound("bell_bounce_short")
                        stall:setSprite("left")
                        cutscene:wait(0.38)
                        if not Input.down("up") and not Input.down("down") and Input.down("left") and not Input.down("right") then
                            Assets.playSound("levelup")
                            Game:setFlag("NEXTROUNDMINIGAME", true)
                            stall:setSprite("won")
                            cutscene:text("* Good job!")
                        else
                            Assets.playSound("bluh")
                            stall:setSprite("lost")
                            cutscene:text("* You lost!")
                        end
                    end
                    if dir == 4 then
                        Assets.playSound("bell_bounce_short")
                        stall:setSprite("right")
                        cutscene:wait(0.38)
                        if not Input.down("up") and not Input.down("down") and not Input.down("left") and Input.down("right") then
                            Assets.playSound("levelup")
                            Game:setFlag("NEXTROUNDMINIGAME", true)
                            stall:setSprite("won")
                            cutscene:text("* Good job!")
                        else
                            Assets.playSound("bluh")
                            stall:setSprite("lost")
                            cutscene:text("* You lost!")
                        end
                    end
                else
                    Assets.playSound("bluh")
                    stall:setSprite("lost")
                    cutscene:text("* Don't push the button before the signal is shown! You lost!")
                end
            end

            if Game:getFlag("NEXTROUNDMINIGAME") then
                stall:setSprite("on")
                Game:setFlag("NEXTROUNDMINIGAME", false)
                cutscene:text("* ROUND 3")
                local choice = love.math.random(1, 4)
                if choice == 1 then
                    cutscene:wait(0.3)
                end
                if choice == 2 then
                    cutscene:wait(0.4)
                end
                if choice == 3 then
                    cutscene:wait(0.5)
                end
                if choice == 4 then
                    cutscene:wait(0.6)
                end
                if not Input.down("up") and not Input.down("down") and not Input.down("left") and not Input.down("right") then
                    local dir = love.math.random(1, 4)
                    if dir == 1 then
                        Assets.playSound("bell_bounce_short")
                        stall:setSprite("up")
                        cutscene:wait(0.32)
                        if Input.down("up") and not Input.down("down") and not Input.down("left") and not Input.down("right") then
                            Assets.playSound("levelup")
                            Game:setFlag("NEXTROUNDMINIGAME", true)
                            stall:setSprite("won")
                            cutscene:text("* Good job!")
                        else
                            Assets.playSound("bluh")
                            stall:setSprite("lost")
                            cutscene:text("* You lost!")
                        end
                    end
                    if dir == 2 then
                        Assets.playSound("bell_bounce_short")
                        stall:setSprite("down")
                        cutscene:wait(0.32)
                        if not Input.down("up") and Input.down("down") and not Input.down("left") and not Input.down("right") then
                            Assets.playSound("levelup")
                            Game:setFlag("NEXTROUNDMINIGAME", true)
                            stall:setSprite("won")
                            cutscene:text("* Good job!")
                        else
                            Assets.playSound("bluh")
                            stall:setSprite("lost")
                            cutscene:text("* You lost!")
                        end
                    end
                    if dir == 3 then
                        Assets.playSound("bell_bounce_short")
                        stall:setSprite("left")
                        cutscene:wait(0.32)
                        if not Input.down("up") and not Input.down("down") and Input.down("left") and not Input.down("right") then
                            Assets.playSound("levelup")
                            Game:setFlag("NEXTROUNDMINIGAME", true)
                            stall:setSprite("won")
                            cutscene:text("* Good job!")
                        else
                            Assets.playSound("bluh")
                            stall:setSprite("lost")
                            cutscene:text("* You lost!")
                        end
                    end
                    if dir == 4 then
                        Assets.playSound("bell_bounce_short")
                        stall:setSprite("right")
                        cutscene:wait(0.32)
                        if not Input.down("up") and not Input.down("down") and not Input.down("left") and Input.down("right") then
                            Assets.playSound("levelup")
                            Game:setFlag("NEXTROUNDMINIGAME", true)
                            stall:setSprite("won")
                            cutscene:text("* Good job!")
                        else
                            Assets.playSound("bluh")
                            stall:setSprite("lost")
                            cutscene:text("* You lost!")
                        end
                    end
                else
                    Assets.playSound("bluh")
                    stall:setSprite("lost")
                    cutscene:text("* Don't push the button before the signal is shown! You lost!")
                end
            end

            if Game:getFlag("NEXTROUNDMINIGAME") then
                stall:setSprite("on")
                Game:setFlag("NEXTROUNDMINIGAME", false)
                cutscene:text("* ROUND 4")
                local choice = love.math.random(1, 5)
                if choice == 1 then
                    cutscene:wait(0.2)
                end
                if choice == 2 then
                    cutscene:wait(0.3)
                end
                if choice == 3 then
                    cutscene:wait(0.4)
                end
                if choice == 4 then
                    cutscene:wait(0.5)
                end
                if choice == 5 then
                    cutscene:wait(0.6)
                end
                if not Input.down("up") and not Input.down("down") and not Input.down("left") and not Input.down("right") then
                    local dir = love.math.random(1, 4)
                    if dir == 1 then
                        Assets.playSound("bell_bounce_short")
                        stall:setSprite("up")
                        cutscene:wait(0.3)
                        if Input.down("up") and not Input.down("down") and not Input.down("left") and not Input.down("right") then
                            Assets.playSound("levelup")
                            Game:setFlag("NEXTROUNDMINIGAME", true)
                            stall:setSprite("won")
                            cutscene:text("* Good job!")
                        else
                            Assets.playSound("bluh")
                            stall:setSprite("lost")
                            cutscene:text("* You lost!")
                        end
                    end
                    if dir == 2 then
                        Assets.playSound("bell_bounce_short")
                        stall:setSprite("down")
                        cutscene:wait(0.3)
                        if not Input.down("up") and Input.down("down") and not Input.down("left") and not Input.down("right") then
                            Assets.playSound("levelup")
                            Game:setFlag("NEXTROUNDMINIGAME", true)
                            stall:setSprite("won")
                            cutscene:text("* Good job!")
                        else
                            Assets.playSound("bluh")
                            stall:setSprite("lost")
                            cutscene:text("* You lost!")
                        end
                    end
                    if dir == 3 then
                        Assets.playSound("bell_bounce_short")
                        stall:setSprite("left")
                        cutscene:wait(0.3)
                        if not Input.down("up") and not Input.down("down") and Input.down("left") and not Input.down("right") then
                            Assets.playSound("levelup")
                            Game:setFlag("NEXTROUNDMINIGAME", true)
                            stall:setSprite("won")
                            cutscene:text("* Good job!")
                        else
                            Assets.playSound("bluh")
                            stall:setSprite("lost")
                            cutscene:text("* You lost!")
                        end
                    end
                    if dir == 4 then
                        Assets.playSound("bell_bounce_short")
                        stall:setSprite("right")
                        cutscene:wait(0.3)
                        if not Input.down("up") and not Input.down("down") and not Input.down("left") and Input.down("right") then
                            Assets.playSound("levelup")
                            Game:setFlag("NEXTROUNDMINIGAME", true)
                            stall:setSprite("won")
                            cutscene:text("* Good job!")
                        else
                            Assets.playSound("bluh")
                            stall:setSprite("lost")
                            cutscene:text("* You lost!")
                        end
                    end
                else
                    Assets.playSound("bluh")
                    stall:setSprite("lost")
                    cutscene:text("* Don't push the button before the signal is shown! You lost!")
                end
            end
            if Game:getFlag("NEXTROUNDMINIGAME") then
                stall:setSprite("on")
                Game:setFlag("NEXTROUNDMINIGAME", false)
                cutscene:text("* ROUND 5")
                local choice = love.math.random(1, 6)
                if choice == 1 then
                    cutscene:wait(0.2)
                end
                if choice == 2 then
                    cutscene:wait(0.3)
                end
                if choice == 3 then
                    cutscene:wait(0.4)
                end
                if choice == 4 then
                    cutscene:wait(0.5)
                end
                if choice == 5 then
                    cutscene:wait(0.6)
                end
                if choice == 6 then
                    cutscene:wait(0.1)
                end
                if not Input.down("up") and not Input.down("down") and not Input.down("left") and not Input.down("right") then
                    local dir = love.math.random(1, 4)
                    if dir == 1 then
                        Assets.playSound("bell_bounce_short")
                        stall:setSprite("up")
                        cutscene:wait(0.29)
                        if Input.down("up") and not Input.down("down") and not Input.down("left") and not Input.down("right") then
                            Assets.playSound("levelup")
                            Game:setFlag("NEXTROUNDMINIGAME", true)
                            stall:setSprite("won")
                            cutscene:text("* Good job!")
                        else
                            Assets.playSound("bluh")
                            stall:setSprite("lost")
                            cutscene:text("* You lost!")
                        end
                    end
                    if dir == 2 then
                        Assets.playSound("bell_bounce_short")
                        stall:setSprite("down")
                        cutscene:wait(0.29)
                        if not Input.down("up") and Input.down("down") and not Input.down("left") and not Input.down("right") then
                            Assets.playSound("levelup")
                            Game:setFlag("NEXTROUNDMINIGAME", true)
                            stall:setSprite("won")
                            cutscene:text("* Good job!")
                        else
                            Assets.playSound("bluh")
                            stall:setSprite("lost")
                            cutscene:text("* You lost!")
                        end
                    end
                    if dir == 3 then
                        Assets.playSound("bell_bounce_short")
                        stall:setSprite("left")
                        cutscene:wait(0.29)
                        if not Input.down("up") and not Input.down("down") and Input.down("left") and not Input.down("right") then
                            Assets.playSound("levelup")
                            Game:setFlag("NEXTROUNDMINIGAME", true)
                            stall:setSprite("won")
                            cutscene:text("* Good job!")
                        else
                            Assets.playSound("bluh")
                            stall:setSprite("lost")
                            cutscene:text("* You lost!")
                        end
                    end
                    if dir == 4 then
                        Assets.playSound("bell_bounce_short")
                        stall:setSprite("right")
                        cutscene:wait(0.29)
                        if not Input.down("up") and not Input.down("down") and not Input.down("left") and Input.down("right") then
                            Assets.playSound("levelup")
                            Game:setFlag("NEXTROUNDMINIGAME", true)
                            stall:setSprite("won")
                            cutscene:text("* Good job!")
                        else
                            Assets.playSound("bluh")
                            stall:setSprite("lost")
                            cutscene:text("* You lost!")
                        end
                    end
                else
                    Assets.playSound("bluh")
                    stall:setSprite("lost")
                    cutscene:text("* Don't push the button before the signal is shown! You lost!")
                end
            end
            if Game:getFlag("NEXTROUNDMINIGAME") then
                --stall:setSprite("on")
                Game:setFlag("NEXTROUNDMINIGAME", false)
                Game:setFlag("WONREACTIONTIMEMINIGAME", true)
                cutscene:text("* You won the game!")
                Game:setFlag("tl_mwon", true)
                local itemcheck = Game.inventory:addItem("nut")
                if itemcheck then
                    cutscene:text("* You obtained a Nut.")
                else
                    cutscene:text("* You don't have enough space.")
                end
            end
            
        end
        if opinion == 2 then
            cutscene:text("* The game is simple.")
            cutscene:text("* Press the direction shown on screen and hold it until the screen is green.")
            cutscene:text("* Release the button and repeat for 5 rounds, each getting faster.")
            cutscene:text("* Can you master your reaction speed?")
            cutscene:text("* Win to obtain the prize!\nCurrent Prize:\nNut")
        end
        if opinion == 3 then
            cutscene:showShop()
            cutscene:text("* How much do you want to donate?")
            cutscene:text("* (WARNING: DONATING HAS NO EFFECT TO THE GAME.)")
            local donate = cutscene:choicer({"10", "20", "50", "0"})
            if donate == 1 then
                if Game.money >= 10 then
                    Game.money = Game.money - 10
                    cutscene:text("* Thank you!")
                else
                    cutscene:text("* You don't have enough D$.")
                end
            end
            if donate == 2 then
                if Game.money >= 20 then
                    Game.money = Game.money - 20
                    cutscene:text("* Thank you!")
                else
                    cutscene:text("* You don't have enough D$.")
                end
            end
            if donate == 3 then
                if Game.money >= 50 then
                    Game.money = Game.money - 50
                    cutscene:text("* Thank you!")
                else
                    cutscene:text("* You don't have enough D$.")
                end
            end
            cutscene:hideShop()
        end
        stall:setSprite("off")
    end
}
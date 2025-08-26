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
    end,

    a = function(cutscene, event)
        cutscene:text("* The machine turns on, each of the four buttons have text on them.")
        local opinion = cutscene:choicer({"Fight", "Reward", "Info", "Shut off"})
        if opinion == 1 then
            cutscene:startEncounter("annabelle", true, stall)
            Game:setFlag("annabelle_defeated", true)
            cutscene:text("* Rewards can now be claimed under Reward in this machine.")
            cutscene:text("* Each reward can only be claimed once.")
        end
        if opinion == 2 then
            if Game:getFlag("annabelle_defeated") then
                local reward = cutscene:choicer({"Claim\nBody Guts", "Claim\nMind Guts", "Claim Soul Guts", "Shut off"})
                if reward == 1 then
                    if not Game:getFlag("bg_claim") then
                        local itemcheck = Game.inventory:addItem("body_guts")
                        if itemcheck then
                            Game:setFlag("bg_claim", true)
                            cutscene:text("* A strange patch (?) falls out of the machine.")
                        else
                            cutscene:text("* You do not have space in your inventory.")
                        end
                    else
                        cutscene:text("* You already claimed this reward.")
                    end
                end
                if reward == 2 then
                    if not Game:getFlag("mg_claim") then
                        local itemcheck = Game.inventory:addItem("mind_guts")
                        if itemcheck then
                            Game:setFlag("mg_claim", true)
                            cutscene:text("* A strange patch (?) falls out of the machine.")
                        else
                            cutscene:text("* You do not have space in your inventory.")
                        end
                    else
                        cutscene:text("* You already claimed this reward.")
                    end
                end
                if reward == 3 then
                    if not Game:getFlag("sg_claim") then
                        local itemcheck = Game.inventory:addItem("soul_guts")
                        if itemcheck then
                            Game:setFlag("sg_claim", true)
                            cutscene:text("* A strange patch (?) falls out of the machine.")
                        else
                            cutscene:text("* You do not have space in your inventory.")
                        end
                    else
                        cutscene:text("* You already claimed this reward.")
                    end
                end
            else
                cutscene:text("* Defeat Annabelle to unlock this segment.")
            end
        end
        if opinion == 3 then
            cutscene:text("* Hello, I am Annabelle. This is my cabinet.")
            cutscene:text("* Master (God I hate calling him that) soon releases a new game.")
            cutscene:text("* I will be the girl at the center!")
            cutscene:text("* I will have my own big fight!")
            cutscene:text("* It will be glorious! But I could use feedback.")
            cutscene:text("* In the real game you do fight me with another loadout.")
            cutscene:text("* But you can still fight me here to give feedback on my attacks!")
            cutscene:text("* Well, you'd have to tell Tritra the feedback.")
            cutscene:text("* But you're smart, you set this game up.")
            cutscene:text("* You'll find Tritra.")
            cutscene:text("* Anyhow, once you defeat me, the rewards will be yours!")
            cutscene:text("* Three pieces of armor for specialists who focus on single stats!")
            cutscene:text("* The battle will be very difficult though, as it is meant for experts.")
            cutscene:text("* Or at least those who have any kind of complete loadout.")
            cutscene:text("* Good luck! Make sure to save!")
        end
    end
}
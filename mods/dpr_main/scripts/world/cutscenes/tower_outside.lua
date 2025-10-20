return {
    lazul = function(cutscene)
        local quest = Game:getFlag("package_quest")
        if quest and quest == 1 then
            cutscene:showNametag("Lazul", {color = {0, 0, 1, 1}})
            cutscene:text("[color:blue]* In case you forgot the bin code:[wait:5] The code is [color:yellow]00000000[color:blue].")
            cutscene:hideNametag()
        elseif quest and quest > 1 then
            cutscene:showNametag("Lazul", {color = {0, 0, 1, 1}})
            cutscene:text("[color:blue]* We have nothing to discuss.")
            cutscene:hideNametag()
        else
            cutscene:showNametag("Lazul", {color = {0, 0, 1, 1}})
            cutscene:text("[color:blue]* Hey![wait:5] Do you happen to be a delivery man?[wait:5] No?[wait:5] Good.")
            Game.inventory:addItem("diamond_package")
            Assets.playSound("item")
            cutscene:hideNametag()
            cutscene:text("* You were given the [color:yellow]Diamond Package[color:reset].")
            cutscene:text("* The [color:yellow]Diamond Package[color:reset] was added to your [color:yellow]KEY ITEMs[color:reset].")
            cutscene:showNametag("Lazul", {color = {0, 0, 1, 1}})
            cutscene:text("[color:blue]* Take that to the man who lives in the Warp Hub.[wait:5] Use the Warp Bin.")
            cutscene:text("[color:blue]* The code is [color:yellow]00000000[color:blue].")
            cutscene:hideNametag()
            Game:getQuest("a_special_delivery"):unlock()
            Game:setFlag("package_quest", 1)
        end
    end,
    
	start = function(cutscene, event)
        local hero = cutscene:getCharacter("hero")
	    Game.world.music:pause()
        hero:setFacing("down")
        hero:setSprite("fell")
        cutscene:wait(1)
        local ocean = Music("deltarune/ocean")
        ocean:play()
        cutscene:wait(5)
        cutscene:shakeCharacter(hero, 4, y)
        hero:setSprite("landed_2")
        Game.world:addChild(RippleEffect(hero.x, hero.y, 50, 240, 10));
        Assets.playSound("step1")
        cutscene:wait(4)
        cutscene:shakeCharacter(hero, 4, y)
        hero:setSprite("walk")
        Game.world:addChild(RippleEffect(hero.x, hero.y, 50, 240, 10));
        Assets.playSound("step2")
        cutscene:wait(4)
        ocean:stop()
        Game.world.music:resume()
        Assets.playSound("ominous_cancel")
        Game:getQuest("wherethefuck"):unlock()
	end,

    trans = function(cutscene, event)
        if love.math.random(1, 100) <= 5 and Game:getFlag("egg_h", false) then
            cutscene:mapTransition("tower/hell/hell_egg", "spawn")
            -- default wait func waits for the fade animation to end. movement should be allowed slightly before that
            cutscene:wait(function () return Game.world.map.id == "spamgolor_meeting" end)
            local timeout = .5
            cutscene:during(function () timeout = timeout - DT end)
            -- prevent player from accidentally exiting the room
            cutscene:wait(function ()
                return Input.up("left") or (timeout <= 0)
            end)
        else
            cutscene:mapTransition("tower/hell/hell_3c", "entry")
        end
    end,

    egg = function(cutscene, event)
        cutscene:text("* Well,[wait:5] there is a man here.")
        local item = "egg"
        if Game.inventory:addItem(item) then
                    if item.id == "egg" then
                        Assets.stopAndPlaySound("egg")
                    else
                        Assets.stopAndPlaySound("egg")
                    end
                    cutscene:text("* (You received an Egg.)")
                    Game:setFlag("egg_h", true)
            end
    end
}
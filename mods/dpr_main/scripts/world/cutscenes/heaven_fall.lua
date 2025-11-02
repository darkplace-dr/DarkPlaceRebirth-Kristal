return function(cutscene)


    if not Game:getFlag("heaven_open", false) then
        cutscene:textTagged("* No.", "smug", "dess")
        cutscene:mapTransition("floor1/main", "spawn")
        return
    end

    local texts = {}
    
        local function bigText(str, advance, skippable)
            text = DialogueText("[voice:default]" .. str, 160, 80, 640, 480,
                { auto_size = true })
            text.layer = WORLD_LAYERS["textbox"]
            text.skip_speed = not skippable
            text.parallax_x = 0
            text.parallax_y = 0
            Game.world:addChild(text)

            if advance ~= false then
                cutscene:wait(function() return not text:isTyping() end)
                text:remove()
            end
        end

        local function flashingLight()
            local flash = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
            flash.layer = 100
            flash.color = { 1, 0, 0 }
            flash.alpha = 0.50
            flash.parallax_x = 0
            flash.parallax_y = 0
            Game.world:addChild(flash)

            Game.world.timer:every(1, function()
                Game.world.timer:tween(0.5, flash, { alpha = 0 }, "linear")
                Game.world.timer:tween(0.5, flash, { alpha = 0.50 }, "linear")
            end)
        end

        local function light()
            local light = Rectangle(0, 0, SCREEN_WIDTH+100, SCREEN_HEIGHT+100)
            light.layer = 100
            light.color = { 1, 1, 1 }
            light.alpha = 0
            light.parallax_x = 0
            light.parallax_y = 0
            Game.world:addChild(light)
            Game.world.timer:tween(3, light, { alpha = 1 }, "linear")
        end

        local function black()
            local black = Rectangle(0, 0, SCREEN_WIDTH+100, SCREEN_HEIGHT+100)
            black.layer = 100
            black.color = { 0, 0, 0 }
            black.alpha = 0
            black.parallax_x = 0
            black.parallax_y = 0
            Game.world:addChild(black)
            Game.world.timer:tween(0, black, { alpha = 1 }, "linear")
        end

    -- An example cutscene to show off elevator cutscenes: Hero and Susie get mildly inconvenienced by the elevator being broken.
    local elevator = Game.world.map:getEvent("elevator")
        
        if Game:hasPartyMember("hero") and Game:hasPartyMember("susie") then
        local hero = cutscene:getCharacter("hero")
        local susie = cutscene:getCharacter("susie")
        
        
        cutscene:wait(5)
        cutscene:textTagged("* Guess this one's going to take a while.", "neutral_closed_b", "hero")
        cutscene:textTagged("* Ugh,[wait:5] again?", "suspicious", "susie")
        cutscene:textTagged("* Fine,[wait:5] I guess.", "suspicious", "susie")
        
        -- Susie walks to the left wall and leans on it.
        cutscene:detachFollowers()
        cutscene:walkTo(susie, 223, 287, 1)
        cutscene:wait(1)
        Assets.playSound("wing")
        susie:setSprite("wall_right")
        
        cutscene:wait(5)
        
        cutscene:textTagged("* So uh,[wait:5] about that thing earlier...", "nervous_side", "susie")

        cutscene:during(function()
            if elevator.volcount == 0 then return false end
            elevator.volcount = Utils.approach(elevator.volcount, 0, (0.05 * DTMULT))
        end)
        elevator.rectcon = 3
        Assets.playSound("noise")
        cutscene:wait(2)

        susie:setSprite("walk_unhappy")
        susie:setFacing("right")
        cutscene:textTagged("* Huh?!", "surprise", "susie")
        cutscene:textTagged("* It stopped... AGAIN?", "teeth", "susie")
        susie:walkTo(316, susie.y, 1)
        susie:setFacing("up")
        cutscene:textTagged("* I swear,[wait:5] if I have to ride this thing again i'm gonna...", "teeth", "susie")

        cutscene:during(function()
            if elevator.volcount == 0.7 then return false end
            elevator.volcount = Utils.approach(elevator.volcount, 0, (0 * DTMULT))
        end)
        flashingLight()
        local shake_timer = Game.world.timer:every(0.2, function()
        Game.world:shake(6, 6)
        end)
        elevator.dir = -1
        elevator.rectcon = 1
        elevator.rectspeed = 28
        elevator.maxrectspeed = 28
        elevator.shakecon = 3
        elevator.target_floor = elevator:getFloorByName("Floor 1")
        susie:setSprite("shock_right")
        local destroyed = Music("mus_f_destroyed")
        destroyed:play()
        cutscene:wait(2)

        cutscene:textTagged("* What the...", "shock", "susie")

        bigText("WARNING![wait:5] WARNING![wait:20]", 200, 105, 1)

        bigText("ELEVATOR LOSING POWER![wait:20]", 200, 105, 1)

        cutscene:textTagged("* W-wait!", "shock", "susie")
        susie:setSprite("walk_unhappy")
        susie:setFacing("down")
        susie:walkTo(316, 360, 0.5)
        cutscene:textTagged("* Let us out![wait:5] Let us...", "teeth_b", "susie")

        bigText("LOSING ALTITUDE![wait:20]", 200, 105, 1)

        bigText("BRACE FOR IMPACT![wait:20]", 200, 105, 1)

        susie:setAnimation({"shock_down_flip", 0.1, true})
        destroyed:fade(0, 4)
        light()
        Game.world.timer:cancel(shake_timer)
        cutscene:wait(4.5)
        destroyed:remove()
        black()
        Assets.playSound("closet_impact")
        Game:removePartyMember("susie")
        cutscene:wait(4)
        Game:setFlag("Heaven_Fall", true)
        cutscene:mapTransition("tower/hell/hell_1", "spawn")

    end
end

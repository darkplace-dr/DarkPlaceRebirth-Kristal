return {
    ---@param cutscene WorldCutscene
    introcutscene = function(cutscene)
        local text
        Game:setBorder("simple")

        local skip_hint


        local function gonerTextFade(wait)
            local this_text = text
            Game.world.timer:tween(1, this_text, { alpha = 0 }, "linear", function()
                this_text:remove()
            end)
            if wait ~= false then
                cutscene:wait(1)
            end
        end

        -- FIXME: actually use skippable
        local function gonerText(str, advance, skippable)
            text = DialogueText("[speed:0.5][spacing:6][style:GONER][voice:none]" .. str, 160, 100, 640, 480,
                { auto_size = true })
            text.layer = WORLD_LAYERS["textbox"]
            text.skip_speed = not skippable
            text.parallax_x = 0
            text.parallax_y = 0
            Game.world:addChild(text)

            if advance ~= false then
                cutscene:wait(function() return not text:isTyping() end)
                gonerTextFade(true)
            end
        end

        ---@type Music -- satisfy LLS
        local world_music = Game.world.music
        world_music:play("AUDIO_DRONE", 0.8)

        local cover = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        cover:setColor(COLORS["black"])
        cover:setParallax(0, 0)
        cover:setLayer(WORLD_LAYERS["below_ui"])
        Game.world:addChild(cover)

        if not Game:isDessMode() then

            skip_hint = Text("Hold C+D to skip",
                0, SCREEN_HEIGHT/2+50, SCREEN_WIDTH, SCREEN_HEIGHT,
                {
                    align = "center",
                    font = "plain"
                }
            )
    
            if Input.usingGamepad() then
                skip_hint:setText("Hold [button:leftshoulder]+[font:plain,0.5] [font:plain][button:rightshoulder]to skip")
            end
            local skip_hint_alphafx = skip_hint:addFX(AlphaFX(0.15))
            if Game:getGlobalFlag("Intro_seen") then
                skip_hint_alphafx.alpha = 0.5
            end
            skip_hint:setParallax(0, 0)
            skip_hint:setLayer(WORLD_LAYERS["ui"])
            Game.world:addChild(skip_hint)
    
            local can_exit = true
            cutscene:during(function()
                if not can_exit then return false end
    
                if ( false
                    or (Input.down("c") and Input.down("d"))
                    or (Input.down("gamepad:leftshoulder") and Input.down("gamepad:rightshoulder"))
                ) then
                    Game.fader:fadeOut { speed = 0 }
                    -- Kristal.hideBorder(0) takes an entire frame, which is too slow.
                    BORDER_ALPHA = 0
                    Game:setFlag("skipped_intro", true)
                    Assets.playSound("item", 0.1, 1.2)
                    skip_hint:remove()
                    Game.world.music:stop()
                    Input.clear("c")
                    Input.clear("d")
    
                    -- NOTE: when this cutscene gets complex we may need to do
                    -- some fallback configurations here
                    cutscene:after(function()
                        --[[if sideb_file_found then
                            Game.world.timer:after(2, function()
                                Game.world:startCutscene("_main.snowgraveskip")
                            end)
                        else]]
                            Game.tutorial = true
                            Game.world:loadMap("grey_cliffside/cliffside_start", nil, "down")
                            Game.world:startCutscene("cliffside.intro")
                        --end
                    end)
                    cutscene:endCutscene()
                end
            end)
    
            cutscene:wait(0.5)
            local skip_hint_fade_time = 4
            if Game:getGlobalFlag("Intro_seen") then
                cutscene:wait(2)
                skip_hint_fade_time = 2
            end
    
            cutscene.world.timer:tween(skip_hint_fade_time, skip_hint_alphafx, {alpha = 0})
            cutscene:wait(skip_hint_fade_time)
    
            skip_hint:remove()
            can_exit = false
        end

        gonerText("ARE YOU[wait:40]\nTHERE?[wait:20]")
        cutscene:wait(0.5)
        gonerText("ARE WE[wait:40]\nCONNECTED?[wait:20]")

        cutscene:wait(0.5)

        local soul = SoulAppearance(SCREEN_WIDTH / 2 - 25, SCREEN_HEIGHT / 2 + 20)
        soul:setParallax(0, 0)
        soul.layer = WORLD_LAYERS["below_textbox"]
        --soul.alpha = 50
        --soul.graphics.fade = 0.01
        --soul.graphics.fade_to = 1
        local soul_movement = true
        cutscene:during(function()
            if soul_movement == true then
                soul.y = SCREEN_HEIGHT / 2 + 20 + math.sin(Kristal.getTime() * 2) * 6
            end
        end)
        if Game:isDessMode() then
            soul.sprite = Assets.getTexture("party/dess/walk/down_1")
            soul:setColor(1, 1, 1, 1)
        end
        Game.world:addChild(soul)
        cutscene:wait(1.75)

        if Game:isDessMode() then
            world_music:stop()
            gonerText("WAIT WHAT THE FUCK.[wait:20]")

            world_music:play("gimmieyourwalletmiss", 1, 1)
            cutscene:showNametag("Dess", {top = true, right = false})
            cutscene:text("* hey guys its me dess from hit kristal mod dark place", "condescending", "dess", {top = true})
            cutscene:hideNametag()
            gonerText("WHAT THE HELL ARE\nYOU DOING HERE.[wait:20]")
            cutscene:showNametag("Dess", {top = true, right = false})
            cutscene:text("* uhhh being the main character?", "calm", "dess", {top = true})
            cutscene:hideNametag()
            gonerText("YOU ARE NOT SUPPOSED\nTO BE HERE.[wait:20]")
            cutscene:showNametag("Dess", {top = true, right = false})
            cutscene:text("* idc lol", "condescending", "dess", {top = true})
            cutscene:text("* man who knew that wing gaster would be so lame", "annoyed", "dess", {top = true})
            cutscene:hideNametag()
            gonerText("YOU INSOLATE CHILD.[wait:20]")
            gonerText("THAT IS DR. W.D.\nGASTER TO YOU.[wait:20]")
            cutscene:showNametag("Dess", {top = true, right = false})
            cutscene:text("* dont care + didnt ask + ratio + you shattered across time and space", "calm_b", "dess", {top = true})
            cutscene:hideNametag()
            gonerText("...[wait:20]")
            gonerText("FINE.[wait:20]")
            gonerText("IF YOU'RE GOING TO\nACT LIKE THAT.[wait:20]")
            gonerText("THEN SO BE IT.[wait:20]")
            gonerText("I HAVE VERY IMPORTANT\nMATTERS TO ATTEND\nTO RIGHT NOW.[wait:20]")
            gonerText("SO I SHALL RETURN YOU[wait:20]")
            gonerText("FROM WHENCE.[wait:30]\nYOU.[wait:30]\nCAME.[wait:30]")
            cutscene:wait(1.5)
            soul:shake(5)
            Assets.stopAndPlaySound("wing")
            world_music:fade(0, 1)
            cutscene:wait(1.5)
            cutscene:showNametag("Dess", {top = true, right = false})
            cutscene:text("* wait what", "wtf", "dess", {top = true})
            cutscene:hideNametag()
            soul:shake(5)
            Assets.stopAndPlaySound("wing")
            cutscene:wait(1)
            soul:shake(5)
            Assets.stopAndPlaySound("wing")
            cutscene:wait(1)
            local shake = 0
            while shake < 15 do
                shake = shake + 1
                soul:shake(5)
                Assets.stopAndPlaySound("wing")
                cutscene:wait(0.5/shake)
            end
            soul_movement = false
            cutscene:wait(3)
            soul.physics.speed_x = 0
            soul.physics.speed_y = 0
            soul.physics.gravity = 1
            Assets.playSound("closet_fall")
            cutscene:wait(4)
            Assets.playSound("locker")
            cutscene:wait(2)

            cutscene:after(function()
                Game:setGlobalFlag("Intro_seen", true)
                Game.tutorial = true
                Game.world:mapTransition("hub_dess_house", nil, "down")
                Game.world:startCutscene("dessmode.intro")
            end)
        else
            gonerText("EXCELLENT.[wait:20]")
            cutscene:wait(0.5)
            gonerText("TRULY[wait:20]\nEXCELLENT.[wait:20]")
            cutscene:wait(0.5)
            gonerText("NOW.[wait:20]")
    
            cutscene:wait(0.5)
            gonerText("WE MAY-")
    
            world_music:stop()
            Assets.playSound("wing")
            gonerText("SHIT-")
            Assets.playSound("closet_fall")
    
    
            for i = 1, 8 do
                local head = Sprite("world/cutscenes/intro/vessel/IMAGE_GONERHEAD_"..i, 320, -50)
                head.layer = soul.layer - 1
                head:setScale(3)
                head:setParallax(0, 0)
                head:setOrigin(0.5, 0.5)
                head.physics.speed_x = Utils.random(-4, 4)
                head.physics.speed_y = Utils.random(-8, -4)
                head.physics.gravity = Utils.random(0.5, 1)
                head.graphics.spin = Utils.random(0.1, 0.25)
                Game.world:addChild(head)
            end
    
            cutscene:wait(0.2)	
    
            for i = 1, 6 do
                local body = Sprite("world/cutscenes/intro/vessel/IMAGE_GONERBODY_"..i, 320, -50)
                body.layer = soul.layer - 2
                body:setScale(3)
                body:setParallax(0, 0)
                body:setOrigin(0.5, 0.5)
                body.physics.speed_x = Utils.random(-4, 4)
                body.physics.speed_y = Utils.random(-8, -4)
                body.physics.gravity = Utils.random(0.5, 1)
                body.graphics.spin = Utils.random(0.1, 0.25)
                Game.world:addChild(body)
            end
    
            cutscene:wait(0.2)	
    
            for i = 1, 5 do
                local legs = Sprite("world/cutscenes/intro/vessel/IMAGE_GONERLEGS_"..i, 320, -50)
                legs.layer = soul.layer - 3
                legs:setScale(3)
                legs:setParallax(0, 0)
                legs:setOrigin(0.5, 0.5)
                legs.physics.speed_x = Utils.random(-4, 4)
                legs.physics.speed_y = Utils.random(-8, -4)
                legs.physics.gravity = Utils.random(0.5, 1)
                legs.graphics.spin = Utils.random(0.1, 0.25)
                Game.world:addChild(legs)
            end
    
    
    
            cutscene:wait(5)
            Assets.playSound("badexplosion")
            cutscene:wait(0.5)
            gonerText("...[wait:20]")
            gonerText("I DROPPED THE FUCKING[wait:40]\nGONER PIECES.[wait:20]")
            gonerText("OKAY NO NEED TO\nPANIC I JUST NEED\nTO FIND A REPLACEMENT.[wait:20]")
            gonerText("JUST...\n[wait:40]GIMME A MINUTE,\nOKAY?[wait:20]")
            cutscene:wait(2.5)
            gonerText("...[wait:20]")
            cutscene:wait(2.5)
            gonerText("...[wait:20]")
            cutscene:wait(2.5)
            gonerText("FOUND IT.[wait:20]")
            gonerText("NOW.[wait:20]")
    
            cutscene:wait(0.5)
            gonerText("WE MAY[wait:40]\nBEGIN\n[wait:20]")
            cutscene:wait(1.25)
    
            soul:hide()
    
            cutscene:wait(1.75)
    
            local background = GonerBackground(nil, nil, "AUDIO_EXPERIMENT", true, world_music)
            background.layer = WORLD_LAYERS["ui"]
            Game.world:addChild(background)
    
            cutscene:wait(1)
    
            local hero_sprite = Sprite("hero", 320, 240, nil, nil, "world/cutscenes/intro")
            hero_sprite.parallax_x = 0
            hero_sprite.parallax_y = 0
            hero_sprite:setOrigin(0.5, 0.5)
            hero_sprite:setScale(3)
            hero_sprite.layer = WORLD_LAYERS["below_textbox"]
            hero_sprite.alpha = 0
            hero_sprite.graphics.fade = 0.01
            hero_sprite.graphics.fade_to = 1
            Game.world:addChild(hero_sprite)
    
            local chara_x = { 320 }
            local chara_y = { 270 }
            local siner = 0
    
            cutscene:during(function()
                siner = siner + DTMULT
                
                local offset_x, offset_y = math.sin(siner / 24) * 2, math.sin(siner / 30) * 2
                hero_sprite.x = chara_x[1] + offset_x * 6
                hero_sprite.y = chara_y[1] + offset_y * 6
            end)
    
            gonerText("THIS[wait:40]\nIS YOUR VESSEL.[wait:20]")
    
            cutscene:wait(1)
    
            gonerText("ITS NAME[wait:40]\nIS-")
            gonerText("OKAY SO I MADE THIS\nLIKE OVER A\nDECADE AGO.[wait:20]")
            gonerText("SO THE NAME IS\nKINDA ASS.[wait:20]")
            gonerText("SO LET'S JUST SAY\nTHEIR NAME IS \"HERO\"\nAND MOVE ON,[wait:5] OKAY?[wait:20]")
            gonerText("ANYWAYS[wait:20]")
            gonerText("ITS NAME[wait:40]\nIS \"HERO\"[wait:20]")
            cutscene:wait(0.5)
    
            gonerText("DO YOU ACCEPT[wait:40]\nTHIS VESSEL?[wait:20]", false)
    
            cutscene:wait(4)
    
            local chosen = nil
            local choicer = GonerChoice(220, 360, {
                { { "YES", 0, 0 }, { "<<" }, { ">>" }, { "NO", 160, 0 } }
            }, function(choice)
                chosen = choice
            end)
            choicer:setSelectedOption(2, 1)
            choicer:setSoulPosition(80, 0)
            Game.stage:addChild(choicer)
    
            cutscene:wait(function() return chosen ~= nil end)
    
            gonerTextFade()
    
            if chosen == "YES" then
                gonerText("EXCELLENT.[wait:20]")
                gonerText("TRULY[wait:40]\nEXCELLENT.[wait:20]")
    
                cutscene:wait(0.75)
            else
                Game:setFlag("_main_vesselno", true)
                gonerText("WELL I HAVE LITERALLY\nNOTHING ELSE.")
                gonerText("SO FUCK YOU,[wait:5]\nWE'RE GOING WITH IT\nANYWAYS.")
                gonerText("...[wait:20]")
                cutscene:wait(0.5)
                gonerText("I'M SORRY[wait:40]\nTHAT WAS VERY...[wait:20]")
                cutscene:wait(0.5)
                gonerText("UNPROFESSIONAL[wait:40]\nOF ME.[wait:20]")
                cutscene:wait(0.5)
                gonerText("I APOLOGIZE[wait:40]\nFOR YELLING AT YOU.[wait:20]")
    
                cutscene:wait(0.75)
            end
    
            gonerText("ANYWAYS.[wait:20]")
            cutscene:wait(0.5)
            gonerText("THE PURPOSE[wait:40]\nOF THIS MEETING.[wait:20]")
            cutscene:wait(0.5)
            gonerText("THE FABRIC OF REALITY[wait:40]\nIS AT STAKE.[wait:20]")
            cutscene:wait(0.5)
            gonerText("CONTRARY TO WHAT[wait:40]\nYOU PREVIOUSLY THOUGHT...[wait:20]")
            cutscene:wait(0.5)
            gonerText("THERE IS NO SUCH THING[wait:40]\nAS \"THE ROARING\"[wait:20]")
            cutscene:wait(0.5)
            gonerText("IT IS SOMETHING[wait:40]\nI MADE UP.[wait:20]")
            cutscene:wait(0.5)
            gonerText("TO PREVENT PEOPLE[wait:40]\nFROM CREATING[wait:40]\nDARK FOUNTAINS.[wait:20]")
            cutscene:wait(0.5)
            gonerText("AS THAT WOULD CAUSE[wait:40]\nREALITY TO BECOME...[wait:20]")
            cutscene:wait(0.5)
            gonerText("VERY[wait:40]\nUNSTABLE.[wait:20]")
            cutscene:wait(0.5)
            gonerText("BUT IT SEEMS LIKE[wait:40]\nA VERY CERTAIN[wait:40]\nDELTA WARRIOR...[wait:20]")
            cutscene:wait(0.5)
            gonerText("HAS REALIZED THAT.[wait:20]")
            cutscene:wait(0.5)
            gonerText("YES[wait:40]\nA THOUSAND FOUNTAINS[wait:40]\nHAVE BEEN CREATED.[wait:20]")
            cutscene:wait(0.5)
            gonerText("I PAID RALSEI A GOOD\nSALARY TO PREVENT\nTHIS FROM HAPPENING.[wait:20]")
            cutscene:wait(0.5)
            gonerText("ANYWAYS.[wait:20]")
            cutscene:wait(0.5)
            gonerText("YOUR MISSION.[wait:20]")
            cutscene:wait(0.5)
            gonerText("IS TO PREVENT REALITY[wait:40]\nFROM COLLAPSING.[wait:20]")
            cutscene:wait(0.5)
    
            gonerText("DO YOU ACCEPT[wait:40]\nTHIS MISSION?[wait:20]", false)
    
            cutscene:wait(4)
    
            chosen = nil
            choicer = GonerChoice(220, 360, {
                { { "YES", 0, 0 }, { "<<" }, { ">>" }, { "NO", 160, 0 } }
            }, function(choice)
                chosen = choice
            end)
            choicer:setSelectedOption(2, 1)
            choicer:setSoulPosition(80, 0)
            Game.stage:addChild(choicer)
    
            cutscene:wait(function() return chosen ~= nil end)
    
            gonerTextFade()
    
            if chosen == "YES" then
                gonerText("EXCELLENT.[wait:20]")
                gonerText("TRULY[wait:40]\nEXCELLENT.[wait:20]")
    
                cutscene:wait(0.75)
            else
                if Game:getFlag("_main_vesselno") then
                    gonerText("OKAY YOU ARE\nREALLY STARTING TO\nPISS ME OFF.[wait:20]")
                    gonerText("LIKE SERIOUSLY?[wait:20]")
                    gonerText("I TAKE BACK\nMY APOLOGY.[wait:20]")
                    gonerText("YOU'RE GONNA\nSAVE THE WORLD.[wait:20]")
                    gonerText("WHETHER YOU LIKE IT\nOR NOT.[wait:20]")
                else
                    gonerText("THAT WAS[wait:40]\nA RHETORICAL QUESTION.[wait:20]")
                    cutscene:wait(0.5)
                    gonerText("WHY ARE YOU EVEN HERE[wait:40]\nIF NOT TO PLAY\nTHE GAME?[wait:20]")
                    cutscene:wait(0.5)
                    gonerText("WHATEVER.[wait:20]")
                end
    
                cutscene:wait(0.75)
            end
    
            gonerText("NOW.[wait:20]")
            cutscene:wait(0.5)
            gonerText("THE FUTURE[wait:20]")
            cutscene:wait(1)
            Assets.playSound("locker")
            Kristal.hideBorder()
            world_music:stop()
            background:remove()
            hero_sprite:remove()
            cutscene:wait(1)
            gonerText("IS IN YOUR HANDS[wait:20]")
            cutscene:wait(1.5)
            Game.fader:fadeOut {speed = 0}
    
            cutscene:after(function()
                Game:setGlobalFlag("Intro_seen", true)
                Game.tutorial = true
                Game.world:mapTransition("grey_cliffside/cliffside_start", nil, "down")
                Game.world:startCutscene("cliffside.intro")
            end)

        end
    end,
}
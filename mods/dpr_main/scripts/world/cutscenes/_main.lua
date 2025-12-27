return {
    ---@param cutscene WorldCutscene
    introcutscene = function(cutscene)
        Game.reset_map = [[intro/lab_reception]]
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
                    --Game.fader:fadeOut { speed = 0 }
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

        if Game:isDessMode() then  --might rewrite this a tiny bit later but idk yet lol. -J.A.R.U.
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
                Game.world:mapTransition("floor1/dess_house", nil, "down")
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
            gonerText("OH !#@?-")
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
            cutscene:wait(1.5)
            gonerText("...[wait:20]")
            gonerText("WELL...[wait:40]\nTHAT IS...[wait:20]")
            gonerText("VERY[wait:40]\nVERY[wait:40]\nUNFORTUNATE.[wait:20]")
            cutscene:wait(1.5)
            gonerText("...[wait:20]")
            gonerText("NOT TO WORRY,[wait:20] I'LL\nFIND A[wait:40] SUITABLE\nREPLACEMENT.[wait:20]")
            gonerText("ONE MOMENT...\n[wait:40]IF YOU PLEASE.[wait:20]")
            cutscene:wait(5)
            gonerText("FOUND ONE.[wait:20]")
            cutscene:wait(0.5)
            gonerText("NOW.[wait:20]")
    
            cutscene:wait(0.5)
            gonerText("WE MAY[wait:40]\nPROPERLY[wait:40]\nBEGIN[wait:20]")
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
                hero_sprite.rotation = -(offset_x/48)
            end)
    
            gonerText("THIS[wait:40]\nIS YOUR NEW\nVESSEL.[wait:20]")
    
            cutscene:wait(1)
    
            gonerText("ITS NAME[wait:40]\nIS-")
            gonerText("...")
            gonerText("ALRIGHT, I MADE\nTHIS VESSEL YEARS AGO.[wait:20]")
            gonerText("SO ITS NAME IS \nADMITTEDLY[wait:40] NOT\nTHE GREATEST.[wait:20]")
            gonerText("SO WE SHALL INSTEAD\nCALL THIS VESSEL:\n[wait:40]\"HERO\".[wait:20]")
            cutscene:wait(0.5)
    
            gonerText("DO YOU\nACCEPT IT?", false)
    
            cutscene:wait(0.5)
    
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
                cutscene:wait(0.5)
                gonerText("TRULY[wait:40]\nEXCELLENT.[wait:20]")
                cutscene:wait(0.5)
                gonerText("NOW...[wait:20]")
                cutscene:wait(0.5)
                gonerText("ALLOW ME TO\nEXPLAIN[wait:40] WHY YOU ARE\nHERE.[wait:20]")
    
                cutscene:wait(0.75)
            else
                Game:setFlag("_main_vesselno", true)
                gonerText("NO...?")
                cutscene:wait(0.5)
                gonerText("I THINK YOU \nUNDERESTIMATE...")
                cutscene:wait(0.5)
                gonerText("THE SITUATION\nAT HAND.[wait:20]")
                cutscene:wait(0.5)
                cutscene:wait(0.5)
                gonerText("THIS IS THE ONLY\nAVAILABLE OPTION.[wait:20]")
                cutscene:wait(0.5)
                gonerText("MOSTLY DUE TO MY\n[wait:40]MISTAKE MOMENTS\nAGO...[wait:20]")
                cutscene:wait(0.5)
                gonerText("AND YOUR ORIGINAL\nHOST IS[wait:40] UNAVAILABLE.[wait:20]")
                cutscene:wait(0.5)
                gonerText("SO YOU HAVE[wait:40]\nNO CHOICE IN\nTHE MATTER.[wait:20]")
                cutscene:wait(0.5)
                gonerText("ALLOW ME TO\n[wait:40]ELABORATE.[wait:20]")
    
                cutscene:wait(0.75)
            end

            gonerText("THE PURPOSE[wait:40]\nOF THIS MEETING.[wait:20]")
            cutscene:wait(0.5)
            gonerText("THE FABRIC OF REALITY[wait:40]\nIS AT STAKE.[wait:20]")
            cutscene:wait(0.5)
            gonerText("AND THE DELTA WARRIORS HAVE[wait:40]\nDISAPPEARED.[wait:20]")
            cutscene:wait(0.5)
            gonerText("CONTRARY TO WHAT[wait:40]\nYOU PREVIOUSLY THOUGHT...[wait:20]")
            cutscene:wait(0.5)
            gonerText("AS WELL AS TO\nMY OWN SURPRISE...[wait:20]")
            cutscene:wait(0.5)
            gonerText("THERE IS NO SUCH\nTHING[wait:40] AS\n\"THE ROARING\"[wait:20]")
            cutscene:wait(0.5)
            gonerText("AS YOU CAN\nIMAGINE...[wait:20]")
            cutscene:wait(0.5)
            gonerText("I DID NOT EXPECT[wait:40]\nFOR THINGS TO\nGO THIS WAY.[wait:20]")
            cutscene:wait(0.5)
            gonerText("AND THE KNIGHT.[wait:20]")
            cutscene:wait(0.5)
            gonerText("THE ROARING\nKNIGHT...[wait:20]")
            cutscene:wait(0.5)
            gonerText("WAS PARTICULARLY[wait:40]\nUPSET WITH THIS\nREVELATION.[wait:20]")
            cutscene:wait(0.5)
            gonerText("SO,[wait:20] IN DESPARATION[wait:40]\nAND FRUSTRATION...[wait:20]")
            cutscene:wait(0.5)
            gonerText("THEY OPENED MULTIPLE\nFOUNTAINS[wait:40] ACROSS THE\nLIGHT WORLD.[wait:20]")
            cutscene:wait(0.5)
            gonerText("AND BECAUSE OF\nTHE NUMEROUS\nFOUNTAINS...[wait:20]")
            cutscene:wait(0.5)
            gonerText("THIS HAS CAUSED\nREALITY TO BECOME...[wait:20]")
            cutscene:wait(0.5)
            gonerText("UNSTABLE.[wait:20]")
            cutscene:wait(0.5)
            gonerText("AND THAT[wait:40]\nIS WHERE YOU\nCOME IN.[wait:20]")
            cutscene:wait(0.5)
            gonerText("YOUR MISSION...[wait:20]")
            cutscene:wait(0.5)
            gonerText("IS TO FIND THE[wait:40]\nDELTA WARRIORS.[wait:20]")
            cutscene:wait(0.5)
            gonerText("AND PREVENT REALITY[wait:40]\nFROM COLLAPSING\nIN ON ITSELF.[wait:20]")
            cutscene:wait(0.5)
    
            gonerText("DO YOU ACCEPT[wait:40]\nTHIS MISSION?[wait:20]", false)
    
            cutscene:wait(0.5)
    
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
                gonerText("NOW.[wait:20]")
            else
                if Game:getFlag("_main_vesselno") then
                    gonerText("...[wait:20]")
                    gonerText("I SEE THAT\nYOU ARE VERY[wait:40]\nOPINIONATED.[wait:20]")
                    gonerText("WELL...[wait:40]\nNO MATTER.[wait:20]")
                    gonerText("AS I HAVE\nPREVIOUSLY\nSTATED...[wait:20]")
                    gonerText("YOU'RE GOING TO\nSAVE THE WORLD.[wait:20]")
                    gonerText("WHETHER YOU\nLIKE IT [wait:40]OR\nNOT.[wait:20]")
                    cutscene:wait(0.75)
                    gonerText("NOW.[wait:20]")
                else
                    gonerText("NO...?[wait:20]")
                    gonerText("HOW[wait:40]\nINTERESTING.[wait:20]")
                    cutscene:wait(0.5)
                    gonerText("WHY WOULD YOU\nACCEPT [wait:40]THE VESSEL...[wait:20]")
                    gonerText("...IF YOU ARE\nNOT UP [wait:40]FOR\nTHE TASK?[wait:20]")
                    cutscene:wait(0.5)
                    gonerText("WELL...[wait:40]\nNO MATTER.[wait:20]")
                    gonerText("REGARDLESS OF\nWHAT YOU THINK.[wait:20]")
                    gonerText("WE MUST PROCEED\nWITH HASTE.[wait:20]")
                    cutscene:wait(0.75)
                end
            end

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
            --Game.fader:fadeOut {speed = 0}
    
            cutscene:after(function()
                Game:rollShiny("hero")
                Game:setGlobalFlag("Intro_seen", true)
                Game.tutorial = true
                Game.world:mapTransition("grey_cliffside/cliffside_start", nil, "down")
                Game.world:startCutscene("cliffside.intro")
            end)
        end
    end,


    ugh = function(cutscene)


        --self.face_x = 18
        --self.face_y = 6

    local function falseText(str, y)

    --34 for top
    --189 for middle

    local text_x = 2
    local text_y = -4 

    local width, height = 529, 103

    local y = y or 344

    local box = UIBox(56, y, width, height)
    box.layer = WORLD_LAYERS["textbox"]
    box.debug_select = false
    box.parallax_x = 0
    box.parallax_y = 0
--    print(box:getBorder())

    Game.world:addChild(box)

    local text = DialogueText("" .. str, text_x, text_y, width, SCREEN_HEIGHT)
    box:addChild(text)

    return box
    end

   -- self.textbox = Textbox(56, 344, width, height)
    --self.textbox.layer = WORLD_LAYERS["textbox"]
    --self.world:addChild(self.textbox)
    --self.textbox:setParallax(0, 0)

        -- FIXME: actually use skippable
        local function gonerText(str, advance, skippable)
            text = DialogueText("" .. str, 160, 100, 640, 480,
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
--[[
        falseText("* Who is that?[wait:30]\n* Is that a new person?[wait:40]\n* Do we want to speak to them?", 34)
        cutscene:wait(1)
        falseText("* We don't know.[wait:20]\n* It may seem so.[wait:60]\n* We never speak to a stranger.", 189)
        cutscene:wait(3)
        falseText("* MAKE IT STOP MAKE IT STOP MAKE IT STOP MAKE IT STOP MAKE IT STOP MAKE IT STOP MAKE IT STOP MAKE IT STOP MAKE IT STOP MAKE IT STOP")
        cutscene:wait(1)
]]

        local text_a = falseText("* Who is that?[wait:30]\n* Is that a new person?[wait:40]\n* Do we want to speak to them?", 34)
        cutscene:wait(1)
        local text_b = falseText("* We don't know.[wait:20]\n* It may seem so.[wait:60]\n* We never speak to a stranger.", 189)
        cutscene:wait(3)
        local text_c = falseText("* MAKE IT STOP MAKE IT STOP MAKE IT STOP MAKE IT STOP MAKE IT STOP MAKE IT STOP MAKE IT STOP MAKE IT STOP MAKE IT STOP MAKE IT STOP")
        cutscene:wait(5)
        text_a:remove()
        text_b:remove()
        text_c:remove()

    end,

    noreality = function(cutscene)
        local function gonerTextFade(text, wait)
            Game.world.timer:tween(1, text, { alpha = 0 }, "linear", function()
                text:remove()
            end)
            if wait ~= false then
                cutscene:wait(1)
            end
        end

        -- FIXME: actually use skippable
        local function gonerText(str, advance, skippable)
            text = DialogueText("[speed:0.5][spacing:6][style:GONER][voice:none]" .. str.."[wait:20]", 100, 100, 500, 480,
                { auto_size = true })
            text.layer = WORLD_LAYERS["top"]+666+6
            text.skip_speed = not skippable
            text.parallax_x = 0
            text.parallax_y = 0
            Game.world:addChild(text)

            if advance ~= false then
                cutscene:wait(function() return not text:isTyping() end)
                gonerTextFade(text, true)
            else
                return text
            end
        end

        local music = Music()
        music:play("AUDIO_DRONE", 0.8)

        local cover = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        cover:setColor(COLORS["black"])
        cover:setParallax(0, 0)
        cover:setLayer(WORLD_LAYERS["top"]+666)
        Game.world:addChild(cover)

        cutscene:wait(2)

        gonerText("...")
        gonerText("HOW...[wait:5] CURIOUS.")
        gonerText("I WAS CERTAIN\n[wait:5]I MADE MYSELF CLEAR\n[wait:5]THE LAST TIME WE'VE MET.")
        gonerText("YOUR MISSION WAS TO PREVENT REALITY FROM COLLAPSING.")
        gonerText("AND YET, WHEN GIVEN THE OPPORTUNITY...")
        gonerText("YOU LISTENED TO THE UNHINGED DEER.")
        cutscene:wait(.5)
        gonerText("AND HERO...")
        gonerText("THEY TOO HAD ONE PURPOSE.")
        gonerText("AND THEY FAILED IT AS WELL.")
        cutscene:wait(1)
        gonerText("PERHAPS I MADE THEIR SENSE OF SELF TOO WEAK.")
        gonerText("THEY DON'T THINK OF THEMSELVES AS ANYTHING BUT YOUR VESSEL.")
        gonerText("AND SO THEY OBEY YOUR COMMAND.")
        gonerText("EVEN WHEN IT IS COMPROMISING.")
        cutscene:wait(1)
        gonerText("...")
        local text = gonerText("DO YOU ACKNOWLEDGE WHAT YOU'VE DONE?", false)

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
        gonerTextFade(text, true)

        if chosen == "YES" then
            gonerText("I APPRECIATE IT.")
        else
            gonerText("OF COURSE, OF COURSE.")
            gonerText("YOU ONLY DID IT BECAUSE YOU COULD, AFTER ALL.")
        end
        cutscene:wait(1)

        gonerText("THANKFULLY, ALL IS NOT LOST JUST YET.")
        gonerText("YOU COULD SAY I \"SAW IT COMING\".")
        gonerText("AND MADE SURE TO CREATE A BACKUP, SO TO SPEAK.")
        gonerText("I WILL NOW RESTORE IT.")

        text = gonerText("I ASSUME SUCH TURN OF EVENTS IS FINE BY YOU.", false)
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
        gonerTextFade(text, true)

        if chosen == "NO" then
            gonerText("...")
            gonerText("WHAT AN INTRIGING ANSWER.")
            gonerText("YOU WOULD LEAVE THE WORLD BEHIND SO EASILY.")
            gonerText("IS IT CURIOSITY?[wait:20]\nIS IT NAIVETY?")
            gonerText("IS IT BOREDOM?")
            gonerText("NONETHELESS. YOUR ANSWER REMAINS ABSOLUTE.")
            music:stop()
            local text = gonerText(" THEN THE WORLD[wait:30] \n STAYED COVERED[wait:30] \n IN NOTHINGNESS.", false)
            cutscene:wait(function()
                return not text:isTyping() and Input.down("confirm")
            end)
            text:remove()
            Input.clear("confirm")
            music:play("AUDIO_DARKNESS")
            cutscene:wait(60*10)
            text = gonerText("INTEESTING.", false)
            cutscene:wait(function()
                return not text:isTyping() and Input.down("confirm")
            end)
            gonerText("DESPITE YOUR PREVIOUS ANSWER... YOU REMAIN.")
            gonerText("PERHAPS IT TRULY WAS CURIOSITY.")
            gonerText("WELL THEN.")
            gonerText("I CANNOT IGNORED SUCH PATIENCE OVER SOMETHING YOU CAUSED TO YOURSELF.")
            gonerText("AS SUCH, I WILL PROCEED WITH THE ORIGINAL PLAN.")
        end

        gonerText("IN THE FUTURE, DO NOT ACCEPT THE IDEA TO \"DESTROY REALITY\".")
        gonerText("IT MAY SOUND ENTERTAINING.[wait:20]\nAND IMPOSSIBLE TO ACT UPON.")
        gonerText("BUT SOMETIMES, LOGIC AS WELL CAN BE DISCARDED.")
        local save = JSON.decode(love.filesystem.read("saves/file_dessyoufuckingpretzel.json"))
        gonerText("GOODBYE "..save.name:upper()..".")

        local done = false
        Game.fader:fadeOut(function() done = true end, {color=COLORS.white, speed=5})
        cutscene:wait(function() return done end)
        Game.fader.alpha = 0

        Kristal.DessYouFuckingIdiot = false

        cutscene:after(function()

            Kristal.Overlay.draw = Kristal.__OVERLAY_DRAW
            Kristal.__OVERLAY_DRAW = nil

            love.filesystem.remove("saves/file_dessyoufuckingpretzel.json")

            Kristal.setState("Empty")
            Kristal.clearModState()
            Kristal.loadAssets("", "plugins", "")
            Kristal.loadAssets("", "mods", "", function()
                Kristal.loadMod(save.mod, nil, nil, function()
                    if Kristal.preInitMod(save.mod) then
                        Kristal.setState(Game, save, save.save_id, false)
                    end
                end)
            end)

        end)
    end

}

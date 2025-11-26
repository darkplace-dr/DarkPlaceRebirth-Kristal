return {
    ---@param cutscene WorldCutscene
    mranttenna = function(cutscene)
        if Game:getFlag("can_kill") then
            return
        end

        local susie = cutscene:getCharacter("susie")
        local tenna = cutscene:getCharacter("tenna")

        if Game.world.player.facing == "left" then
            tenna.sprite.flip_x = true
        end

        if not Game:getFlag("tenna_introduction") then
            Game:setFlag("tenna_introduction", true)
            if susie then
                tenna.sprite:setTennaSprite(1, nil, 1)
                cutscene:showNametag("Tenna")
                cutscene:text("* WELL,[wait:5] if it isn't one of my FAVORITE [funnytext:star,sparkle_glock,0,-10,73,30] contestants!", nil, "tenna")

                cutscene:showNametag("Susie")
                cutscene:text("* Tenna?[wait:10]\n* The hell are you doing here?", "surprise", "susie")

                cutscene:showNametag("Tenna")
                cutscene:text("* Haha!![wait:10]\n* YOUR guess is as good as MINE,[wait:5] Susie!!", nil, "tenna")
                tenna.sprite:setTennaSprite(2, nil, 1)
                cutscene:text("* But hey,[wait:5] I thought while I was in this tower...", nil, "tenna")
                tenna.sprite:setTennaSprite(4, nil, 1)
                cutscene:text("* I'd set up my own floor!!", nil, "tenna")
                tenna.sprite:setTennaSprite(0, "pose_podium_2", 1)
                cutscene:text("* Anyways...", nil, "tenna")
            end
            tenna.sprite:setTennaSprite(2, nil, 1)
            cutscene:showNametag("Tenna")
            cutscene:text("* Welcome to the TENNA ROOM!", nil, "tenna") -- TODO: "Tenna Room" should be a funnytext
            cutscene:text("* It's a FAMILY REUNION,[wait:5] and an invite has been sent to EVERY SINGLE ONE of my RELATIVES!", nil, "tenna")
            tenna.sprite:setTennaSprite(2, "whisper", 1)
            cutscene:text("* [funnytext:mike_send,nil,-10,5,192,32][wait:15]", nil, "tenna")
            tenna.sprite:setTennaSprite(1, nil, 1)
            cutscene:text("* Granted,[wait:5] he JUST did that,[wait:5] so it's only just ME,[wait:5] MYSELF,[wait:5] and I here!", nil, "tenna")
            tenna.sprite:setTennaSprite(21, nil, 1)
            cutscene:showNametag("Mr. (Ant) Tenna")
            cutscene:text("* But for the sake of clarity,[wait:5] you can just call me MR. (ANT) TENNA!", nil, "tenna") -- TODO: "Mr. "Ant" Tenna" should also be a funnytext
            tenna.sprite:setTennaSprite(0, "bulletin", 1)
            cutscene:text("* Now,[wait:5] uh,[wait:5] just a forewarning...", nil, "tenna")
            tenna.sprite:setTennaSprite(0, "tie_adjust_a", 1)
            cutscene:text("* Some of my relatives may have a...[wait:10] criminal record,[wait:5] shall we say?", nil, "tenna")
            tenna.sprite:setTennaSprite(4, nil, 1)
            cutscene:text("* But HEY![wait:10] Family is family![wait:10] \nWho am I to judge?", nil, "tenna")
            tenna.sprite:setTennaSprite(1, nil, 1)
            cutscene:text("* Anyways...", nil, "tenna")
        end

        tenna.sprite:setTennaSprite(2, nil, 1)
        cutscene:showNametag("Mr. (Ant) Tenna")
        cutscene:text("* Whaddya need from your good \nol' pal?", nil, "tenna")
        cutscene:hideNametag()

        local choicer = {"Why are\nyou 3D?", "Nothing", "Games"}
        if Game:getFlag("arlee_quest") then
            table.insert(choicer, "Starbits?")
        end

        local choice = cutscene:choicer(choicer)
        cutscene:showNametag("Mr. (Ant) Tenna")
        if choice == 1 then
            tenna.sprite:setTennaSprite(1, nil, 1)
            cutscene:text("* What?[wait:10]\n* Why do I look 3D?", nil, "tenna")

            tenna.sprite:setTennaSprite(0, "pose_podium_1", 0)
            Game.world.music:pause()
            cutscene:text("* ...", nil, "tenna")
            Game.world.music:resume()

            Assets.playSound("wing")
            tenna:shake()
            tenna.sprite:setTennaSprite(0, "tie_adjust_a", 1)
            cutscene:text("* Kid,[wait:5] did you hit your head or something?", nil, "tenna")
            tenna.sprite:setTennaSprite(4, nil, 1)
            cutscene:text("* You're 3D,[wait:5] I'm 3D,[wait:5] this WHOLE ROOM is 3D!", nil, "tenna")
            tenna.sprite:setTennaSprite(1, nil, 1)
            cutscene:text("* WHAT?[wait:5]\n* You think we're in some sorta VIDEO GAME or something?", nil, "tenna")
            cutscene:text("* And I'm rendered in a different artstyle from everything else??", nil, "tenna")
            tenna.sprite:setTennaAnim(1, "laugh", 1)
            Assets.playSound("whip_hard")
            Assets.playSound("laughtrack_short_temp")
            cutscene:text("* HAHAHA!!![wait:10] This is the FUNNIEST thing I've heard all day,[wait:5] folks!!", nil, "tenna")
            Assets.stopSound("laughtrack_short_temp")
        elseif choice == 2 then
            tenna.sprite:setTennaSprite(3, nil, 1)
            cutscene:text("* Well![wait:5] Give me a holler if you need me!!", nil, "tenna")
        elseif choice == 3 then
            tenna.sprite:setTennaSprite(2, "pose_podium_1", 1)
            cutscene:text("* The BOARDS?[wait:5]\n* Why,[wait:5] they've been out of \norder!", nil, "tenna")
            tenna.sprite:setTennaSprite(2, "whisper", 1)
            cutscene:text("* Making my games didn't come without a few issues,[wait:5] y'know!", nil, "tenna")
            tenna.sprite:setTennaSprite(1, nil, 1)
            cutscene:text("* Modding's harder than it \nlooks!", nil, "tenna")
            tenna.sprite:setTennaSprite(22, nil, 1)
            cutscene:text("* But,[wait:5] if you REALLY want to play the GAMES so badly...", nil, "tenna")
            tenna.sprite:setTennaSprite(1, nil, 1)
            cutscene:text("* Who am I to deny a COMEBACK SPECIAL!?", nil, "tenna")
            tenna.sprite:setTennaSprite(18, nil, 1)
            cutscene:text("* We'll get EVERYONE back together!!!", nil, "tenna")
            tenna.sprite:setTennaSprite(21, nil, 1)
            Assets.playSound("whip_hard")
            cutscene:text("* THAT INCLUDES YOU TOO,[wait:5] MIKE!!!", nil, "tenna")
            tenna.sprite:setTennaSprite(25, nil, 1)
            cutscene:text("* Kids, go talk to Ramb![wait:5]\n* He might have the old console on him!", nil, "tenna")
            tenna.sprite:setTennaSprite(2, "point_left", 1)
            Assets.playSound("whip_crack_only")
            cutscene:text("* Hurry![wait:5]\n* The fate of[funnytext:tv_time,ftext_enter,0,0,96,48][wait:5]is at stake!!", nil, "tenna")
            tenna.sprite:setTennaSprite(0, "pose_podium_2", 1)
            cutscene:text("* Heh,[wait:5] but that's only if you WANT to play, of course!", nil, "tenna")
            tenna.sprite:setTennaSprite(0, "whisper_blush", 1)
            cutscene:text("* I've learned by now that forcing someone to play NEVER works well.", nil, "tenna")
        elseif choice == 4 then
            if not Game:getFlag("tenna_physicalchallenge") then
                tenna.sprite:setTennaSprite(2, "pose_podium_1", 1)
                cutscene:text("* Huh?[wait:10] Have I seen any STARBITS lying around?", nil, "tenna")
                tenna.sprite:setTennaSprite(1, nil, 1)
                cutscene:text("* Well,[wait:5] as a matter of fact, I HAVE!", nil, "tenna")
                tenna.sprite:setTennaSprite(2, nil, 1)
                tenna:setAnimation("point_left")
                cutscene:text("* But don't think I'm just gonna give it to you for free.", nil, "tenna")
                tenna.sprite:setTennaSprite(17, nil, 1)
                cutscene:text("* In order to win this [funnytext:grand_prize,ftext_gunshot,0,0,148,28]...", nil, "tenna")
                tenna.sprite:setTennaSprite(21, nil, 1)
                cutscene:text("* YOU need to WIN a\n[funnytext:physical_challenge/physical_challenge,ftext_bounce,0,-10,195,34]!", nil, "tenna")
                tenna.sprite:setTennaSprite(2, nil, 1)
                cutscene:text("* The rules are simple:", nil, "tenna")
                tenna.sprite:setTennaSprite(24, nil, 1)
                cutscene:text("* Throughout this tower,[wait:5] there are 8 stickers featuring yours truly that you must collect.", nil, "tenna")
                tenna.sprite:setTennaSprite(21, nil, 1)
                cutscene:text("* Bring them all to me,[wait:5] and you'll win the STARBIT!", nil, "tenna")
                tenna.sprite:setTennaSprite(3, nil, 1)
                cutscene:text("* Now,[wait:5] are you READY?[wait:10] Because...", nil, "tenna")
                tenna.sprite:setTennaSprite(0, "point_at_screen_c", 1)
                Game.world.music:pause()
                cutscene:itsTVTime()
                Game.world.music:resume()
                Game:setFlag("tenna_physicalchallenge", true)
                Game:setFlag("challenge_stickers", 0)
            else
                local stickers = Game:getFlag("challenge_stickers")
                tenna.sprite:setTennaSprite(2, "pose_podium_3", 1)
                cutscene:text("* Let's see how many stickers \nyou have...", nil, "tenna")
                tenna.sprite:setTennaSprite(2, "pose_podium_4", 1)
                cutscene:text("* It seems you have "..stickers.." out of 8 stickers!", nil, "tenna")
                if stickers == 0 then
                    tenna.sprite:setTennaSprite(4, nil, 1)
                    cutscene:text("* WOW---!!![wait:5]\n* YOU haven't collected a SINGLE sticker!", nil, "tenna")
                    tenna.sprite:setTennaSprite(17, nil, 1)
                    cutscene:text("* Remember,[wait:5] the stickers look like me,[wait:5] you can't miss 'em.", nil, "tenna")
                end
            end
        end

        tenna.sprite:setTennaSprite(24, nil, 1)
        cutscene:hideNametag()
        tenna.sprite.flip_x = false
    end,

    ---@param cutscene WorldCutscene
    ---@param fctenna NPC
    forecastedtenna = function (cutscene, fctenna)
        -- Or as some say, "Funny Feline Tenna."
        -- Dialogue almost entirely written by TheSkerch.
        cutscene:setSpeaker(fctenna)
        cutscene:after(function () cutscene:hideNametag() end)
        cutscene:showNametag("FC!Tenna")
        if not Game:getFlag("tenna_introduction_forecasted") then
        end
        -- Game:setFlag("tenna_introduction_forecasted", true)
        local crude_c = true

        local options = {
            "Money",
            "Authorities",
            "New Future!",
        }

        if math.random() <= 0.10 then
            table.insert(options, "Identity")
        end

        local choice = cutscene:choicer(options)
        if choice == 1 then
            cutscene:text("* Oh MONEY you say??", "wink")
            cutscene:text("* Money? Are we sponsored by HONEY??", "troll")
            cutscene:text("* Well no actually... I DON'T KNOW what that IS!", "disapproving")
            cutscene:text("* But SPEAKING of MONEY... Do YOU have some??", "icantthinkofagoodnamebutiswearithasagooduse")
            cutscene:text("* Wait is that!", "pensive")
            cutscene:text("* Oh MAN I GOTTA bolt!", "wink")
        elseif choice == 2 then
            cutscene:text("* WHAT? WHAT did you say?", "disapproving")
            cutscene:text("* They're AFTER me???", "traumatized")
            cutscene:text("* Oh DAMMIT! Guess I gotta LIFT OFF!", "sad")
            cutscene:text("* With my lightspeedwings [font:main]sponsored all NEW FASHIONABLE[font:main_mono] pair of WINGS!", "smile")
        elseif choice == 3 then
            cutscene:text("* NEW Future!", "wink")
            cutscene:text("* NEW like all MY shows!\n* SOOOO relevant to the KIDS!", "smile")
            Assets.playSound("phone")
            cutscene:hideNametag()
            cutscene:wait(1)
            -- he recieves a call
            cutscene:showNametag("FC!Tenna")
            cutscene:text("* Wait, WHAT??? What are you SAYING???", "disapproving")
            cutscene:text("* I'm... not... NEW?", "gasp")
            cutscene:text("* I'm in the OLD PAST?", "gasp")
            cutscene:text("* ...", "sad")
            cutscene:text("* Sorry kids... I'm just gonna...", "sad")
            crude_c = false
        elseif choice == 4 then
            cutscene:text("* My IDENTITY!?", "gasp")
            cutscene:text("* Well,[wait:5] that's an easy one!", "wink")
            cutscene:text("* I'm deltarune", "smile_dated")
            cutscene:hideNametag()
            cutscene:wait(0.2)
            cutscene:showNametag("FC!Tenna")
            cutscene:text("* What's that face for?\n* Are you implying that...", "disapproving")
            cutscene:text("* I'm... not... deltarune!?", "gasp")
            cutscene:text("* ...", "smpte")
            cutscene:text("* YOU'RE LYING![wait:5]\n* I'M DELTARUNE![wait:5]\n* I'M DELTARUNE!", "smile")
            cutscene:text("* You're not DESERVING of my presence![wait:5]\n* I'm OUTTA HERE!", "troll")
            crude_c = true
        end
        cutscene:hideNametag()

        -- leaving this commented out because itsTVTime i mean its funny thanks vscode

        --[[
        fctenna.physics.gravity = -30/30
        fctenna.physics.friction = 1/30
        fctenna.graphics.spin = 0.01
        fctenna.physics.gravity_direction = 0.05 + (math.pi/2)
        ]]

        -- TODO: He should be sad if you choose new future
        fctenna:setAnimation("flying")
        fctenna.physics.speed_y = -4

        cutscene:wait(3)
        cutscene:showNametag("Mr. (Ant) Tenna")
        cutscene:setSpeaker("tenna")
        local funnytext = crude_c and "crude,funnyfelineboat_discovery" or "rude,funnyfelineboat_discovery"
        cutscene:text("* Well, THAT was [funnytext:"..funnytext..", -110, -40]!")
    end,

    ---@param cutscene WorldCutscene
    ---@param ectenna NPC
    eclipsetenna = function (cutscene, ectenna)
        cutscene:setSpeaker(ectenna)
        cutscene:after(function () cutscene:hideNametag() end)
		-- placeholder dialogue for now...
        cutscene:showNametag("DR:E!Tenna")
		ectenna:setSprite("lookleft")
		cutscene:text("[face:ooh]* Funny place we're in,\n[wait:5]eh?")
		ectenna:setSprite("idle")
		cutscene:text("[face:shit]* You wouldn't happen to\nknow any... directions\nwould you?")
		cutscene:text("[face:idle]* I mean listen kid:")
		cutscene:text("[face:ooh]* I got [wait:5]ACTORS. [wait:10]Actors\nthat I also pay[wait:5].[wait:5].[wait:5].")
		ectenna:setSprite("lookleft")
		cutscene:text("[face:what]* Lesser. [wait:5]Than most.")
		ectenna:setSprite("idle")
		cutscene:text("[face:what]* And if I'm not there,\n[wait:5]someone might take over.")
		cutscene:text("[face:what]* And if someone takes\nover, [wait:5]that means that\nthey might get PAID.")
		cutscene:text("[face:thefuck]* So the longer I'm out\nhere, [wait:5]the longer someone\nmight take [wait:10]MY [wait:10]MONEY.")
    end
}

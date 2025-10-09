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
                tenna.sprite:setPreset(1)
                cutscene:showNametag("Tenna")
                cutscene:text("* WELL,[wait:5] if it isn't one of my FAVORITE [funnytext:star,sparkle_glock,0,-10,73,30] contestants!", nil, "tenna")
                cutscene:showNametag("Susie")
                cutscene:text("* Tenna?[wait:10]\n* The hell are you doing here?", "surprise", "susie")
                cutscene:showNametag("Tenna")
                cutscene:text("* Haha!![wait:10]\n* YOUR guess is as good as MINE,[wait:5] Susie!!", nil, "tenna")
                tenna.sprite:setPreset(2)
                cutscene:text("* But hey,[wait:5] I thought while I was in this tower...", nil, "tenna")
                tenna.sprite:setPreset(4)
                cutscene:text("* I'd set up my own floor!!", nil, "tenna")
                tenna.sprite:setPreset(0)
                tenna:setSprite("pose_podium_2")
                cutscene:text("* Anyways...", nil, "tenna")
            end
            tenna.sprite:setPreset(2)
            cutscene:showNametag("Tenna")
            cutscene:text("* Welcome to the TENNA ROOM!", nil, "tenna") -- TODO: "Tenna Room" should be a funnytext
            cutscene:text("* It's a FAMILY REUNION,[wait:5] and an invite has been sent to EVERY SINGLE ONE of my RELATIVES!", nil, "tenna")
            tenna:setAnimation("whisper")
            cutscene:text("* I had Mike send them all out for me.", nil, "tenna") -- TODO: this should be like that whisper funnytext Tenna occasionally uses.
            tenna.sprite:setPreset(1)
            cutscene:text("* Granted,[wait:5] he JUST did that,[wait:5] so it's only just ME,[wait:5] MYSELF,[wait:5] and I here!", nil, "tenna")
            tenna.sprite:setPreset(21)
            cutscene:showNametag("Mr. (Ant) Tenna")
            cutscene:text("* But for the sake of clarity,[wait:5] you can just call me MR. (ANT) TENNA!", nil, "tenna") -- TODO: "Mr. "Ant" Tenna" should also be a funnytext
            tenna.sprite:setPreset(0)
            tenna:setSprite("bulletin")
            cutscene:text("* Now,[wait:5] uh,[wait:5] just a forewarning...", nil, "tenna")
            tenna.sprite:setPreset(0)
            tenna:setSprite("tie_adjust_a")
            cutscene:text("* Some of my relatives may have a...[wait:10] criminal record,[wait:5] shall we say?", nil, "tenna")
            tenna:setAnimation("whisper")
            tenna.sprite:setPreset(4)
            cutscene:text("* But HEY![wait:10] Family is family![wait:10] \nWho am I to judge?", nil, "tenna")
            tenna.sprite:setPreset(1)
            cutscene:text("* Anyways...", nil, "tenna")
        end

        tenna.sprite:setPreset(2)
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
            tenna.sprite:setPreset(1)
            cutscene:text("* What?[wait:10]\n* Why do I look 3D?", nil, "tenna")
            tenna.sprite:setPreset(0)
            tenna:setSprite("pose_podium_1")
            Game.world.music:pause()
            cutscene:text("* ...", nil, "tenna")
            Game.world.music:resume()
            Assets.playSound("wing")
            tenna:shake()
            tenna:setSprite("tie_adjust_a")
            cutscene:text("* Kid,[wait:5] did you hit your head or something?", nil, "tenna")
            tenna.sprite:setPreset(4)
            cutscene:text("* You're 3D,[wait:5] I'm 3D,[wait:5] this WHOLE ROOM is 3D!", nil, "tenna")
            tenna.sprite:setPreset(1)
            cutscene:text("* WHAT?[wait:5]\n* You think we're in some sorta VIDEO GAME or something?", nil, "tenna")
            cutscene:text("* And I'm rendered in a different artstyle from everything else??", nil, "tenna")
            tenna:setAnimation("laugh")
            Assets.playSound("whip_hard")
            Assets.playSound("laughtrack_short_temp")
            cutscene:text("* HAHAHA!!![wait:10] This is the FUNNIEST thing I've heard all day,[wait:5] folks!!", nil, "tenna")
            Assets.stopSound("laughtrack_short_temp")
        elseif choice == 2 then
            tenna.sprite:setPreset(3)
            cutscene:text("* Well,[wait:5] give me a holler if you need me.", nil, "tenna")
        elseif choice == 3 then
            tenna.sprite:setPreset(2)
            tenna:setSprite("pose_podium_1")
            cutscene:text("* The BOARDS?[wait:5]\n* Why,[wait:5] they've been out of \norder!", nil, "tenna")
            tenna:setAnimation("whisper")
            cutscene:text("* Making my games didn't come without a few issues,[wait:5] y'know!", nil, "tenna")
            tenna.sprite:setPreset(1)
            cutscene:text("* Modding's harder than it \nlooks!", nil, "tenna")
            tenna.sprite:setPreset(22)
            cutscene:text("* But,[wait:5] if you REALLY want to play the GAMES so badly...", nil, "tenna")
            tenna.sprite:setPreset(1)
            cutscene:text("* Who am I to deny a COMEBACK SPECIAL!?", nil, "tenna")
            tenna.sprite:setPreset(30)
            cutscene:text("* We'll get EVERYONE back together!!!", nil, "tenna")
            tenna.sprite:setPreset(21)
            Assets.playSound("whip_hard")
            cutscene:text("* THAT INCLUDES YOU TOO,[wait:5] MIKE!!!", nil, "tenna")
            tenna.sprite:setPreset(25)
            cutscene:text("* Kids, go talk to Ramb![wait:5]\n* He might have the old console on him!", nil, "tenna")
            tenna.sprite:setPreset(2)
            Assets.playSound("whip_crack_only")
            tenna:setAnimation("point_left")
            cutscene:text("* Hurry![wait:5]\n* The fate of[funnytext:tv_time,ftext_enter,0,0,96,48][wait:5]is at stake!!", nil, "tenna")
            tenna.sprite:setPreset(0)
            tenna:setSprite("pose_podium_2")
            cutscene:text("* Heh,[wait:5] but that's only if you WANT to play, of course!", nil, "tenna")
            tenna:setAnimation("whisper_blush")
            cutscene:text("* I've learned by now that forcing someone to play NEVER works well.", nil, "tenna")
        elseif choice == 4 then
            if not Game:getFlag("tenna_physicalchallenge") then
                tenna.sprite:setPreset(-3)
                cutscene:text("* Huh?[wait:10] Have I seen any STARBITS lying around?", nil, "tenna")
                tenna.sprite:setPreset(1)
                cutscene:text("* Well,[wait:5] as a matter of fact, I HAVE!", nil, "tenna")
                tenna.sprite:setPreset(2)
                tenna:setAnimation("point_left")
                cutscene:text("* But don't think I'm just gonna give it to you for free.", nil, "tenna")
                tenna.sprite:setPreset(17)
                cutscene:text("* In order to win this [funnytext:grand_prize,ftext_gunshot,0,0,148,28]...", nil, "tenna")
                tenna.sprite:setPreset(21)
                cutscene:text("* YOU need to WIN a\n[funnytext:physical_challenge/physical_challenge,ftext_bounce,0,-10,195,34]!", nil, "tenna")
                tenna.sprite:setPreset(2)
                cutscene:text("* The rules are simple:", nil, "tenna")
                tenna.sprite:setPreset(24)
                cutscene:text("* Throughout this tower,[wait:5] there are 8 stickers featuring yours truly that you must collect.", nil, "tenna")
                tenna.sprite:setPreset(21)
                cutscene:text("* Bring them all to me,[wait:5] and you'll win the STARBIT!", nil, "tenna")
                tenna.sprite:setPreset(3)
                cutscene:text("* Now,[wait:5] are you READY?[wait:10] Because...", nil, "tenna")
                tenna.sprite:setPreset(0)
                tenna:setSprite("point_at_screen_c")
                Game.world.music:pause()
                cutscene:itsTVTime()
                Game.world.music:resume()
                Game:setFlag("tenna_physicalchallenge", true)
                Game:setFlag("challenge_stickers", 0)
            else
                local stickers = Game:getFlag("challenge_stickers")
                tenna.sprite:setPreset(2)
                tenna:setSprite("pose_podium_3")
                cutscene:text("* Let's see how many stickers \nyou have...", nil, "tenna")
                tenna:setSprite("pose_podium_4")
                cutscene:text("* It seems you have "..stickers.." out of 8 stickers!", nil, "tenna")
                if stickers == 0 then
                    tenna.sprite:setPreset(4)
                    cutscene:text("* WOW---!!![wait:5]\n* YOU haven't collected a SINGLE sticker!", nil, "tenna")
                    tenna.sprite:setPreset(17)
                    cutscene:text("* Remember,[wait:5] the stickers look like me,[wait:5] you can't miss 'em.", nil, "tenna")
                end
            end
        end

        tenna.sprite:setPreset(24)
        cutscene:hideNametag()
        tenna.sprite.flip_x = false
    end,
}
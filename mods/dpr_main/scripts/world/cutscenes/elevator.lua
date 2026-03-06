return{
    top = function(cutscene)
        local elevator = Game.world.map:getEvent("elevator")

        if Game:getFlag("elevator_top") == true then
            cutscene:wait(2)
            cutscene:wait(cutscene:fadeOut(1))
            cutscene:wait(1)
            cutscene:wait(cutscene:fadeIn(1))
            cutscene:wait(1)

            elevator.infinite = false
            return
        end

        local hero = cutscene:getCharacter("hero")
        local susie = cutscene:getCharacter("susie")
        local dess = cutscene:getCharacter("dess")

        local dess_speen = false
        local hero_karma = Game:getPartyMember("hero"):getFlag("karma")

        cutscene:wait(5)
        if hero then
            cutscene:showNametag("Hero")
            cutscene:text("* ...", "neutral_closed", "hero")
            cutscene:text("* I think this is gonna take a while...", "really", "hero")
            if #Game.party >= 2 then
                hero:setFacing("down")
                cutscene:text("* We should probably get comfortable.", "neutral_closed_b", "hero")
                hero:setFacing("up")
            end
            cutscene:hideNametag()
            if susie then
                cutscene:walkTo(susie, 223, 287, 1, "right")
                cutscene:during(function()
                    if susie.x == 223 then
                        susie:setSprite("wall_right")
                        susie:shake()
                        Assets.playSound("wing")
                        return false
                    end
                end)
            end
            if dess then
                dess_speen = true
                local dess_timer = 0
                function DessRotate(direction)
                    if direction == "up" then
                        dess:setFacing("right")
                    elseif direction == "right" then
                        dess:setFacing("down")
                    elseif direction == "down" then
                        dess:setFacing("left")
                    elseif direction == "left" then
                        dess:setFacing("up")
                    end
                end
                cutscene:during(function()
                    if not dess_speen then return false end
                    dess_timer = dess_timer + DT
                    if dess_timer > 1/30 then
                        dess_timer = 0
                        DessRotate(dess:getFacing())
                    end
                end)
            end

            cutscene:wait(5)

            if dess then
                hero:setFacing("down")
                cutscene:wait(1)
                cutscene:showNametag("Hero")
                cutscene:text("* ...", "really", "hero")
                cutscene:text("* Dess,[wait:5] what the hell are you doing?", "annoyed", "hero")
                cutscene:showNametag("Dess")
                cutscene:text("* transfering my angular momentum to the elevator", "calm", "dess")
                cutscene:text("* did wing gaster never teach you physics?", "annoyed", "dess")
                cutscene:showNametag("Hero")
                cutscene:text("* As a matter of fact,[wait:5] he did,[wait:5] and that's not how physics works.", "really", "hero")
                cutscene:showNametag("Dess")
                cutscene:text("* not with that attitude", "teehee", "dess")
                cutscene:showNametag("Hero")
                cutscene:text("* ...", "really", "hero")
                hero:setFacing("up")
                cutscene:hideNametag()
                cutscene:wait(5)
            end

            if susie then
                cutscene:showNametag("Susie")
                cutscene:text("* Hey,[wait:5] uh,[wait:5] Hero...", "annoyed", "susie")
                hero:setFacing("left")
                cutscene:showNametag("Hero")
                cutscene:text("* Yeah?", "neutral_closed_b", "hero")
                cutscene:showNametag("Susie")
                cutscene:text("* What do you think is even at the top of this tower?", "annoyed_down", "susie")
                cutscene:showNametag("Hero")
                cutscene:text("* Well,[wait:5] if I had to guess,[wait:5] it's where the Dark Fountain is.", "neutral_opened_b", "hero")
                cutscene:showNametag("Susie")
                cutscene:text("* I see...", "annoyed_down_alt", "susie")
                cutscene:text("* I'm guessing that means the Knight will be there too...", "annoyed_down", "susie")
                cutscene:showNametag("Hero")
                cutscene:text("* Yeah,[wait:5] that seems likely.", "pout", "hero")
                cutscene:showNametag("Susie")
                cutscene:text("* Do you think...[wait:10] we'll win this time?", "bangs_neutral", "susie")
                if hero_karma < -30 then
                    cutscene:showNametag("Hero")
                    cutscene:text("* I mean,[wait:5] we've been getting stronger,[wait:5] haven't we?", "neutral_closed", "hero")
                    cutscene:showNametag("Susie")
                    cutscene:text("* Well,[wait:5] that's the thing...", "annoyed_down_alt", "susie")
                    cutscene:text("* I FEEL stronger,[wait:5] but I don't feel...[wait:5] STRONGER,[wait:5] if that makes sense.", "annoyed_down_alt_smile", "susie")
                    cutscene:showNametag("Hero")
                    cutscene:text("* Susie,[wait:5] we're saving all of reality here.", "annoyed", "hero")
                    cutscene:text("* If we have to kill a few enemies to get stronger,[wait:5] then so be it.", "pout", "hero")
                    cutscene:showNametag("Susie")
                    cutscene:text("* ...", "annoyed", "susie")
                    cutscene:text("* (There's gotta be a better way...)", "bangs_neutral", "susie")
                elseif hero_karma > 30 then
                    cutscene:showNametag("Hero")
                    cutscene:text("* Well,[wait:5] we've been through thick and thin together,[wait:5] haven't we?", "neutral_smile", "hero")
                    cutscene:text("* We got the one thing the Knight lacks,[wait:5] and that's teamwork!", "happy", "hero")
                    cutscene:showNametag("Susie")
                    cutscene:text("* Heh,[wait:5] hell yeah, we do!", "smile", "susie")
                    cutscene:text("* But, uh...", "nervous", "susie")
                    cutscene:text("* What will happen...[wait:5] AFTER we win, though?", "annoyed_down_smile", "susie")
                    cutscene:showNametag("Hero")
                    cutscene:text("* Well,[wait:5] we seal the Fountain,[wait:5] and the world is saved,[wait:5] right?", "neutral_closed_b", "hero")
                    cutscene:showNametag("Susie")
                    cutscene:text("* Yeah,[wait:5] but like...", "annoyed_down_alt_smile", "susie")
                    cutscene:text("* What about you, dude?", "calm", "susie")
                    cutscene:text("* What'll you do when this is all over?", "annoyed_down_alt", "susie")
                    cutscene:showNametag("Hero")
                    cutscene:text("* ...", "shocked", "hero")
                    cutscene:text("* I...", "shade", "hero")
                    cutscene:text("* We'll uh,[wait:5] cross that bridge when we get to it.", "happy", "hero")
                    cutscene:showNametag("Susie")
                    cutscene:text("* Uh,[wait:5] alright.", "nutral", "susie")
                    cutscene:text("* (Are they doing okay...?)", "neutral_side", "susie")
                else
                    cutscene:showNametag("Hero")
                    cutscene:text("* Well,[wait:5] uh...", "shocked", "hero")
                    cutscene:text("* (I can't tell her about the SAVEs...)", "really", "hero")
                    cutscene:text("* We can always prepare a bit more before we go fight them.", "happy", "hero")
                    cutscene:showNametag("Susie")
                    cutscene:text("* I guess...", "neutral_side", "susie")
                end
                hero:setFacing("up")
                cutscene:hideNametag()
                cutscene:wait(5)
            end

            elevator.volcount = 0
            elevator.rectspeed = 0
            elevator.maxrectspeed = 0
            Game.world:shakeCamera(5)
            Assets.playSound("screenshake")
            if susie then
                susie:setSprite("shock_right")
                Assets.playSound("sussurprise")
                cutscene:slideTo(susie, susie.x + 40, susie.y, 0.5, "out-cubic")
            end

            cutscene:wait(2)

            if susie then
                cutscene:showNametag("Susie")
                cutscene:text("* Hero...[wait:10] What the HELL just happened?", "surprise_smile", "susie")
                cutscene:hideNametag()
            end

            elevator.maxrectspeed = 25
            local elevator_shaking = true
            cutscene:during(function()
                if elevator.pitchcount == 1 then return false end
                elevator.volcount = Utils.approach(elevator.volcount, 1, (0.05 * DTMULT))
                elevator.pitchcount = Utils.approach(elevator.pitchcount, 1, (0.01 * DTMULT))
            end)
            local shaketimer = 0
            cutscene:during(function()
                if not elevator_shaking then return false end
                shaketimer = shaketimer + 1*DTMULT
                Game.world.camera.x = 320 + math.sin(shaketimer*5)*3
            end)

            cutscene:wait(5)
            cutscene:wait(cutscene:fadeOut(3, {color = {1,1,1}}))
            cutscene:wait(1)

            elevator.volcount = 0
            elevator.pitchcount = 0.5
            elevator.rectspeed = 0
            elevator.maxrectspeed = 0
            elevator_shaking = false
            dess_speen = false
            Assets.playSound("screenshake")

            hero:setSprite("fell")
            if susie then
                susie:setSprite("fell")
            end
            if dess then
                dess:setSprite("battle/defeat_1")
            end

            cutscene:wait(2)
            cutscene:wait(cutscene:fadeIn(2))
            cutscene:wait(1)

            elevator.infinite = false
            cutscene:wait(function()
                elevator.charadjustcon = 0 -- Don't re-adjust characters when the elevator opens.
                return elevator.doorcon == 1
            end)

            cutscene:wait(1)
            hero:shake(5)
            Assets.playSound("bump")
            cutscene:wait(1)
            hero:resetSprite()
            hero:setFacing("down")
            hero:shake()
            Assets.playSound("wing")
            cutscene:wait(1)
            cutscene:showNametag("hero")
            cutscene:text("* ... Is everyone alright?", "shocked", "hero")
            cutscene:hideNametag()

            for _, follower in ipairs(Game.world.followers) do
                follower:shake()
                Assets.stopAndPlaySound("bump")
                cutscene:wait(1)
                follower:shake()
                follower:resetSprite()
                Assets.stopAndPlaySound("wing")
            end

            if susie then susie:setFacing("right") end
            if dess then dess:setFacing("up") end

            cutscene:wait(1)
            cutscene:showNametag("hero")
            cutscene:text("* Well...[wait:5] looks like we made it.", "neutral_closed", "hero")
            cutscene:text("* Let's uh...[wait:5] keep a mental note to hang on to something next time.", "happy", "hero")

            cutscene:interpolateFollowers()
            Game:setFlag("elevator_top", true)
        end
    end
}
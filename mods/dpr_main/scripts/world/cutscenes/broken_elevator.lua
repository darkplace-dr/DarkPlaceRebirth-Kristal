return function(cutscene)
    -- An example cutscene to show off elevator cutscenes: Hero and Susie get mildly inconvenienced by the elevator being broken.
    local elevator = Game.world.map:getEvent("elevator")

    if Game.party[1].name == "Dess" then
        local dess = cutscene:getCharacter("dess")
        cutscene:wait(5)

        dess:setFacing("down")
        cutscene:textTagged("*[wait:30] Left.[wait:10] [face:thisremindsmeofthetimeiwasindarkplace][wait:5]", "smug", "dess", {auto = true})
        local music = Music("dogcheck/intermission")
        cutscene:during(function()
            if Game.world.x > 640 then
                Game.world.x = Game.world.x - 640*2
                Game.world.x = Game.world.x + DTMULT*8

                local sprites = {
                    "dab",
                    "bup",
                    "angreh",
                    "elf/walk/down_1",
                    "name"
                }
                local meth = math.random(1, #sprites)
                dess:setSprite(sprites[meth])
                
            else
                Game.world.x = Game.world.x + DTMULT*8
            end
        end)

        cutscene:wait(30)
        elevator.infinite = false
        cutscene:wait(function()
            elevator.charadjustcon = 0 -- Don't re-adjust characters when the elevator opens.
            return elevator.doorcon == 1 end)
            elevator.target_floor = elevator:getFloorByName("Floor 1")
        dess:resetSprite()
        music:remove()
        cutscene:during(function()
            Game.world.x = 0
        end)
    elseif Game:hasPartyMember("hero") and Game:hasPartyMember("susie") then
        local hero = cutscene:getCharacter("hero")
        local susie = cutscene:getCharacter("susie")
        
        
        cutscene:wait(5)
        cutscene:textTagged("* You might wanna get comfy.[wait:5] This'll take a while.", "neutral_closed_b", "hero")
        cutscene:textTagged("* Uh,[wait:5] if you say so.", "suspicious", "susie")
        
        -- Susie walks to the left wall and leans on it.
        cutscene:detachFollowers()
        cutscene:walkTo(susie, 223, 287, 1)
        cutscene:wait(1)
        Assets.playSound("wing")
        susie:setSprite("wall_right")
        
        cutscene:wait(5)
        
        -- The elevator comes to a stop, but the doors don't open.
        cutscene:during(function()
            if elevator.volcount == 0 then return false end
            elevator.volcount = Utils.approach(elevator.volcount, 0, (0.05 * DTMULT))
        end)
        elevator.rectcon = 3
        cutscene:wait(2)
        
        -- Susie gets off the wall, then hero turns to look at her.
        susie:setSprite("walk_unhappy")
        susie:setFacing("right")
        cutscene:textTagged("* Hey,[wait:5] why'd we stop?", "nervous_side", "susie")
        cutscene:textTagged("* I'm...[wait:5] not sure.", "shocked", "hero")
        cutscene:textTagged("* Sans DID say the elevator wasn't finished, though.", "neutral_closed", "hero")

        -- Susie walks towards the center of the room.
        susie:walkTo(316, susie.y, 2)
        cutscene:textTagged("* Oh, great.[wait:10] So it's broken.", "annoyed", "susie")
        -- When she gets there, she looks up.
        cutscene:during(function()
            if susie.x == 316 then
                susie:setSprite("away")
                return false
            end
        end)
        cutscene:textTagged("* We're not stuck here,[wait:5] are we...?", "annoyed_down", "susie")
        cutscene:wait(2)
        
        -- Hero does something with the elevator panel...
        hero:setSprite("walk/up_4")
        cutscene:wait(0.5)
        hero:setSprite("walk")
        hero:setFacing("up")
        cutscene:wait(0.5)
        
        -- ...And it starts going back down.
        cutscene:during(function()
            if elevator.volcount == 0.7 then return false end
            elevator.volcount = Utils.approach(elevator.volcount, 0.7, (0.05 * DTMULT))
        end)
        elevator.dir = -1
        elevator.rectcon = 1
        elevator.target_floor = elevator:getFloorByName("Floor 1")
        cutscene:wait(2)
        
        -- Susie glances over
        susie:setSprite("away_turn")
        cutscene:textTagged("* ...[wait:10] We're going back down?", "surprise", "susie")
        hero:setFacing("left")
        cutscene:textTagged("* Better than being stuck,[wait:5] I suppose.", "annoyed", "hero")
        cutscene:textTagged("* Yeah,[wait:5] I guess so.", "neutral_side", "susie")
        cutscene:wait(3)
        
        -- Elevator's gonna stop in a sec. Wait until it does.
        elevator.infinite = false
        cutscene:wait(function()
            elevator.charadjustcon = 0 -- Don't re-adjust characters when the elevator opens.
            return elevator.doorcon == 1 end)

        -- Hero looks down, followed by Susie.
        cutscene:wait(0.5)
        hero:setFacing("down")
        cutscene:wait(0.5)
        susie:setFacing("down")
        susie:resetSprite()

        -- Hero walks over to the door.
        hero:walkToSpeed(316, 354, 4, "down")
        cutscene:showNametag("Hero", {top = true})
        cutscene:text("* And here we are.[wait:10] Back where we started.", "neutral_closed", "hero", {top = true})

        -- Wait until Hero stops moving
        cutscene:wait(function() return hero.x == 316 and hero.y == 354 end)

        -- Hero looks back at Susie, and they get moving.
        hero:setFacing("up")
        cutscene:textTagged("* About time.[wait:5] Let's get moving.", "smirk", "susie")

        hero:setFacing("down")
        cutscene:wait(cutscene:attachFollowers())
    else
        cutscene:text("* There is no dialouge.")
        cutscene:text("* Screw the dialouge.")
        cutscene:wait(5)
        elevator.infinite = false
        cutscene:wait(function()
            elevator.charadjustcon = 0 -- Don't re-adjust characters when the elevator opens.
            return elevator.doorcon == 1 end)
            elevator.target_floor = elevator:getFloorByName("Floor 1")
    end
        
    
end
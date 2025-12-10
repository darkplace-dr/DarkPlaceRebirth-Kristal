return {
    ---@param cutscene WorldCutscene
    main = function(cutscene, map, partyleader)
        if Game:isDessMode() or Game.world.player:getName() == "Dess" then
            cutscene:showNametag("Dess")
            if map == "floor1/dess_house" then
                cutscene:text("* this is where i'd put my house", "genuine", "dess")
                cutscene:text("* IF I HAD ONE", "doom_AURGHHHHHH", "dess")
            elseif map == "floor1/main_south" then
                cutscene:text("* the start of a new adventure", "condescending", "dess")
                cutscene:text("* its filling me with DESSTERMINATION", "calm_b", "dess")
            elseif map == "main_outdoors/tower_outside" then
                cutscene:text("* wow who knew the tower looked so ugly on the outside", "condescending", "dess")
                cutscene:text("* its almost like this is some king of...[wait:10]\n* [color:red]unfinished map", "mspaint", "dess")
            elseif map == "floor1/main" then -- Might use this dialogue for the Cliffside deadrooms, but I can't think of anything better rn
                cutscene:text("* wow this place looks so familiar", "neutral_b", "dess")
                cutscene:text("* this reminds me of the time i was in Dark Place Legacy", "thisremindsmeofthetimeiwasindarkplace", "dess")
            elseif map == "floor1/fuseroom" then
                cutscene:text("* dude when are they adding crafting", "angry", "dess")
            elseif map == "floor1/traininggrounds" then
                cutscene:text("* Aw yeah, its the place where i use my fists", "challenging", "dess")
                cutscene:text("* feeling evil think ill kill them all", "dess.exe", "dess")
            elseif map == "floor1/spamgolor_meeting" then
                cutscene:text("* hey breloom when are you gonna stop being lazy and port over spamgolor", "angry", "dess")
                cutscene:showNametag("BrendaK7200")
                cutscene:text("* Shut the fuck up, Dess.[wait:10]\n* I'll add him eventually.", nil, "brenda")
                cutscene:showNametag("Dess")
                cutscene:text("* ", "wtf_b", "dess")
                cutscene:text("* kk swag", "smug", "dess")
            elseif map == "floor1/marketplace" then
                cutscene:text("* cant wait to spend my totally not stollen money on some swag items", "swag", "dess")
            elseif map == "floor1/tutorialmasters" then
                cutscene:text("* ew tutorials", "annoyed", "dess")
            elseif map == "floor1/pregreatdoor" then
                cutscene:text("* ...", "neutral_b", "dess")
            elseif map == "floor1/greatdoor" then
                cutscene:hideNametag()
                cutscene:text("* (But you couldn't think of anything to say.)")
            elseif map == "hub_elevator" then
                cutscene:text("* ...", "neutral_b", "dess")
            elseif map == "dessstuff/dessstart" then
                cutscene:text("* this is it,[wait:5] the map that started it all", "heckyeah", "dess")
                cutscene:text("* as we all know Dark Place was so much worse before I came along", "condescending", "dess")
            elseif map == "dessstuff/dessend" then
                cutscene:text("* okay,[wait:5] let's start killing,[wait:5] some [color:red]UFOs[color:reset]...", "dess.exe", "dess")
            elseif map == "field" then
                cutscene:hideNametag()
                cutscene:text("* (You give a moment of silence for those in need...)")
                cutscene:text("[speed:0.1]* (...)\n[wait:10](...)\n[wait:10](...)")
                cutscene:text("* (There will always be hope.)")
            elseif map == "warp_hub/hub" then
                cutscene:text("* y'know I remember this place being a LOT bigger before", "neutral_b", "dess")
                cutscene:text("* why is it just a tiny island now?", "eyebrow", "dess")
            elseif map == "floortv/green_room" then
                cutscene:text("* hey remember when folks thought Chapter 3 would look like this entirely?", "genuine", "dess")
                cutscene:text("* heh.[wait:5] good times,[wait:5] good times.", "condescending", "dess")
            else
                cutscene:text("* allan please add dialogue", "neutral", "dess")
            end
            cutscene:hideNametag()
        elseif partyleader == "mario" then
            cutscene:text("* allan please add dialogue", "neutral", "mario")
            cutscene:text("* Everyone knows Mario is cool as fuck.[wait:10] But who knows what he's thinking?[wait:10] Who knows why he crushes turtles?[wait:10] And why do we think about him as fondly as we think of the mystical (nonexistent?) Dr Pepper?[wait:10] Perchance.", "neutral", "mario")
            cutscene:hideNametag()
        else
            if map == "grey_cliffside/cliffside_start" then
                if partyleader == "hero" then
                    local hero = cutscene:getCharacter("hero")
                    local heroFacing = hero.sprite.facing
                    if #Game.party == 1 and not Game:getFlag("cliffside_askedDeltaWarrior") then
                        hero:setFacing("down")
                        cutscene:textTagged("* Well,[wait:5] here we are,[wait:5] our mission begins now.", "neutral_closed", "hero")
                        cutscene:textTagged("* Say,[wait:5] do you happen to know whoever's responsible for this?", "neutral_closed_b", "hero")
                        local choicer = cutscene:choicer({"Yes", "Nope"})
                        if choicer == 1 then
                            cutscene:textTagged("* Great,[wait:5] what do they look like?", "happy", "hero")
                            choicer = cutscene:choicer({"You But\nBlue", "Purple\nLizard", "Fluffy Goat", "Deer Girl"})
                            if choicer == 1 then
                                Game:setFlag("cliffside_askedDeltaWarrior", "kris")
                            elseif choicer == 2 then
                                Game:setFlag("cliffside_askedDeltaWarrior", "susie")
                            elseif choicer == 3 then
                                Game:setFlag("cliffside_askedDeltaWarrior", "ralsei")
                            else
                                Game:setFlag("cliffside_askedDeltaWarrior", "noelle")
                            end
                            cutscene:textTagged("* Got it.[wait:10]\n* I'll keep that in mind.", "neutral_closed", "hero")
                        else
                            Game:setFlag("cliffside_askedDeltaWarrior", "dunno")
                            cutscene:textTagged("* Well it was worth a shot.", "annoyed", "hero")
                            cutscene:textTagged("* Let's keep going, then.", "neutral_closed", "hero")
                        end
                        hero:setFacing(heroFacing)
                    elseif #Game.party == 1 and Game:getFlag("cliffside_askedDeltaWarrior") ~= "dunno" then
                        hero:setFacing("down")
                        if Game:getFlag("cliffside_askedDeltaWarrior") == "kris" then
                            cutscene:textTagged("* Someone who looks like me but blue...", "neutral_closed", "hero")
                        elseif Game:getFlag("cliffside_askedDeltaWarrior") == "susie" then
                            cutscene:textTagged("* A purple lizard...", "neutral_closed", "hero")
                        elseif Game:getFlag("cliffside_askedDeltaWarrior") == "ralsei" then
                            cutscene:textTagged("* Some kind of fluffy goat...", "neutral_closed", "hero")
                        else
                            cutscene:textTagged("* Some sort of deer girl...", "neutral_closed", "hero")
                        end
                        cutscene:textTagged("* I'll keep that in mind.", "neutral_closed_b", "hero")
                        hero:setFacing(heroFacing)
                    elseif #Game.party == 1 then
                        hero:setFacing("down")
                        cutscene:textTagged("* Let's keep going.", "neutral_closed", "hero")
                        hero:setFacing(heroFacing)
                    else
                    end
                end
            elseif map == "floortv/green_room" then
                local susie = cutscene:getCharacter("susie")
                if susie then
                    cutscene:textTagged("* Huh.[wait:5]\n* Even Tenna's Green Room is in this place...", "suspicious", susie)
                    cutscene:textTagged("* I don't recall there being a platter in the room though.", "sus_nervous", susie)
                end
            elseif map == "field" then
                cutscene:text("* (You give a moment of silence for those in need...)")
                cutscene:text("[speed:0.1]* (...)\n[wait:10](...)\n[wait:10](...)")
                cutscene:text("* (There will always be hope.)")
            else
                cutscene:text("* (But your voice echoed aimlessly.)")
            end
        end
    end,
}
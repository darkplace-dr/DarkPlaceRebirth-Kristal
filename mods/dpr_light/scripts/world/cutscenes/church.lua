return {
    ---@param cutscene WorldCutscene
    organ = function(cutscene, event, player)
        cutscene:text("* (A giant organ.)")
    end,

    door = function(cutscene, event, player)
        cutscene:text("* (It's a door. A large person could fit inside.)")
        cutscene:text("* (...[wait:5] it's locked.)")
    end,

    candles = function(cutscene, event, player)
        cutscene:text("* (It's an altar full of hope\ncandles.[wait:5] Each one has a\nperson's name on it.)")
    end,

    fire_extinguisher = function(cutscene, event, player)
        if cutscene:getCharacter("susie") then
            if GeneralUtils.getLeader().id == "kris" then
                cutscene:text("* (It's a fire extinguisher.)[wait:10]\n* (For some reason you have the\nfeeling...)")
                cutscene:text("* (...[wait:5] Susie will say something\nstupid about it.)[react:1]", nil, nil, {reactions={{"They should make one of these\nthat shoots whip cream", "mid", "bottom", "smile", "susie"}}})
            else
                cutscene:text("* (It's a fire extinguisher.)")
                cutscene:text("* They should make one of these that shoots whip cream", "smile", "susie")
            end
        else
            cutscene:text("* (It's a fire extinguisher.)")
        end
    end,

    holy_water = function(cutscene, event)
        cutscene:text("* (It's a bowl of blessed water with a motion sensor to stop cats from drinking it.)")
        cutscene:text("* (It's not clear what happens if you touch the sensor.)")
    end,

    entrance_bookshelf = function(cutscene, event)
        cutscene:text("* (It's a bookshelf full of\nhymnals and scripture.)")
        cutscene:text("* (...[wait:5] and some copies of Lord of\nthe Hammer.)")
        if Game:getFlag("alvinAtGraveyard") and not Game.inventory:hasItem("light/lord_of_the_hammer") then
            cutscene:textChoicer("* (Take a copy?)", {"Take", "Don't"})
            if cutscene.choice == 1 then
                local success, text = Game.inventory:tryGiveItem("light/lord_of_the_hammer")
                if success then
                    cutscene:text(text)
                end
            end
        end
    end,

    pitcher = function(cutscene, event)
        cutscene:text("* (It's a large pitcher of water.)")
        cutscene:text("* (Cups are stored below it.)")
    end,

    drinks = function(cutscene, event)
        cutscene:text("* (Juice,[wait:5] and wafer-like crackers.)")
    end,

    cupboard = function(cutscene, event)
        cutscene:text("* (Documents...)")
    end,

    office_bookshelf = function(cutscene, event)
        cutscene:text("* (Books. Many copies of Lord of the Hammer...[wait:5] and some unlabeled notebooks.)")
    end,

    plaque = function(cutscene, event)
        cutscene:text("* (It's a plaque bearing the words of a famous writer.)")
        cutscene:text("* (\"Hope comes to those who believe. And for those that cannot...\")")
        cutscene:text("* (\"...[wait:5] May our hope shine so brightly...\")")
        cutscene:text("* (\"...[wait:5] That they,[wait:5] too,[wait:5] may keep shelter from the dark.\")")
    end,

    hanging = function(cutscene, event)
        cutscene:text("* (Seems to be some sort of incense container.)")
    end,

    wardrobe = function(cutscene, event)
        cutscene:text("* (The wardrobe is full of choir robes...[wait:5] There's even one in your size.)")
    end,

    bells = function(cutscene, event)
        cutscene:text("* (It's a set of bells of different sizes.)")
        local dowemess = cutscene:choicer({"Mess\nwith them", "Don't"})
        if dowemess == 1 then
            Game.world.timer:after(4/30, function() Assets.playSound("playablebell", 0.7, 0.8) end)
            Game.world.timer:after(8/30, function() Assets.playSound("playablebell", 0.7, 1) end)
            Game.world.timer:after(12/30, function() Assets.playSound("playablebell", 0.7, 1.2) end)
            cutscene:wait(1)
        end
    end,

    piano = function(cutscene, event)
        cutscene:text("* (It's a keyboard. It has settings to sound like either a piano or an organ.)")
    end,

    alvin = function(cutscene, alvin)
        cutscene:setSpeaker(alvin)
        if Game:getFlag("alvinAtGraveyard") then
            cutscene:text("* I'm sorry.[wait:5] I don't think I can focus on talking right now.")
            return
        end

        local not_tourists = {
            "kris",
            "susie",
            "noelle",
            "berdly"
        }
        local human_tourists = {
            "hero",
            "jamm"
        }

        local tourist = false
        for i,member in ipairs(Game.party) do
            if not TableUtils.contains(not_tourists, member.id) then
                tourist = true
                break
            end
        end

        local human_tourist = false
        for i,member in ipairs(Game.party) do
            if TableUtils.contains(human_tourists, member.id) then
                human_tourist = member.id
                break
            end
        end

        local susie_in_party = #TableUtils.filter(Game.party, function(value) return value.id == "susie" end) == 1

        local alvin_recognizes
        for i,member in ipairs(Game.party) do
            if (susie_in_party and member.id == "susie") or TableUtils.contains(not_tourists, member.id) then
                alvin_recognizes = member
                break
            end
        end

        alvin:setSprite("alvin")
        if alvin_recognizes then
            cutscene:text("* Ah "..alvin_recognizes:getName()..".[wait:5] It is wonderful to see you here today.")
        else
            cutscene:text("* Ah a new face.[wait:5] Welcome to our humble church.")
        end
        if not alvin_recognizes or (alvin_recognizes and #Game.party == 2) then
            cutscene:text("* And I see you brought a friend along.")
        end
        if not alvin_recognizes then
            cutscene:text("* I don't recall seeing you here before.[wait:5] Are you a "..(human_tourist and "human " or "").."tourist by any chance?")
        end
        if human_tourist == "hero" then
            cutscene:setSpeaker()
            cutscene:text("* You can say that,[wait:5] yes.[wait:5] My name's Hero.", "happy", "hero")
            cutscene:setSpeaker("alvin")
            cutscene:text("* Welcome to our little Hometown,[wait:5] Hero.")
        elseif not alvin_recognizes then
            cutscene:text("* Welcome to our little Hometown.")
        end
        cutscene:text("* If you have any questions about this town,[wait:5] I'd be glad to answer them.")
        local c = cutscene:choicer({"Shelter", "Susie", "Gerson", "Goodbye"})
        if c == 1 then
            if tourist then
                cutscene:text("* [speed:0.3]...[speed:1][wait:5]Ah yes,[wait:5] the shelter to the south of the church.")
                cutscene:text("* Truly,[wait:5] it is no place for a tourist to go to.")
                cutscene:text("* I believe no one has maintained it in a while.[wait:5] It would be dangerous to go there.")
                cutscene:text("* Hometown has many other interesting places to visit.")
                cutscene:text("* I would suggest going there instead.")
                cutscene:text("* I'm honestly quite surprised you've even learn about it in the first place.")
                cutscene:text("* If something heavy weights on your shoulder,[wait:5] young one...")
                cutscene:text("* Please,[wait:5] do not hesitate to come here and pray.")
                cutscene:text("* The light of the Angel guides everyone,[wait:5] regardless of their belief or origin.")
            else
                cutscene:text("* ...?[wait:5] First Kris,[wait:5] now you "..alvin_recognizes:getName().."...")
                cutscene:text("* Please look to the Angel for guidance.[wait:5] I will pray for you as well.")
                cutscene:text("* "..alvin_recognizes:getName().."...[wait:5] Stay away from the shelter.")
                cutscene:text("* Especially now that Kris is nowhere to be seen...")
                if susie_in_party then
                    cutscene:text("* Do you know anything about this, Susie?")
                    cutscene:text("* Uhh...[wait:5] Not really,[wait:5] no.")
                    cutscene:text("* I'm looking for them too but,[wait:5] uh,[wait:5] tough luck so far...")
                    cutscene:text("* You have all my support, Susie.[wait:5] I understand how hard it must be.")
                    cutscene:text("* Yeah...")
                end
            end
        elseif c == 2 then
            if susie_in_party then
                if GeneralUtils.getLeader().id == "susie" then
                    cutscene:text("* Susie?[wait:5] Why would you ask me about yourself?[wait:5] Ha ha.")
                else
                    cutscene:text("* Your friend Susie?")
                    if GeneralUtils.getLeader().id == "dess" and Game:hasPartyMember("susie") then
                        cutscene:text("* We're not friends.", "suspicious", "susie")
                        cutscene:text("* We're besties.[react:1]", "teehee", "dess", {reactions={
                            {"Like hell\nwe are!", "right", "bottom", "susie", "teeth"}
                        }})
                        cutscene:text("* Right...")
                    else
                        cutscene:text("* Well I'm not too sure what I could tell you about her...")
                        cutscene:text("* that you probably don't already know yourself.")
                    end
                end
                cutscene:text("* In any case,[wait:5] I would like to thank you for helping me cleaning up the church.")
                cutscene:text("* I don't know what happened yet that night...")
                cutscene:text("* but I don't think I would have cleaned up everything without your help.")
                cutscene:text("* No problem.[wait:5] It's...[wait:5] It was the least I could do.", "sincere", "susie")
                cutscene:text("* You are a kind soul Susie.[wait:5] I am sure the Angel has great plans for you.")
                cutscene:text("* And if you ever want to come back to a service, know you'll be welcomed.")
                cutscene:text("* Even if you'll only be here for our \"sick juice\".")
                cutscene:text("* Thanks,[wait:5] that's cool.", "smile", "susie")
            else
                cutscene:text("* Susie?[wait:5] She is one of the new kids living here at Hometown.")
                cutscene:text("* I've heard of few things about her...")
                cutscene:text("* But I've seen her myself,[wait:5] and I believe she's a sweet girl.")
                cutscene:text("* Maybe just as weird as Kris is.[wait:5] Which is far from a bad thing.")
            end
        elseif c == 3 then
            if tourist then
                cutscene:text("* Ah so you've heard about my father...")
                cutscene:text("* That makes sense.[wait:5] I believe his books are famous world-wide.")
                cutscene:text("* Unfortunately,[wait:5] he passed away a few years ago.[wait:5] A great loss to this world.")
                cutscene:text("* He was a great man.[wait:5] Always being a mentor to anyone who needed one.")
                cutscene:text("* ...")
                cutscene:text("* My father was always a source of inspiration and always the one to go to for advices.")
                cutscene:text("* And yet...")
                alvin:setSprite("alvin_back")
                cutscene:wait(1.5)
                cutscene:text("* If you need to tell someone you're proud of them...")
                cutscene:text("* Do not wait until it's too late to say it.")
                cutscene:text("* You wouldn't want to leave this Earth with regrets,[wait:5] would you?")
                cutscene:wait(1)
                if susie_in_party then
                    cutscene:text("* ...", "shy_down", "susie")
                end
                alvin:setSprite("alvin")
                cutscene:text("* Ah I'm sorry,[wait:5] that was unwarranted of me.")
                cutscene:text("* Do not worry yourself with me.[wait:5] You're only here to have a good time after all.")
                if not Game.inventory:hasItem("light/lord_of_the_hammer") then
                    cutscene:text("* And if you want,[wait:5] I can give you a copy of my father's book.")
                    cutscene:text("* It's a great story,[wait:5] inspired by the Prophecy of the DELTA RUNE itself.")
                    if cutscene:choicer({"Take it", "Don't"}) == 1 then
                        cutscene:text("* I can only hope it will be an inspiring read.")
                        local success, text = Game.inventory:tryGiveItem("light/lord_of_the_hammer")
                        if success then
                            cutscene:text(text, {talk=false})
                            Game:setFlag("alvinAtGraveyard", true)
                            local party = {}
                            for i,member in ipairs(Game.party) do
                                table.insert(party, member.id)
                            end
                            Game:setFlag("alvinRemembersParty", party)
                            alvin:setSprite("alvin_back")
                            return
                        else
                            cutscene:text("* Ah it appears your hands are already full.")
                        end
                    end
                    cutscene:text("* This is alright.[wait:5] You can come and take it from here anytime you want.")
                end
            else
                cutscene:text("* ...My father?")
                cutscene:text("* He was a great man.[wait:5] Inspiring many even beyond the grave.")
                cutscene:text("* I suppose his inspiration reached me as well in a way.")
                cutscene:text("* "..alvin_recognizes:getName()..",[wait:5] if you ever need to tell someone something...")
                cutscene:text("* Never wait too late to do it, alright?")
                cutscene:text("* You wouldn't want to leave this plane with regrets, would you?")
                cutscene:text("* ...")
                cutscene:text("* I'm sorry,[wait:5] it might have been too sudden of me to say this.")
                cutscene:text("* I suppose,[wait:5] just like my father was always a source of advice...")
                cutscene:text("* You can consider this my own advice.")
            end
            Game:setFlag("alvinAtGraveyard", true)
            local party = {}
            for i,member in ipairs(Game.party) do
                table.insert(party, member.id)
            end
            Game:setFlag("alvinRemembersParty", party)
        else
            cutscene:text("* May the Angel guides your way.")
        end
        alvin:setSprite("alvin_back")
    end
}

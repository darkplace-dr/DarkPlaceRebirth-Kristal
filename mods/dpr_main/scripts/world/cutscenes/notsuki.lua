return {
    script = function(cutscene, event)
        if Game:getFlag("tl_clock") then
            -- We pass nil as the second argument so that it doesn't mistake "notsuki" for being the name of a portrait.
            cutscene:text("* You won the race!", nil, "notsuki")
            if not Game:getFlag("tl_rwon") then
                cutscene:text("* Take this.", nil, "notsuki")
                local itemcheck = Game.inventory:addItem("harvester")
                if itemcheck then
                    cutscene:text("* She hands you a scythe.")
                    cutscene:text("* This scythe heals those who can wield it!", nil, "notsuki")
                    Game:setFlag("tl_rwon", true)
                else
                    cutscene:text("* You carry so much junk with you! Get rid of it first!", nil, "notsuki")
                end
            else
                cutscene:text("* But you already did, idiot.", nil, "notsuki")
                cutscene:text("* I won't reward you twice!", nil, "notsuki")
                cutscene:text("* You aren't the only one, you know.", nil, "notsuki")
                cutscene:text("* I have to make sure I can reward others too!", nil, "notsuki")
            end
        elseif not Game:getFlag("tl_nmet") then
            cutscene:text("* Hello, I am Notsuki. Not Natsuki, that's for sure!", nil, "notsuki")
            cutscene:text("* Welcome to Tritra Land!", nil, "notsuki")
            cutscene:text("* My master build this place.", nil, "notsuki")
            cutscene:text("* Mostly so you go to play his other works...", nil, "notsuki")
            cutscene:text("* This land is fanservice to those that actually bothered with his games.", nil, "notsuki")
            cutscene:text("* For instance to the right there is a replica of the Cinnamon Clouds race.", nil, "notsuki")
            cutscene:text("* If you manage to activate the clock and get to me fast enough...", nil, "notsuki")
            cutscene:text("* ...I'll give you a reward! The timer will be 12 seconds!", nil, "notsuki")
            if Game.playtime <= 1440 then
                cutscene:text("* ...", nil, "notsuki")
                cutscene:text("* You are new here, aren't you?", nil, "notsuki")
                cutscene:text("* You just arrived and came here.", nil, "notsuki")
                cutscene:text("* That's a compliment, isn't it?", nil, "notsuki")
                cutscene:text("* Well, I do have this still left from knitting.", nil, "notsuki")
                cutscene:text("* I know it's junk but it does act as armor.", nil, "notsuki")
                cutscene:text("* And besides, these scraps are almost worthless.", nil, "notsuki")
                cutscene:text("* I also have some stuffing left over from making plushies.", nil, "notsuki")
                cutscene:text("* With enough will they are like milk for the team.", nil, "notsuki")
                Game.inventory:addItem("bael_fur")
                Game.inventory:addItem("bael_fur")
                Game.inventory:addItem("cotton_milk")
                Game.inventory:addItem("cotton_milk")
                cutscene:text("* Notsuki hands you two scraps of bael fur as well as two bottles of cotton milk.")
            end
            Game:setFlag("tl_nmet", true)
        elseif Game:getFlag("tl_mwon") and not Game:getFlag("tl_mwonnr") then
            cutscene:text("* You won the arcade game, didn't you?", nil, "notsuki")
            cutscene:text("* Honestly, the entire reward being a single nut sucks.", nil, "notsuki")
            cutscene:text("* I know he set it up this way so it isn't overpowered...", nil, "notsuki")
            cutscene:text("* But still, it is a joke!", nil, "notsuki")
            cutscene:text("* So I have prepared a solution!", nil, "notsuki")
            cutscene:text("* Me, the great Notsuki!", nil, "notsuki")
            local itemcheck = Game.inventory:addItem("dancing_tear")
            if itemcheck then
                Game:setFlag("tl_mwonnr", true)
                cutscene:text("* Notsuki hands you a floating tear that dances around you.")
                cutscene:text("* It is a dancing tear, makes you REALLY tense.", nil, "notsuki")
                cutscene:text("* Those are actually my fuel.", nil, "notsuki")
                cutscene:text("* My key doesn't spin by itself you see.", nil, "notsuki")
                cutscene:text("* Luckily master has an infinite supply.", nil, "notsuki")
                cutscene:text("* Less luckily I need more than half of that infinite supply.", nil, "notsuki")
                cutscene:text("* So he can only have one robot running.", nil, "notsuki")
                cutscene:text("* Yet he made me as his one and only robot.", nil, "notsuki")
                cutscene:text("* ...", nil, "notsuki")
                cutscene:text("* I am glad I am alive.", nil, "notsuki")
                cutscene:text("* I am going to outlive master.", nil, "notsuki")
                cutscene:text("* Maybe I should ask him how that makes him feel?", nil, "notsuki")
                cutscene:text("* He probably will be happy when I tell him.", nil, "notsuki")
                cutscene:text("* I can sense it.", nil, "notsuki")
                cutscene:text("* So I should tell him that when he feels down.", nil, "notsuki")
                cutscene:text("* ...", nil, "notsuki")
            else
                cutscene:text("* But you should return when you can carry it.", nil, "notsuki")
            end
        else
            if Game:getFlag("mimicBossDone") and not Game:getFlag("edwin") then
                Game:setFlag("edwin", true)
                cutscene:text("* You defeated the mimic?", nil, "notsuki")
                cutscene:text("* Woah, you did it without violence.", nil, "notsuki")
                cutscene:text("* How do I know?", nil, "notsuki")
                cutscene:text("* Easy! K[wait:2]i[wait:2]l[wait:2]l[wait:2]e[wait:2]r[wait:2]s[wait:2] a[wait:2]r[wait:2]e[wait:2]n[wait:2]'t[wait:2] w[wait:2]e[wait:2]l[wait:2]c[wait:2]o[wait:2]m[wait:2]e[wait:2] h[wait:2]e[wait:2]r[wait:2]e.", nil, "notsuki")
                cutscene:text("* But you my friend, aren't.", nil, "notsuki")
                cutscene:text("* Here, this bat should fit you!", nil, "notsuki")
                itemcheck = Game.inventory:addItem("body_pillow")
                if itemcheck then
                    cutscene:text("* Notsuki hands you a body pillow.")
                else
                    cutscene:text("* Can't carry it? Your loss.", nil, "notsuki")
                end
            else
                if not Game:getFlag("tl_chest") then
                    cutscene:text("* I have hidden a chest somewhere in this room.", nil, "notsuki")
                    cutscene:text("* Try to find it! Bet you can't!", nil, "notsuki")
                elseif not Game:getFlag("tl_ct1") then
                    cutscene:text("* So you found the chest, huh?", nil, "notsuki")
                    cutscene:text("* That casette has music I really like on it!", nil, "notsuki")
                    cutscene:text("* I even tried convincing my master to use it for this room!", nil, "notsuki")
                    cutscene:text("* But he insisted on using self composed stuff...", nil, "notsuki")
                    cutscene:text("* Oh well, hope you enjoy that casette as much as I do!", nil, "notsuki")
                end
            end
        end
    end,
    warning = function(cutscene, event)
        cutscene:text("* You are capable of killing.", nil, "notsuki")
        cutscene:text("* I control the forcefields you know.", nil, "notsuki")
        if Game:getFlag("tl_nmet") then
            cutscene:text("* I should have noticed it sooner...", nil, "notsuki")
        end
        if Game:getFlag("tl_chest") then
            cutscene:text("* I would ask you to return the casette, but I'm not stupid.", nil, "notsuki")
        end
        cutscene:text("* I promise you, this land will not see harm!", nil, "notsuki")
        cutscene:text("* Go away punk, and pray to Nazrin for forgiveness...", nil, "notsuki")
        Game:setFlag("nazrinpissed", true)
        Game:setFlag("tl_nkyck", true)
    end,
    chest = function(cutscene, event)
        cutscene:text("* There is a chest here!")
        if not Game:getFlag("tl_chest") then
            local itemcheck = Game.inventory:addItem("casette")
            if itemcheck then
                cutscene:text("* You find a casette, an item that changes the music!")
                Game:setFlag("tl_chest", true)
            else
                cutscene:text("* You don't have enough space to take its loot...")
            end
        else
            cutscene:text("* As you already took a casette, it automatically closes!")
        end
    end
}
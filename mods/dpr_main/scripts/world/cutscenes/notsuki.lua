return {
    script = function(cutscene, event)
        if Game:getFlag("tl_clock") then
            cutscene:text("* [voice:nostuki]You won the race!")
            if not Game:getFlag("tl_rwon") then
                cutscene:text("* [voice:nostuki]Take this.")
                itemcheck = Game.inventory:addItem("harvester")
                if itemcheck then
                    cutscene:text("* She hands you a scythe.")
                    cutscene:text("* [voice:nostuki]This scythe heals those who can wield it!")
                    Game:setFlag("tl_rwon", true)
                else
                    cutscene:text("* [voice:nostuki]You carry so much junk with you! Get rid of it first!")
                end
            else
                cutscene:text("* [voice:nostuki]But you already did, idiot.")
                cutscene:text("* [voice:nostuki]I won't reward you twice!")
                cutscene:text("* [voice:nostuki]You aren't the only one, you know.")
                cutscene:text("* [voice:nostuki]I have to make sure I can reward others too!")
            end
        else
            if not Game:getFlag("tl_nmet") then
                cutscene:text("* [voice:nostuki]Hello, I am Notsuki. Not Natsuki, that's for sure!")
                cutscene:text("* [voice:nostuki]Welcome to Tritra Land!")
                cutscene:text("* [voice:nostuki]My master build this place.")
                cutscene:text("* [voice:nostuki]Mostly so you go to play his other works...")
                cutscene:text("* [voice:nostuki]This land is fanservice to those that actually bothered with his games.")
                cutscene:text("* [voice:nostuki]For instance to the right there is a replica of the Cinnamon Clouds race.")
                cutscene:text("* [voice:nostuki]If you manage to activate the clock and get to me fast enough...")
                cutscene:text("* [voice:nostuki]...I'll give you a reward! The timer will be 12 seconds!")
                Game:setFlag("tl_nmet", true)
            else
                if Game:getFlag("tl_mwon") and not Game:getFlag("tl_mwonnr") then
                    cutscene:text("* [voice:nostuki]You won the arcade game, didn't you?")
                    cutscene:text("* [voice:nostuki]Honestly, the entire reward being a single nut sucks.")
                    cutscene:text("* [voice:nostuki]I know he set it up this way so it isn't overpowered...")
                    cutscene:text("* [voice:nostuki]But still, it is a joke!")
                    cutscene:text("* [voice:nostuki]So I have prepared a solution!")
                    cutscene:text("* [voice:nostuki]Me, the great Notsuki!")
                    itemcheck = Game.inventory:addItem("dancing_tear")
                    if itemcheck then
                        Game:setFlag("tl_mwonnr", true)
                        cutscene:text("* Notsuki hands you a floating tear that dances around you.")
                        cutscene:text("* [voice:nostuki]It is a dancing tear, makes you REALLY tense.")
                        cutscene:text("* [voice:nostuki]Those are actually my fuel.")
                        cutscene:text("* [voice:nostuki]My key doesn't spin by itself you see.")
                        cutscene:text("* [voice:nostuki]Luckily master has an infinite supply.")
                        cutscene:text("* [voice:nostuki]Less luckily I need more than half of that infinite supply.")
                        cutscene:text("* [voice:nostuki]So he can only have one robot running.")
                        cutscene:text("* [voice:nostuki]Yet he made me as his one and only robot.")
                        cutscene:text("* [voice:nostuki]...")
                        cutscene:text("* [voice:nostuki]I am glad I am alive.")
                        cutscene:text("* [voice:nostuki]I am going to outlive master.")
                        cutscene:text("* [voice:nostuki]Maybe I should ask him how that makes him feel?")
                        cutscene:text("* [voice:nostuki]He probably will be happy when I tell him.")
                        cutscene:text("* [voice:nostuki]I can sense it.")
                        cutscene:text("* [voice:nostuki]So I should tell him that when he feels down.")
                        cutscene:text("* [voice:nostuki]...")
                    else
                        cutscene:text("* [voice:nostuki]But you should return when you can carry it.")
                    end
                else
                    if not Game:getFlag("tl_chest") then
                        cutscene:text("* [voice:nostuki]I have hidden a chest somewhere in this room.")
                        cutscene:text("* [voice:nostuki]Try to find it! Bet you can't!")
                    else
                        if not Game:getFlag("tl_ct1") then
                            cutscene:text("* [voice:nostuki]So you found the chest, huh?")
                            cutscene:text("* [voice:nostuki]That casette has music I really like on it!")
                            cutscene:text("* [voice:nostuki]I even tried convincing my master to use it for this room!")
                            cutscene:text("* [voice:nostuki]But he insisted on using self composed stuff...")
                            cutscene:text("* [voice:nostuki]Oh well, hope you enjoy that casette as much as I do!")
                        end
                    end
                end
            end
        end
    end,
    warning = function(cutscene, event)
        cutscene:text("* [voice:nostuki]You are capable of killing.")
        cutscene:text("* [voice:nostuki]I control the forcefields you know.")
        if Game:getFlag("tl_nmet") then
            cutscene:text("* [voice:nostuki]I should have noticed it sooner...")
        end
        if Game:getFlag("tl_chest") then
            cutscene:text("* [voice:nostuki]I would ask you to return the casette, but I'm not stupid.")
        end
        cutscene:text("* [voice:nostuki]I promise you, this land will not see harm!")
        cutscene:text("* [voice:nostuki]Go away punk, and pray to Nazrin for forgiveness...")
        Game:setFlag("nazrinpissed", true)
        Game:setFlag("tl_nkyck", true)
    end,
    chest = function(cutscene, event)
        cutscene:text("* There is a chest here!")
        if not Game:getFlag("tl_chest") then
            itemcheck = Game.inventory:addItem("casette")
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
return {
    hero = function(cutscene, event)
        cutscene:showNametag("Hero")
        cutscene:text("* Hey.", "neutral_closed", "hero")
        cutscene:hideNametag()
    end,
    susie = function(cutscene, event)
        cutscene:showNametag("Susie")
        if #Game.party >= 2 then
            cutscene:text("* Oh,[wait:5] hey guys.", "smile", "susie")
        else
            if Game.party[1].id == "hero" then
                cutscene:text("* Ah,[wait:5] Hero,[wait:5] it's good to see ya.", "smile", "susie")
            elseif Game.party[1].id == "kris" then
                cutscene:text("* Oh hey, Kris!", "smile", "susie")
            elseif Game.party[1].id == "noelle" then
                cutscene:text("* Heya Noelle.", "smile", "susie")
            elseif Game.party[1].id == "berdly" then
                cutscene:text("* Oh,[wait:5] uh,[wait:5] hey Berdly.", "neutral_side", "susie")
            end
        end
        cutscene:text("* You need anything?", "small_smile", "susie")
        cutscene:hideNametag()
        local opinion = cutscene:choicer({"Delta\nWarriors", "This Place", "You", "No"})
        cutscene:showNametag("Susie")
        if opinion == 1 then
            cutscene:text("* Ah,[wait:5] yeah I'm a part of the Delta Warriors.", "smile", "susie")
            cutscene:text("* Which one of em do you wanna know more about?", "small_smile", "susie")
            cutscene:hideNametag()
            opinion = cutscene:choicer({"Kris", "Ralsei", "Noelle", "Berdly"})
            cutscene:showNametag("Susie")
            if opinion == 1 then
                if Game.party[1].id == "kris" then
                    cutscene:text("* You wanna know what I think about you?", "surprise", "susie")
                    cutscene:text("* Jeez, Kris,[wait:5] I didn't know you had an ego!", "smile", "susie")
                    cutscene:text("* Heh,[wait:5] I'm kidding, I'm kidding.", "closed_smile", "susie")
                    cutscene:text("* Mostly.", "shock_nervous", "susie")
                    cutscene:text("* But yeah, I think you're a really great friend!", "sincere_smile", "susie")
                else
                    cutscene:text("* Kris,[wait:5] huh?", "small_smile", "susie")
                    cutscene:text("* Honestly they're a great friend!", "smile", "susie")
                    cutscene:text("* And a great leader as well.", "small_smile", "susie")
                    cutscene:text("* I sorta regret picking on them before now.", "shy_down", "susie")
                    cutscene:text("* Well,[wait:5] at least I'm tryna make up for that.", "small_smile", "susie")
                end
            elseif opinion == 2 then
                cutscene:text("* Ralsei?", "small_smile", "susie")
                cutscene:text("* Yeah,[wait:5] he's cool.", "smile", "susie")
                cutscene:text("* Even if he's a total weenie...", "nervous", "susie")
                cutscene:text("* Speaking of him...", "nervous_side", "susie")
                cutscene:text("* I haven't seen him in this Dark World at all.", "neutral", "susie")
                cutscene:text("* I wonder what happend to him.", "neutral_side", "susie")
                cutscene:text("* Hopefully he's okay...", "shy_down", "susie")
                -- Commented out for now
                --[[if not Game:getFlag("ralseimissing_known") then
                    Kristal.callEvent("setDesc", "mainline",
                        "Well as it turns out Ralsei was wrong when he said that making Dark Fountains causes The Roaring, \z
                        they just get weirder the more you make. Susie has been making them left right and center, \z
                        and she is now on her 1000th fountain. Susie mentioned Ralsei being missing, \z
                        maybe try and find clues relating to him?"
                    )
                    Game:setFlag("ralseimissing_known", true)
                end]]
            elseif opinion == 3 then
                cutscene:text("* Oh,[wait:5] Noelle?", "surprise", "susie")
                cutscene:text("* Honestly she's really nice to me.", "sincere", "susie")
                cutscene:text("* Which is strange considering how much of a jerk I was...", "nervous_side", "susie")
                cutscene:text("* Wonder what's up with her?", "neutral", "susie")
            elseif opinion == 4 then
                if Game:getFlag("POST_SNOWGRAVE") then
                    cutscene:text("* ... Berdly?", "surprise", "susie")
                    cutscene:text("* He's NOT someone I'd call a \"Delta Warrior\",[wait:5] but...", "sus_nervous", "susie")
                    cutscene:text("* I actually haven't seen him for a while now...", "suspicious", "susie")
                else
                    cutscene:text("* Ah,[wait:5] Berdly.", "neutral", "susie")
                    cutscene:text("* He's um...", "neutral_side", "susie")
                    cutscene:text("* Okay he's not BAD,[wait:5] he's just...", "nervous", "susie")
                    cutscene:text("* Really annoying.", "nervous_side", "susie")
                    cutscene:text("* But uh,[wait:5] even with THAT...", "shy", "susie")
                    cutscene:text("* I still consider him a friend.", "small_smile", "susie")
                    cutscene:text("* Somewhat.", "shy_b", "susie")
                end
            end
            if not Game:getFlag("drcastsplitup_known") then
                cutscene:text("* Y'know,[wait:5] speaking of those guys...", "neutral_side", "susie")
                cutscene:text("* I didn't see them at all when I first entered this Dark World.", "nervous", "susie")
                cutscene:text("* Which is strange because we were all together when we entered.", "nervous_side", "susie")
                cutscene:text("* Not gonna lie,[wait:5] I'm starting to worry for them...", "shy_down", "susie")
                Game:getQuest("krismissing"):unlock()
                Game:getQuest("noellemissing"):unlock()
                if not Game:getFlag("POST_SNOWGRAVE") then
                    Game:getQuest("berdlymissing"):unlock()
                end
                Game:setFlag("drcastsplitup_known", true)
            end
        elseif opinion == 2 then
            cutscene:text("* What do I think of this place?", "neutral", "susie")
            cutscene:text("* Well I think it's weird as hell.", "neutral_side", "susie")
            cutscene:text("* I guess that's what you get for uh...", "nervous_side", "susie")
            cutscene:text("* Making a thousand Dark Fountains I guess.", "nervous", "susie")
        elseif opinion == 3 then
            cutscene:text("* Oh you wanna know more about me?", "shy", "susie")
            cutscene:text("* Well,[wait:5] I'm Susie!", "smile", "susie")
            cutscene:text("* But uh,[wait:5] you already knew that.", "nervous_side", "susie")
            cutscene:text("* Honestly what else is there to say about me?", "nervous", "susie")
        elseif opinion == 4 then
            cutscene:text("* Ah,[wait:5] alright then.", "neutral", "susie")
            cutscene:text("* Well uh,[wait:5] I'm always here if you DO need me.", "small_smile", "susie")
            cutscene:text("* Man it's boring not being in the party...", "shy_down", "susie")
        end
        cutscene:hideNametag()
    end,
    dess = function(cutscene, event)
        event:facePlayer()
        cutscene:showNametag("Dess")
        cutscene:text("* eyyy what's upp it's me Dess", "heckyeah", "dess")
        cutscene:hideNametag()
        event:setFacing("down")
    end,
    noelle = function(cutscene, event)
        event:facePlayer()
        cutscene:showNametag("Noelle")
        cutscene:text("* Oh,[wait:5] uh...[wait:5] Hey there.", "smile_closed", "noelle")
        cutscene:hideNametag()
        event:setFacing("down")
    end,
    berdly = function(cutscene, event)
        event:facePlayer()
        cutscene:showNametag("Berdly")
        cutscene:text("* Ah...[wait:5] Greetings,[wait:5] my fellow teammate.", "smirk", "berdly")
        cutscene:hideNametag()
        event:setFacing("down")
    end,
    kris = function(cutscene, event)
        cutscene:text("* (They just stand in silence,[wait:5] seemingly looking in Susie's direction.)")
    end,
    ralsei = function(cutscene, event)
        event:facePlayer()
        cutscene:showNametag("Ralsei")
        cutscene:text("* Oh,[wait:5] hello there![wait:5] You need anything?", "blush_smile", "ralsei")
        cutscene:hideNametag()
        event:setFacing("down")
    end,
    mario = function(cutscene, event)
        event:facePlayer()
        cutscene:showNametag("Mario")
        cutscene:text("* I wonder if they serve spaghetti in here", "main", "mario")
        cutscene:hideNametag()
        event:setFacing("down")
    end,
    pauling = function(cutscene, event)
        cutscene:text("* (She seems to be concentrated on writing something down...)")
    end,
    ostarwalker = function(cutscene, event)
        cutscene:text("* This party room is[wait:10]\n       pissing me off")
    end,

-- keep this at the bottom
-- and type a face every time you edit this file
-- :|
-- :O
-- :(
-- :)
-- :P
-- :/
    party = function(cutscene, event)
        cutscene:after(function()
           Game.world:openMenu(DarkCharacterMenu())    
           Game.world.menu.ready = true
        end)
    end,
}
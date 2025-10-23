---@type table<string, fun(cutscene:WorldCutscene, event?:NPC|Event)>
local desslmao = {
    dessbegin = function(cutscene)
        Kristal.callEvent(KRISTAL_EVENT.onDPDessTalk)
        local dess = cutscene:getCharacter("dess")
        local susie = cutscene:getCharacter("susie")
        local jamm = cutscene:getCharacter("jamm")
        local osw = cutscene:getCharacter("ostarwalker")

        local noel = cutscene:getCharacter("noel")
        local data = Noel:loadNoel()

        local noel_remembered_dess, noel_not_remembered_dess
        cutscene:showNametag("Dess Holiday?")
        if #Game.party == 1 then
            cutscene:text("* Yooo hey it's great to see you again", "condescending", "dess")
        else
            cutscene:text("* Yooo hey it's great to see you guys again", "condescending", "dess")
        end
        cutscene:setSpeaker("dess")
        cutscene:textTagged("* its me,[wait:5] dess,[wait:5] from hit kristal mod dark place", "heckyeah", "dess")

        if osw then
            cutscene:textTagged("* And I[wait:10] am\n\n              [wait:10][color:yellow]Starwalker[color:reset]", nil, "ostarwalker")
        end

        if susie then
            cutscene:setSpeaker("susie")
            cutscene:textTagged("[speed:0.5]* ...", "neutral_side", "susie")
            cutscene:textTagged("* I have literally never seen you before in my life.", "annoyed", "susie")
        elseif cutscene:getCharacter("hero") then
            cutscene:setSpeaker("hero")
            cutscene:textTagged("* Uh,[wait:5] am I supposed to know you?", "really")
        elseif noel then -- make sure this character is always next to last
                cutscene:showNametag("Noel")
            if Noel:getFlag("met_dess") then
                cutscene:text("* Nice to see you again?", "bruh", "noel")
                noel_remembered_dess = true
            else
                cutscene:text("* ... [wait:10]Huh?", "huh", "noel")
                cutscene:text("* You talking to me?", "...", "noel")
                cutscene:text("* Pardon,[wait:5] but I think you have me confused for someone who looks [func:tag]and sounds exactly like me.", "bruh", "noel", 
                {
                    functions = {
                        tag = function (text)
                            local face = Game.world.cutscene.textbox.face
                            face.y = face.y + 17
                            Game.world.cutscene.textbox.box.height = 103 + 34
                            Game.world.cutscene.nametag.y = 185 + 34
                        end
                    }
                })
                cutscene:showNametag("A very worrisome mistake.")
                cutscene:text("* A simple wistake.[func:tag]", "huh", "noel", 
                {
                    functions = {
                        tag = function (text)
                            cutscene:text("[instant]* A simple mistake.", "neutral", "noel")
                            cutscene:showNametag("(Nothing was here.)")
                        end
                    }
                })
                Noel:setFlag("met_dess", true) 
                noel_not_remembered_dess = true
            end
        else
            cutscene:textTagged("[speed:0.5]* ...", "heckyeah", "dess")
            cutscene:textTagged("* hey why are you looking at me like that", "eyebrow", "dess")
        end
        cutscene:setSpeaker("dess")
        if noel_remembered_dess then
            cutscene:textTagged("* ayyy finally someone remembers me", "condescending", "dess")
            cutscene:textTagged("* anyways", "calm_b", "dess")
        elseif noel_not_remembered_dess then
            cutscene:textTagged("* nah man that was totally you", "wink", "dess")
        else
            cutscene:textTagged("* aw c'mon don't tell me you guys forgot about me", "neutral", "dess")
            
            if osw then
                cutscene:textTagged("*      [wait:20][color:yellow]no[color:reset]", nil, "ostarwalker")
                cutscene:textTagged("* no as in you didnt forget or no as in you did", "neutral_b", "dess")
                cutscene:textTagged("*      [wait:20][color:yellow]yes[color:reset]", nil, "ostarwalker")
                cutscene:textTagged("* aight", "neutral", "dess")
                
            end
        end
        
        if jamm then
            cutscene:showNametag("Dess")
            cutscene:text("* you at least remember me, right, jammy?", "wink", "dess")
            cutscene:showNametag("Jamm")
            cutscene:text("* Yeah,[wait:5] I remember you...[react:1]", "stern", "jamm", {reactions={
                {"Unfortunately...", 352, 61, "stern", "jamm"}
            }})
            cutscene:showNametag("Dess")
            cutscene:text("* so you remember the adventures we had before?", "wink", "dess")
            cutscene:showNametag("Jamm")
            cutscene:text("* I have no idea what you're talking about...", "nervous_left", "jamm")
            cutscene:showNametag("Dess")
            cutscene:text("* quit joking around lmao", "smug", "dess")
        end

        cutscene:textTagged("* I've been training in the hyperbolic time chamber for 20 years", "condescending", "dess")
        cutscene:textTagged("* got a whole entire attack point out of it", "heckyeah", "dess")
        cutscene:textTagged("* you could call me pretty strong now", "challenging", "dess")
        cutscene:textTagged("* a side effect tho is that i lost all of my character development", "genuine", "dess")
        cutscene:textTagged("* cause this is a reboot babyyyyy", "challenging", "dess")

        if noel and data.met_dess and data.met_dess.understanding then
            cutscene:showNametag("Noel")
            cutscene:text("* Yeah, that's basically what happened.", "bruh", "noel")
        elseif noel and Noel:getFlag("met_dess") and not noel_not_remembered_dess then
            cutscene:showNametag("Noel")
            cutscene:text("* Stop using keywords, you're gonna confuse people.[func:tag]", "bruh", "noel", 
            {
                functions = {
                    tag = function (text)
                        cutscene:showNametag("Inventory, Skills, Attributes, Stats, Combat, Party, Buff, Debuff, Crafting, Loot, EXP.")
                    end
                }
            })
        elseif noel then
            cutscene:showNametag("Noel")
            cutscene:text("* You don't care at all about keeping a low profile do you?", "bruh", "noel")
            cutscene:text("* Well,[wait:5] neither do I\n[wait:10][face:bruh]but that's besides the point.", "oh", "noel")
                Noel:setFlag("met_dess", true)
        end

        if susie then
            cutscene:setSpeaker("susie")
            cutscene:textTagged("[speed:0.5]* ...", "nervous_side", "susie")
            cutscene:textTagged("* I have no idea what anything you just said meant.", "nervous", "susie")
            cutscene:setSpeaker("dess")
        end
        cutscene:textTagged("* Oh yeah can I join your team btw", "neutral", "dess")

        cutscene:setSpeaker()
        cutscene:text("* (Can she join your team btw?)")
        local can_she_join_your_team_btw = cutscene:choicer({"Yes", "No"})

        cutscene:setSpeaker("dess")
        if can_she_join_your_team_btw == 1 then
            cutscene:textTagged("* sick", "condescending")
        else
            cutscene:textTagged("* Uhhh I don't care im joining anyways", "condescending")
        end
        cutscene:hideNametag()

        Game.world.music:stop()
        local fan = Music("deltarune/fanfare", 1, 0.9, false)

        cutscene:detachFollowers()

        for i, member in ipairs(Game.party) do
            local char = cutscene:getCharacter(member.id)
            char:slideTo(char.x - (40 + (i*10)), char.y, 2, "out-cubic")
        end        

        cutscene:walkTo("dess", dess.x - 50, dess.y + 10, 11, "left")
        cutscene:setSpeaker()
        cutscene:text("[noskip][voice:none][speed:0.1]* (Dess joined the party!)[wait:70]\n\n[speed:1](Unfortunately)", {auto = true})
        fan:remove()
        Game.world.music:resume()

        cutscene:setSpeaker("dess")
        cutscene:textTagged("* Ok follow me guys", "heckyeah", "dess")
        if susie then
            cutscene:setSpeaker("susie")
            susie:setSprite("shock_right")
            cutscene:textTagged("* Wh-", "shock", "susie")
            susie:setSprite("exasperated_right")
            cutscene:textTagged("* THAT'S NOT HOW THIS WORKS!", "teeth_b", "susie")
            cutscene:setSpeaker("dess")
            cutscene:textTagged("* uhhhh idc", "condescending", "dess")
            cutscene:textTagged("* just be happy i didnt smack the party leader with my bat this time", "condescending", "dess")
            cutscene:setSpeaker("susie")
            cutscene:textTagged("* I-", "teeth", "susie")
            cutscene:hideNametag()
            susie:setSprite("walk_unhappy/right_1")
            susie:shake(5)
            Assets.stopAndPlaySound("wing")
            cutscene:wait(1)
            cutscene:setSpeaker("susie")
            cutscene:textTagged("* Ughhh,[wait:5] do I have much of a choice?", "annoyed", "susie")
            cutscene:setSpeaker("dess")
            cutscene:textTagged("* mmmmnope", "smug", "dess")
            cutscene:textTagged("* hey if it makes you feel any better", "calm", "dess")
            cutscene:textTagged("* i'll MAYBE give the leader's position back at the end of this", "condescending", "dess")
            cutscene:textTagged("* MAYBE", "calm_b", "dess")
            cutscene:setSpeaker("susie")
            cutscene:textTagged("* ...[wait:10] Fine,[wait:5] lead the way.", "annoyed_down", "susie")
            cutscene:setSpeaker("dess")
            cutscene:textTagged("* awesome sauce", "challenging", "dess")
        elseif cutscene:getCharacter("hero") then
            cutscene:setSpeaker("hero")
            cutscene:textTagged("* [speed:0.25]...[wait:10][speed:1] [face:neutral_closed_b]Wait what?", "neutral_closed")
        end
        cutscene:hideNametag()
        cutscene:wait(cutscene:fadeOut(.25))
        cutscene:wait(0.25)

        -- Wooo party setup time
        Game:addPartyMember("dess", 1)

        local over_capacity = " "

        if Game.party[4] then
            over_capacity = Game.party[4].id 
        end


        if #Game.party == 4 then
            Game:addFollower(Game.party[4].id)
            Game:removePartyMember(Game.party[4].id)
        end
        local old_followers = {}
        for _, value in ipairs(Game.world.followers) do
            table.insert(old_followers, value)
        end
        Game.world.player:convertToFollower(2)
        for i, follower in ipairs(old_followers) do
            follower:convertToFollower(2+i)
        end
        cutscene:interpolateFollowers()

        cutscene:getCharacter("dess"):convertToPlayer()
        cutscene:walkTo(Game.world.player, Game.world.player.x-200, Game.world.player.y, 2)
        cutscene:wait(2.2)
        cutscene:wait(cutscene:fadeIn(0.25))
        if fullparty then
            --[[if susie then
                -- I'll write dialogue for this later
            else
                cutscene:setSpeaker("dess")
                cutscene:textTagged("* oh yeah btw you can only have 3 party members at once", "heckyeah", "dess")
                cutscene:textTagged("* they had to nerf that shit", "heckyeah", "dess")
                cutscene:textTagged("* smth about it being too overpowered", "heckyeah", "dess")
                cutscene:textTagged("* anyways lets go", "heckyeah", "dess")
            end]]
            cutscene:setSpeaker("dess")
            cutscene:textTagged("* oh yeah btw you can only have 3 party members at once", "neutral", "dess")
            cutscene:textTagged("* they had to nerf that shit from last time", "angry", "dess")
            cutscene:textTagged("* smth about it being too overpowered", "neutral_b", "dess")
            cutscene:textTagged("* anyways lets go", "heckyeah", "dess")
        else
            cutscene:setSpeaker("dess")
            cutscene:textTagged("* ok lets go", "heckyeah", "dess")
        end


        if over_capacity == "ostarwalker" then
            cutscene:textTagged("* This is\n\n     [wait:20][color:yellow]bullshit[color:reset]", nil, "ostarwalker")
        elseif over_capacity == "susie" then
            if Game.party[3].name == "Berdly" then
                cutscene:textTagged("* Why the hell do I have to be out back!?", "neutral", "susie")
                cutscene:textTagged("* Ah, fret not my", "neutral", "berdly")
            else
                cutscene:textTagged("* Yeah, like I'd do that.", "neutral", "susie")
                cutscene:textTagged("* Switch spots with me person in front of me.", "neutral", "susie")

                if Game.party[3].id == "jamm" then
                    cutscene:showNametag("Jamm")
                    cutscene:text("* No cutsies,[wait:5] Susie.", "stern", "jamm")
                    cutscene:showNametag("Susie")
                    cutscene:text("* Oh,[wait:5] come on!", "teeth", "susie")
                else
                    local susie_id = Game.world.followers[3].actor.id

                    local susie = Game.world.followers[3]
                    local character_swap = Game.world.followers[2]
        
                    Game:addPartyMember(susie_id)
                    Game:removePartyMember(Game.party[3])
        
                    susie:convertToFollower(2)
                    character_swap:convertToFollower(3)
        
                    cutscene:interpolateFollowers()
                    cutscene:wait(0.5)
                end
            end

        elseif over_capacity == "noel" then
            cutscene:setSpeaker("Noels")
            cutscene:text("* Guess I'm sitting this one out.", "bruh", "noel")
            cutscene:text("* Seems easier than having to do literally anything productive with my meaningless life.", "bruh", "noel")
        elseif over_capacity == "jamm" then
            cutscene:showNametag("Jamm")
            cutscene:text("* (Guess I could do with a break for now anyways...)", "nervous_left", "jamm")
        end
        cutscene:hideNametag()

        --Kristal.callEvent("completeAchievement", "starstruck") -- Uncomment this when we've added achievements
        Game:setFlag("gotDess", true)
        Game:unlockPartyMember("dess")

        local susie_party = Game:getPartyMember("susie")
        if cutscene:getCharacter("susie") then
            susie_party:addOpinion("dess", -10)
        end
    end,

    dessgetoverhere = function(cutscene, event)
        if Game:isDessMode() then
            cutscene:showNametag("Dess")
            cutscene:text("* hmmm for some reason i feel like i'm missing something", "neutral_b", "dess")
            cutscene:text("* oh i know", "eurika", "dess")
            cutscene:hideNametag()
            cutscene:text("* (Dess can now ACT!)")
            Game:setFlag("dess_canact", true)
            Game:getPartyMember("dess").has_act = true
            Game:setFlag("dessThingy", true)
            Game:setFlag("desshere_kills", Game:getPartyMember("dess").kills)
            if event then
                event:remove()
            end
        else
            if Game:getFlag("gotDess") then
                cutscene:setSpeaker("dess")
                cutscene:textTagged("* Hey I can do a crazy impression watch this", "condescending", "dess")
                cutscene:textTagged("* Look at meeee I'm FRISK from [funnytext:ut,ut_intronoise,0,0,92,4] lmao", "calm", "dess")
    
                if cutscene:getCharacter("noel") then
                    cutscene:showNametag("Noel")
                    cutscene:text("[func:tag]* Damn, where did Dess go?", "bruh", "noel", 
                    {
                        functions = {
                            tag = function (text)
                                text.rotation = 0.1                    
                            end
                        }
                    })
                end
    
                if cutscene:getCharacter("susie") then
                    cutscene:setSpeaker("susie")
                    cutscene:textTagged("[speed:0.5]* ...", "nervous_side", "susie")
                    cutscene:textTagged("* (Who the hell is THAT?)", "nervous", "susie")
                elseif cutscene:getCharacter("jamm") then
                    cutscene:showNametag("Jamm")
                    cutscene:text("* (Is that racist? Is Dess being racist?)", "stern", "jamm")
                end
                cutscene:hideNametag()
                Game:setFlag("dessThingy", true)
                if event then
                    event:remove()
                end
            else
                local leader = Game.world.player
                
                cutscene:showNametag("???")
                cutscene:textTagged("* Hey fucker you need to come talk to me first", "neutral", "dess")
                
                cutscene:hideNametag()
                leader.y = leader.y + 12
            end
        end
    end,

    dessboss = function(cutscene, event)
        local boss = cutscene:getCharacter("ufoofdoom", 1)
        local whodis = {nametag = "???"}
        
        local wave_mag = 0
        local function getFXWaveMag()
            return wave_mag
        end
        boss:addFX(ShaderFX("wave", {
            ["wave_sine"] = function () return Kristal.getTime() * 100 end,
            ["wave_mag"] = function () return getFXWaveMag() end,
            ["wave_height"] = 2,
            ["texsize"] = { SCREEN_WIDTH, SCREEN_HEIGHT }
        }), "funky_mode")

        local function mimicTwitch(amount)
            wave_mag = wave_mag + 0.5

            boss:shake(amount)
            Assets.stopAndPlaySound("wing", nil, 1 + (wave_mag / 2))
        end

        local susie = cutscene:getCharacter("susie")
        local jamm = cutscene:getCharacter("jamm")
        local leader = Game.world.player

        local noel_party = Game:hasPartyMember("noel")

        cutscene:detachFollowers()
        cutscene:detachCamera()

        for i,party in ipairs (Game.world.followers) do
            if i == 1 then
                cutscene:walkTo(cutscene:getCharacter(party.actor.id), leader.x-40, leader.y+20, 1, "up")
            end
            if i == 2 then
                cutscene:walkTo(cutscene:getCharacter(party.actor.id), leader.x+40, leader.y+20, 1, "up")
            end
        end

        if susie then
            cutscene:setSpeaker("susie")
            cutscene:textTagged("* Ugh,[wait:10] alright,[wait:5] is this the last one?!", "angry", "susie")

            cutscene:setSpeaker("dess")
            cutscene:textTagged("* Yep", "neutral", "dess")

            cutscene:setSpeaker("susie")
            cutscene:textTagged("* Alright...[wait:10] let's finally get outta here.", "annoyed_down", "susie")
        elseif Noel:dessParty() then
            if Noel:getFlag("knows_mimic") then
                cutscene:textTagged("* This is it Dess...[wait:5] The mimic boss...", "bruh", "noel")
                cutscene:textTagged("* [speed:0.1]...[wait:10] [speed:1][face:eyebrow]the what?", "neutral", "dess")
            else
                cutscene:textTagged("* This area is very well designed i'm so glad i have it all to myself", "condescending", "dess")
                cutscene:textTagged("* I'm literally right here...", "bruh", "noel")
                cutscene:textTagged("* [speed:0.1]...[wait:5] [speed:1][face:genuine_b]No you're not", "kind", "dess")
                cutscene:textTagged("* Yes I am.", "...", "noel")
                cutscene:textTagged("* Nuh uh.", "kind", "dess")
                cutscene:textTagged("* Yuh uh.", "bruh", "noel")
                cutscene:textTagged("* Ttfym yuh uh???", "angry", "dess")
            end
        elseif jamm then
            cutscene:showNametag("Jamm")
            cutscene:text("* Jeez,[wait:5] finally,[wait:5] the last one...", "stern", "jamm")
        else
            cutscene:setSpeaker("dess")
            cutscene:textTagged("* This area is very well designed i'm so glad i have it all to myself", "condescending", "dess")
        end
        cutscene:hideNametag()

        cutscene:wait(1)
        mimicTwitch(2)
        cutscene:wait(2)

        if susie then
            cutscene:setSpeaker("susie")
            cutscene:textTagged("* Did you just see that??", "surprise_frown", "susie")
            cutscene:textTagged("* Why did it just shake?", "shy_b", "susie")
            cutscene:setSpeaker("dess")
            cutscene:textTagged("* That's normal, all the other ones shake if you hit them", "neutral", "dess")
        elseif Noel:dessParty() then
            if Noel:getFlag("knows_mimic") then
                cutscene:textTagged("* The mimic?[wait:5] The boss that changes shape and complains about the meta.", "bruh", "noel")
                cutscene:textTagged("* Do you have the stupid?", "genuine_b", "dess")
                cutscene:textTagged("* That's just a normal flying thingy.", "kind", "dess")
            else
                cutscene:textTagged("* Man that was a long pause...[wait:10][face:...] Wait did that thing just move?", "huh", "noel")
                cutscene:textTagged("* sopt ignoring my question", "angry", "dess")
            end
        elseif jamm then
            cutscene:showNametag("Jamm")
            cutscene:text("* Hold on...[wait:10]\n* Is something happening?", "suspicious", "jamm")
            cutscene:showNametag("Dess")
            cutscene:text("* wdym all the other ones shake if you hit them", "neutral", "dess")
        else
            cutscene:setSpeaker("dess")
            cutscene:textTagged("* ...", "kind", "dess")
        end
        cutscene:hideNametag()

        mimicTwitch(4)

        if susie then
            cutscene:setSpeaker("susie")
            cutscene:textTagged("* But...[wait:10] we didn't hit it!", "shock_down", "susie")
        elseif jamm then
            cutscene:showNametag("Jamm")
            cutscene:text("* Pretty sure we didn't touch this one yet...", "nervous_left", "jamm")
        elseif Noel:dessParty() then
            if Noel:getFlag("knows_mimic") then
                cutscene:textTagged("* I think I know what I'm talking about.[wait:5] Ya'see[wait:5] I've played these games before.", "neutral", "noel")
                cutscene:textTagged("*", "mspaint", "dess")
            else
                cutscene:textTagged("* Dess I can't come up with jokes for these long non-dramatic pauses please do it for me.", "oh", "noel")
            end
        else
            cutscene:textTagged("* ...", "neutral", "dess")
        end
        cutscene:hideNametag()

        mimicTwitch(8)

        cutscene:setSpeaker("dess")
        if susie or jamm then
            cutscene:textTagged("* Yo wait you're right!", "wtf_b")
        elseif Noel:dessParty() then
            if Noel:getFlag("knows_mimic") then
                cutscene:textTagged("*", "mspaint", "dess")
                cutscene:textTagged("* Are-[wait:5] Are you okay?", "...", "noel")
                cutscene:textTagged("*", "mspaint", "dess")
                cutscene:textTagged("* Dess?", "huh", "noel")
                cutscene:textTagged("* Oh look the thingy is headed straight for us.", "condescending", "dess")
            else
                cutscene:textTagged("* Nice try,[wait:5] I'm not falling for that.", "condescending", "dess")
            end
        else
            cutscene:textTagged("* Oh shit!", "wtf_b")
        end
        mimicTwitch(10)

        cutscene:setSpeaker()
        cutscene:hideNametag()
        mimicTwitch(12)

        wave_mag = Utils.clampMap(boss.alpha, 1, 0.5, 2, 64)

        boss:fadeTo(0.5, 0.2)
        cutscene:wait(1)
        boss.y = boss.y + 256
        boss:fadeTo(0, 0)
        boss:fadeTo(1, 0.25)
        cutscene:panTo(boss.x, boss.y - 32, 2)
        
        cutscene:wait(0.8)

        for i,party in ipairs (Game.world.followers) do
            cutscene:look(cutscene:getCharacter(party.actor.id), "down")
        end
        cutscene:look(leader, "down")
        
        cutscene:wait(1.2)
        cutscene:setSpeaker(boss)
        cutscene:textTagged("* Alright,[wait:6] let's cut the crap.", whodis)
        --cutscene:textTagged("* Uheehee!", whodis)
        cutscene:hideNametag()

        if susie then
            cutscene:setSpeaker("susie")
            cutscene:textTagged("* Who the hell are you?!", "angry", "susie")
        end
        
        cutscene:setSpeaker(boss)
        cutscene:textTagged("* I'm the mimic.[wait:10] You know me.\n* I've been the boss here since forever.", whodis)
        
        if Noel:dessParty() then
            cutscene:textTagged("* Are you sure?[wait:5][face:calm] Cuz I cant see you", "condescending", "dess")
        elseif jamm then
            cutscene:showNametag("Jamm")
            cutscene:text("* I have never seen you before in my life.", "nervous_left", "jamm")
        else
            cutscene:setSpeaker("dess")
            cutscene:textTagged("* yea and?", "neutral", "dess")
        end
        cutscene:hideNametag()

        cutscene:setSpeaker(boss)
        cutscene:textTagged("* I'm sick of it![wait:10]\n* I'm sick of all this meta-on-meta nonsense!", whodis)
        cutscene:textTagged("* Jokes upon memes upon cycles\nof the same tired things...\n* All of us on different 'layers'", whodis)
        cutscene:textTagged("* Tell me,[wait:6] what do the other party members think?", whodis)
        
        if susie then
            cutscene:setSpeaker("susie")
            cutscene:textTagged("* ...???", "shy", "susie")
        end
        
        if jamm then
            cutscene:showNametag("Jamm")
            cutscene:text("* Is...[wait:10] there something wrong with that?", "nervous_left", "jamm")
        end
        cutscene:hideNametag()

        if Noel:dessParty() then
            if Noel:getFlag("knows_mimic") then
                cutscene:textTagged("* Your whining is annoying please shut the fuck.[wait:5]  ", "...", "noel", {auto = true})
                cutscene:textTagged("[instant]* Your whining is annoying please shut the up.", "...", "noel")
            else
                cutscene:textTagged("* Shush[wait:5] I'm wasnt talkin to you", "calm", "dess")
                cutscene:textTagged("* besides this is dess mode there's nobody else here", "calm", "dess")
                cutscene:textTagged("* I'm literally right here!!!!", "madloud", "noel")
                cutscene:textTagged("* silence dess 2", "condescending", "dess")
                cutscene:textTagged("* wha-", "excusemebutwhatthefuck", "noel")
                cutscene:textTagged("* oh hey is that the mimic?", "neutral_c", "dess")
            end
        elseif Game:isDessMode() then
            cutscene:setSpeaker("dess")
            cutscene:textTagged("* uhhh this is dess mode there's nobody else here", "eyebrow", "dess")
        end
        
        cutscene:setSpeaker("dess")
        cutscene:textTagged("* Look man.", "condescending", "dess")
        cutscene:textTagged("* That's no reason to go\nall 'boss-fightey\nstartey' on us.", "eyebrow", "dess")
        
        cutscene:setSpeaker(boss)
        cutscene:textTagged("* What I'm saying is...", whodis)
        cutscene:textTagged("* It's exhausting,[wait:6] 'Dess'.[wait:10]\n* I'm just a bossfight,[wait:6] I can't change that.", whodis)
        cutscene:textTagged("* But what I *can* do is talk.[wait:10]\n* So all I really have to say is...", whodis)

        if Game:isDessMode() then
            cutscene:text("[noskip]* Happy new year,[wait:6] 199-", nil, nil, {auto = true})
            Game.world.music:stop()
            Assets.playSound("recordscratch")
            cutscene:setSpeaker("dess")
            cutscene:textTagged("* okay i've had enough of your crap", "angry", "dess")
            cutscene:textTagged("* i have no idea what anything you're saying means", "neutral_b", "dess")
            cutscene:textTagged("* and frankly,[wait:5] you're starting to piss me off", "annoyed", "dess")
            cutscene:textTagged("* this is MY area,[wait:5] not yours", "angry", "dess")
            cutscene:textTagged("* and i'm gonna kick your fuckin ass", "heckyeah", "dess")
            Assets.playSound("cardrive", 1.5, 0.9)
            Game.world.music:fade(0, 0.8)
            cutscene:wait(cutscene:fadeOut(1, {color = {1,1,1}}))

            if Noel:dessParty() and Game:isDessMode() then
                local noel = Game.world:getCharacter("noel")
                cutscene:slideTo(noel, noel.x -80, noel.y, 1)
            end

            local dess_party = Game:getPartyMember("dess")
            dess_party:increaseStat("health", 250)
            dess_party:increaseStat("attack", 15)
            dess_party:increaseStat("magic", 20)
            dess_party:increaseStat("defense", 10)
            dess_party:setActor("dess_super")
            Game:setFlag("super_dess", true)
            Game.world.player:setActor("dess_super")
            cutscene:wait(2)
            Game.world.music:play("undefeatable", 0.65, 1)
            cutscene:wait(cutscene:fadeIn(1))
            cutscene:wait(1)
            cutscene:setSpeaker(nil)
            cutscene:text("[noskip]* (Dess's stats increased dramatically!)")
            cutscene:setSpeaker(boss)
            cutscene:textTagged("* What the hell?!", whodis)
            if Noel:dessParty() then
                cutscene:textTagged("* oh thats new...", "oh", "noel")
            end
            cutscene:setSpeaker("dess")
            cutscene:textTagged("* heh,[wait:5] what's wrong,[wait:5] deer got your tongue?", "condescending", "dess_super")

            if Noel:dessParty() then
                cutscene:textTagged("* you may think you had the advantage since it was just me and dess 2", "calm", "dess_super")
                cutscene:textTagged("* I have a name...", "oh", "noel")
            else
                cutscene:textTagged("* you may think you had the advantage since it was just me...", "calm", "dess_super")
            end
            cutscene:textTagged("* but you're dead wrong, bucko", "angry", "dess_super")
            cutscene:textTagged("* your biggest mistake was invading my domain...", "neutral", "dess_super")
            cutscene:textTagged("* and now...?", "doom_shiteatinggrin", "dess_super")
            cutscene:textTagged("* You're fuckin dead,[wait:5] kiddo.", "hackerman", "dess_super")
            
            Game:saveQuick("spawn")

            cutscene:hideNametag()
            cutscene:attachCamera(1)
            cutscene:startEncounter("mimicboss", true, boss)

            boss:remove()
            cutscene:attachFollowers(5)
            Game.world.music:fade(0, 0.75)
            cutscene:wait(1)

            if Noel:dessParty() then
                if Noel:getFlag("knows_super_dess") then
                else
                    cutscene:textTagged("* ...", "bruh", "noel")
                    cutscene:textTagged("* ...", "angry", "dess_super")
                    cutscene:textTagged("* wow that was fucking awesome how the fuck did i do that", "wtf", "dess_super")
                    cutscene:textTagged("* Dess...", "huh", "noel")
                    cutscene:textTagged("* What did you do..?", "...", "noel")
                    cutscene:textTagged("* it must have been the power of the chaos emeralds...", "neutral_b", "dess_super")
                    cutscene:textTagged("* Dess...[wait:10] You have done something you were never meant to do Dess...", "huh", "noel")
                    cutscene:textTagged("* I only have one thing to say to you...", "...", "noel")
                    cutscene:textTagged("*[speed:0.1] ... [speed:1.5][face:yay]THAT ACTUALLY WAS REALLY FUCKING AWESOME HOLY SHIT!!!", "...", "noel")
                    Noel:setFlag("knows_super_dess", true)
                end
            else
                cutscene:textTagged("* ...", "angry", "dess_super")
                cutscene:textTagged("* wow that was fucking awesome how the fuck did i do that", "wtf", "dess_super")
                cutscene:textTagged("* is this the power of the chaos emeralds...?", "neutral_b", "dess_super")
            end

            Assets.playSound("cardrive", 1.5, 0.9)
            cutscene:wait(cutscene:fadeOut(1, {color = {1,1,1}}))
            dess_party:heal(250)
            dess_party:increaseStat("health", -250)
            dess_party:increaseStat("attack", -15)
            dess_party:increaseStat("magic", -20)
            dess_party:increaseStat("defense", -10)
            dess_party:setActor("dess")
            Game:setFlag("super_dess", false)
            Game:setFlag("dess_canact", false)
            Game:getPartyMember("dess").has_act = false
            Game.world.player:setActor("dess")
            cutscene:wait(2)
            Game.world.music:play("gimmieyourwalletmiss", 1, 1)
            cutscene:wait(cutscene:fadeIn(1))
            cutscene:wait(1)
            cutscene:setSpeaker(nil)
            cutscene:text("[noskip]* (Dess's stats returned to normal)")
            cutscene:text("[noskip]* (Dess can no longer ACT.)")
            cutscene:setSpeaker("dess")
            cutscene:textTagged("* oh", "weed", "dess")
            cutscene:textTagged("* well thats fuckin bullshit", "mspaint", "dess")
            cutscene:textTagged("* i wanted to be op forever", "angry", "dess")
            cutscene:textTagged("* oh well", "neutral_b", "dess")

            if Noel:dessParty() then
                if Noel:getFlag("knows_super_dess") then
                else
                    cutscene:textTagged("* No,[wait:5] try doing it agian![wait:5] DO IT DO IT DO IT!", "neutral", "noel")
                    cutscene:textTagged("* Okay here we go.", "calm_b", "dess")
                    cutscene:textTagged("* ...", "calm", "dess")
                    cutscene:textTagged("* ...", "calm", "dess")
                    cutscene:textTagged("* ZZZZZZZZZZZZZzzzzzzzzzz", "calm", "dess")
                    cutscene:textTagged("* ah shit i pressed the slep button by mistake", "angry", "dess")
                    cutscene:textTagged("* no point in trying anymore", "condescending", "dess")
                end
            end
    
            if Game:getFlag("desshere_kills") and Game:getPartyMember("dess").kills >= Game:getFlag("desshere_kills") + 9 then
                cutscene:wait(3)
                cutscene:setSpeaker("dess")
                cutscene:textTagged("* oh wait actually", "wtf", "dess")
                cutscene:textTagged("* i killed all those stupid ufos that were here", "condescending", "dess")
                cutscene:textTagged("* that means i can kill most enemies for realsies now", "heckyeah", "dess")
                cutscene:textTagged("* aw yeah,[wait:5] fun mode is enabled now", "challenging", "dess")
                Assets.playSound("ominous")
                Game:setFlag("can_kill", true)
            end

            if Noel:dessParty() then
                cutscene:textTagged("* Arent we already in fun mode?", "neutral", "noel")
                cutscene:textTagged("* No this is [face:swag]Dess Mode[face:thisremindsmeofthetimeiwasindarkplace][font:main_mono,16]TM[font:reset][face:condescending]", "condescending", "dess")

            end
            if noel_party then
                Noel:setFlag("knows_mimic", true)
            end

            Game:setFlag("mimic_defeated", true)
            Game.inventory:addItemTo("key_items", "keyCard", true)

            if event then
                event:remove()
            end
        else
            cutscene:textTagged("* Happy new year,[wait:6] 1998!", whodis)
        
            --[[ -- OLD DIALOGUE THAT I HATE BECAUSE I WAS TERRIBLE AT WRITING -char
                 -- not the other people your writing is fine I just really hate the mimic's writing ok
            boss:fadeTo(0.2, 0.05)
            cutscene:wait(1)
            boss:setActor("susie")
            cutscene:look(boss, "up")
            boss:fadeTo(1, 0.05)
            cutscene:wait(1)
            cutscene:setSpeaker(nil)
            if susie then
                cutscene:textTagged("[face:susie_bangs/smile_b][voice:susie]* I'm you!", whodis)
    
                cutscene:setSpeaker("susie")
                cutscene:textTagged("* Wha-?![wait:10] What the hell??", "surprise_frown", "susie")
            else
                cutscene:textTagged("[face:susie_bangs/smile_b][voice:susie]* LOOK at me![wait:10] I'm the Angry Dino Girl!", whodis)
            end
    
            cutscene:hideNametag()
    
            boss:fadeTo(0.2, 0.05)
            cutscene:wait(1)
            boss:setActor("kris")
            cutscene:look(boss, "up")
            boss:fadeTo(1, 0.05)
            cutscene:wait(1)
            cutscene:setSpeaker()
    
            if susie then
                cutscene:textTagged("* SUSIE LOOK![wait:5]\n* IT'S ME[wait:5] [color:yellow]KRIS[color:reset]!", whodis)
            else
                cutscene:textTagged("* AND NOW I'm the blue one!", whodis)
            end
            cutscene:textTagged("* Uheeheehee!", whodis)
            cutscene:hideNametag()
    
            boss:fadeTo(0.2, 0.05)
            cutscene:wait(1)
            boss:setActor("ufoofdoom")
            boss:fadeTo(1, 0.05)
            cutscene:setSpeaker("dess")
            cutscene:textTagged("* Whatever can we fight now", "condescending", "dess")
    
            cutscene:setSpeaker()
            cutscene:textTagged("* ...OH![wait:10] I see!", whodis)
            cutscene:textTagged("* ...Uheehee!", whodis)
            cutscene:textTagged("* You're even worse than me! Uhee!", whodis)
    
            if susie then
                cutscene:setSpeaker("susie")
                cutscene:textTagged("* Uhh,[wait:10] what do they mean by that?", "nervous", "susie")
    
                cutscene:setSpeaker()
                cutscene:textTagged("* Uheehee![wait:10] You're much better!", whodis)
            end
            cutscene:setSpeaker(boss)
            cutscene:textTagged("* It's too easy to be who you want to be!", whodis)
            cutscene:textTagged("* I know that is not the real Dess Holiday!", whodis)
    
            if susie then
                cutscene:textTagged("* Huh???", "surprise_frown", "susie")
    
                cutscene:setSpeaker(boss)
                cutscene:textTagged("* Don't act all surprised!", whodis)
                cutscene:textTagged("* I know that you aren't the real Susie either!", whodis)
    
                cutscene:setSpeaker("susie")
                cutscene:textTagged("* ...???", "suspicious")
                cutscene:textTagged("* Uh.", "suspicious")
                cutscene:textTagged("* Alright,[wait:5] let's smash this guy into a pulp.", "teeth_smile")
    
                cutscene:textTagged("* Agreed", "neutral", "dess")
            else
                cutscene:textTagged("* Whatever,[wait:5]I wanna smash you already", "neutral", "dess")
            end
    
            cutscene:setSpeaker()
            cutscene:textTagged("* Suit yourself![wait:5] Uheehee!", whodis)
            --]]
            Game:saveQuick("spawn")

            cutscene:hideNametag()
            cutscene:attachCamera(1)
            cutscene:startEncounter("mimicboss", true, boss)
            boss:remove()

            cutscene:wait(1)
            for i,party in ipairs (Game.world.followers) do
                if i == 1 then
                    cutscene:look(cutscene:getCharacter(party.actor.id), "right")
                end
                if i == 2 then
                    cutscene:look(cutscene:getCharacter(party.actor.id), "left")
                end
            end
            cutscene:wait(1)
    
            cutscene:setSpeaker("dess")
            cutscene:textTagged("* ...?", "eyebrow", "dess")
            cutscene:textTagged("* weird way to end a meme section but ok", "eyebrow", "dess")
            cutscene:textTagged("* well that was fun", "condescending", "dess")
            cutscene:textTagged("* so whaddaya say we all go and smoke a ciggie outside a 7-11?", "genuine", "dess")
            if susie then
                cutscene:setSpeaker("susie")
                cutscene:textTagged("* What the hell is a 7-11?", "nervous_side", "susie")
                cutscene:setSpeaker("dess")
                cutscene:textTagged("* damn that's not what you said last time", "eyebrow", "dess")
                if jamm then
                    cutscene:setSpeaker("jamm")
                    cutscene:textTagged("* What are you saying???[wait:10]\n* Are you okay in the head???", "suspicious", "jamm")
                else
                    cutscene:setSpeaker("susie")
                    cutscene:textTagged("* Why do you keep acting like I'm supposed to know you?", "suspicious", "susie")
                    cutscene:setSpeaker("dess")
                    cutscene:textTagged("* uhhh because you are?", "condescending", "dess")
                end
                cutscene:setSpeaker("dess")
                cutscene:textTagged("* damn this really IS a reboot", "neutral_b", "dess")
                cutscene:textTagged("* ok tell you what,[wait:5] I'll give the leader spot back", "genuine_b", "dess")
                cutscene:textTagged("* IF and only IF", "calm_b", "dess")
                cutscene:textTagged("* you promise to by me a Mug:tm: Root Beer when this is all over", "condescending", "dess")
                cutscene:setSpeaker("susie")
                cutscene:textTagged("* ...[wait:10] Fine.", "suspicious", "susie")
                if jamm then
                    cutscene:textTagged("* You are the single weirdest person I've ever met.[react:1]", "annoyed", "susie", {reactions={
                        {"Tell me\nabout it...", 352, 61, "stern", "jamm"}
                    }})
                else
                    cutscene:textTagged("* You are the single weirdest person I've ever met.", "annoyed", "susie")
                end
                cutscene:setSpeaker("dess")
                cutscene:textTagged("* i'll take that as a compliment", "heckyeah", "dess")
            else
                cutscene:textTagged("[speed:0.5]* ...", "genuine", "dess")
                cutscene:textTagged("* dang no takers then?", "neutral_b", "dess")
                cutscene:textTagged("* oh well more ciggies for me then", "condescending", "dess")
            end
            cutscene:hideNametag()
    
            local susie_party = Game:getPartyMember("susie")
            if susie then
                susie_party:addOpinion("dess", -10)
            end
    
            if Game:getPartyMember("dess").kills >= 8 then
                cutscene:wait(3)
                cutscene:setSpeaker("dess")
                cutscene:textTagged("* Hey actually wait", "genuine", "dess")
                cutscene:textTagged("* wouldn't it be cool if like...", "kind", "dess")
                cutscene:textTagged("* All of the sensless murder we've been doing like...", "condescending", "dess")
                cutscene:textTagged("* Allowed us to actually kill people normally?", "kind", "dess")
                cutscene:showNametag("Dess", {top = true})
                cutscene:textTagged("* That'd be a cool reference to hit Deltarune fangame made by Vyletbunni known as Deltatraveler where in the section 2 obliteration route you can actually kill the animals and people if you clear out all the enemies in the first few rooms", "condescending", "dess", {top = true})
                if susie then
                    cutscene:setSpeaker("susie")
                    cutscene:textTagged("* ...", "neutral_side", "susie")
                    cutscene:textTagged("* Oooookay then...", "neutral", "susie")
                end
                Assets.playSound("ominous")
                Game:setFlag("can_kill", true)
            end
            cutscene:setSpeaker("dess")
            if #Game.world.followers == 3 then
                cutscene:textTagged("* anyways imma be chillin in the diner if you guys need me", "kind", "dess")
                cutscene:hideNametag()
                cutscene:wait(cutscene:fadeOut(1))
                cutscene:wait(1)
    
                -- Party setup 2: Desslectric boogaloo
                local newparty = Game.world.followers[3].actor.id
                Game:addPartyMember(newparty)
                Game:removePartyMember("dess")
                Game.world:removeFollower(newparty)
                cutscene:getCharacter(newparty):remove()
                cutscene:wait(0.5)
                for i, v in ipairs(Game.world.followers) do
                    v:setActor(Game.party[i+1]:getActor())
                end
                Game.world.player:setActor(Game.party[1]:getActor())
                cutscene:attachFollowers(0.1)
                cutscene:interpolateFollowers()
                cutscene:wait(0.5)
    
                cutscene:wait(cutscene:fadeIn(1))
            else
                cutscene:textTagged("* ok time to stop leading", "genuine", "dess")
                cutscene:hideNametag()
                cutscene:hideNametag()
    
                cutscene:wait(cutscene:fadeOut(1))
                cutscene:wait(1)
                Game:movePartyMember("dess", 2)
                for i, v in ipairs(Game.world.followers) do
                    v:setActor(Game.party[i+1]:getActor())
                end
                Game.world.player:setActor(Game.party[1]:getActor())
                cutscene:attachFollowers(0.1)
                cutscene:interpolateFollowers()
                cutscene:wait(0.5)
    
                cutscene:wait(cutscene:fadeIn(1))
            end
            cutscene:setSpeaker()
            cutscene:text("* (Dess is no longer leading the party!)")

            Game:setFlag("mimic_defeated", true)
            Game.inventory:addItemTo("key_items", "keyCard", true)

            if event then
                event:remove()
            end
        end
    end,
}
return desslmao

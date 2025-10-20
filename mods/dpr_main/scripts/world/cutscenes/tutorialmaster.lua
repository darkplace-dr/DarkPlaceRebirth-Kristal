---@type table<string, fun(cutscene: WorldCutscene, master: NPC)>
local tutorialmaster = {
    bepis = function(cutscene, master)
        cutscene:setTextboxTop(true)
        master:setAnimation({ "bop" })
        cutscene:text("* I'm Bepi Master.\n[wait:5]* Ask me about BEPI's.")
        local choices = { "Pipis", "2", "3" }
        table.insert(choices, "Bye")
        local c = cutscene:choicer(choices)
        if c == 1 then
            master:setAnimation({ "idle" })
            cutscene:text("* This question is out of my domain")
            master:setAnimation({ "bop" })
            cutscene:text("* So how about you wake up and taste the [color:red]pain[color:reset]?")
        elseif c == 2 then
            master:setAnimation({ "shocked" })
            cutscene:text("* BING BING BING TWO.")
        elseif c == 3 then
            cutscene:text("* Three's an odd number.")
            if Utils.containsValue(Game.party, Game:getPartyMember("susie")) then
                cutscene:text("* Even I could tell you that, no wonder.", "smile", "susie")
                master:setAnimation({ "shocked" })
                cutscene:text("* I.. I meant it FIGURATIVELY!")
            end
        elseif c == 4 then
            cutscene:text("* Later,[wait:5] kid.")
        end
        master:setAnimation({ "idle" })
    end,
    dess = function (cutscene, master)
        master:setAnimation({ "bop" })
        cutscene:text("* I'm Dess Master.\n[wait:5]* Don't ask me about DESS's.")

        local choices = { "Stars", "Use", "Fact" }
        table.insert(choices, "Bye")
        local c = cutscene:choicer(choices)
        if c == 1 then-- cringe cringe cringe die die die (I added this in legacy and i want it gone it shall be gone forever)
                cutscene:text("* Dess's power of the STARS.")
                cutscene:text("* Will[wait:5] HOPEFULLY[wait:5] get her run over by CARS.")
                cutscene:text("[noskip]* Time to drop some BARS[speed:0.1][func:stop]... ... ...[instant]\n[func:tag][color:red]Metal Pipe[color:reset].[stopinstant][wait:4]      ", nil, nil, 
                    {
                        functions = {
                            tag = function (text)
                                Game.world.fader:fadeIn(nil, {speed = 0.5, color = {1, 1, 1}, alpha = 1})
                                Assets.playSound("bad_pipe")
                            end,
                            stop = function (text)
                                Game.world.music:pause()
                            end
                        },
                        auto = true
                    }
                )
                Game.world.music:resume()
        elseif c == 2 then
			cutscene:text("* Dess' use is still unknown.[wait:5]\n* To find out, you're on your own.")
			cutscene:text("* Some still say she is a wizard.[wait:5]\n* But I have yet to see her cast 'Blizzard'!")
			if Game:hasPartyMember("dess") then
                cutscene:text("* I'm Dess,[wait:5] not Noelle.\n* I shoot badass stars not snowflakes.", "condescending", "dess")
                master:setAnimation({ "shocked" })
                cutscene:text("* Exactly![wait:5] That's not a wizard spell!")
				master:setAnimation({ "bop" })
				cutscene:text("* Well maybe it is actually...")
				cutscene:text("* Seriously though.[wait:10] Keep her magic up, those badass stars \ncan deal some damage.")
            end
        elseif c == 3 then
            cutscene:text("* Dess will stop being annoying,[wait:5] if you give me money to buy cigarettes.")
            cutscene:text("* Sorry,[wait:5] that was a lie.")
            cutscene:text("* Give me money,[wait:5] to buy cigarettes.")
        elseif c == 4 then
            cutscene:text("* Later,[wait:5] Chum.")
        end
        master:setAnimation({ "idle" })
    end,
    susie = function(cutscene, master)
        master:setAnimation({ "bop" })
        cutscene:text("* I'm Susie Master.\n[wait:5]* Ask me about SUSIE's.")

        local choices = {"Healing", "Attack", "Fact"}
        table.insert(choices, "Bye")
        local c = cutscene:choicer(choices)
        if c == 1 then
            cutscene:text("* Susie puts all her POWER,[wait:5] in this one SPELL.")
            cutscene:text("* This will send your TENSION,[wait:5] straight to HELL.")
            cutscene:text("* Susie's ULTIMATE HEAL,[wait:5] is so RAD.")
            cutscene:text("* Unfortunely it's also,[wait:5] very[wait:5] very[wait:5] BAD.")
        elseif c == 2 then
            cutscene:text("* Susie's BUSTER, RUDE as may be...")
            cutscene:text("* Will deal more damage, if you just press [Z]!")
        elseif c == 3 then
            cutscene:text("* bing bing bing three")
        elseif c == 4 then
            cutscene:text("* Later,[wait:5] kid.")
        end
        master:setAnimation({ "idle" })
    end,
    ceroba = function(cutscene, master)
        cutscene:setTextboxTop(true)
        master:setAnimation({ "bop" })
        cutscene:text("* I'm Ceroba Master.\n[wait:5]* Ask me about CEROBA's.")
        local choices = { "1", "2", "3" }
        table.insert(choices, "Bye")
        local c = cutscene:choicer(choices)
        if c == 1 then
            master:setAnimation({ "shocked" })
            cutscene:text("* BING BING BING ONE.")
        elseif c == 2 then
            master:setAnimation({ "shocked" })
            cutscene:text("* BING BING BING TWO.")
        elseif c == 3 then
            master:setAnimation({ "shocked" })
            cutscene:text("* BING BING BING THREE.")
        elseif c == 4 then
            cutscene:text("* Later,[wait:5] kid.")
        end
        master:setAnimation({ "idle" })
    end,
    hero = function(cutscene, master)
        cutscene:setTextboxTop(true)
        master:setAnimation({ "bop" })
        cutscene:text("* I'm Hero Master.\n[wait:5]* Ask me about HERO's.")
        local choices = { "1", "2", "fact" }
        table.insert(choices, "Bye")
        local c = cutscene:choicer(choices)
        if c == 1 then
        elseif c == 2 then
            master:setAnimation({ "shocked" })
            cutscene:text("* BING BING BING TWO.")
        elseif c == 3 then
            cutscene:text("* Hero enjoys giving us GOLD.")
            cutscene:text("* It makes them feel BIG, STRONG, and dare I say BOLD!")
            cutscene:text("* ...", "happy", "hero")
        elseif c == 4 then
            cutscene:text("* Later,[wait:5] kid.")
        end
        master:setAnimation({ "idle" })
    end,
    brenda = function(cutscene, master)
        cutscene:setTextboxTop(true)
        master:setAnimation({ "bop" })
        cutscene:text("* I'm Brenda Master.\n[wait:5]* Ask me about BRENDA's.")
        local choices = { "Powderkeg", "Battle", "Fact" }
        table.insert(choices, "Bye")
        local c = cutscene:choicer(choices)
        if c == 1 then
            cutscene:text("* MultiFlare may not do MUCH...")
            cutscene:text("* But to increase its damage,[wait:5] you need to do as SUCH.")
            cutscene:text("* Cover your enemy in black POWDER...")
            master:setAnimation({ "shocked" })
            cutscene:text("* Then your FIRE attacks will hit.[noskip][wait:10].[wait:10].[wait:10] LOUDER?")
        elseif c == 2 then
            cutscene:text("* Brenda's defenses may not be HIGH...")
            cutscene:text("* But her attack damage can be SKY-HIGH-[wait:5]", nil, nil, {auto = true})
            cutscene:text("* Hold on...[wait:10] Did...[wait:5] did you just rhyme \"high\" with itself?", "suspicious_b", "brenda")
            master:setAnimation({ "shocked" })
            cutscene:text("* LOOK,[wait:5] COMING UP WITH RHYMES ON THE SPOT IS HARD,[wait:5] OKAY?!")
        elseif c == 3 then
            cutscene:text("* Brenda may not be a SQUID...")
            cutscene:text("* But she still likes it when you give us QUID.")
            cutscene:text("* I-", "shocked", "brenda")
            cutscene:text("* No.", "pissed", "brenda")
            master:setAnimation({ "shocked" })
            cutscene:text("* Perhaps I appealed to the wrong nationality!")
            master:setAnimation({ "bop" })
            cutscene:text("* Brenda may not be fond of PRANKS...")
            cutscene:text("* But she still likes it when you give us FRANCS.")
            cutscene:text("* That currency isn't even in use anymore.", "suspicious", "brenda")
            master:setAnimation({ "shocked" })
            cutscene:text("* IT'S THE THOUGHT THAT COUNTS,[wait:5] OKAY?!")
        elseif c == 4 then
            cutscene:text("* Later,[wait:5] kid.")
        end
        master:setAnimation({ "idle" })
    end,
}
return tutorialmaster

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

        local choices = { "Stars", "2", "Fact" }
        table.insert(choices, "Bye")
        local c = cutscene:choicer(choices)
        if c == 1 then
            if master:getFlag("sorry_dess") then
                cutscene:text("* Last I checked STAR isn't an actual type...")
                cutscene:text("* But my thing says your type is STAR so...[wait:5] screw it.")
                cutscene:text("* You are a BALL of FIRE Dess.\n[wait:5]* A giant ball OF fire.")
                cutscene:text("* I think that's what that means anyWAY.")
                if master:getFlag("dungeonkiller") then
                    cutscene:text("* That phone over there is[wait:5] odd...")
                    cutscene:text("* They keep saying things that don't make sense.")
                    cutscene:text("* (Sometimes I feel like I'm the only one who can see them.)")
                    cutscene:text("* (I still have no idea who " ..
                    Game.save_name .. " is and what they have to do with you Dess...)")
                end
            else
                cutscene:text("* Dess's power of the STARS.")
                cutscene:text("* Will[wait:5] HOPEFULLY[wait:5] get her run over by CARS.")
                cutscene:text("*[speed:0.3] ...")
                cutscene:text("*[speed:0.3] ...")
                cutscene:text("* Great,\n[wait:5]now I feel like a piece of sh[wait:5]-tupid[speed:0.3]...")
                cutscene:text("* Sorry for being mean...[wait:5]\n* There's no excuse for my actions...")
                cutscene:text("* I'll try being nicer\nfrom now on.")
                master:setFlag("sorry_dess", true)
                if master:getFlag("dungeonkiller") then
                    cutscene:text("* Someone told me someone else made some other person do something.")
                    cutscene:text("* Say...[wait:5] any of you know of a " .. Game.save_name .. "?")
                end
            end
        elseif c == 2 then
            master:setAnimation({ "shocked" })
            cutscene:text("* BING BING BING TWO.")
        elseif c == 3 then
            cutscene:text("* Dess will stop being annoying,[wait:5] if you give me money to buy cigarettes.")
            cutscene:text("* Sorry,[wait:5] that was a lie.")
            cutscene:text("* Give me money,[wait:5] to buy cigarettes.")
            if master:getFlag("sorry_dess") then
                cutscene:text("* Sorry for calling you annoying by the way.")
            end
        elseif c == 4 then
            cutscene:text("* Later,[wait:5] Chum.")
        end
        master:setAnimation({ "idle" })
    end,
}
return tutorialmaster

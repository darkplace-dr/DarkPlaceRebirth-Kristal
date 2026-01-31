return {
    jigsaw_joe = function(cutscene, event)
		cutscene:showNametag("Jigsaw Joe")
        cutscene:text("* How can I help ya!?")
		cutscene:hideNametag()
        local choices = { "Challenge", "Nothing" }
        local c = cutscene:choicer(choices)
        if c == 1 then
            cutscene:after(function()
                Game.world:openMenu(BossSelectMenu())
            end)
        else
            cutscene:setSpeaker(event)
			cutscene:showNametag("Jigsaw Joe")
            cutscene:text("* No worries! [wait:5]We'll always be here.")
			cutscene:hideNametag()
        end
    end,
    
    clover = function(cutscene, event)
        cutscene:setSpeaker(event)
        cutscene:showNametag("Clover")
        cutscene:text("[miniface:clover_happy]It's a PARTY every day!\n[miniface:clover_mad]And I'M the oldest!\n[miniface:clover_sad](We're the same age...)")
        cutscene:hideNametag()
    end,
    
    battlemaster = function(cutscene, master)
        cutscene:setTextboxTop(false)
        master:setAnimation({ "bop" })
		cutscene:showNametag("Battle's Master")
        cutscene:text("* I'm Battle's Master. Ask me about Battles.")
		cutscene:hideNametag()
        local choices = { "Grazing", "Hitbox", "Hole", "Nothing" }
        table.insert(choices, "Bye")
        local c = cutscene:choicer(choices)
        if c == 1 then
            Game.world:addChild(GrazeTutorial())
			cutscene:showNametag("Battle's Master")
            cutscene:text("* When shots aim directly,[wait:5] try to move SLOW.")
            cutscene:text("* They aim where you WERE,[wait:5] not where you GO.")
            cutscene:text("* Take the advantage and move BIT BY BIT.")
            cutscene:text("* You'll gain TP but you won't get HIT.")
        elseif c == 2 then
			cutscene:showNametag("Battle's Master")
            cutscene:text("* Shots aren't always AS THEY APPEAR.")
            cutscene:text("* The bigger they are,[wait:5] the LESS TO FEAR.")
            cutscene:text("* You'll only get hurt a LITTLE INSIDE.")
            cutscene:text("* Take your pride and LEARN THE SIZE.")
        elseif c == 3 then
			cutscene:showNametag("Battle's Master")
            if Game:getFlag("money_hole") == 1 then            
                cutscene:text("* We reached our monthly FUNDING GOAL.")
                cutscene:text("* I will now talk about OUR HOLE.")
                cutscene:text("* It was dark,[wait:5] filled with darker dollawers")
                cutscene:text("* Fed from subscription by our followers")
                cutscene:text("* Working hard no bank no lender")
                cutscene:text("* We received one unit of legal tender")
                cutscene:text("* ...")
                cutscene:text("* Thanks for donating.")
            else
                cutscene:text("* We failed to hit our FUNDING GOAL.")
                cutscene:text("* I will not talk about OUR HOLE.")
            end
        elseif c == 4 then
			cutscene:showNametag("Battle's Master")
            cutscene:text("* Okay.")
        end
		cutscene:hideNametag()
        master:setAnimation({ "idle" })
    end
}
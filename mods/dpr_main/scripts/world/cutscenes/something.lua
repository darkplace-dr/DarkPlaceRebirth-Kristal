return {
    b = function(cutscene, event)
        local stall = cutscene:getCharacter("something")
        if Game:getFlag("something_defeated") then
            cutscene:text("* I'll be on my way soon. Don't worry.", nil, stall)
        else
            if not Game:getFlag("bench_intro") then
                cutscene:text("* Hello!", nil, stall)
                cutscene:text("* What brings you to this little area?", nil, stall)
                cutscene:text("* Thank goodness you aren't capable of killing.", nil, stall)
                cutscene:text("* My job is to make those who kill wish to be killed themeselves.", nil, stall)
                cutscene:text("* But honestly I just hide away from this task.", nil, stall)
                if Game:getFlag("can_kill") then
                    cutscene:text("* So don't worry about me creating nightmares.", nil, stall)
                end
                cutscene:text("* Why here out of all places?", nil, stall)
                cutscene:text("* It is quiet and I can read here.", nil, stall)
                cutscene:text("* I currently read The Time Machine by H. G. Wells.", nil, stall)
                cutscene:text("* It is a really good book.", nil, stall)
                cutscene:text("* Hasn't aged a day despite it being over 100 years old.", nil, stall)
                cutscene:text("* Anyway, I helped out on STARRUNE.", nil, stall)
                cutscene:text("* I was paid in ATTACKS DIRECTLY FROM STARRUNE.", nil, stall)
                cutscene:text("* So if you want we can fight a little.", nil, stall)
                cutscene:text("* Well, I guess considering I am an immortal nightmare not FIGHT.", nil, stall)
                cutscene:text("* But I will pretend I can loose/die.", nil, stall)
                cutscene:text("* How does that sound?", nil, stall)
                Game:setFlag("bench_intro", true)
            else
                cutscene:text("* Wanna fight?", nil, stall)
                local opinion = cutscene:choicer({"Yes", "No"})
                if opinion == 1 then
                    cutscene:startEncounter("something", true, stall)
                    Game:setFlag("something_defeated", true)
                    cutscene:text("* Ah! That felt good!", nil, stall)
                    cutscene:text("* I think I should get back to my job.", nil, stall)
                    cutscene:text("* Don't worry, I'll contact Notsuki in TRITRA LAND about this.", nil, stall)
                    cutscene:text("* She will place some chests in TRITRA LAND as your reward.", nil, stall)
                    if Game:getFlag("can_kill") then
                        cutscene:text("* Oh wait I don't think she will let you in...", nil, stall)
                        cutscene:text("* She has a thing against those capable of murder.", nil, stall)
                        cutscene:text("* Uh... I have this box of cotton milk.", nil, stall)
                        cutscene:text("* That stuff heals the entire party.", nil, stall)
                        Game.inventory:addItem("cotton_milk")
                        Game.inventory:addItem("cotton_milk")
                        Game.inventory:addItem("cotton_milk")
                        Game.inventory:addItem("cotton_milk")
                        Game.inventory:addItem("cotton_milk")
                        Game.inventory:addItem("cotton_milk")
                        cutscene:text("* You obtain 6 bottles of Cotton Milk. Unless your inventory is full.")
                        cutscene:text("* This still doesn't feel fair...", nil, stall)
                        Game.inventory:addItem("body_pillow")
                        cutscene:text("* You obtain a body pillow. Unless your inventory is full.")
                        cutscene:text("* Now that is something Notsuki usually would give.", nil, stall)
                        cutscene:text("* At least if you didn't kill your way through the Mimic.", nil, stall)
                        cutscene:text("* That is decent compensation, right?", nil, stall)
                    end
                end
            end
        end
    end
}
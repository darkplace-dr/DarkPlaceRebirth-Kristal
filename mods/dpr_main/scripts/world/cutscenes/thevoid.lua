return {
    ---@param cutscene WorldCutscene
    altar1 = function(cutscene)
        local hero = cutscene:getCharacter("hero")
        local susie = cutscene:getCharacter("susie")
        local noel = cutscene:getCharacter("noel")
        
        cutscene:text("* (You feel an ominous presence from this altar.)")
        if hero and susie and noel then
            cutscene:detachFollowers()
            cutscene:detachCamera()
            cutscene:walkToSpeed(hero, "hero_marker", 4)
            cutscene:walkToSpeed(noel, "noel_marker", 4)
            cutscene:wait(cutscene:walkToSpeed(susie, "sus_marker", 4))
            cutscene:look(hero, "up")
            cutscene:look(susie, "up")
            cutscene:look(noel, "up")
            Game.world.camera:panTo("camera_marker", 1)
            cutscene:wait(1.5)
            cutscene:look(hero, "up")
            cutscene:look(susie, "up")
            cutscene:look(noel, "up")

            cutscene:text("* Hey,[wait:5] what's this?", "suspicious", susie)
            cutscene:text("* Hey,[wait:5] Hero.[wait:10] You don't think anything's gonna happen to us if I...", "smirk", susie)
            cutscene:text("* Touch this weird orb thing,[wait:5] do ya?", "smile", susie)
            cutscene:text("* I sure hope not...[wait:10] Rather,[wait:5] I'd prefer it if you...[wait:10] didn't.", "annoyed", hero)

            cutscene:text("[speed:0.8]* (Do you wish to travel to the VOID?)")
            cutscene:text("[speed:0.8]* (After travelling,[wait:5] you will be unable to return for a long time...)")
    
            local travel = cutscene:choicer({"Yes", "No"})
            if travel == 1 then
                cutscene:text("* ...heh.[wait:10] heh heh heh.", "smile", susie)
                cutscene:text("* What are you laughing about...?", "annoyed", hero)
                susie:setSprite("away")
                cutscene:wait(cutscene:slideTo(susie, susie.x, susie.y+20, 0.2))
                cutscene:wait(1)
                susie:setSprite("playful_punch_2")
                cutscene:wait(cutscene:slideTo(susie, susie.x, susie.y-90, 0.25))
                susie:shake()

                for i,v in pairs(Game.world.map.tile_layers) do
                    v.visible = false
                end
                
                cutscene:wait(0.25)
                susie:resetSprite()
                cutscene:look(susie, "left")
                cutscene:wait(cutscene:walkToSpeed(hero, hero.x, hero.y+20, 4, "up", true))
                cutscene:text("* ...", "shock_down", susie)
                cutscene:text("* ... You've done it now...", "neutral_closed_b", hero)
                Game.world.camera:shake(1,1,0)

                cutscene:text("* Uhh,[wait:5] what's going on—?", "shock_down", susie)
                local r = Rectangle(0, 0, SCREEN_WIDTH*2, SCREEN_HEIGHT*2)
                r.color = {0,0,0}
                r.layer = 5000
                Game.world:addChild(r)
                cutscene:wait(1)
                Game:swapIntoMod("dlc_trials", false)
            else
                cutscene:text("* Well,[wait:5] I suppose we can leave this for another time.", "smile", susie)
            end
        end
    end,
}
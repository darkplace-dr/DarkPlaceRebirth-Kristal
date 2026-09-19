return {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `WorldCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!
    
    ---@param cutscene WorldCutscene
        
    down = function(cutscene, event, data)
        local properties = data and data.properties or {}
            
        local warpx = properties.x or 40 -- nothing IG?
        local warpy = properties.y or 603 -- 603
        local speed = Game.world.player:getCurrentSpeed(running)
        Game.world.player.force_walk = true
        
        Game.world.player.y = Game.world.player.y - warpy + speed
        for _,follower in ipairs(Game.world.followers) do
            follower.y = follower.y - (warpy+4) + speed
            for _,point in ipairs(follower.history) do
                point.y = point.y - (warpy+4) + speed
            end
        end

    end,

    up = function(cutscene, event, data)
        local properties = data and data.properties or {}
        local warpx = properties.x or 40 -- nothing
        local warpy = properties.y or 600 -- 600
        local speed = Game.world.player:getCurrentSpeed(running)
            Game.world.player.force_walk = true
            Game.world.player.y = Game.world.player.y + warpy - speed
            for _,follower in ipairs(Game.world.followers) do
                follower.y = follower.y + (warpy+4) - speed
            for _,point in ipairs(follower.history) do
                point.y = point.y + (warpy+4) - speed
            end
        end
    end,

        left = function(cutscene, event)
        local party1 = cutscene:getCharacter(Game.party[1].actor.id)
        if party1 then
            cutscene:detachFollowers()
            local x = party1.x
            local y = party1.y
            party1.x = x + 40
            party1.y = y
            party1:resetSprite()
        end
                    if #Game.world.followers > 0 then
Game.world:detachFollowers()
            for i=1, #Game.world.followers do
                local party = Game.world:getCharacter(Game.party[i+1].actor.id)
                Game.world:detachFollowers()
                local x = party.x
                local y = party.y
                party.x = x + 40   
                party.y = y
                party:resetSprite()
            end
    end

        cutscene:attachFollowers()
    end,

            right = function(cutscene, event)
        local party1 = cutscene:getCharacter(Game.party[1].actor.id)
        if party1 then
            cutscene:detachFollowers()
            local x = party1.x
            local y = party1.y
            party1.x = x - 40
            party1.y = y
            party1:resetSprite()
        end
                    if #Game.world.followers > 0 then
Game.world:detachFollowers()
            for i=1, #Game.world.followers do
                local party = Game.world:getCharacter(Game.party[i+1].actor.id)
                Game.world:detachFollowers()
                local x = party.x
                local y = party.y
                party.x = x - 40   
                party.y = y
                party:resetSprite()
            end
    end
    cutscene:attachFollowers()
end,

door1 = function(cutscene, event)
        -- Open textbox and wait for completion
        cutscene:text("* There's a door here.")

        -- If we have Susie, play a cutscene
            cutscene:detachCamera()
            cutscene:detachFollowers()
            cutscene:text("* Open it?")
            local choicer = cutscene:choicer({
        "Yes",
        "No",
    })

    if choicer == 1 then
        
        local x = event.x + event.width/2
            local y = event.y + event.height/2

            -- Move Susie up to the wall over 0.75 seconds
            cutscene:detachFollowers()
            cutscene:walkTo(Game.world.player, x, y, 0.75, "up")
            
            if #Game.world.followers > 0 then
                Game.world:detachFollowers()
                for i=1, #Game.world.followers do
                    local party = Game.world:getCharacter(Game.party[i+1].actor.id)
                    local party = Game.world:getCharacter(Game.party[2].actor.id)
                    cutscene:walkTo(party, x, y, 0.75, "up")
                end
            end
            cutscene:fadeOut(0.5, {color = COLORS.white})
            cutscene:wait(0.5)
            cutscene:loadMap("floor1/marketplace","door1")
            cutscene:fadeIn()
            
            
    end
    if choicer == 2 then
            -- Get the bottom-center of the broken wall
            cutscene:text("* You doorn't.")
    end
    end,

door3 = function(cutscene, event)
        -- Open textbox and wait for completion
        cutscene:text("* There's a console here.")

        -- If we have Susie, play a cutscene
            cutscene:detachCamera()
            cutscene:detachFollowers()
            cutscene:text("* Use it?")
            local choicer = cutscene:choicer({
        "Yes",
        "No",
    })

    if choicer == 1 then
        
        local x = event.x + event.width/2
            local y = event.y + event.height/2

            -- Move Susie up to the wall over 0.75 seconds
            cutscene:detachFollowers()
            cutscene:walkTo(Game.world.player, x, y, 0.75, "up")
            
            if #Game.world.followers > 0 then
                Game.world:detachFollowers()
                for i=1, #Game.world.followers do
                    local party = Game.world:getCharacter(Game.party[i+1].actor.id)
                    local party = Game.world:getCharacter(Game.party[2].actor.id)
                    cutscene:walkTo(party, x, y, 0.75, "up")
                end
            end
            cutscene:fadeOut(0.5, {color = COLORS.white})
            cutscene:wait(0.5)
            cutscene:loadMap("floor1/roomloop","spawn")
            cutscene:fadeIn()
            
            
    end
    if choicer == 2 then
            -- Get the bottom-center of the broken wall
            cutscene:text("* You doorn't.")
    end
    end,
    door4 = function(cutscene, event)
        -- Open textbox and wait for completion
        cutscene:text("* There's a door here.")

        -- If we have Susie, play a cutscene
            cutscene:detachCamera()
            cutscene:detachFollowers()
            cutscene:text("* Open it?")
            local choicer = cutscene:choicer({
        "Yes",
        "No",
    })

    if choicer == 1 then
        
        local x = event.x + event.width/2
            local y = event.y + event.height/2

            -- Move Susie up to the wall over 0.75 seconds
            cutscene:detachFollowers()
            cutscene:walkTo(Game.world.player, x, y, 0.75, "up")
            
            if #Game.world.followers > 0 then
                Game.world:detachFollowers()
                for i=1, #Game.world.followers do
                    local party = Game.world:getCharacter(Game.party[i+1].actor.id)
                    local party = Game.world:getCharacter(Game.party[2].actor.id)
                    cutscene:walkTo(party, x, y, 0.75, "up")
                end
            end
            cutscene:fadeOut(0.5, {color = COLORS.white})
            cutscene:wait(0.5)
            cutscene:loadMap("floor1/doorsroom","door2")
            cutscene:fadeIn()
            
            
    end
    if choicer == 2 then
            -- Get the bottom-center of the broken wall
            cutscene:text("* You doorn't.")
    end
    end


}
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

aircon1 = function(cutscene,event)
    cutscene:text("* This is also an air conditioner but I was indeciseive on where to put it so I put two of them.")
    cutscene:text("* ...Walk through it?")
        local choicer = cutscene:choicer({
        "Yes",
        "No",
        })
        if  choicer == 1 then
        cutscene:mapTransition("doorsroom", "door3")
        else
        cutscene:text("* You sigh in relief.")
        end
end,
console = function(cutscene,event)
    cutscene:text("* There's a console here.")
    local choicer = cutscene:choicer({
        "Yes",
        "No",
        })
        if  choicer == 1 then
        cutscene:mapTransition("floor1/normalroom", "spawn")
        else
        cutscene:text("* You sigh in relief.")
        end
end,
gumbler = function(cutscene,event)
    local gumbler = cutscene:getCharacter("gumbler")
cutscene:setSpeaker(gumbler)
    if Game:getFlag("Fusequest", 0) == 3 then
        cutscene:text("* TEST FUCKING DIALOGUE")
    else
    cutscene:text("* Oh, you can FUSE?")
    cutscene:text("* Well Go FUSE Me SOME NEW F%%%ING DIALOGUE!")
    if Game:getFlag("Fusequest", 0) == 2 then
        cutscene:text("* (Apply the new dialogue?)")
        local choicer = cutscene:choicer({
        "Yes",
        "No"
        })
        if choicer == 1 then
            cutscene:text("* TEST FUCKING DIALOGUE")
            Game:setFlag("Fusequest", 3)
        else
            cutscene:text("* (You don't apply the new dialogue)")
        end
    else
    Game:setFlag("Fusequest", 1)
    end
    end
end,

crazy = function(cutscene,event)
    local dino = cutscene:getCharacter("johndino")
    cutscene:setSpeaker(dino)
    if Game.inventory:hasItem("special_spaghetti") then
    cutscene:text("* IT? THAT'S A'S pasta")
    cutscene:text("* GIVE IT TO mE'S, MEMEMEMEMEMEMEME'S!!!")
    cutscene:text("* (Give?)")
    local choicer = cutscene:choicer({
        "No",
        "No",
        "No",
        "PASTA"
        })
        if choicer == 4 then
           cutscene:text("* this is burning my nose. thank you. i will now bestow upon you only the finest of gifts. goodbye, kind people.")
           cutscene:text("* You got the [color:yellow]Dino blend[color:reset].", nil, event)
			Game.inventory:addItem("dino_blend")
            cutscene:mapTransition("floor1/doorsroom", "door3")
        else
            cutscene:text("* WHY??? WHY DO YOU tORTURE??z? GIVE ME NOW!!!")
            cutscene:mapTransition("floor1/doorsroom", "door3")
        end
else
    cutscene:text("* OH! YOU WANT out. Of THIS DUMP!!!! ?")
    cutscene:text("* Well,[wait:3] well well, WELL, well, wellWELLWELLWELLWELLWELLLWELLWELL!!!,")
    cutscene:text("* Oh JOY oh bEE! Do EYE have THE JUST THE THING THE for yOU!")
    cutscene:text("* I'M HUNGERS!!! bRING ME's the PASTA'S WHEN STORE BACK!!!")
    cutscene:mapTransition("floorcyber/dog_highway", "east")
end
end,

door1 = function(cutscene, event)
        -- Open textbox and wait for completion
        cutscene:text("* There's a door here.")

        -- If we have Susie, play a cutscene
            cutscene:text("* Open it?")
            local choicer = cutscene:choicer({
        "Yes",
        "No",
    })

    if choicer == 1 then
                    cutscene:detachCamera()
            cutscene:detachFollowers()
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
            cutscene:text("* Use it?")
            local choicer = cutscene:choicer({
        "Yes",
        "No",
    })

    if choicer == 1 then
                    cutscene:detachCamera()
            cutscene:detachFollowers()
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
    mouse = function(cutscene,event)
        Assets.playSound("notmouse")
    end,
    door4 = function(cutscene, event)
        -- Open textbox and wait for completion
        cutscene:text("* There's a door here.")

        -- If we have Susie, play a cutscene

            cutscene:text("* Open it?")
            local choicer = cutscene:choicer({
        "Yes",
        "No",
    })

    if choicer == 1 then
                    cutscene:detachCamera()
            cutscene:detachFollowers()
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
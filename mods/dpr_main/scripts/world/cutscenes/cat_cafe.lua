return {
    ---@param cutscene WorldCutscene


    event_redirect = function(cutscene, event)
        local e = event.data.properties.redirect
        cutscene:after(function()
            Game.world:getEvent((e + 0)):onInteract()
        end)
    end,

    finished = function(cutscene, event)
        cutscene:text("* TIME IS UP!")


            cutscene:wait(cutscene:fadeOut(1))

                Game.world.map.minigame_remain = 0

            Game.world.map.minigame = nil

            local hs = Game:getFlag("cat_cafe_hi_score", 0)
            local s = (math.floor(Game.world.map.cpoint))

            if s > hs then
                Game:setFlag("cat_cafe_hi_score", s)
                Game.world.map.text:setText("HI SCORE: ".. s)
            end

                Game.world.map.cpoint = 0
                Game.world.map.combo = 1


        Game.world.map.tex:setText("POINTS: 0\nTIME: 0")

        for i, cat in ipairs(Game.world.map.cats) do
            cat.alpha = 1

            if cat.food then
                cat.food:remove()
                cat.food = nil
            end

            if cat.thought then
               cat.thought:remove()
               cat.thought = nil
            end
        end

            local p = Game.world.player

           for i,_ in ipairs(p.food) do
               _:remove()
               p.food[i] = nil
           end

            p.x, p.y = 142, 584
            p:setFacing("up")

            local c = Game.world:getEvent(24)
            c.x, c.y = 280, 440
            local o = Game.world:getEvent(25)
            o.x, o.y = 320, 440

            Game.world.map.minigame = nil

            cutscene:alignFollowers()

            cutscene:wait(cutscene:attachFollowers(99))

            cutscene:wait(cutscene:fadeIn(1))

    end,

    cafe_cat = function(cutscene, event)


       if event.alpha == 0 then return end

       local p = Game.world.player
       if p.food and #p.food > 0 then


         for i, food in ipairs(p.food) do

           local max = (#p.food - (i-1))
           if p.food[max].ufd == event.food.ufd then

               p.food[max]:remove()
               table.remove(p.food, max) 
               --p.food[max] = nil
               Assets.playSound("reverse_splat", 0.8, 1)

               Game.world.map.cpoint = (1*Game.world.map.combo) + Game.world.map.cpoint
               Game.world.map.combo = Game.world.map.combo * 1.5

               for i, food in ipairs(p.food) do
                   food.x = 3
                   food.y = -(2 + (i * 10))
               end

               event.food:remove()
               event.food = nil

               event.thought:remove()
               event.thought = nil

               event.alpha = 0
               break
           elseif max == 1 then
              Assets.playSound("meow_angry", 0.8, math.random(8, 12)/10)
              event:shake(3, 1)
           else
           end
        end


       else
           Assets.playSound("meow", 0.8, math.random(8, 12)/10)
       end
    end,
    the_trigger = function(cutscene, event)


        local pos = {}

        for i, cat in ipairs(Game.world.map.cats) do
            if cat.alpha == 1 then Game.world.map.combo = 1 end

            if cat.alpha == 0 then
               cat.alpha = 1

        local thought = Sprite("world/maps/floor2/darkjam_26/cat_cafe/thought", cat.x - 115, cat.y - 98)
        cat.thought = thought
        thought:setScale(2)
        thought.layer = 1
        thought:play(0.5)
        Game.world:addChild(thought)

        local specials = {
            "pancakes",
            "bloody_pancakes",
            "blue_raspberry",
            "castle_cake",
            "cat_food_fudge",
            "green_stacks",
            "knife_in_my_food",
            "purple_face_cake",
            --"nothing",
        }

        local spr = specials[(math.random(1, #specials))]
        local food = Sprite("world/maps/floor2/darkjam_26/cat_cafe/specials/".. spr, cat.x - 100, cat.y - 84)
        food.ufd = spr
        cat.food = food
        food:setScale(2)
        food.layer = 1.1
        food:play(0.5)
        Game.world:addChild(food)



            end
        end

    end,
    pickup_food = function(cutscene, event)

        local prop = event.data.properties

        local spr = prop.id or "pancakes"

        local p = Game.world.player

        if not p.food then p.food = {} end

        if #p.food == 6 then
            Assets.playSound("error", 0.8, math.random(8, 12)/10)
            p:shake(3, 1)
            return
        else
            Assets.playSound("item", 0.8, math.random(8, 12)/10)
        end

        local food = Sprite("world/maps/floor2/darkjam_26/cat_cafe/specials/".. spr)
        food.ufd = spr

        p.food[(#p.food + 1)] = food

        food.x = 3
        food.y = -(2 + (#p.food * 10))

        Game.world.player:addChild(food)

    end,
    cat_statue = function(cutscene, event)

        local p = Game.world.player
       if p.food and #p.food > 0 then
           for i,_ in ipairs(p.food) do
               if p.food[i].ufd == "nothing" then
                   Assets.playSound("glassbreak", 0.8)
               else
                   Assets.playSound("reverse_splat", 0.8, 1 + (i/3))
               end
               local max = #p.food
               _:remove()
               p.food[i] = nil

               cutscene:wait(0.05)
           end
       else
           Assets.playSound("meow_angry", 0.8, math.random(8, 12)/10)
       end


    end,
    counter = function(cutscene, event)
        --Minigame, Shop, Nevermind

        if Game.world.map.minigame == true then
            cutscene:text("* Wouwd nyu like tyo shtop pwaying, nya?")

            local choice = cutscene:choicer({"Quit", "Keep Playing"})

            if choice == 1 then


            cutscene:wait(cutscene:fadeOut(1))

                Game.world.map.minigame_remain = 0

            Game.world.map.minigame = nil

            local hs = Game:getFlag("cat_cafe_hi_score", 0)
            local s = (math.floor(Game.world.map.cpoint))

            if s > hs then
                Game:setFlag("cat_cafe_hi_score", s)
                Game.world.map.text:setText("HI SCORE: ".. s)
            end

                Game.world.map.cpoint = 0
                Game.world.map.combo = 1


        Game.world.map.tex:setText("POINTS: 0\nTIME: 0")

        for i, cat in ipairs(Game.world.map.cats) do
            cat.alpha = 1

            if cat.food then
                cat.food:remove()
                cat.food = nil
            end

            if cat.thought then
               cat.thought:remove()
               cat.thought = nil
            end
        end

            local p = Game.world.player

           for i,_ in ipairs(p.food) do
               _:remove()
               p.food[i] = nil
           end

            local c = Game.world:getEvent(24)
            c.x, c.y = 280, 440
            local o = Game.world:getEvent(25)
            o.x, o.y = 320, 440

            Game.world.map.minigame = nil

            cutscene:alignFollowers()

            cutscene:wait(cutscene:attachFollowers(99))

            cutscene:wait(cutscene:fadeIn(1))


            elseif choice == 2 then

            end

            return
        end



        cutscene:text("* Wat cyan i dyo fow nyu tyoday, nya?")

        local choice = cutscene:choicer({"Minigame", "Shop", "Nothing"})

        if choice == 1 then
            cutscene:text("* Okiay den, wet mew shet things up fow nyu. wemembah tyo hab fun, nyan~!")
            cutscene:detachFollowers()
            cutscene:wait(cutscene:fadeOut(1))
            local p = Game.world.player

            local c = Game.world:getEvent(24)
            c.x, c.y = 120, 640
            local o = Game.world:getEvent(25)
            o.x, o.y = 160, 640

            p:setFacing("down")
            p.x, p.y = 910, 185

            for i, f in ipairs(Game.world.followers) do
                f.x, f.y = 20 + (40*i), 140
                f:setFacing("down")
            end

        for i, cat in ipairs(Game.world.map.cats) do
            cat.alpha = 0
        end

            cutscene:wait(cutscene:fadeIn(1))

            cutscene:text("* START!")
            Game.world.map.minigame_remain = 60
            Game.world.map.minigame = true
             
        elseif choice == 2 then
        elseif choice == 3 then
            cutscene:text("* baie baie nyow!")
        end

    end,
}

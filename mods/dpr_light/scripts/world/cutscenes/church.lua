return {
    ---@param cutscene WorldCutscene
    organ = function(cutscene, event, player)
        cutscene:text("* (A giant organ.)")
    end,

    door = function(cutscene, event, player)
        cutscene:text("* (It's a door. A large person could fit inside.)")
        cutscene:text("* (...[wait:5] it's locked.)")
    end,

    candles = function(cutscene, event, player)
        cutscene:text("* (It's an altar full of hope\ncandles.[wait:5] Each one has a\nperson's name on it.)")
    end,

    fire_extinguisher = function(cutscene, event, player)
        if cutscene:getCharacter("susie_lw") then
            cutscene:text("* (It's a fire extinguisher.)[wait:10]\n* (For some reason you have the\nfeeling...)")
            cutscene:text("* (...[wait:5] Susie will say something\nstupid about it.)[react:1]", nil, nil, {reactions={{"They should make one of these\nthat shoots whip cream", "mid", "bottom", "smile", "susie"}}})
        else
            cutscene:text("* (It's a fire extinguisher.)")
        end
    end,

    holy_water = function(cutscene, event)
        cutscene:text("* (It's a bowl of blessed water with a motion sensor to stop cats from drinking it.)")
        cutscene:text("* (It's not clear what happens if you touch the sensor.)")
    end,

    entrance_bookshelf = function(cutscene, event)
        cutscene:text("* (It's a bookshelf full of\nhymnals and scripture.)")
        cutscene:text("* (...[wait:5] and some copies of Lord of\nthe Hammer.)")
    end,

    pitcher = function(cutscene, event)
        cutscene:text("* (It's a large pitcher of water.)")
        cutscene:text("* (Cups are stored below it.)")
    end,

    drinks = function(cutscene, event)
        cutscene:text("* (Juice,[wait:5] and wafer-like crackers.)")
    end,

    cupboard = function(cutscene, event)
        cutscene:text("* (Documents...)")
    end,

    office_bookshelf = function(cutscene, event)
        cutscene:text("* (Books. Many copies of Lord of the Hammer...[wait:5] and some unlabeled notebooks.)")
    end,

    plaque = function(cutscene, event)
        cutscene:text("* (It's a plaque bearing the words of a famous writer.)")
        cutscene:text("* (\"Hope comes to those who believe. And for those that cannot...\")")
        cutscene:text("* (\"...[wait:5] May our hope shine so brightly...\")")
        cutscene:text("* (\"...[wait:5] That they,[wait:5] too,[wait:5] may keep shelter from the dark.\")")
    end,

    hanging = function(cutscene, event)
        cutscene:text("* (Seems to be some sort of incense container.)")
    end,

    wardrobe = function(cutscene, event)
        cutscene:text("* (The wardrobe is full of choir robes...[wait:5] There's even one in your size.)")
    end,

    bells = function(cutscene, event)
        cutscene:text("* (It's a set of bells of different sizes.)")
        local dowemess = cutscene:choicer({"Mess\nwith them", "Don't"})
        if dowemess == 1 then
            Game.world.timer:after(4/30, function() Assets.playSound("playablebell", 0.7, 0.8) end)
            Game.world.timer:after(8/30, function() Assets.playSound("playablebell", 0.7, 1) end)
            Game.world.timer:after(12/30, function() Assets.playSound("playablebell", 0.7, 1.2) end)
            cutscene:wait(1)
        end
    end,

    piano = function(cutscene, event)
        cutscene:text("* (It's a keyboard. It has settings to sound like either a piano or an organ.)")
    end,
}

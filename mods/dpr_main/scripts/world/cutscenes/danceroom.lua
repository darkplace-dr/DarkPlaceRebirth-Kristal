return {
    -- keep this at the top of the file
    -- and increment every time you edit it
    -- times edited: 3
    
    jamm = function(cutscene, event)
        cutscene:showNametag("Jamm")
        cutscene:text("* Heck yeah,[wait:5] this dance party room is amazing!", "smug", "jamm")
        cutscene:text("* Still wondering when the performance will start,[wait:5][face:smug] but yeah!", "look_left", "jamm")
        cutscene:hideNametag()
    end,
    susie = function(cutscene, event)
        cutscene:showNametag("Susie")
        cutscene:text("* Dude,[wait:5] this party is sick!", "smile", "susie")
        cutscene:hideNametag()
    end,
    ralsei = function(cutscene, event)
        cutscene:text("* someone please write for Ralsei here idk how to do that")
    end,
    ceroba = function(cutscene, event)
        cutscene:text("* someone please write for Ceroba here idk how to do that")
    end,
    kris = function(cutscene, event)
        -- nothing :P
    end,
}

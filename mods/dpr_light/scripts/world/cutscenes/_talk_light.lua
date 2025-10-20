return function(cutscene)
    local susie = cutscene:getCharacter("susie")
    local noelle = cutscene:getCharacter("noelle")
    local ceroba = cutscene:getCharacter("ceroba")
    if Game.world.map.id == "light/hometown/town_school" then
        if ceroba then
            cutscene:text("* Why is there only one parking place?", "unsure", ceroba)
            cutscene:text("* Do you have only one car in town?", "unsure_alt", ceroba)
            if noelle then
                cutscene:text("* Oh![wait:10] It's actually because...", "smile", noelle)
                cutscene:text("* ...", "confused", noelle)
                cutscene:text("* ...", "frown", noelle)
                cutscene:text("* ...", "confused_surprise_b", noelle)
                cutscene:text("* Actually,[wait:5] I don't know.", "what_smile", noelle)
            end
        else
            cutscene:text("* Your voice echoes aimlessly.")
        end
    elseif Game.world.map.id == "light/hometown/school/school_lobby" then
        if ceroba then
            cutscene:text("* So,[wait:5] this is your school,[wait:5] huh?", "alt", ceroba)
            cutscene:text("* Hopefully we won't get in trouble here for trespassing.", "nervous_smile", ceroba)
            cutscene:text("* Especially me,[wait:5] since,[wait:5] you know...", "confounded", ceroba)
            cutscene:text("* I'm not a child nor a teacher to be walking around here.", "nervous_smile", ceroba)
        else
            cutscene:text("* Your voice echoes aimlessly.")
        end
    elseif Game.world.map.id == "light/hometown/school/kris_class" then
        if ceroba then
            cutscene:text("* A generic classroom...", "alt", ceroba)
            cutscene:text("* Personally I wouldn't say there's anything to talk about.", "neutral", ceroba)
        else
            cutscene:text("* Your voice echoes aimlessly.")
        end
    elseif Game.world.map.id == "light/hometown/school/toriel_class" then
        if ceroba then
            if not Game.world.map.ceroba_talk then
                cutscene:text("* This must be a class for low graders,[wait:5] right?", "neutral", ceroba)
                cutscene:text("* ...", "alt", ceroba)
                cutscene:text("* Wait,[wait:5] \"Ms. Toriel\"?", "surprised", ceroba)
                cutscene:text("* THE Toriel?[wait:10] Toriel Dreemurr?", "nervous", ceroba)
                cutscene:text("* (No,[wait:5] this is probably just a coincidence...)", "dissapproving", ceroba)
                Game.world.map.ceroba_talk = 1
            else
                cutscene:text("* ...", "alt", ceroba)
                cutscene:text("* (Kanako would love it here...)", "dissapproving", ceroba)
            end
        else
            cutscene:text("* Your voice echoes aimlessly.")
        end
    elseif Game.world.map.id == "light/hometown/school/school_door" then
        if ceroba then
            cutscene:text("* Just another school corridor.", "alt", ceroba)
            cutscene:text("* Nothing I haven't seen.", "closed_eyes", ceroba)
        else
            cutscene:text("* Your voice echoes aimlessly.")
        end
    elseif Game.world.map.id == "light/hometown/school/unused_class" then
        if ceroba then
            cutscene:text("* This classroom is...[wait:10] [face:unsure_alt]Quite empty.", "unsure", ceroba)
            cutscene:text("* It must be unused then...", "closed_eyes", ceroba)
        else
            cutscene:text("* Your voice echoes aimlessly.")
        end
    else
        cutscene:text("* Your voice echoes aimlessly.")
    end
end
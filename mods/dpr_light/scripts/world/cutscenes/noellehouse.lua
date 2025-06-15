return {
    ---@param cutscene WorldCutscene
    door = function(cutscene, event, player)
        cutscene:text("* (It's locked.)")
        if Game:hasPartyMember("noelle") then
            cutscene:text("* (...[wait:5] why are we trying to open my parents' room?)", "what_smile_b", "noelle")
        end
    end,

    dess_blocker = function(cutscene, event, player)
        cutscene:text("* Umm,[wait:5] sorry...[wait:5] guests aren't allowed in there.", "smile_side", "noelle")
        cutscene:text("* Especially after what happened last time...", "what_smile", "noelle")
    end,
}

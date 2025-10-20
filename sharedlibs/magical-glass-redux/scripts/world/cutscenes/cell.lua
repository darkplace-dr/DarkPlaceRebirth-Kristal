return {
    box_a = function(cutscene)
        Assets.stopSound("phone")
        Assets.stopAndPlaySound("dimbox")
        cutscene:wait(7/30)
        cutscene:after(function() Game.world:openMenu(LightStorageMenu("items", "box_a")) end)
    end,
    box_b = function(cutscene)
        Assets.stopSound("phone")
        Assets.stopAndPlaySound("dimbox")
        cutscene:wait(7/30)
        cutscene:after(function() Game.world:openMenu(LightStorageMenu("items", "box_b")) end)
    end,
    settings = function(cutscene)
        Assets.stopSound("phone")
        Assets.stopAndPlaySound("ui_select")
        cutscene:wait(1/30)
        cutscene:after(function() Game.world:openMenu(LightConfigMenu()) end)
    end,
    recruits = function(cutscene)
        Assets.stopSound("phone")
        if not Game:getConfig("enableRecruits") then
            cutscene:text("* You tried to open the recruits menu, [wait:10]but recruits are disabled.")
        elseif #Game:getAllRecruits(true) > 0 then
            Assets.stopAndPlaySound("ui_select")
            cutscene:wait(1/30)
            cutscene:after(function() Game.world:openMenu(RecruitMenu()) end)
        else
            cutscene:text("* You tried to open the recruits menu, [wait:10]but you have no recruits.")
        end
    end,
}
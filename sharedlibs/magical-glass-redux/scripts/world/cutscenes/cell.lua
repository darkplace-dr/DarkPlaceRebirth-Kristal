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
}
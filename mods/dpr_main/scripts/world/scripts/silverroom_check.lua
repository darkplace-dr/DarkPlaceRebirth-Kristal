return function(script, chara)
    if (Game.world.player.holding and #Game.world.player.holding > 0 and not Game.world:hasCutscene()) then
        Game.world:startCutscene("hub.silverroom_check")
    end
end
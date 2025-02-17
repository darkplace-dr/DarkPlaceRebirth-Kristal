return {
    dess_plush = function(cutscene)
        local dess_plush = cutscene:getCharacter("dess_plush")
        local dess = cutscene:getCharacter("dess")
        local susie = cutscene:getCharacter("susie")
        if dess then
            cutscene:textTagged("* Dang,[wait:5] I wonder how this got here.", "genuine", "dess")
            cutscene:textTagged("* Dang,[wait:5] I REALLY wonder how this thing got here.", "kind", "dess")
            cutscene:textTagged("* Good Heavens,[wait:5] I REALLY feel like pondering on how this marketable stuffed version of myself had made it's way to the location we currently are standing on.", "condescending", "dess")
            if susie then
                cutscene:textTagged("* OKAY, can we get moving now?!", "angry", susie)
                cutscene:textTagged("* k.", "condescending", "dess")
            end
        end
        cutscene:hideNametag()
        Assets.playSound("achievement")
        cutscene:text("* You found the Dess Plush!")
        Assets.playSound("item")
        dess_plush:remove()
        Game:setFlag("dess_plush", true)
    end,
}
return{
    sign1 = function(cutscene)
        local hero = cutscene:getCharacter("hero")

        cutscene:text("* (It's a sign.)")
        if not Game:getFlag("topfloor_canreadsigns", false) then
            if hero then
                cutscene:showNametag("Hero")
                cutscene:text("* Hmm...[wait:10] the letters are a bit smudged,[wait:5] but I think I can read this.", "neutral_closed_b", "hero")
                cutscene:hideNametag()
                Game:setFlag("topfloor_canreadsigns", true)
            end
        end
        if hero then
            cutscene:text("[voice:hero]* Notice:")
            cutscene:text("[voice:hero]* Due to a lack of proper infrastructure...")
            cutscene:text("[voice:hero]* ...we highly urge visitors to tread this floor with caution.")
            cutscene:text("[voice:hero]* [color:yellow]Climbing gear[color:reset] is recommended for anyone who wishes to not take dangerous detours.")
            cutscene:text("[voice:hero]* - Sincerely,[wait:5] Management")
            cutscene:showNametag("Hero")
            cutscene:text("* Well that's not very reassuring.", "really", "hero")
        else
            if Game.party[1].id == "dess" then
                cutscene:showNametag("Dess")
                cutscene:text("* i cant read ts lmao", "condescending", "dess")
                cutscene:hideNametag()
            else
                cutscene:text("* (Unfortunately,[wait:5] it's written in a font you can't read.)")
            end
        end
    end
}

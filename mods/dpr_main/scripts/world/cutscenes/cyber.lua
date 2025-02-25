---@type table<string,fun(cutscene:WorldCutscene, event?: Event|NPC)>
local cyber = {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `WorldCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene WorldCutscene
    kris_cutout = function(cutscene, event, chara)
        local fakeKris = cutscene:getCharacter("kris_cutout")
        local fakeKrisKnockedOver = Game:getFlag("fakeKrisKnockedOver", false)

        if fakeKrisKnockedOver == false then
            cutscene:text("* (Upon closer inspection, this is not Kris...)")

            Assets.playSound("noise")
            fakeKris:setAnimation("flat")
            cutscene:text("* (...but rather, an extremely convincing cardboard cutout of them.)")
		
            Game:setFlag("fakeKrisKnockedOver", true)
        else
            cutscene:text("* (...)")
        end
    end,
}
return cyber

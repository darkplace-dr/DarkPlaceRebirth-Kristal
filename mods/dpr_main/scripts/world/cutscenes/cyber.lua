---@type table<string,fun(cutscene:WorldCutscene, event?: Event|NPC)>
local cyber = {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `WorldCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene WorldCutscene
    kris_cutout = function(cutscene, event, chara)
        local fakeKris = cutscene:getCharacter("kris_cutout")
        local fakeKrisKnockedOver = Game:getFlag("fakeKrisKnockedOver", false)
        local gotCellPhone = Game:getFlag("gotCellPhone", false)

        if fakeKrisKnockedOver == false then
            cutscene:text("* (Upon closer inspection, this is not Kris...)")

            Assets.playSound("noise")
            fakeKris:setAnimation("flat")
            cutscene:text("* (...but rather, an extremely convincing cardboard cutout of them.)")
		
            Game:setFlag("fakeKrisKnockedOver", true)
        elseif fakeKrisKnockedOver == true then
            if gotCellPhone == false then
                cutscene:text("* (There's a cell phone attached to the cutout.)\n* (Take it?)")
                local choice = cutscene:choicer({ "Take it", "Don't" })
			    if choice == 1 then
			        Assets.playSound("item")
			        Game.inventory:addItem("cell_phone")
                    cutscene:text("* (You got the Cell Phone.)")
                    cutscene:text("* (The Cell Phone was added to your KEY ITEMS.)")
                end
                Game:setFlag("gotCellPhone", true)
            else
                cutscene:text("* (It's just a cardboard \ncutout.)")
            end
        end
    end,
}
return cyber

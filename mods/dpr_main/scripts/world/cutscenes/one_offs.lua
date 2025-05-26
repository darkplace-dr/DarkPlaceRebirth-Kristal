return {
    jamm_dlc = function(cutscene)
        if Kristal.Mods.data["dpr_jamm_dlc"] == nil then
			cutscene:text("* But your feet refused to budge.")
			cutscene:text(string.format("* (Are you missing the \"Jamm's DLC\" DLC?)"))
			return
		end


		local has_dess = cutscene:getCharacter("dess") ~= nil
		cutscene:text("* Your "
			.. (has_dess and "desstination" or "destination")
			.." is "
			..(has_dess and "in another castle" or "infinitely far away")
			..".\n* Leave this "
			.. (has_dess and "Dark " or "")
			.."Place?")
		local enter = cutscene:choicer({"Yes", "No"})

		if enter == 1 then
			cutscene:after(Game:swapIntoMod("dpr_jamm_dlc", true, "fwood/entry", "entrypoint"))
		else
			cutscene:text("* You travelen't.")
			cutscene:wait(cutscene:walkTo(Game.world.player, Game.world.player.x, Game.world.player.y + 20))
		end
    end,
}
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
    trapped_forever = function(cutscene)
        local id = Game.world.player.actor.id

        if Game:getGlobalFlag(id.. "_trapped_forever", false) then
			cutscene:text("[speed:0.3][voice:nil]*[spacing:5] It appears you have reached an end.")
			cutscene:text("[speed:0.3][voice:nil]*[spacing:5] Or rather,[wait:5] your previous incarnation has.")
			cutscene:text("[speed:0.3][voice:nil]*[spacing:5] Using it as a sacrifice...")
			cutscene:text("[speed:0.3][voice:nil]*[spacing:5] We may restore your body to as it was before.")
			cutscene:text("[speed:0.3][voice:nil]*[spacing:5] However,[wait:5] you will not end up where you first started.")
			cutscene:text("[speed:0.3][voice:nil]*[spacing:5] Such is the cost of restoring without [color:red]DETERMINATION[color:reset].")
			cutscene:text("[speed:0.3][voice:nil]*[spacing:5] Should you wish to proceed...")
			cutscene:text("[speed:0.3][voice:nil]*[spacing:5] Things may not turn out how fate intended.")
			cutscene:text("[speed:0.3][voice:nil]*[spacing:5] Do you wish to bear this cost,[wait:5] or stay in purgatory forever?")
			local choice = cutscene:choicer({"Yes", "No"})
			if choice == 1 then
				cutscene:text("[speed:0.3][voice:nil]*[spacing:5] Very well...")
				cutscene:text("[speed:0.3][voice:nil]*[spacing:5] See you on the other side.")
				cutscene:wait(cutscene:fadeOut(3, {color = {1,1,1}}))
				cutscene:wait(0.5)
				Game:setFlag("_heromode", true)
				Game.world:loadMap("main_outdoors/tower_outside")
				Game.world.music:stop()
				cutscene:fadeIn(0)

				local hero = cutscene:getCharacter("hero")
        		hero:setSprite("fell")

				cutscene:wait(2)
            	local wing = Assets.playSound("wing")
            	Game.world.player:shake()
            	cutscene:wait(1.5)
            	wing:play()
            	Game.world.player:shake()
            	cutscene:wait(0.5)
            	wing:stop()
            	wing:play()
            	Game.world.player:shake()
				hero:resetSprite()
            	hero:setFacing("right")
            	cutscene:wait(2)
            	cutscene:textTagged("* Hello?", "neutral_closed_b", "hero")
				local stime = 0.30
           		cutscene:wait(stime)
            	hero:setFacing("up")
            	cutscene:wait(stime)
            	hero:setFacing("left")
            	cutscene:wait(stime)
            	hero:setFacing("down")
            	cutscene:wait(stime)
            	hero:setFacing("right")
           		cutscene:wait(0.75)

            	cutscene:textTagged("* Is someone...", "neutral_closed", "hero")
            	hero:setFacing("up")
				cutscene:textTagged("* ...", "shocked", "hero")
				cutscene:textTagged("* This isn't...[wait:10] where I was supposed to go.", "annoyed_b", "hero")
            	hero:setFacing("down")
				cutscene:textTagged("* Or,[wait:5] well,[wait:5] in a way it is, I think?", "shocked", "hero")
				cutscene:textTagged("* Whatever,[wait:5] saves a bunch of walking.", "pout", "hero")
				Game.world.music:play("mainhub_outside")
				-- cus it breaks stuff otherwise
				local baseParty = {}
				table.insert(baseParty, "hero")
            	Game:setFlag("_unlockedPartyMembers", baseParty)
			else
				cutscene:text("[speed:0.3][voice:nil]*[spacing:5] Very well...")
				cutscene:text("[speed:0.3][voice:nil]*[spacing:5] Then remain here for all eternity.")
				Kristal.returnToMenu()
			end
        else
            Game:setGlobalFlag(id.. "_trapped_forever", true)
			cutscene:text("[speed:0.3][voice:nil]*[spacing:5] It appears you have reached an end.")
			cutscene:text("[speed:0.3][voice:nil]*[spacing:5] What a pity that you didn't [color:yellow]SAVE[color:reset].")
			cutscene:text("[speed:0.3][voice:nil]*[spacing:5] Although perhaps,[wait:5] you may still be of some use.")
			cutscene:text("[speed:0.3][voice:nil]*[spacing:5] Should a future incarnation of you pass on without saving...")
			cutscene:text("[speed:0.3][voice:nil]*[spacing:5] They may use your life to restore theirs.")
			cutscene:text("[speed:0.3][voice:nil]*[spacing:5] Of course,[wait:5] it would come with some other costs.")
			cutscene:text("[speed:0.3][voice:nil]*[spacing:5] Such is the result of restoring without proper [color:red]DETERMINATION[color:reset].")
			cutscene:text("[speed:0.3][voice:nil]*[spacing:5] But until then...")
			cutscene:text("[speed:0.3][voice:nil]*[spacing:5] Goodbye.")
            Kristal.returnToMenu()
        end
    end,
    lost_hero = function(cutscene)
		cutscene:text("* (Nothing more than a past life.)")
    end,
}
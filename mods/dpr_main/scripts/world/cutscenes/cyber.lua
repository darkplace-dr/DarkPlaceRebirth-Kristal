---@type table<string,fun(cutscene:WorldCutscene, event?: Event|NPC)>
local cyber = {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `WorldCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene WorldCutscene
    knock_door = function(cutscene, event)
        local cityDoorKnocks = Game:getFlag("cityDoorKnocks", 0)
        local cityDoorUnlocked = Game:getFlag("cityDoorUnlocked", false)
		if cityDoorUnlocked then
			Assets.playSound("dooropen")
			local callback = function(map)
				Assets.playSound("doorclose")
			end
			Game.world:mapTransition("floorcyber/numbers_station", "entry_up", "up", callback)
		else
			Assets.playSound("knock")
			cutscene:text("* (Knock,[wait:5] knock,[wait:5] knock)")
			if cityDoorKnocks >= 24 then
				Game.world.music:fade(0, 1)
				cutscene:wait(2)
				cutscene:text("* ...")
				cutscene:text("* You managed to unlock the door.")
				Assets.playSound("dooropen")
				local callback = function(map)
					Assets.playSound("doorclose")
				end
				Game.world:mapTransition("floorcyber/numbers_station", "entry_up", "up", callback)
				Game:setFlag("cityDoorUnlocked", true)
			else
				cutscene:text("* You found the only knockable door in the city.")
				cutscene:text("* This here is my pride and joy...")
				Game:setFlag("cityDoorKnocks", cityDoorKnocks+1)
			end
		end
    end,
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
                    Game:setFlag("gotCellPhone", true)
                end
            else
                cutscene:text("* (It's just a cardboard \ncutout.)")
            end
        end
    end,
    checks_quest = function(cutscene, event)
        local hacker = cutscene:getCharacter("hacker")
        local hackerSidequest = Game:getFlag("hackerSidequest", 0)
        local hackerCheckmarks = Game:getFlag("hackerCheckmarks", 0)
		-- placeholder dialog
		if hackerSidequest == 2 then
			cutscene:showNametag("Hacker")
			cutscene:text("* I just wanted to make a cool demoscene for you.")
			cutscene:text("* Now that I finished this I can show up all sorts of places.")
			cutscene:hideNametag()
		else
			if hackerCheckmarks < 3 then
				if hackerSidequest == 0 then
					cutscene:showNametag("Hacker")
					cutscene:text("* I'm the Hacker. I'm going after the blue checksmarks once more.")
					cutscene:text("* Find 3 in this floor ahead,[wait:5] and I'll join your [City].")
					cutscene:text("* You just look like the kind of folks who have a [Cool City].")
					cutscene:hideNametag()

					Game:setFlag("hackerSidequest", 1)
					Game:setFlag("hackerCheckmarks", 0)
					Game:getQuest("checks_quest"):unlock()
				else
					cutscene:showNametag("Hacker")
					cutscene:text("* According to cyber,[wait:5] you found "..hackerCheckmarks.." blue checksmarks out of 3.")
					if hackerCheckmarks == 0 then
						cutscene:text("* 0,[wait:5] not bad for a beginner. Your \"Checks Quest 2\" is only beginning.")
					end
					if hackerCheckmarks == 1 then
						cutscene:text("* 1,[wait:5] the biggest prime number. Your \"Checks Quest 2\" is just started.")
					end
					if hackerCheckmarks == 2 then
						cutscene:text("* 2. Not bad for amateurs but you need to learn what the number \"3\" is.")
					end
					cutscene:hideNametag()
				end
			else
				cutscene:showNametag("Hacker")
				if hackerSidequest == 0 then
					cutscene:text("* Wow,[wait:5] I'm the Hacker and you found all 3 checkmarks!")
				else
					cutscene:text("* You found 3 checkmarks?![wait:5] Elite...[wait:5] I will now live in your city.")
				end
				cutscene:text("* Maybe our cyber paths will cyber cross once more in the near future.")
				cutscene:text("* In the meantime,[wait:5] let me show you the power of the blue checkmarks...")
				cutscene:hideNametag()
				Game:setFlag("hackerSidequest", 2)
			end
		end
    end,
}
return cyber

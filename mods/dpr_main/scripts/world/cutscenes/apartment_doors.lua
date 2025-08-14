return {
	jamm = function(cutscene, event)
		cutscene:text("* It's a door.")
		cutscene:text("* The sign reads \"This apartment belongs to Luthane Jamm and Marcy Jamm.\"")
		if Game:getFlag("acj_quest_prog", 0) >= 2 then
			if not Game:hasPartyMember("jamm") then
				if Game:getFlag("jamm_waiting") then
					cutscene:text("* Didn't Jamm say he'd wait for you here?")
				end
				cutscene:text("* Will you knock?")
			else
				cutscene:text("* Will you enter the apartment?")
			end
			
			local choice = cutscene:choicer({"Yes", "No"})
			
			if choice == 1 then
				if not Game:hasPartyMember("jamm") then
					Assets.playSound("knock")
					cutscene:text("* You knock on the door...")
						
					cutscene:showNametag("Jamm")
					cutscene:text("[voice:jamm]* Oh,[wait:5] coming!")
					cutscene:hideNametag()
				else
					cutscene:text("* Jamm pulls a key card out of his pocket and unlocks the door...")
				end
				
				cutscene:wait(cutscene:fadeOut(0))
				Assets.playSound("dooropen")
				
				cutscene:wait(1)
				
				Assets.playSound("doorclose")
				cutscene:loadMap("floor2/apartments/jamm/jamm_apartment", "entry")
				cutscene:wait(cutscene:fadeIn(0))
			else
				cutscene:text("* You decide not to.")
			end
		end
	end,

	ddelta = function(cutscene, event)
		cutscene:text("* It's a door.")
		cutscene:text("* The sign reads \"This\napartment belongs to Diamond Deltahedron.\"")
		-- To write
	end,

	brenda = function(cutscene, event)
		cutscene:text("* It's a door.")
		cutscene:text("* The sign reads \"This apartment belongs to Brenda Kathiline.\"")
		if Game:hasPartyMember("brenda") then
			if not Game:getFlag("a_brenda_door") then
				cutscene:showNametag("Brenda")
				cutscene:text("* Oh wow,[wait:5] my own apartment?", "shocked", "brenda")
				cutscene:text("* Wait hold on,[wait:5] I just got here,[wait:5] how the hell do I have my own personalized apartment?", "suspicious_b", "brenda")
				cutscene:text("* Eh whatever,[wait:5] don't look a Giftrot in the mouth as they say.", "suspicious", "brenda")
				cutscene:hideNametag()
			end
			if not Game:getFlag("a_brenda_key") then
				cutscene:text("* Unfortunately,[wait:5] it's locked.")
			else

			end
		else
			cutscene:text("* It's locked.")
		end
	end,

	nell = function(cutscene, event)
		cutscene:text("* It's a blank door with a yellow soul emblem.")
		cutscene:text("* You can't help but wonder who it might belong to.")
		-- To write (in like a 1000 years when this gremlin's DLC will come out)
	end,

	gen = function(cutscene, event)
		Game.world.music:pause()
		cutscene:wait(1)
		cutscene:text("[wait:30][sound:giygastalk][voice:none][speed:0.3][shake]* Come in...")
		cutscene:text("[wait:30][sound:giygastalk][voice:none][speed:0.3][shake]* Come and see [wait:10]the story...")
		cutscene:text("[wait:30][sound:giygastalk][voice:none][speed:0.3][shake]* The story of [wait:10]a man\n[wait:10]* Who went too deep...")
		cutscene:wait(1)
		Game.world.music:play()
	end,

	ceroba = function(cutscene, event)
		if Game:getFlag("ceroba_dead") then
			cutscene:text("* You have a feeling that this room might be left empty forever...")
		elseif Game:hasPartyMember("ceroba") then
			cutscene:text("* That's my room.", "neutral", "ceroba")
			cutscene:text("* You want to come in?", "alt", "ceroba")
			local choice = cutscene:choicer({"Yes", "No"})
			cutscene:text("* Alright then.", "neutral", "ceroba")
			if choice == 1 then
				cutscene:mapTransition("floor2/apartments/ceroba", "entrance")
			end
		elseif Game:hasUnlockedPartyMember("ceroba") then
			cutscene:text("* Knock on the door?")
			local choice = cutscene:choicer({"Yes", "No"})
			if choice == 1 then
				Assets.playSound("knock", 0.8)
				cutscene:wait(1)
				cutscene:text("* Come in!", nil, "ceroba")
				Assets.playSound("dooropen")
				cutscene:mapTransition("floor2/apartments/ceroba", "entrance")
			end
		else
			cutscene:text("* A door with an interesting style choice. It's locked.")
		end
	end,
}
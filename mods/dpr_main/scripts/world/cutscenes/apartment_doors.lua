return {
	jamm = function(cutscene, event)
		cutscene:text("* It's a door.")
		cutscene:text("* The sign reads \"This apartment belongs to Luthane Jamm and Marcy Jamm.\"")
		-- To write
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
}
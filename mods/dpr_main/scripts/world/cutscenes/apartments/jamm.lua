return {
	introductions = function(cutscene, event)
		local jamm = cutscene:getCharacter("jamm")
		
		cutscene:showNametag("Jamm")
		if #Game.party == 1 then
			cutscene:text("* Hey,[wait:5] it's you!", "smile", "jamm")
		else
			cutscene:text("* Hey,[wait:5] it's you guys!", "smile", "jamm")
		end
		cutscene:hideNametag()
		
		cutscene:detachFollowers()
		
		if #Game.party == 1 then
			cutscene:walkTo(Game.world.player, 660, 640, 1, "up")
		elseif #Game.party == 2 then
			cutscene:walkTo(Game.world.player, 630, 640, 1, "up")
			cutscene:walkTo(Game.world.followers[1], 690, 640, 1, "up")
		elseif #Game.party == 3 then
			cutscene:walkTo(Game.world.player, 600, 640, 1, "up")
			cutscene:walkTo(Game.world.followers[1], 660, 640, 1, "up")
			cutscene:walkTo(Game.world.followers[2], 720, 640, 1, "up")
		else	-- I know 4 is planned but I won't write this case yet
		
		end
		
		cutscene:wait(cutscene:panTo("camto", 1))
		
		cutscene:showNametag("Jamm")
		cutscene:text("* Thanks again for giving me the opportunity to escape.", "side_smile", "jamm")
		
		if cutscene:getCharacter("susie") then
			cutscene:showNametag("Susie")
			cutscene:text("* Uh,[wait:5] yeah...[wait:10]\n* Where were you trapped at?", "nervous", "susie")
			cutscene:showNametag("Jamm")
			cutscene:text("* You don't want to know...", "nervous", "jamm")
		end
		
		if #Game.party == 1 then
			cutscene:text("* I really appreciate you saving my skin.", "side_smile", "jamm")
			cutscene:text("* If I was stuck any longer,[wait:5] I would...", "ouch", "jamm")
			if Game.party[1].id == "dess" then
				cutscene:text("* I mean,[wait:5] I know I'm gonna get an earful about it,[wait:5] but...", "neutral", "jamm")
			elseif Game.party[1].id == "mario" then
				cutscene:text("* But let's be real,[wait:5] Mario.[wait:10]\n* I didn't expect you.", "smug", "jamm")
				cutscene:text("* Any luck finding Luigi yet?", "side_smile", "jamm")
				cutscene:showNametag("Mario")
				cutscene:text("* ...That's-a what Mario was supposed to be doing?", "default", "mario")
				cutscene:showNametag("Jamm")
				cutscene:text("* ...Why am I not surprised.", "stern", "jamm")
			else
				cutscene:text("* But enough about me.[wait:10]\n* What's your name?", "neutral", "jamm")
				
				if Game.party[1].id == "susie" then
					cutscene:showNametag("Susie")
					cutscene:text("* I'm Susie![wait:10]\n* I'm the one who made the fountains!", "sincere_smile", "susie")
					cutscene:text("* I mean,[wait:5] not that I'm proud of that NOW...", "nervous_side", "susie")
					cutscene:showNametag("Jamm")
					cutscene:text("* Fountains?", "neutral", "jamm")
					cutscene:showNametag("Susie")
					cutscene:text("* They,[wait:5] uh,[wait:5] let us enter the dark worlds.", "smirk", "susie")
					cutscene:showNametag("Jamm")
					cutscene:text("* Yeah,[wait:5] sounds about right.", "stern", "jamm")
				elseif Game.party[1].id == "hero" then
					cutscene:showNametag("Hero")
					cutscene:text("* I'm Hero.", "neutral_closed", "hero")
					cutscene:showNametag("Jamm")
					cutscene:text("* \"Hero\" as in an unnamed hero,[wait:5] or...?", "neutral", "jamm")
					cutscene:showNametag("Hero")
					cutscene:text("* Something like that???", "shocked", "hero")	-- they never made the realization
					cutscene:showNametag("Jamm")
					cutscene:text("* I see...", "look_left", "jamm")
				else
					cutscene:hideNametag()
					cutscene:text("* You tell Jamm your name.")
					cutscene:showNametag("Jamm")
				end
				
				cutscene:text("* So,[wait:5] " .. Game.party[1].name .. "?[wait:10] Nice to meet you!", "side_smile", "jamm")
			end
		else
			cutscene:text("* I really appreciate you guys saving my skin.", "side_smile", "jamm")
			cutscene:text("* If I was stuck any longer,[wait:5] I would...", "ouch", "jamm")
			cutscene:text("* But enough about me.[wait:10]\n* What are your names?", "neutral", "jamm")
			
			local undefined = 0
			for k,party in ipairs(Game.party) do
				if party.id == "susie" then
					cutscene:showNametag("Susie")
					cutscene:text("* I'm Susie![wait:10]\n* I'm the one who made the fountains!", "sincere_smile", "susie")
					cutscene:text("* I mean,[wait:5] not that I'm proud of that NOW...", "nervous_side", "susie")
					cutscene:showNametag("Jamm")
					cutscene:text("* Fountains?", "neutral", "jamm")
					cutscene:showNametag("Susie")
					cutscene:text("* They,[wait:5] uh,[wait:5] let us enter the dark worlds.", "smirk", "susie")
					cutscene:showNametag("Jamm")
					cutscene:text("* Yeah,[wait:5] sounds about right.", "stern", "jamm")
				elseif party.id == "hero" then
					cutscene:showNametag("Hero")
					cutscene:text("* I'm Hero.", "neutral_closed", "hero")
					cutscene:showNametag("Jamm")
					cutscene:text("* \"Hero\" as in an unnamed hero,[wait:5] or...?", "neutral", "jamm")
					cutscene:showNametag("Hero")
					cutscene:text("* Something like that???", "shocked", "hero")	-- they never made the realization
					cutscene:showNametag("Jamm")
					cutscene:text("* I see...", "look_left", "jamm")
				elseif party.id == "dess" then
					cutscene:showNametag("Dess")
					cutscene:text("* Well--", "smug", "dess", {auto=true})
					cutscene:showNametag("Jamm")
					cutscene:text("* I know who you are,[wait:5] Dess.", "stern", "jamm")
				elseif party.id == "mario" then
					cutscene:showNametag("Jamm")
					cutscene:text("* I know who you are,[wait:5] Mario.", "side_smile", "jamm")
					cutscene:text("* Any luck finding Luigi yet?", "side_smile", "jamm")
					cutscene:showNametag("Mario")
					cutscene:text("* ...That's-a what Mario was supposed to be doing?", "default", "mario")
					cutscene:showNametag("Jamm")
					cutscene:text("* ...Why am I not surprised.", "stern", "jamm")
				else
					undefined = undefined + 1
				end
			end
			
			if undefined == #Game.party then
				cutscene:hideNametag()
				cutscene:text("* You all tell Jamm your names.")
			elseif undefined > 0 then
				cutscene:hideNametag()
				cutscene:text("* The rest of you tell Jamm your names.")
			end
			
			cutscene:text("* Well,[wait:5] it's nice to meet you all!", "side_smile", "jamm")
		end
		
		cutscene:text("* Hey,[wait:5] am I right to assume you are all on some mission?", "side_smile", "jamm")
		
		if cutscene:getCharacter("hero") then
			cutscene:showNametag("Hero")
			cutscene:text("* Yeah,[wait:5] we're trying to seal the fountains.", "neutral_closed", "hero")
			cutscene:showNametag("Jamm")
			cutscene:text("* You think I could tag along,[wait:5] then?", "side_smile", "jamm")
		elseif cutscene:getCharacter("susie") then
			cutscene:showNametag("Susie")
			cutscene:text("* Yeah,[wait:5] we're trying to seal the fountains.", "neutral", "susie")
			cutscene:showNametag("Jamm")
			cutscene:text("* You think I could tag along,[wait:5] then?", "side_smile", "jamm")
		else
			cutscene:text("* Because I think I could help you out.", "side_smile", "jamm")
		end
		
		cutscene:text("* My [color:yellow]DarkSling[color:white] spell can deal heavy damage to regular enemies...", "sling_ready", "jamm")
		cutscene:text("* Though,[wait:5] admittedly,[wait:5] it's weak against bosses.", "nervous_left", "jamm")
		cutscene:text("* Though,[wait:5] if violence is not your forte,[wait:5] I can still help.", "neutral", "jamm")
		cutscene:text("* My [color:yellow]HealSling[color:white] spell can heal enemies...", "neutral", "jamm")
		cutscene:text("* Which could make them more likely to accept our mercy!", "side_smile", "jamm")
		cutscene:text("* And my [color:yellow]Numbshot[color:white] spell can make enemies fall asleep.", "neutral", "jamm")
		cutscene:text("* So,[wait:5] what do you think?", "side_smile", "jamm")
		
		Game.world.music:stop()
		local party_jingle = Music("deltarune/charjoined")
        party_jingle:play()
        party_jingle.source:setLooping(false)
		cutscene:hideNametag()
		cutscene:text("* (Jamm joined the team!)")
		
		Game.world.music:play("jamm_apartment")
		cutscene:showNametag("Jamm")
		cutscene:text("* I have something I need to do real quick,[wait:5] first.", "neutral", "jamm")
		cutscene:text("* Call me from the party menu when you need me,[wait:5] okay?", "side_smile", "jamm")
		cutscene:hideNametag()
		Game:setFlag("jamm_waiting", nil)
		Game:setFlag("acj_quest_prog", 3)
		Game:unlockPartyMember("jamm")
		cutscene:attachFollowers()
		cutscene:wait(cutscene:attachCamera())
	end,
	
	breaker_box	= function(cutscene, event)
		cutscene:text("* It's a breaker box.[wait:10]\n* For some reason,[wait:5] it's locked.")
	end,
	
	balcony_door = function(cutscene, event)
		cutscene:text("* The door to the balcony seems stuck.")
		if cutscene:getCharacter("jamm") then
			cutscene:showNametag("Jamm")
			cutscene:text("* Yeah,[wait:5] sorry,[wait:5] I've been meaning to fix that...", "nervous", "jamm")
			cutscene:hideNametag()
		end
	end,
	
	stove = function(cutscene, event)
		cutscene:text("* It's a stove.[wait:10]\n* The quality on it is immaculate.")
	end,
	
	tv = function(cutscene, event)
		cutscene:text("* It's a small flatscreen TV.")
		if cutscene:getCharacter("jamm") then
			cutscene:showNametag("Jamm")
			cutscene:text("* It's a humble little thing,[wait:5] yeah...", "nervous", "jamm")
			cutscene:text("* Money's been tight when I bought this thing,[wait:5] but Marcy seems to like it.", "side_smile", "jamm")
			cutscene:hideNametag()
		end
	end,
	
	couch = function(cutscene, event)
		cutscene:text("* It's a small couch.\n* The cushons seem to be glued on.")
		if cutscene:getCharacter("jamm") then
			cutscene:showNametag("Jamm")
			cutscene:text("* ...Long story.", "nervous", "jamm")
			cutscene:hideNametag()
		end
	end,
	
	bathroom = function(cutscene, event)
		cutscene:text("* The door is locked.")
		if cutscene:getCharacter("jamm") then
			cutscene:showNametag("Jamm")
			cutscene:text("* ...Sorry,[wait:5] the bathroom is currently undergoing remodeling.", "neutral", "jamm")
			cutscene:hideNametag()
		end
	end,
	
	closet = function(cutscene, event)
		cutscene:text("* The door is locked.")
		if cutscene:getCharacter("jamm") then
			cutscene:showNametag("Jamm")
			cutscene:text("* ...No,[wait:5] you are not going to see my closet,[wait:5] okay?", "stern", "jamm")
			cutscene:hideNametag()
		end
	end,
	
	marcy_bed = function(cutscene, event)
	end,
	
	marcy_desk = function(cutscene, event)
	end,
	
	marcy_closet = function(cutscene, event)
	end,
	
	jamm_bed = function(cutscene, event)
	end,
	
	jamm_desk = function(cutscene, event)
	end,
	
	jamm_closet = function(cutscene, event)
	end,
}
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
	
	jamm = function(cutscene, event)
		local susie = cutscene:getCharacter("susie")
		local brenda = cutscene:getCharacter("brenda")
		local dess = cutscene:getCharacter("dess")
		
		cutscene:showNametag("Jamm")
		if Game:getFlag("dungeonkiller") then
			cutscene:text("* Oh,[wait:5] hey.", "neutral", "jamm")
		else
			cutscene:text("* Oh,[wait:5] hey,[wait:5] guys![wait:5] Nice seeing you again!", "smile", "jamm")
			cutscene:text("* I've just been keeping my daughter company, is all.", "smile", "jamm")
			cutscene:text("* Did you want to talk about something?", "smile", "jamm")
		end
		cutscene:hideNametag()
		
		local list = {"Wife", "Marcy", Game:getFlag("latest_jamm_adventure", "Forest")}
		local colors = {{1,1,1},{1,1,1},{1,1,1}}
		if Game:getFlag("jaruHasTalkedAboutAlexa") and not Game:getFlag("jammHasTalkedAboutAlexa") then
			list = {"Wife", "Marcy", Game:getFlag("latest_jamm_adventure", "Forest"), "Alexa"}
			colors = {{1,1,1},{1,1,1},{1,1,1},{1,1,0}}
		end
		
		local choice = cutscene:choicer(list, {color=colors})
		if choice == 1 then
			cutscene:showNametag("Jamm")
			cutscene:text("* You want to know about my wife?", "neutral", "jamm")
			cutscene:text("* Ania was an amazing woman,[wait:5] that's for sure.", "smile", "jamm")
			cutscene:text("* She was smart,[wait:5] helpful,[wait:5] caring...", "smile", "jamm")
			cutscene:text("* And honestly, we knew each other since we were children.", "smile", "jamm")
			cutscene:text("* Ania...[wait:5] was perfect.", "neutral", "jamm")
			cutscene:text("* I told Marcy about her death,[wait:5] and she knows it well.", "shaded_neutral", "jamm")
			cutscene:text("* She's just...[wait:5] still in denial.[wait:5] After all this time.", "shaded_neutral", "jamm")
		elseif choice == 2 then
			cutscene:showNametag("Jamm")
			cutscene:text("* Marcy is a great child.[wait:5] I couldn't ask for better.", "smile", "jamm")
			cutscene:text("* She's always been a curious child,[wait:5] and I love that.", "side_smile", "jamm")
			cutscene:text("* Unfortunately,[wait:5] she can be a little slow...", "look_left", "jamm")
			cutscene:text("* But that gives me all the more time to help,[wait:5] right?", "smile", "jamm")
			cutscene:text("* Marcy also always wanted to see the light,[wait:5] but...", "smile", "jamm")
			cutscene:text("* She has a condition that makes her ill when she's there.", "nervous", "jamm")
			cutscene:text("* I...[wait:5] guess it doesn't help that she was born in the dark.", "nervous_left", "jamm")
			cutscene:text("* Marcy hasn't given up hope,[wait:5] though,[wait:5] and I'm with her all the way!", "smug", "jamm")
		elseif choice == 3 then
			cutscene:showNametag("Jamm")
			if Game:getFlag("latest_jamm_adventure", "Forest") == "Forest" then
				cutscene:text("* So,[wait:5] the forest where you found me...", "neutral", "jamm")
				cutscene:text("* It's actually a place I hold dear to me.", "side_smile", "jamm")
				cutscene:text("* I've actually had so many memories there,[wait:5] honestly.", "smile", "jamm")
				cutscene:text("* Playing there as a kid,[wait:5] meeting Ania,[wait:5] adventures...", "happy", "jamm")
				cutscene:text("* And then there was...", "neutral", "jamm")
				cutscene:text("* ...", "nervous_left", "jamm")
				cutscene:text("* ...Let's not talk about that.", "nervous", "jamm")
			end
		else
			if list[4] == "Alexa" then
				cutscene:showNametag("Jamm")
				cutscene:text("* Huh?[wait:5]\n* You want to know more about Alexa?", "neutral", "jamm")
				cutscene:text("* Where she came from?[wait:5]\n* Yeah, I can tell you.", "neutral", "jamm")
				cutscene:text("* It all started when I found this [color:yellow]time machine[color:white]...", "neutral", "jamm")
				cutscene:text("* Actually,[wait:5] it was more like a time-and-place machine.", "neutral", "jamm")
				cutscene:text("* I noticed there was already a destination set,[wait:5] so I pressed it.", "neutral", "jamm")
				cutscene:text("* Yes,[wait:5] I know![wait:5] It was irresponsible!", "nervous", "jamm")
				cutscene:text("* However,[wait:5] keep in mind this was before I married Ania,[wait:5] okay?", "nervous_left", "jamm")
				cutscene:text("* A-anyways,[wait:5] I ended up on this world called \"Europa\".", "look_left", "jamm")
				cutscene:text("* In this town called Frivatown,[wait:5] actually.", "neutral", "jamm")
				cutscene:text("* Alexa was one of the first people I met while I was there.", "look_left", "jamm")
				cutscene:text("* I stayed on Europa for a few days,[wait:5] trading stories and such...", "side_smile", "jamm")
				cutscene:text("* I even went to the 158th Frivatown festival.", "smile", "jamm")
				cutscene:text("* Alexa and a few of her friends became curious about the Dark...", "neutral", "jamm")
				cutscene:text("* So,[wait:5] I brought them back. Let them do what they wanted to.", "side_smile", "jamm")
				cutscene:showNametag("J.A.R.U.")
				cutscene:text("* And so I gave Alexa that job,[wait:5] right?", "default", "shadowsalesman")
				cutscene:showNametag("Jamm")
				cutscene:text("* Well,[wait:5] yeah,[wait:5] it was right about that time.", "neutral", "jamm")
				cutscene:text("* Let me guess;[wait:5] we butt dialed you?", "stern", "jamm")
				cutscene:showNametag("J.A.R.U.")
				cutscene:text("* Yeah,[wait:5] but your story does put things into perspective.", "eye_closed", "shadowsalesman")
				cutscene:text("* However, let me ask;[wait:5] why are they still here?", "default", "shadowsalesman")
				cutscene:text("* Why didn't you bring them back using your time machine?", "default", "shadowsalesman")
				cutscene:showNametag("Jamm")
				cutscene:text("* I intended to,[wait:5] J.A.R.U.", "nervous", "jamm")
				cutscene:text("* However,[wait:5] the time machine broke when I used it the second time,[wait:5] so...", "neutral", "jamm")
				cutscene:text("* They became stuck,[wait:5] you know?", "worried", "jamm")
				cutscene:showNametag("J.A.R.U.")
				cutscene:text("* Right,[wait:5] that makes sense.", "oh", "shadowsalesman")
				cutscene:hideNametag()
				cutscene:text("* (Click.)")
				Game:setFlag("jammHasTalkedAboutAlexa", true)
			end
		end
    end,
}
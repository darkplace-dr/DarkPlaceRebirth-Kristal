return {
	---@param cutscene WorldCutscene
	mranttenna = function(cutscene)
		if Game:getFlag("can_kill") then
			return
		end
		local susie = cutscene:getCharacter("susie")
		local tenna = cutscene:getCharacter("tenna")

		if not Game:getFlag("tenna_introduction") then
			Game:setFlag("tenna_introduction", true)
			if susie then
				tenna.sprite:setPreset(1)
				cutscene:showNametag("Tenna")
				cutscene:text("* Well,[wait:5] if it isn't my FAVORITE contestant!", nil, "tenna")
				cutscene:showNametag("Susie")
				cutscene:text("* Tenna?[wait:10]\n* The hell are you doing here?", "surprise", "susie")
				cutscene:showNametag("Tenna")
				cutscene:text("* Haha,[wait:5] I have no idea how I got here!", nil, "tenna")
				tenna.sprite:setPreset(2)
				cutscene:text("* But hey,[wait:5] I thought while I was in this tower...", nil, "tenna")
				tenna.sprite:setPreset(4)
				cutscene:text("* I'd set up my own floor!", nil, "tenna")
				tenna.sprite:setPreset(1)
				cutscene:text("* Anyways...", nil, "tenna")
			end
			tenna.sprite:setPreset(2)
			cutscene:showNametag("Tenna")
			cutscene:text("* Welcome to the Tenna Room!", nil, "tenna") -- TODO: "Tenna Room" should be a funnytext
			cutscene:text("* It's a family reunion,[wait:5] I've sent an invite to every single one of my relatives!", nil, "tenna")
			tenna.sprite:setPreset(1)
			cutscene:text("* Granted,[wait:5] I just did that,[wait:5] so it's just me, myself, and I here.", nil, "tenna")
			tenna.sprite:setPreset(21)
			cutscene:showNametag("Mr. \"Ant\" Tenna")
			cutscene:text("* For the sake of clarity,[wait:5] you can just call me Mr. \"Ant\" Tenna!", nil, "tenna") -- TODO: "Mr. "Ant" Tenna" should also be a funnytext
			tenna.sprite:setPreset(69)
			cutscene:text("* Now,[wait:5] uh,[wait:5] just a forewarning...", nil, "tenna")
			tenna.sprite:setPreset(-3)
			cutscene:text("* Some of my relatives may have a...[wait:10] criminal record,[wait:5] shall we say?", nil, "tenna")
			tenna.sprite:setPreset(4)
			cutscene:text("* But HEY![wait:10] Family is family![wait:10] Who am I to judge.", nil, "tenna")
			tenna.sprite:setPreset(1)
			cutscene:text("* Anyways...", nil, "tenna")
		end
		tenna.sprite:setPreset(2)
		cutscene:showNametag("Mr. \"Ant\" Tenna")
		cutscene:text("* What did you need from your good ol' pal?", nil, "tenna")
		cutscene:hideNametag()
		local choicer = {"Why are\nyou 3D?", "Nothing"}
		if Game:getFlag("arlee_quest") then
			table.insert(choicer, "Starbits?")
		end
		if Game:getFlag("tenna_physicalchallenge") then
			table.insert(choicer, "Physical Challenge")
		end
		local choice = cutscene:choicer(choicer)
		cutscene:showNametag("Mr. \"Ant\" Tenna")
		if choice == 1 then
			tenna.sprite:setPreset(35)
			cutscene:text("* What?[wait:10] Why do I look 3D?", nil, "tenna")
			tenna.sprite:setPreset(-3)
			Game.world.music:pause()
			cutscene:text("* ...", nil, "tenna")
			tenna.sprite:setPreset(1)
			Game.world.music:resume()
			cutscene:text("* Kid,[wait:5] did you hit your head or something?", nil, "tenna")
			tenna.sprite:setPreset(4)
			cutscene:text("* You're 3D,[wait:5] I'm 3D,[wait:5] this whole room is 3D!", nil, "tenna")
			tenna.sprite:setPreset(1)
			cutscene:text("* What,[wait:5] you think we're in some sorta video game or something?", nil, "tenna")
			cutscene:text("* And I'm rendered in a different artstyle from everything else?", nil, "tenna")
			tenna.sprite:setPreset(35)
			cutscene:text("* Hahaha![wait:10] That's the funniest thing I've heard all day!", nil, "tenna")
		elseif choice == 2 then
			tenna.sprite:setPreset(3)
			cutscene:text("* Well,[wait:5] give me a holler if you need me.", nil, "tenna")
		elseif choice == 3 then
			if not Game:getFlag("tenna_physicalchallenge") then
				tenna.sprite:setPreset(-3)
				cutscene:text("* Huh?[wait:10] Have I seen any starbits lying around?", nil, "tenna")
				tenna.sprite:setPreset(1)
				cutscene:text("* Well,[wait:5] as a matter of fact, I have!", nil, "tenna")
				tenna.sprite:setPreset(69)
				cutscene:text("* But don't think I'm just gonna give it to you for free.", nil, "tenna")
				tenna.sprite:setPreset(17)
				cutscene:text("* In order to win this Grand Prize...", nil, "tenna") -- TODO: "Grand Prize" should be a funnytext
				tenna.sprite:setPreset(21)
				cutscene:text("* You need to win a\n[funnytext:physical_challenge/physical_challenge,ftext_bounce,0,-10,195,34]!", nil, "tenna")
				tenna.sprite:setPreset(1)
				cutscene:text("* The rules are simple:", nil, "tenna")
				tenna.sprite:setPreset(24)
				cutscene:text("* Throughout this tower,[wait:5] there are 8 stickers featuring yours truly that you must collect.", nil, "tenna")
				tenna.sprite:setPreset(21)
				cutscene:text("* Bring them all to me,[wait:5] and you'll win the starbit!", nil, "tenna")
				tenna.sprite:setPreset(3)
				cutscene:text("* Now,[wait:5] are you ready?[wait:10] Because...", nil, "tenna")
				tenna.sprite:setPreset(21)
				Game.world.music:pause()
				cutscene:itsTVTime()
				Game.world.music:resume()
				Game:setFlag("tenna_physicalchallenge", true)
				Game:setFlag("challenge_stickers", 0)
			else
				tenna.sprite:setPreset(4)
				cutscene:text("* You gotta beat that\n[funnytext:physical_challenge/physical_challenge,ftext_bounce,0,-10,195,34]\nbefore you get that starbit!", nil, "tenna")
			end
		elseif choice == 4 then
			local stickers = Game:getFlag("challenge_stickers")
			tenna.sprite:setPreset(-3)
			cutscene:text("* Let's see how many stickers you have...", nil, "tenna")
			tenna.sprite:setPreset(69)
			cutscene:text("* It seems you have "..stickers.." out of 8 stickers!", nil, "tenna")
			if stickers == 0 then
				tenna.sprite:setPreset(4)
				cutscene:text("* Wow,[wait:5] you haven't collected a single sticker!", nil, "tenna")
				tenna.sprite:setPreset(17)
				cutscene:text("* Remember,[wait:5] the stickers look like me,[wait:5] you can't miss 'em.", nil, "tenna")
			end
		end
		tenna.sprite:setPreset(24)
		cutscene:hideNametag()
	end,
}

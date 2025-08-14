return {
	bed = function(cutscene, event)
		cutscene:text("* (A nice,[wait:5] comfy bed for one person.)")
	end,

	nightstand = function(cutscene, event)
		cutscene:text("* (You open the nightstand.)")
		cutscene:text("* (Inside is the hairbrush,[wait:5] rope ribbons,[wait:5] hair scrunchies,[wait:5] and a sleeping mask.)")
	end,

	table = function(cutscene, event)
		cutscene:text("* (On the table stands a lonely plant,[wait:5] a plate,[wait:5] and a candle.)")
		cutscene:text("* (In the window you can see a sunset in the desert-like area.)")
	end,

	fridge = function(cutscene, event)
		cutscene:text("* (The fridge contains some general food and drinks inside it.)")
		cutscene:text("* (On the top you can see some bottles.)")
		cutscene:text("* (Even if you really wanted to,[wait:5] they're too high to reach.)")
	end,

	dresser = function(cutscene, event)
		cutscene:text("* (You open the dresser and see many neatly folded clothes.)\n* (Including a lot of robes.)")
		cutscene:text("* (Above the dresser is a neat flower art and some framed pictures.)")
	end,

	thoughts = function(cutscene, event)
		local ceroba = Game.world:getCharacter("ceroba_dw")
		ceroba:facePlayer()
		cutscene:text("* Yes?", "neutral", "ceroba")
		local topic = cutscene:choicer({"Room", "Thoughts", "Advice", "Nothing"})
		if topic == 1 then
			cutscene:text("* This room,[wait:5] huh...?", "closed_eyes", "ceroba")
			cutscene:text("* Well,[wait:5] it's nice.[wait:5] Reminds me of my house back in the Dunes.", "smile", "ceroba")
			cutscene:text("* Even the view from the window is somewhat...", "smile_alt", "ceroba")
			cutscene:text("* Wait,[wait:5] how is that view possible?[wait:5] Is there a desert here?", "surprised", "ceroba")
			cutscene:text("* Ah...[wait:5] I suppose that is just the Dark World magic or something.", "neutral", "ceroba")
			cutscene:text("* Anyways,[wait:5] I like it in here.", "smile", "ceroba")
			cutscene:text("* Maybe I can even take a nap sometime soon...", "snarky", "ceroba")
		elseif topic == 2 then
			local thoughts = love.math.random(1, 3)
			if thoughts == 1 then -- gotta add more
				cutscene:text("* Dark World are...[wait:5] Peculiar.", "alt", "ceroba")
				cutscene:text("* My magic works much easier here,[wait:5] and...", "closed_eyes", "ceroba")
				cutscene:text("* This new outfit...[wait:5] Dark Fountains...[wait:5] The Prophecy...", "neutral", "ceroba")
				cutscene:text("* ...[wait:5] the Knight.[wait:5] The Roaring.[wait:5] The world instability.", "dissapproving", "ceroba")
				cutscene:text("* It truly feels like a different world.", "alt", "ceroba")
			elseif thoughts == 2 then
				cutscene:text("* I wonder how Kanako is...", "alt", "ceroba")
				cutscene:text("* Can't even call her from here,[wait:5] since my phone...", "dissapproving", "ceroba")
				cutscene:text("* Well,[wait:5] doesn't exactly work in this world.", "muttering", "ceroba")
				cutscene:text("* But I'm sure she's having fun with Star right now...", "smile", "ceroba")
				cutscene:text("* Hope they don't go making her learn how to shoot or anything.", "suspicious", "ceroba")
			elseif thoughts == 3 then
				cutscene:text("* I just remembered a funny joke.", "grin", "ceroba")
				cutscene:text("* \"What's the best way to catch a squirrel?\"", "happy", "ceroba")
				cutscene:text("* ...", "happy", "ceroba")
				cutscene:text("* \"Act like a nut.\"", "grin", "ceroba")
				cutscene:wait(1.5)
				cutscene:text("* What?[wait:5] Not funny?", "nervous_smile", "ceroba")
			end
		elseif topic == 3 then
			local advices = { -- gotta add more of these too
				"Think before you do.",
				"Don't forget to brush your teeth.",
				"Don't take everything too personally.",
				"Don't forget to eat your greens.",
				"Learn to let go.",
				"Learn to be patient.",
				"Don't forget to take a break every once in a while.",
			}
			cutscene:text("* You want an advice?", "neutral", "ceroba")
			cutscene:text("* Let me think...", "closed_eyes", "ceroba")
			cutscene:wait(1.5)
			cutscene:text("* Ah,[wait:5] here's one.", "closed_eyes", "ceroba")
			local advice = Utils.pick(advices)
			cutscene:text("* \""..advice.."\"", "neutral", "ceroba")
		else
			cutscene:text("* Alright then.", "closed_eyes", "ceroba")
		end
		ceroba:setFacing("up")
	end,
}

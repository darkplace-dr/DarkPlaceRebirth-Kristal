return {
    ---@param cutscene WorldCutscene
    door = function(cutscene, event, player)
        cutscene:text("* (It's locked.)")
        if Game:hasPartyMember("noelle") then
            cutscene:text("* (...[wait:5] why are we trying to open my parents' room?)", "what_smile_b", "noelle")
        end
    end,

    dess_blocker = function(cutscene, event, player)
        cutscene:text("* Umm,[wait:5] sorry...[wait:5] guests aren't allowed in there.", "smile_side", "noelle")
        cutscene:text("* Especially after what happened last time...", "what_smile", "noelle")
    end,
	
    noelle_computer = function(cutscene, event, player)
        local name = Game.world.player.actor.name
		local wallpaper =  {"Noelle's family in the snow.",
							"Noelle's family looking festive.",
							"Noelle's family edited to be elves.",
							"a motion-blurred photo of a human child.",
							"Dess holding a cracked baseball bat.",
							"a picture of a far-off, snowy city.",
							"Noelle and Dess at the pageant as kids.",
							"some green dog puppet thing."}
		cutscene:text("* (It's Noelle's computer. The cycling wallpaper is...)")
		if name == "Kris" then
			wallpaper[4] = "a motion-blurred photo of you as a kid."
		end
		cutscene:text("* (...[wait:5] "..Utils.pick(wallpaper)..")")
    end,
	
    noelle_plant = function(cutscene, event, player)
        local name = Game.world.player.actor.name
		if name == "Kris" then
			cutscene:text("* (It's a Christmas cactus.)\n* (You remember it's named 'Krismas.')")
		else
			cutscene:text("* (It's a Christmas cactus.)\n* (You don't know the name of it.)")
		end
    end,
	
    noelle_closet = function(cutscene, event, player)
        local name = Game.world.player.actor.name
        if name == "Kris" then
			cutscene:text("* (A great hiding place,[wait:5] although it smells like detergent and deer.)")
		else
			cutscene:text("* (A clothes wardrobe. A pair of small angel wings are inside...[wait:5] worn out and tattered.)")
		end
    end,
	
    dess_box = function(cutscene, event, player)
        local name = Game.world.player.actor.name
        cutscene:text("* It's a box of odds-and-ends. Dig through?")
		local choice = cutscene:choicer({"Dig through", "Don't dig through"})
        if choice == 1 then
			cutscene:text("* You dug through the box and found...")
			cutscene:text("* A couple of burnt lighters,[wait:5] rusted multitool knives,[wait:5] expired rations,[wait:5]")
			cutscene:text("* Walkie talkies,[wait:5] loose binoculars,[wait:5] a pair of shoes fit for hooves,[wait:5]")
			cutscene:text("* Violent comic books,[wait:5] paintballs,[wait:5] a cracked hockey mask,[wait:5] frayed yarn and buttons,[wait:5]")
			if name == "Kris" then			
				cutscene:text("* Your brother's retainer,[wait:5] and old mint cans with unique leaves inside of them.")
			else
				cutscene:text("* A used retainer,[wait:5] and old mint cans with unique leaves inside of them.")
			end
		else
			cutscene:text("* There's a lot.")
		end
    end,
	
    dess_shelf = function(cutscene, event, player)
        local name = Game.world.player.actor.name
        if name == "Kris" then
			cutscene:text("* (It's a shelf. In the front are all the holiday-themed games and movies...)")
			cutscene:text("* (...[wait:5] and at the back are all the scary games you never got to play.)")
		else
			cutscene:text("* (It's a shelf packed with tons of games and movies.)")
		end
    end,
}

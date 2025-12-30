return {
	world = function(cutscene)
		local x, y = Game.world:getCharacter(GeneralUtils.getLeader("chara").id):getPosition()

		local wait = cutscene:alertParty(1)
		cutscene:text("* Everyone! Place yourself.")
		cutscene:wait(wait)

		cutscene:detachFollowers()
		cutscene:wait(cutscene:walkPartyTo(function(chara, i)
			print("Moving "..cutscene:getPartyCharacterAtIndex(i))
			local id = Game:getPartyMember(chara.party).id
			return 120+50*(i-1), SCREEN_HEIGHT/2, id == "dess" and 10 or i, "down"
		end))

		cutscene:text("* Looook to the left!")
		cutscene:partyLook("left")

		cutscene:wait(1)

		cutscene:text("* Looook to the right!")
		cutscene:partyLook("right")

		cutscene:wait(1)

		cutscene:text("* Something to say?")

		cutscene:textVariant("* Nah.", {
			hero = "smug_b",
			susie = "smile",
			dess = "condescending",
			ceroba = "wat",
			jamm = "troll"
		})

		cutscene:text("* Same thing but with priority.")

		cutscene:textVariant("* Yah.", {
			hero = "smug_b",
			susie = "smile",
			dess = "condescending",
			ceroba = "wat",
			jamm = "troll"
		}, {priority={ -- <-- order of piority
			"hero", "susie", "ceroba", "jamm", "dess"
		}})

		cutscene:text("* Now slide.")

		cutscene:wait(cutscene:slidePartyTo(function(chara, i)
			return chara.x, chara.y+30*i, i
		end))

		cutscene:spinParty(3)
		cutscene:text("spiiiiiin")

		cutscene:spinParty(0)
		cutscene:text("* no spin. Full stop.")

		cutscene:text("* Head call!")

		local hero = cutscene:textIfExists("* Hero's here.", "happy", "hero")
		local susie = cutscene:textIfExists("* Susie's here.", "closed_grin", "susie")
		local dess = cutscene:textIfExists("* Dess's here.", "swag", "dess")
		local ceroba = cutscene:textIfExists("* Ceroba's here.", "smile_1", "ceroba")
		local jamm = cutscene:textIfExists("* Jamm's here.", "happy", "jamm")
		local noel = cutscene:textIfExists("* Noel's here.", "bruh", "noel")
		local noelle = cutscene:textIfExists("* Noelle's here.", "smile_closed", "noelle")
		local kris = cutscene:textIfExists("* (...)", nil, "kris")
		print(hero, susie, dess, ceroba, jamm)

		cutscene:runIf(not hero, function(cutscene) cutscene:text("* No Hero.") end)
		cutscene:runIf(not susie, function(cutscene) cutscene:text("* No Susie") end)
		cutscene:runIf(not dess, function(cutscene) cutscene:text("* No Dess") end)
		cutscene:runIf(not ceroba, function(cutscene) cutscene:text("* No Ceroba") end)
		cutscene:runIf(not jamm, function(cutscene) cutscene:text("* No Jamm") end)
		cutscene:runIf(not noel, function(cutscene) cutscene:text("* No Noel") end)
		cutscene:runIf(not noelle, function(cutscene) cutscene:text("* No Noelle") end)
		cutscene:runIf(not kris, function(cutscene) cutscene:text("* No Kris") end)

		cutscene:text("* Special test: textIfExists with wait to false")

		local ran, wait, textbox = cutscene:textIfExists("* Yep.", "happy", "hero", {wait=false})
		print("BETWEEN WAIT AAAAAAAAA", ran, wait, textbox)
		Assets.playSound("noise")
		Game.world.camera:shake()
		cutscene:wait(wait)

		cutscene:text("* Last check: only runs if Dess exists.")

		cutscene:runIfExists("dess", function(cutscene, dess)
			cutscene:text("* What's up losers?", "genuine", dess)
			cutscene:text("* Today I'm blowing myself up.", "condescending", dess)
			cutscene:text("* Promo code: reving my wife 2nite", "swag", dess)

			Game:removePartyMember("dess")
			cutscene:wait(cutscene:explode(dess))
		end)

		cutscene:text("* Okay nice. Thanks.")

		cutscene:wait(cutscene:attachFollowers())
		cutscene:wait(cutscene:walkTo(cutscene:getPartyCharacterAtIndex(1), x, y))
	end,
	battle = function(cutscene)

	end
}
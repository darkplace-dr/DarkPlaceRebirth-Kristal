return {
    kill = function(cutscene, battler, enemy)
		if Game:getFlag("dessQuoteUnquoteSpares", 0) == 0 then
			cutscene:text("* Alright,[wait:10] you fuckin' uhhh ready for this?", "neutral", "dess")
			cutscene:text("* Okay here we go", "calm", "dess")
		elseif Game:getFlag("dessQuoteUnquoteSpares", 0) == 1 then
			cutscene:text("* No no trust me I'll spare them this time.", "neutral", "dess")
		elseif Game:getFlag("dessQuoteUnquoteSpares", 0) == 2 then
			cutscene:text("* Okay so MAYBE we got off on the wrong foot...", "neutral_b", "dess")
			cutscene:text("* (if you're a filthy pacifist runner)", "condescending", "dess")
			cutscene:text("* But no trust me I'll be nice this time.", "genuine", "dess")
		elseif Game:getFlag("dessQuoteUnquoteSpares", 0) == 3 then
			cutscene:text("* alright,[wait:6] same shit different asshole.", "condescending", "dess")
		elseif Game:getFlag("dessQuoteUnquoteSpares", 0) == 4 then
			cutscene:text("* Again?", "reverse", "dess")
		else
			cutscene:text("* Teehee.", "teehee", "dess")
		end
		Game:addFlag("dessQuoteUnquoteSpares", 1, 0)

		cutscene:wait(2)
		enemy:defeat("KILLED", true)
		enemy:explode(0, 0, false)
		cutscene:wait(2)
    end,
    noel = function(cutscene, battler, enemy)
	if not Game:getFlag("noel_ufo_action") then
		Game:setFlag("noel_ufo_action", true)
		cutscene:text("* Alright,[wait:10] here we go.\n[wait:10][face:huh]* I guess?", "neutral", "noel")

		cutscene:wait(1)
		enemy:addFX(ShaderFX("glitch_transparent", {
            		["iTime"] = function() return Kristal.getTime() end
       		}))

		battler:setSprite("walk/down")
		Assets.playSound("dtrans_square", 1, 0.5)
                enemy:shake()
		cutscene:wait(0.25)
		battler:setSprite("walk/right")
		Assets.playSound("dtrans_square", 1, 1)
                enemy:shake()
		cutscene:wait(0.25)
		battler:setSprite("walk/up")
		Assets.playSound("dtrans_square", 1, 1.5)
                enemy:shake()
		cutscene:wait(0.125)
		battler:setSprite("walk/left")
		Assets.playSound("dtrans_square", 1, 2)
                enemy:shake()
		cutscene:wait(0.125)
		battler:setSprite("walk/down")
		Assets.playSound("dtrans_square", 1, 2.5)
                enemy:shake()
		cutscene:wait(0.25)
		battler:setSprite("walk/right")
		Assets.playSound("dtrans_square", 1, 3)
                enemy:shake()
		enemy:spare()
		cutscene:wait(2)
		battler:resetSprite()

		cutscene:text("* I'm not gonna do that again so you better hope it was worth it "..Game.party[1].name..".", "...", "noel")


		cutscene:text("* Noel [color:green]forcefully[color:reset] spared the UFO OF DOOM?")
        else
		cutscene:text("* No.", "bruh", "noel")
	end
    end,
}
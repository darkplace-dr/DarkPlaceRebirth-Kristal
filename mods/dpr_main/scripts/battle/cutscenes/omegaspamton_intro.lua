return {
    omegaspamton_intro = function(cutscene, battler, enemy)
        local omega = cutscene:getEnemies("omega_spamton")[1]
		
		
		--Game.battle:setState("INTRO")
		cutscene:wait(0.5)
		
		for i,battler in ipairs(Game.battle.party) do
			battler:setAnimation("battle/idle")
		end
		
		cutscene:wait(1)
		
		Game.battle:shakeCamera(2, 2, 0)
        local src = Assets.playSound("rumble")
        src:setLooping(true)
        src:setVolume(0.75)
		
        local intro_music = Music()
		intro_music:play("omega_spamton_intro")
		intro_music.source:setLooping(false)

		cutscene:wait(6.5)
		
		cutscene:moveTo(omega, 770, 720, 2)
		
		cutscene:wait(function() return omega.y == 720 end)

		Assets.playSound("screenshake")
        Game.battle:shakeCamera(0)
        src:stop()
		omega.sprite.partshadow = false
		cutscene:wait(2)
		
        intro_music:remove()
		
		omega:setAnimation("laugh")
		cutscene:wait(5)
		omega:setAnimation("static")
		cutscene:wait(1)
		
		cutscene:after(function() 
		    Game.battle:setState("ACTIONSELECT")
            omega:setAnimation("idle")
            Game.battle.music:play("omega_spamton.loop")
        end, true)
    end,
	omegaspamton_outro = function(cutscene, battler, enemy)
        --WIP
    end,
	omegaspamton_outro_alt = function(cutscene, battler, enemy)
        --WIP
    end,
}

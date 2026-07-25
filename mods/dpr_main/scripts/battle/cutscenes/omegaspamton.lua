return {
    intro = function(cutscene, battler, enemy)
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

        Game.battle.music:play("omega_spamton_intro", 1)
		Game.battle.music:setLooping(false)

		cutscene:wait(6.5)

		cutscene:moveTo(omega, 770, 720, 2)

		cutscene:wait(function() return omega.y == 720 end)

		Assets.playSound("screenshake")
        Game.battle:shakeCamera(0)
        src:stop()
		omega.sprite.partshadow = false
		cutscene:wait(2)

		omega:setAnimation("laugh")
		cutscene:wait(5)
		omega:setAnimation("static")
		cutscene:wait(1)

		cutscene:after(function()
		    Game.battle:setState("ACTIONSELECT")
            omega:setAnimation("idle")
            Game.battle.music:play("omega_spamton_loop")
			Game.battle.music:setLooping(true)
        end, true)
    end,
	outro = function(cutscene, battler, enemy)
		cutscene:wait(2)

		local susie = Game.battle:getPartyBattler("susie")
		if susie.chara.health <= 0 then
			susie:heal(math.abs(susie.chara.health) + 1)
		end
		susie:toggleOverlay(false)
		susie:setAnimation("battle/idle")
		cutscene:battlerText(susie, "Did...[wait:5] Did\nwe do it...?", { right = true, x = susie.x + 36, y = susie.y - 49 })

		cutscene:wait(1)

		Assets.playSound("closet_fall", 1, 0.9)
		Game.battle.enemies[1].physics.gravity = 1

		cutscene:wait(4)

		Assets.playSound("closet_impact", 1, 0.5)

		cutscene:wait(3)

        cutscene:after(function()
			Game.battle.enemies[1]:defeat("SPARED", false)
		    Game.battle:setState("VICTORY")
        end, true)
    end,
	outro_alt = function(cutscene, battler, enemy)
        cutscene:wait(2)

		local susie = Game.battle:getPartyBattler("susie")
		if susie.chara.health <= 0 then
			susie:heal(math.abs(susie.chara.health) + 1)
		end
		susie:toggleOverlay(false)
		susie:setAnimation("battle/idle")
		cutscene:battlerText(susie, "Did...[wait:5] Did\nwe do it...?", { right = true, x = susie.x + 36, y = susie.y - 49 })

		cutscene:wait(1)

		Assets.playSound("explosion", 1, 0.9)
		cutscene:fadeOut(1, { color = { 1, 1, 1 } })

		cutscene:wait(3)
		Game.battle.enemies[1].visible = false

		cutscene:fadeIn(1, { color = { 1, 1, 1 } })

		cutscene:wait(2)

        cutscene:after(function()
			Game.battle.enemies[1]:defeat("KILLED", true)
		    Game.battle:setState("VICTORY")
        end, true)
    end,
}

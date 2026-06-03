return function(cutscene)
    local whirlwind = WingladeWhirlwind(120, 0)
    Game.battle:addChild(whirlwind)

    local cutscene_ended = false

	for k,v in ipairs(Game.battle.party) do
		v.sprite.anim_speed = 0
    end

    Game.battle.timer:during(1, function()
		for k,v in ipairs(Game.battle.party) do
			v.sprite.anim_speed = v.sprite.anim_speed + DT
        end
    end, function()
		for k,v in ipairs(Game.battle.party) do
			v.sprite.anim_speed = 1
        end
    end)

    Game.battle.timer:after(1 + 50/30, function()
        Game.battle.timer:during(1, function()
			for k,v in ipairs(Game.battle.party) do
				v.sprite.anim_speed = v.sprite.anim_speed - DT
			end
        end, function()
            if not cutscene_ended then
				for k,v in ipairs(Game.battle.party) do
					v.sprite.anim_speed = 0
				end
            end
        end)
    end)

    cutscene:wait(cutscene:text("* Everyone spun masterfully!\n* It's a whirlwind...!"))
    cutscene:wait(whirlwind:getEndCallback())

    cutscene_ended = true

    for k,v in ipairs(Game.battle.party) do
		v.sprite.anim_speed = 1
    end

    for _, enemy in ipairs(Game.battle.enemies) do
        enemy:spare()
    end
end
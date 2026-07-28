---@type table<string,fun(cutscene:WorldCutscene, event?: Event|NPC)>
local cyber = {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `WorldCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene WorldCutscene
    

    enemyencounter = function(cutscene, event)
		local dess = cutscene:getCharacter("dess")
		local jamm = cutscene:getCharacter("jamm")
		local susie = cutscene:getCharacter("susie")
		local hero = cutscene:getCharacter("hero")
		local party1 = Game.world:getCharacter(Game.party[1].actor.id)
		local party2 = Game.world:getCharacter(Game.party[2].actor.id)
		local party3 = Game.world:getCharacter(Game.party[3].actor.id)
		local party4 = Game.world:getCharacter(Game.party[4].actor.id)
		cutscene:walkTo(party1, 360, 570, 0.75, "up")
		if #Game.party >= 2 then
		cutscene:walkTo(party2, 330, 555, 0.75, "up")
		end
		if #Game.party >= 3 then
		cutscene:walkTo(party3, 390, 555, 0.75, "up")
		end
		if #Game.party >= 4 then
		cutscene:walkTo(party4, 360, 540, 0.75, "up")
		end
        local player = Game.world.player
        local boss = NPC("chloropurr", player.x-900, player.y)
        boss.layer = player.layer + 0.1
        Game.world:addChild(boss)
        cutscene:wait(1)
		if dess == 1 then
        cutscene:setSpeaker(dess)
        cutscene:text("* Lmao this place is sick.")
		cutscene:text("* Very cool house.")
		else
			cutscene:setSpeaker(susie)
			cutscene:text("* Woah. This place seems...")
			if jamm == 1 then
				cutscene:setSpeaker(jamm)
				cutscene:text("* Interesting?")
				cutscene:setSpeaker(hero)
				cutscene:text("* I guess you could say that...")
			else
				cutscene:setSpeaker(hero)
				cutscene:text("* Run down?")
			end
			cutscene:setSpeaker(susie)
			cutscene:text("* Yeah, and creepy.")
			cutscene:text("* I don't think we're gonna be finding any friends down here.")
			cutscene:setSpeaker(hero)
			cutscene:text("* Me neither.")
		end
		cutscene:wait(1)
		boss:setAnimation({"creepwalk"})
        Game.world.music:play("deltarune/shinkansen")
        Game.world.music:fade(1, 0.9)
        Game.world.timer:tween(1, boss, {x = player.x+660}, "out-cubic")
		if susie == 1 then
		susie:setSprite("shock_down")
		end
		cutscene:wait(1)
		if dess == 1  then
			cutscene:text("* Damn.")
		else
		if jamm == 1 then
			cutscene:setSpeaker(jamm)
			cutscene:text("* Woah,[wait:3] hey,[wait:3] did you see that?")
			cutscene:setSpeaker(hero)
			cutscene:text("* See what?")
			cutscene:setSpeaker(susie)
			cutscene:text("* I- I heard it!")
		else
			cutscene:setSpeaker(susie)
			susie:setSprite("battle/attackready_1")
                    Assets.playSound("weaponpull_fast")
			cutscene:text("* Who- Who's there!")
			cutscene:setSpeaker(hero)
			cutscene:text("* ...Well that's not concerning at all.")
		end
        cutscene:wait(1)
		cutscene:setSpeaker(boss)
		boss:setAnimation({"walk"})
		Game.world.timer:tween(1, boss, {x = player.x+60}, "out-cubic")
		boss:setAnimation({"angry"})
		cutscene:text("* Begone!")
        cutscene:startEncounter("chloropurr", true, boss)
        Game.world.timer:tween(1, boss, {x = player.x+500}, "out-cubic")
        cutscene:wait(1)
        boss:remove()
	end
end,


}
return cyber

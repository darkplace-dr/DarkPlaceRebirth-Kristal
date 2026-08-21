---@type table<string,fun(cutscene:WorldCutscene, event?: Event|NPC)>
local cyber = {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `WorldCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene WorldCutscene
    

    enemyencounter = function(cutscene, event)
		cutscene:text("* The door here is faded, and missing a handle.")
		if Game:getFlag("encounter#dpr_main/chloropurr:done", false) == false then
			local susie = cutscene:getCharacter("susie")
			local hero = cutscene:getCharacter("hero")
			if hero then
				if susie then
					cutscene:setSpeaker(susie)
					cutscene:text("* Want to crawl through the hole?","smile")
					cutscene:setSpeaker(hero)
					cutscene:text("* yes.","neutral_closed")
				else
					cutscene:setSpeaker(hero)
					cutscene:text("* ...Ok, I REALLY need to know what's back there.","neutral_closed")
					cutscene:text("* "..Game.save_name..", Should we go through the hole? ","neutral_closed")
				end
			    local choicer = cutscene:choicer({
    			    "Yes",
     				"No",
				})
				if choicer == 2 then
					cutscene:setSpeaker(hero)
					if susie then
						cutscene:text("* ...We should prepare first, though.","neutral_closed")
					else
						cutscene:text("* ...Yeah, we should probably prepare first.","neutral_closed")
					end
				else
					cutscene:setSpeaker(nil)
					cutscene:text("* You crawl through the hole.")
					cutscene:mapTransition("floor2/jam/darkjamroom1chara1", "spawn")
					cutscene:wait(1)
					local dess = cutscene:getCharacter("dess")
					local jamm = cutscene:getCharacter("jamm")
					local susie = cutscene:getCharacter("susie")
					local hero = cutscene:getCharacter("hero")
					cutscene:detachFollowers()
					if #Game.party >= 1 then
						local party1 = Game.world:getCharacter(Game.party[1].actor.id)
						cutscene:walkTo(party1, 360, 240, 1.5, "up")
					end
					if #Game.party >= 2 then
						local party2 = Game.world:getCharacter(Game.party[2].actor.id)
						cutscene:walkTo(party2, 310, 275, 1.5, "up")
					end
					if #Game.party >= 3 then
						local party3 = Game.world:getCharacter(Game.party[3].actor.id)
						cutscene:walkTo(party3, 410, 275, 1.5, "up")
					end
					if #Game.party >= 4 then
						local party4 = Game.world:getCharacter(Game.party[4].actor.id)
						cutscene:walkTo(party4, 360, 300, 1.5, "up")
					end
    			    local player = Game.world.player
    			    local boss = NPC("chloropurr", player.x-500, 130)
    			    boss.layer = player.layer + 0.1
    			    Game.world:addChild(boss)
    			    cutscene:wait(1)
					if dess == 1 then
    				    cutscene:setSpeaker(dess)
    				    cutscene:text("* Lmao this place is sick.")
						cutscene:text("* Very cool house.")
					else
						if susie then
							cutscene:setSpeaker(susie)
							cutscene:text("* Woah. This place seems...","nervous_side")
							if jamm then
								cutscene:setSpeaker(jamm)
								cutscene:text("* Interesting?","neutral")
								cutscene:setSpeaker(hero)
								cutscene:text("* I guess you could say that...","nervous")
							else
								cutscene:setSpeaker(hero)
								cutscene:text("* Run down?","nervous")
							end
							cutscene:setSpeaker(susie)
							cutscene:text("* Yeah, and creepy.","nervous_side")
							cutscene:text("* I don't think we're gonna be finding any friends down here.","sus_nervous")
							cutscene:setSpeaker(hero)
							cutscene:text("* Me neither.","neutral_closed")
						else
							cutscene:setSpeaker(hero)
							cutscene:text("* ...I don't like this place.","nervous")
								if jamm then
									cutscene:setSpeaker(jamm)
									cutscene:text("* Me neither,[wait:3] it feels... Unnerving.","nervous_left")
								else
									cutscene:text("* I should... Probably leave?","nervous")
								end
							end
					cutscene:wait(1)
					boss:setAnimation("creepwalk",0.2,false)
    	    		Game.world.music:play("deltarune/shinkansen")
    	    		Game.world.music:fade(1, 0.9)
    	    		Game.world.timer:tween(4, boss, {x = player.x+410}, "out-cubic")
					cutscene:wait(1)
					if jamm then
						jamm:shake(4,0)
						jamm:setSprite("trip")
					end
					if #Game.party >= 1 then
						local party1 = Game.world:getCharacter(Game.party[1].actor.id)
						party1:setFacing("right")
						party1:shake(4,0)
					end
					if #Game.party >= 2 then
						local party2 = Game.world:getCharacter(Game.party[2].actor.id)
						party2:setFacing("right")
						party2:shake(4,0)
					end
					if #Game.party >= 3 then
						local party3 = Game.world:getCharacter(Game.party[3].actor.id)
						party3:setFacing("right")
						party3:shake(4,0)
					end
					if #Game.party >= 4 then
						local party4 = Game.world:getCharacter(Game.party[4].actor.id)
						party4:setFacing("right")
						party4:shake(4,0)
					end
					if susie then
						susie:shake(4,0)
						hero:shake(4,0)
						hero:setSprite("shock")
						susie:setSprite("shock_down")
					end
					cutscene:wait(2)
					if dess == 1  then
						cutscene:text("* Damn.")
					else
						if susie then
							if jamm then
								cutscene:setSpeaker(jamm)
								cutscene:text("* Woah,[wait:3] hey,[wait:3] did you see that?","nervous_left")
								cutscene:setSpeaker(hero)
								cutscene:text("* See what?","shocked")
								cutscene:setSpeaker(susie)
								cutscene:text("* I- I heard it!","surprise_frown")
							else
								cutscene:setSpeaker(susie)
								susie:setSprite("battle/attackready_1")
								susie:shake(4,0)
            	    			Assets.playSound("weaponpull_fast")
								cutscene:text("* Who- Who's there!","angry_unsure")
								cutscene:setSpeaker(hero)
								cutscene:text("* ...Well that's not concerning at all.","shocked")
							end
						else
							Assets.playSound("wing")
							hero:setSprite("shock")
							hero:shake(4,0)
							cutscene:text("* ...I heard that.","shocked")
						end
     	    			cutscene:wait(1)
						cutscene:setSpeaker(boss)
						boss:setAnimation("walk",0.1,true)
						Game.world.timer:tween(2, boss, {x = player.x+20}, "out-cubic")
						cutscene:wait(3)
						boss:setAnimation("angry",0.1,false)
						cutscene:text("* Begone!")
						cutscene:wait(1)
        				cutscene:startEncounter("chloropurr", true, boss)
						if susie then
						susie:resetSprite()
						end
						if hero then
							hero:resetSprite()
						end
						if jamm then
							jamm:resetSprite()
						end
						if Game:getFlag("encounter#dpr_main/chloropurr:violenced", false) == false then
							cutscene:wait(2)
							cutscene:text("* I will give you my strength.")
							Game.inventory:addItem("everyweapon")
							cutscene:text("* (You got the [color:yellow]Everyweapon[color:reset].)")
							cutscene:text("* ...Goodbye.")
							Game.world.timer:tween(5, boss, {x = player.x+500}, "in-cubic")
        					cutscene:wait(5)
        					boss:remove()
						else
							boss:remove()
							cutscene:wait(1)
							cutscene:text("* (...Felt something appear in your WEAPONS.)")
							Game.inventory:addItem("everyweapon")
						end
						cutscene:attachFollowers()
					end
				end
			end
		end
		else
			cutscene:text("* Crawl through the hole?")
	    	local choicer = cutscene:choicer({
      		  	"Yes",
      		 	"No",
			})
			if choicer == 1 then
				cutscene:text("* You crawl through the hole...")
				cutscene:text("* But then you crawl back out. It seems that part is still under construction.")
				--cutscene:mapTransition("floor2/jam/darkjamroom1chara1", "spawn")
			else
				cutscene:text("* You crawl on the lack of a handle instead. This achieves nothing.")
			end
		end
end,
enemynpc = function(cutscene, event)
	cutscene:text("* Go away.")
end

}
return cyber

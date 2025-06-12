return {
	greenroomplatter = function(cutscene)
		local platter = cutscene:getEvent("greenroom_platter")
		local flag = "tvfloor_greenroom_platterinteracts"
		local banana

		if platter.jumping then	return end
		if Game:getFlag(flag, 0) == 8 then
			banana = cutscene:spawnNPC("banana", 720, 436)
			banana.layer = platter.layer + 1
			platter:doBananaJump()
			if Game:getFlag(flag, 0) == 8 then
				Game.world.music:pause()
				cutscene:text("* (Oh)")
				if not Game.inventory:addItem("banana") then
					cutscene:text("* (But you did not have enough space.)")
					if banana then
						banana:remove()
					end
					cutscene:text("* (The banana is gone.)")
					Game:setFlag(flag, 0)
				else
					if banana then
						banana:remove()
					end
					Assets.playSound("item")
					cutscene:text("* (You got the Banana.)")
					Game:setFlag(flag, 9)
				end
				Game.world.music:resume()
			end
		else
			if Game:getFlag(flag, 0) ~= 9 then
				platter:doJump()
			end
			if Game:getFlag(flag, 0) <= 0 then
				cutscene:text("* (There is nothing inside of the platter...)")
				Game:setFlag(flag, 1)
			elseif Game:getFlag(flag, 0) == 1 then
				cutscene:text("* (There is still nothing inside of the platter.)")
				Game:setFlag(flag, 2)
			elseif Game:getFlag(flag, 0) == 2 then
				cutscene:text("* (The platter remains empty.)")
				Game:setFlag(flag, 3)
			elseif Game:getFlag(flag, 0) == 3 then
				cutscene:text("* (Nothing can be seen inside of the platter...)")
				Game:setFlag(flag, 4)
			elseif Game:getFlag(flag, 0) == 4 then
				cutscene:text("* (Despite your great efforts, there is still nothing in the platter.)")
				Game:setFlag(flag, 5)
			elseif Game:getFlag(flag, 0) == 5 then
				cutscene:text("* (No matter how hard you try, the platter will forever stay empty.)")
				Game:setFlag(flag, 6)
			elseif Game:getFlag(flag, 0) == 6 then
				cutscene:text("* (And empty it is.)")
				Game:setFlag(flag, 7)
			elseif Game:getFlag(flag, 0) == 7 then
				cutscene:text("* (stop it you motherfu[next]")
				cutscene:text("[instant]* (There is nothing inside of the platter.)")
				Game:setFlag(flag, 8)
			elseif Game:getFlag(flag, 0) == 9 then
				cutscene:text("* (There is nothing left on the platter tray.)")
			end
		end

	end,

	desshasfans = function(cutscene)
		if not Game:hasPartyMember("dess") or Game:getFlag("can_kill", false) then return end
		local dess = cutscene:getCharacter("dess")
		local crowd = cutscene:getEvents("teevie_cameras")[1]
		
		cutscene:detachCamera()
		cutscene:detachFollowers()
		cutscene:showNametag("Dess")
		cutscene:text("* Oh man, i have FANS???", "heckyeah", "dess")
		cutscene:text("* ALWAYS KNEW people liked me", "wink", "dess")
		cutscene:hideNametag()
		crowd.target_volume = 0
		crowd.sound_volume = 0
		crowd.dess_moment = 1
		crowd.cheer_crowd.dess_moment = 1
		Game.world.music:pause()
		Assets.stopSound("crowd_aah")
		Assets.stopSound("crowd_ooh")
		Assets.playSound("crowd_crickets")
		cutscene:wait(2)
		crowd:hideCrowdDess()
		cutscene:wait(1)
		cutscene:showNametag("Dess")
		cutscene:text("* .....", "neutral_b", "dess")
		cutscene:text("* im just THAT cool huh", "swag", "dess")
		cutscene:hideNametag()
		cutscene:walkTo(dess, 80*40, dess.y, 1.5)
		cutscene:wait(1.5)
		Game.world.music:resume()
		crowd.dess_moment = 0
		crowd.cheer_crowd.dess_moment = 0
		crowd:showCrowd()
		cutscene:attachCamera()
		for _,follower in ipairs(Game.world.followers) do
			if follower.actor.id ~= "dess" then
				follower.following = true
				follower:updateIndex()
				follower:moveToTarget()
			end
		end
	end,

}

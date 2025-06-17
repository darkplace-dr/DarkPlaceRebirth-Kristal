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

	sneakattack_zapper = function(cutscene, light)
		local heads = {}
		for _,head in ipairs(Game.world:getEvents("teevie_sneakhead")) do
			if head.x > Game.world.camera.x - (SCREEN_WIDTH/2) + 50 and head.x < Game.world.camera.x + (SCREEN_WIDTH/2) - 50 then
				if head.type == "zapper" then
					table.insert(heads, head)
				end
			end
		end
		if #heads <= 0 then
			if Game:getFlag("can_kill") then
				cutscene:text("* (But nobody came.)")
			else
				cutscene:text("* (You somehow remained undetected.)")
			end
		else
			local head = heads[love.math.random(1, #heads)]
			local guy = cutscene:spawnNPC("zapper", head.x + 64, head.y + 98)
			Assets.playSound("jump")
			guy:setSprite("jump")
			guy.physics.speed_y = -40
			guy.physics.gravity = 2
			guy.scale_x = -2
			local desxloc = Game.world.player.x-Game.world.player.width/2 - 48
			if head.x > Game.world.player.x-Game.world.player.width/2 + 17 then
				desxloc = Game.world.player.x-Game.world.player.width/2 + 90
				guy.scale_x = 2
				guy.x = guy.x - 92
			end
			local recolor = guy:addFX(RecolorFX())
			recolor.color = {0,0,0}
			guy:play(2/30, false)
			Game.world.timer:tween(8/30, recolor, {color = {1,1,1}}, "out-quad")
			Game.world.timer:tween(0.6, guy, {x = desxloc}, "out-quad")
			local groundpos = Game.world.player.y
			head:remove()
			cutscene:wait(function() return guy.y < groundpos end)
			cutscene:wait(function() return guy.y >= groundpos end)
			guy.y = groundpos
			guy:setSprite("jump_idle_1")
			Game.world.timer:after(4/30, function()
				guy:setSprite("jump_idle_2")
			end)
			guy.physics.gravity = 0
			guy.physics.speed_y = 0
			guy.layer = Game.world.player.layer
			Assets.playSound("wing")
			cutscene:showNametag("Zapper")
			cutscene:text("* What the -- you's ain't allowed in here!")
			cutscene:hideNametag()
			local change = TVTurnOff({map = Game.world.map.data.properties["punish_map"], marker = Game.world.map.data.properties["punish_marker"] or "entry_cage", facing = Game.world.map.data.properties["punish_facing"] or "down", flag = Game.world.map.data.properties["punish_flag"] or nil})
			Game.world:addChild(change)
		end
	end,
	sneakattack_shadowguy = function(cutscene, light)
		local heads = {}
		for _,head in ipairs(Game.world:getEvents("teevie_sneakhead")) do
			if head.x > Game.world.camera.x - (SCREEN_WIDTH/2) + 50 and head.x < Game.world.camera.x + (SCREEN_WIDTH/2) - 50 then
				if head.type == "shadowguy" then
					table.insert(heads, head)
				end
			end
		end
		local head_failsafe = false
		if #heads <= 0 and Game:getFlag("can_kill") then
			for _,head in ipairs(Game.world:getEvents("teevie_sneakhead")) do
				if head.type == "shadowguy" then
					table.insert(heads, head)
				end
			end
			head_failsafe = true
		end
		if #heads <= 0 then
			if Game:getFlag("can_kill") then
				cutscene:text("* (But nobody came.)")
			else			
				cutscene:text("* (You somehow remained undetected.)")
			end
		else
			local head = heads[love.math.random(1, #heads)]
			local guy = cutscene:spawnNPC("shadowguy", head.x + 22, head.y + 28)
			if head_failsafe then
				Assets.playSound("fall")
				guy.x = Game.world.player.x - 90
				guy.y =	Game.world.camera.y-SCREEN_HEIGHT/2-100
				guy.physics.gravity = 2
				guy.scale_x = -2
				if head.x > Game.world.player.x-Game.world.player.width/2 + 17 then
					guy.x = Game.world.player.x + 90
					guy.scale_x = 2
				end
			else
				Assets.playSound("jump")
				guy.physics.speed_y = -35
				guy.physics.gravity = 2
				guy.scale_x = -2
				local desxloc = Game.world.player.x - 90
				if head.x > Game.world.player.x-Game.world.player.width/2 + 17 then
					desxloc = Game.world.player.x + 90
					guy.scale_x = 2
				end
				local recolor = guy:addFX(RecolorFX())
				recolor.color = {0,0,0}
				Game.world.timer:tween(8/30, recolor, {color = {1,1,1}}, "out-quad")
				Game.world.timer:tween(0.6, guy, {x = desxloc}, "out-quad")
			end
			local groundpos = Game.world.player.y
			head.visible = false
			cutscene:wait(function() return guy.y < groundpos end)
			cutscene:wait(function() return guy.y >= groundpos end)
			guy.y = groundpos
			guy.physics.gravity = 0
			guy.physics.speed_y = 0
			guy.layer = Game.world.player.layer
			Assets.playSound("wing")
			cutscene:wait(0.5)
			Assets.playSound("tensionhorn")
			cutscene:wait(8/30)
			local src = Assets.playSound("tensionhorn")
			src:setPitch(1.1)
			cutscene:wait(12/30)
			--local enemy_target = self
			Game:setFlag("sneaking_shadowmen_violence", false)
			cutscene:startEncounter("shadowguy_sneaking", true, guy, {wait = true})
			guy:remove()
			cutscene:wait(1/30)
			if Game:getFlag("can_kill") and Game:getFlag("sneaking_shadowmen_violence", false) then
				head:setFlag("killed", true)
			end
			head:remove()
		end
		Game.world.timer:tween(1, light, {y = Game.world.camera.y-SCREEN_HEIGHT/2-300}, "in-back")
		cutscene:wait(1)
		light:remove()
	end,
}

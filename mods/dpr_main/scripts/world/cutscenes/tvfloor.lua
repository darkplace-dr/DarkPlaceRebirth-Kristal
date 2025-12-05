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

	funnytexttest = function(cutscene)
		cutscene:text("* Wow,[wait:5] what an [funnytext:amazing_01,ftext_prize,8,-58,204,61]\n                 performance!!!")
		cutscene:text("* The audience has been brought to [funnytext:tears/tears,splat,0,0,98,31],[wait:5] folks!")
		cutscene:text("* MIKE,[wait:5] the [funnytext:board,ftext_woodblock,0,0,71,46],[wait:5]\nplease!")
		--cutscene:text("[funnytext:brother/brother,ftext_brother,0,0,91,23]")
		cutscene:text("* The gushing pillar of darkness that gives us all form -\n[funnytext:dark_fountain/dark_fountain,ftext_dark_fountain,-20,-30,220,40]!!")
		cutscene:text("* Is another\n[funnytext:physical_challenge/physical_challenge,ftext_bounce,0,-10,195,34]!")
		cutscene:itsTVTime()
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
	
	after_quiz = function(cutscene, answers)
		if Game:getFlag("after_quiz_done", false) then
			return
		end
		local answers = answers or {}
		local correct = 0
		if Game:hasPartyMember("susie") and Game:hasPartyMember("dess") then
			for i = 1, #answers do
				if answers[i]["dess"] == true then
					correct = correct + 1
				end
			end
			if correct == 0 then
				cutscene:textTagged("* Dess,[wait:5] why the HELL are you picking the wrong answers!?", "teeth", "susie")
				cutscene:textTagged("* teehee", "teehee", "dess")
				cutscene:textTagged("* ...", "annoyed", "susie")
			elseif correct == #answers then
				cutscene:textTagged("* MAN you guys suck at this quiz", "condescending", "dess")
				cutscene:textTagged("* Your strategy is literally just picking the opposite answer.", "neutral", "susie")
				cutscene:textTagged("* okay but I got them right didn't I", "smug", "dess")
				cutscene:textTagged("* THAT WAS JUST DUMB LUCK!!!", "teeth_b", "susie")
			else
				cutscene:textTagged("* (... Is Dess picking the opposite answers on purpose?)[react:1]", "suspicious", "susie", {reactions={
				{"yup", "right", "bottom", "wink", "dess"}}})
			end
		end
		cutscene:hideNametag()
		Game:setFlag("after_quiz_done", true)
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
            cutscene:wait(function () return change:isRemoved() end)
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
	
    pippins_first = function(cutscene, event)
        if event.interact_count == 1 then
            cutscene:showNametag("Pippins")
            cutscene:text("* This is Punishment Cage D.", nil, event)
            cutscene:text("* ... Y'know,[wait:5] was there ever a Punishment Cage C in the first place?", nil, event)
            cutscene:hideNametag()
        else
            cutscene:showNametag("Pippins")
            cutscene:text("* By the way,[wait:5] I heard security here can be quite different.", nil, event)
            cutscene:text("* If you don't pay attention,[wait:5] you may be quite surprised! Hee hee.", nil, event)
            cutscene:hideNametag()
        end
    end,
	
    gouldensam_first = function(cutscene, event)
        cutscene:showNametag("Goulden Sam")
        cutscene:text("* (It's tough being the forgotten cage.)", nil, event)
        cutscene:hideNametag()
    end,

    maze_zapper = function(cutscene, event)
		cutscene:showNametag("Zapper")
        cutscene:text("* You seem lost. Do youse need assistance?", nil, event)
        local choicer = cutscene:choicer({"Yes", "No"})
        if choicer == 1 then
			cutscene:text("* That can be arranged.", nil, event)
			cutscene:hideNametag()
			local change = TVTurnOff({map = Game.world.map.id, marker = event.data.properties["tele_marker"] or "spawn", facing = event.data.properties["tele_facing"] or "down", flag = event.data.properties["tele_flag"] or nil})
			Game.world:addChild(change)
			cutscene:wait(function () return change:isRemoved() end)
		else
			cutscene:hideNametag()
		end
    end,

    not_maze_zapper = function(cutscene, event)
        cutscene:showNametag("Zapper")
        if event.interact_count == 1 then
            cutscene:text("* You seem lost. Do youse need assistance?", nil, event)
            cutscene:text("* Well, TOO BAD!![wait:5]\n* I'm not working in dis place!", nil, event)
            if not Game:getFlag("#floortv/zapper_maze#105:opened") then
                cutscene:text("* I'm here for da free water, \n[wait:5]not for helping cheaters like youse!", nil, event)
            end
        else
            if Game:getFlag("#floortv/zapper_maze#105:opened") then
                cutscene:text("* Water...[wait:5] is scarce now cause of youse...", nil, event)
            else
                cutscene:text("* Besides,[wait:5] none of these guys have any buttons that match up with mine!!", nil, event)
                cutscene:text("* Where the hell am I even supposed to take youse to!?", nil, event)
            end
        end
        cutscene:hideNametag()
    end,

    ramb = function(cutscene, event)
        local kris = cutscene:getCharacter("kris")
        local hero = cutscene:getCharacter("hero")
        local susie = cutscene:getCharacter("susie")
        local ramb = cutscene:getCharacter("ramb")

        if not Game:getFlag("ramb_introduction") then
            Game:setFlag("ramb_introduction", true)
            cutscene:showNametag("Ramb")

            if hero then
                cutscene:text("* Oh,[wait:5] Kris! You're here!\n[wait:5]* How's...")
                ramb:setAnimation("turn_subtle")
                cutscene:text("* Oh wait,[wait:5] sorry.\n* Mistook you for someone else.")
            end
            if susie then
                cutscene:showNametag("Susie")
                cutscene:text("* Hey,[wait:5] aren't you one of the guys who was working for Tenna?", "surprise", "susie")
                cutscene:showNametag("Ramb")
                ramb:setAnimation("happy")
                cutscene:text("* Sure am,[wait:5] luv.")
                ramb:setAnimation("happy_nostalgic")
                cutscene:text("* To be fair though,[wait:5] I think nearly everyone on this floor has worked with him.")
                ramb:setAnimation("turned")
                cutscene:text("* At least to some extent,[wait:5] haha.")
                ramb:setAnimation("surprised")
                cutscene:text("* Wait hold on,[wait:5] I think I recognize you!")
                ramb:setAnimation("happy")
                cutscene:text("* You must be Susie,[wait:5] right?\n[wait:5]* One of Kris' friends?")
                cutscene:showNametag("Susie")
                cutscene:text("* Uhhh yeah,[wait:5] I am.", "nervous", "susie")
                if not kris then
                    cutscene:text("* Wait,[wait:5] have you seen Kris around here??", "surprise", "susie")
                    cutscene:showNametag("Ramb")
                    ramb:setAnimation("annoyed")
                    cutscene:text("* Sorry,[wait:5] luv.[wait:5]\n* I'm afraid I haven't seen Kris at all.")
                    ramb:setAnimation("turn_subtle")
                    cutscene:text("* If I see them around though,[wait:5] I'll be sure to let you know,[wait:5] 'kay?")
                    cutscene:showNametag("Susie")
                    cutscene:text("* Uhhh sure,[wait:5] thanks...", "surprise", "susie")
                    cutscene:text("* (Man,[wait:5] where the hell could Kris even be??)", "nervous_side", "susie")
                end
                cutscene:showNametag("Ramb")
                ramb:setAnimation("turned")
                cutscene:text("* Well, [wait:5]guess we can have a little chit-chat right now.")
                ramb:setAnimation("turn")
                cutscene:text("* As long as ol' Tenna's busy having fun somewhere else.")
                cutscene:text("* Anything you wanna talk about,[wait:5] luv?")
            else
                ramb:setAnimation("turn_subtle")
                cutscene:text("* Anything you wanna talk about? [wait:5]\n* I'm free for now.")
            end
        else
            cutscene:showNametag("Ramb")
            cutscene:text("* Good day, luv.\n* Anything you want to ask?")
        end
        ramb:setAnimation("idle")
        cutscene:hideNametag()

        local choicer = {"Tenna", "Nothing", "Gift Shop"}
        if Game:getFlag("tenna_physicalchallenge") then
            table.insert(choicer, "Stickers")
        end

        local choice = cutscene:choicer(choicer)
        if choice == 1 then
            cutscene:showNametag("Ramb")
            ramb:setAnimation("happy_nostalgic")
            cutscene:text("* Ahh,[wait:5] good ol' Tenna...")
            cutscene:text("* If you ask me,[wait:5] I'd say he's \na bit uhh... chaotic.")
            ramb:setAnimation("happy")
            cutscene:text("* Maybe a little TOO chaotic at times.")
            ramb:setAnimation("turned")
            cutscene:text("* I had to quit my job this one time because of it.")
            ramb:setAnimation("annoyed")
            cutscene:text("* Didn't really fancy him crashing out like that, \ny'know?")
            ramb:setAnimation("turn_subtle")
            cutscene:text("* Despite that,[wait:5] doing that was one of the toughest decisions I've ever made.")
            ramb:setAnimation("turned")
            cutscene:text("* Especially since I lost my purpose and turned to stone shortly afterwards,[wait:5] haha.")
            ramb:setAnimation("turn")
            cutscene:text("* When I came here though,[wait:5] ol' Tenna was begging for me to come back and work for him.")
            ramb:setAnimation("happy_nostalgic")
            cutscene:text("* Guess some things never really change after all,[wait:5] do they luv?")
        elseif choice == 2 then
            cutscene:showNametag("Ramb")
            cutscene:text("* Have fun then!")
            if susie then
                ramb:setAnimation("turned")
                if #Game.party == 1 then
                    cutscene:text("* By the by, [wait:5]if you ever end up finding Kris...")
                else
                    cutscene:text("* By the by, [wait:5]if you lot ever end up finding Kris...")
                end
                ramb:setAnimation("look")
                cutscene:text("* Tell them to have a fun time wherever they are, [wait:5]'kay luv?")
                ramb:setAnimation("turned")
                cutscene:text("* Aight,[wait:5] cheers.")
            end
        elseif choice == 3 then
            cutscene:showNametag("Ramb")
            ramb:setAnimation("surprised")
            cutscene:text("* Oh,[wait:5] you mean my shop in the Green Room?")
            ramb:setAnimation("turned")
            cutscene:text("* Sorry,[wait:5] luv.\n[wait:5]* I'm afraid it's closed at \nthe moment.") -- TODO: make ramb give random ribbon armor
            ramb:setAnimation("happy")
            cutscene:text("* Not that it's really much of a problem anyways,[wait:5] eh?")
            ramb:setAnimation("turned")
            cutscene:text("* It's been rather quiet around here,[wait:5] since Tenna and the lot moved in.")
        elseif choice == 4 then
            cutscene:showNametag("Ramb")
            ramb:setAnimation("surprised")
            cutscene:text("* Huh?\n[wait:5]* Stickers you say, luv?")
            ramb:setAnimation("turned")
            cutscene:text("* Ah sorry,[wait:5] don't think Tenna would be quite chipper if I helped you out with it.")
            ramb:setAnimation("happy")
            cutscene:text("* The most I can do is just \ngive you small hints and such,[wait:5] but...")
            ramb:setAnimation("turn_subtle")
            cutscene:text("* I haven't found any stickers around here yet.") -- TODO: make ramb give hints to the harder stickers
            ramb:setAnimation("annoyed")
            cutscene:text("* Seems like ol' Tenna's hid the bloody things really well.")
            ramb:setAnimation("happy_nostalgic")
            cutscene:text("* Well,[wait:5] at least these games are fun,[wait:5] eh luv?")
            local gamechoice = cutscene:choicer({"They\nare", "They're\nnot"})
            if gamechoice == 1 then
                ramb:setAnimation("turned")
                cutscene:text("* That's the spirit!")
            else
                ramb:setAnimation("turned")
                cutscene:text("* Gee,[wait:5] would be better if you tried to enjoy something.") -- TODO: edit this dialogue when there will be more ramb related stuff
            end
            ramb:setAnimation("happy")
            cutscene:text("* Anyways,[wait:5] try to find them \nall,[wait:5] aight?")
        end
        ramb:setAnimation("idle")
        cutscene:hideNametag()
    end,

    ralsei_impostor = function(cutscene, event)
        local hero = cutscene:getCharacter("hero")
        local susie = cutscene:getCharacter("susie")
        local dess = cutscene:getCharacter("dess")

        local ralsei_impostor = cutscene:getCharacter("ralseiimpostor")

        if susie then
            cutscene:showNametag("Susie")
            cutscene:text("* Ralsei!?\n[wait:5]* Is that you??", "surprise", "susie")
            cutscene:text("* Man,[wait:5] am I glad to see you!", "sincere_smile", "susie")
            if hero then
                cutscene:showNametag("Hero")
                cutscene:text("* Uhhh... Susie?", "shocked", "hero")
                cutscene:text("* I don't think that's your friend...", "shocked", "hero")
                cutscene:showNametag("Susie")
                cutscene:text("* The hell makes you say that-[next]", "suspicious", "susie")
            end
            cutscene:hideNametag()
        end

        ralsei_impostor:setFacing("down")
        Assets.playSound("alert")
        cutscene:wait(8/30)
		
        if susie then
            Assets.playSound("sussurprise", 2)
            susie:shake()
            if susie.facing == "up" or susie.facing == "down" then
                susie:setSprite("shock_up")
            elseif susie.facing == "right" then
                susie:setSprite("shock_right")
            elseif susie.facing == "left" then
                susie:setSprite("shock_left")
            end
        end

        cutscene:wait(20/30)
        cutscene:showNametag("Pippins")
        if susie and not hero then
            cutscene:text("* I'm not Ralsei!!")
        else
            cutscene:text("* Had ya fooled,[wait:5] didn't I?")
            if dess or Game:isDessMode() then
                cutscene:showNametag("Dess")
                cutscene:text("* No not really tbh", "", "dess")
            end
        end
        cutscene:hideNametag()

        Assets.playSound("tensionhorn")
        cutscene:wait(8/30)
        local src = Assets.playSound("tensionhorn")
        src:setPitch(1.1)
        cutscene:wait(12/30)

        if susie then
            susie:resetSprite()
        end

        Game:setFlag("pippins_shuttah_violence", false)
        Game:encounter("pippins_shuttah", nil, {ralsei_impostor})
        cutscene:after(function()
            ralsei_impostor:remove()
        end)
    end,

    enter_rambs_room = function(cutscene, event, chara)
		Game:setFlag("in_rambs_room", true)
		Game.world:mapTransition("floortv/green_room", "entry_ramb", chara.facing)
	end,
	
    exit_rambs_room = function(cutscene, event, chara)
		Game:setFlag("in_rambs_room", false)
		Game.world:mapTransition("floortv/inbetween_hall", "entry_ramb", chara.facing)
	end,
	
    green_vending = function(cutscene, event)
        cutscene:text("* (It's the VENDING MACHINE!)\n* (Use the vending machine?)", nil)
        local choicer = cutscene:choicer({"Buy", "Don't Buy"})
        if choicer == 1 then
			Game:enterShop("green_vending")
		end
	end,

    legacy_vending = function(cutscene, event)
        cutscene:text("* (It's the FORGOTTEN VENDING MACHINE!)\n* (Use the vending machine?)", nil)
        local choicer = cutscene:choicer({"Buy", "Don't Buy"})
        if choicer == 1 then
			Game:enterShop("legacy_vending")
		end
	end,
	
    chair_room_chair = function(cutscene, event)
        if not Game:getFlag("chair_room_darker") then
			if MathUtils.random() >= 0.95 then
				Kristal.hideBorder(0)
				Game.world.music:stop()
				Assets.playSound("face")
				love.window.setTitle("")
				local black = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				black:setParallax(0)
				black:setColor(COLORS.black)
				black.layer = WORLD_LAYERS["top"] - 2
				Game.world:addChild(black)
				local eyes = Sprite("world/maps/floor3/nondescript_room/___eyes", SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
				eyes:setOrigin(0.5)
				eyes:setScale(3)
				eyes:setParallax(0)
				eyes.layer = WORLD_LAYERS["top"] - 1
				Game.world:addChild(eyes)
				Game.world.timer:tween(0.5, eyes, {scale_x = 300, scale_y = 300}, "in-cubic")
				cutscene:wait(0.5)
				Assets.stopSound("face")
				black:remove()
				eyes:remove()
				Game.world:loadMap("floortv/green_room", "spawn", "down")
				Kristal.showBorder(0)
				Kristal.setDesiredWindowTitleAndIcon()
			else
				for _, mevent in ipairs(Game.world.map.events) do
					if mevent.layer == Game.world.map.layers["objects_party"] then
						mevent.collider.collidable = false
						mevent.visible = false
						mevent.layer = Game.world.map.layers["objects_nondistort"]
					end
					if mevent.layer == Game.world.map.layers["objects_distort"] then
						mevent.collider.collidable = true
						mevent.visible = true
						mevent.layer = Game.world.map.layers["objects_party"]
					end
				end
				Game.world.map:getImageLayer("bg_dark").visible = true
				for _,chara in ipairs(Game.stage:getObjects(Character)) do
					if not chara:getFX("dark") then
						chara:addFX(RecolorFX(ColorUtils.mergeColor(COLORS.white, COLORS.black, 0.4)), "dark")
						chara:addFX(DarkBlurFX(0, 0.6, false), "blur")
					end
				end
				for _, party in ipairs(Game.party) do
					for _, char in ipairs(Game.stage:getObjects(Character)) do
						if char.actor and char.actor.id == party:getActor(true).id then
							char:setActor(party:getActor(false))
						end
					end
				end
				Game.world.music:play("deltarune/ambientwater_weird")
				Game.world.music:setVolume(1)
				Game:setFlag("chair_room_darker", true)
				love.window.setTitle("... get darker than dark?")
			end
        else
			for _, mevent in ipairs(Game.world.map.events) do
			if mevent.layer == Game.world.map.layers["objects_party"] then
					mevent.collider.collidable = false
					mevent.visible = false
					mevent.layer = Game.world.map.layers["objects_distort"]
				end
				if mevent.layer == Game.world.map.layers["objects_nondistort"] then
					mevent.collider.collidable = true
					mevent.visible = true
					mevent.layer = Game.world.map.layers["objects_party"]
				end
			end
			Game.world.map:getImageLayer("bg_dark").visible = false
			for _,chara in ipairs(Game.stage:getObjects(Character)) do
				if chara:getFX("dark") then
					chara:removeFX("dark")
					chara:removeFX("blur")
				end
			end
			for _, party in ipairs(Game.party) do
				for _, char in ipairs(Game.stage:getObjects(Character)) do
					if char.actor and char.actor.id == party:getActor(false).id then
						char:setActor(party:getActor(true))
					end
				end
			end
			Game.world.music:stop()
			Game.world.music:setVolume(1)
			Game:setFlag("chair_room_darker", false)
			love.window.setTitle("But what if it could...")
        end
    end,
}

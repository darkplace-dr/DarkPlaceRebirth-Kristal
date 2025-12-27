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
	
    green_wvending = function(cutscene, event)
        cutscene:text("* (It's the VENDING MACHINE (promoted by Tenna)!)\n* (Use the vending machine?)", nil)
        local choicer = cutscene:choicer({"Buy", "Don't Buy"})
        if choicer == 1 then
			Game:enterShop("green_wvending")
		end
	end,
	
    green_sellding = function(cutscene, event)
		Game:enterShop("green_sellding")
	end,

    legacy_vending = function(cutscene, event)
        cutscene:text("* (It's the FORGOTTEN VENDING MACHINE!)\n* (Use the vending machine?)", nil)
        local choicer = cutscene:choicer({"Buy", "Don't Buy"})
        if choicer == 1 then
			Game:enterShop("legacy_vending")
		end
	end,

    legacy_freevending = function(cutscene, event)
		cutscene:text("* (It's the VENDING MACHINE!)\n* (It seems to have stopped working for quite a while.)", nil)
		cutscene:text("* (Borrow items from the vending machine?)", nil)
        local choicer = cutscene:choicer({"Borrow", "Don't"})
        if choicer == 1 then
			Game:enterShop("legacy_freevending")
		end
	end,

    legacy_mikevending = function(cutscene, event)
		cutscene:text("* (MIKE'S VENDING MACHINE!)\n* (It seems to have stopped working for quite a while.)", nil)
		cutscene:text("* (Borrow items from the vending machine?)", nil)
        local choicer = cutscene:choicer({"Borrow", "Don't"})
        if choicer == 1 then
			Game:enterShop("legacy_mikevending")
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

    dess = function(cutscene, event)
    	cutscene:text("* Yoo guys what's up.", "heckyeah", "dess")
    	cutscene:text("* What are you doing here...?", "annoyed", "susie")
    	cutscene:text("* Actually wait, I don't want to know.", "nervous_side", "susie")
    	cutscene:text("* I broke in.", "teehee", "dess")
    	cutscene:text("* ...", "suspicious", "susie")
    	cutscene:text("* Anyways, my gentlebeauties and gentleuglies...", "condescending", "dess")
    	cutscene:text("* We're on a TV Floor aren't we?", "condescending", "dess")
    	cutscene:text("* You know what that means, right?", "challenging", "dess")
    	cutscene:text("* ...We get to play a game?", "sus_nervous", "susie")
    	Game.world.music:pause()
    	cutscene:text("* [speed:0.1]y e s", "dess.exe", "dess")
    	Game.world.music:resume()
    	cutscene:text("* After all, what's TV without those shows where you do stupid stuff for money?", "genuine", "dess")
    	cutscene:text("* I have a very very evy ery rvy very yver yrev challenge for ya.", "smug", "dess")
    	cutscene:text("* You should totally play it.", "teehee", "dess")
    	cutscene:text("* (Totally play her game?)")
    	if cutscene:choicer({"Yes", "No"}) == 2 then
    		cutscene:text("* Fuck you.", "mspaint", "dess")
    		event:explode()
    		return
    	end
    	cutscene:text("* Ebic, let's go.", "swag", "dess")
    	cutscene:detachCamera()
    	cutscene:detachFollowers()
    	Game.world.music:fade(0, 1)
    	local start_values = {}
    	start_values[event] = event.y
    	event:spin(1)
    	for _,member in ipairs(Game.party) do
    		local chara = cutscene:getCharacter(member.id)
    		chara:spin(1)
    		start_values[member.id] = chara.y
    	end
    	--cutscene:fadeOut(0.5, {color=COLORS.white})
    	Game.world.fader.fade_color = {1, 1, 1}
    	local snd = Assets.playSound("marioparty")
    	local timer = 0
    	cutscene:wait(function()
    		timer = timer + DTMULT*0.02
    		for _,member in ipairs(Game.party) do
	    		local chara = cutscene:getCharacter(member.id)
	    		chara.y = Utils.ease(start_values[member.id], start_values[member.id]-SCREEN_HEIGHT-10, timer, "inCubic")
	    	end
	    	event.y = Utils.ease(start_values[event], start_values[event]-SCREEN_HEIGHT-10, timer, "inCubic")
	    	Game.world.fader.alpha = timer+0.1
	    	return timer >= 1
    	end)
    	cutscene:loadMap("floortv/dessgame")
    	cutscene:after(function()
    		Game.world:startCutscene("tvfloor.dessgame")
    	end, true)
    	--Game.world.music:play("marioparty", 1, 1)
    end,

    dessgame = function(cutscene)
		Game.world.fader:fadeIn(nil, {speed=0.3})
    	Game.world.music:play("marioparty", 1, 1)

    	cutscene:detachFollowers()

    	if #Game.party == 1 then
    		Game.world.player:setPosition(150, 265)
    	elseif #Game.party == 2 then
    		Game.world.player:setPosition(200, 265)
    		Game.world.followers[1]:setPosition(100, 265)
    	elseif #Game.party == 3 then
    		Game.world.player:setPosition(250, 265)
    		Game.world.followers[1]:setPosition(150, 265)
    		Game.world.followers[2]:setPosition(50, 265)
    	end

    	local hero = cutscene:getCharacter("hero")
    	local susie = cutscene:getCharacter("susie")

    	local susie_timer
    	if susie then
    		susie_timer = Game.world.timer:every(0.5, function()
    			local faces = {"left", "right", "up", "down"}
    			TableUtils.removeValue(faces, susie.facing)
    			cutscene:look(susie, TableUtils.pick(faces))
    		end)
    	end

    	local dess = cutscene:spawnNPC("dess", 480, 225)

    	cutscene:wait(1.5)

    	cutscene:text("* Welcome losers!", "swag", dess)

    	if susie then
    		cutscene:wait(1)

    		Game.world.timer:cancel(susie_timer)

    		susie:setSprite("exasperated_right")
    		Assets.playSound("whip_crack_only")
    		susie:shake()

    		cutscene:text("* WHAT IS THIS??", "teeth", "susie")
    		cutscene:text("* Where did you get this room??", "teeth", "susie")
    		cutscene:text("* How did you teleport us here??", "teeth_b", "susie")

    		cutscene:text("* Well obviously it's because the Tenna guy loves me.", "condescending", "dess")
    		cutscene:text("* TV folks loves idiots like me.[react:1]", "swag", "dess", {reactions={
    			{"That's not\na good thing!!", "right", "bottom", "teeth_b", "susie"}
    		}})
    		cutscene:text("* Didn't you say you broke in though?", "suspicious", hero and "hero" or "susie")

    		cutscene:text("* Details are annoying.", "calm", "dess")

    		cutscene:text("* Anyway back to my COOL game", "condescending", "dess")

    		susie:resetSprite()
    		cutscene:look(susie, "down")
    	end
    	cutscene:text("* The goal is actually kinda simple.", "kind", "dess")

    	if susie then
    		susie:setSprite("shock_right")
    	end

    	-- Thanks to Vikram Rahul Abishek Pranav Rajesh for his Tennison Gambit Intercontinental Ballistic Missile Variation
    	-- https://youtu.be/E2xNlzsnPCQ
    	local str_obvious_choice = "A RT-2PM2 \"Topol-M\" cold-launched three-stage solid propellant silo-based intercontinental ballistic missile"
    	local str_beginner_choice = "A BGM-71 TOW anti-tank missile launched from an M3 Bradley Cavalry Fighting Vehicle tracked armored reconnaissance vehicle"

    	local chosen_str = StringUtils.splitFast(MathUtils.random() < 0.7 and str_obvious_choice or str_beginner_choice, " ")

    	local font = Assets.getFont("main_mono")
    	while #chosen_str > 0 do
    		local ok = true
    		local text = ""
    		while ok do
    			local new_word = table.remove(chosen_str, 1)
    			if not new_word then
    				break
    			end
    			text = text..(#text == 0 and "" or " ")..new_word

    			-- 355 is a magic number. It makes a good result with both strings
    			local _, lines = font:getWrap(text, 355)
    			if #lines > 3 then
    				ok = false
    				table.insert(chosen_str, 1, new_word)
    				text = text:sub(0, text:find(new_word, 0, true)-2)
    			end
    		end
    		cutscene:text("* "..text, "condescending", "dess", {skip=false, auto=true})
    	end
    	cutscene:text("* has been launched towards this location.", "condescending", "dess", {skip=false})
    	cutscene:text("* Thankfully, [color:red]YOU[color:reset] can choose where it will hit.", "challenging", "dess")

    	local trolley = Game.world:spawnObject(DessBallisticTrolleyGame(320, 40), WORLD_LAYERS["below_ui"])
    	trolley.y = -SCREEN_HEIGHT

    	local tweenDone = false
    	Game.world.timer:tween(2, trolley, {y = 0}, "in-bounce", function() tweenDone = true end)

    	cutscene:slideTo(dess, dess.x-60, dess.y, nil, "out-cubic")

    	cutscene:wait(function() return tweenDone end)

    	cutscene:wait(0.4)

    	cutscene:text("* Choose the top option and the missile will blow up our reality.", "teehee", "dess")
    	cutscene:text("* Choose the bottom option and it blows up absolutely nothing.", "neutral_c", "dess")

    	cutscene:wait(1)

    	if susie then
    		susie:resetSprite()
    		cutscene:look(susie, "right")
    	end

    	cutscene:text("* And why would we even choose the top option?", "neutral_side", "susie")

    	cutscene:text("* Why wouldn't you?", "reverse", "dess")
    	cutscene:text("* The bottom option? It's boring, predictable, dumb.", "calm", "dess")
    	cutscene:text("* Nothing has no thrill. It's not even a nice-looking word.", "angry", "dess")
    	cutscene:text("* Nothing is bad and bad things suck.", "neutral_b", "dess")
    	cutscene:text("* Destroying reality on the other end...", "smug", "dess")
    	cutscene:text("* It sounds VERY cool. Very unique and badass.", "swag", "dess")
    	cutscene:text("* It's a once-in-a-lifetime experience to check out.", "genuine_b", "dess")
    	cutscene:text("* And best of all, it solves all your problems!", "eurika", "dess")
    	cutscene:text("* No reality = no problems to have or solves.", "wink", "dess")
    	cutscene:text("* Can't beat my maths here.", "condescending", "dess")
    	cutscene:text("* I graduated elementary school at 15.", "condescending", "dess")

    	cutscene:wait(0.5)

    	local leader_name = GeneralUtils.getLeader():getName()

    	local dessDial = "* How about everyone takes their own decision for once?"

    	if susie then
    		dessDial = "* {leader} this... {leader} that... How about y'all take your own decision?"
    		cutscene:text("* ...", "nervous_side", "susie")
    		cutscene:text("* "..leader_name.."... You're not thinking on doing it, right?", "nervous_side", "susie")
    	end

    	local votingMachine = Game.world:spawnObject(DessGameVoting(), dess:getLayer())
    	votingMachine.y = -SCREEN_HEIGHT/4

    	tweenDone = false
    	Game.world.timer:tween(2, votingMachine, {y = 0}, "out-cubic", function() tweenDone = true end)

    	if susie then
    		susie:resetSprite()
    		cutscene:look(susie, "up")
    	end
    	if hero then
    		hero:resetSprite()
    		cutscene:look(hero, "up")
    	end

    	cutscene:text(StringUtils.format(dessDial, {leader=leader_name}), "neutral_b", "dess")

    	cutscene:wait(function() return tweenDone end)

    	cutscene:wait(1)

    	if susie then
    		cutscene:look(susie, "right")
    		cutscene:text("* Okay well I vote against it.", "sus_nervous", "susie")
    		votingMachine:setChoice(susie, false)
    	end

    	if hero then
    		cutscene:look(hero, "down")
    		cutscene:text("* (...)", "neutral_closed", "hero")
    		cutscene:text("* (Preventing reality from being destroyed IS our main goal...)", "really", "hero")
    		cutscene:text("* (But if you see a use for it, "..Game.save_name.."...)", "pout", "hero")
    		cutscene:text("* (It's not like she can ACTUALLY do that, right?)", "suspicious", "hero")
    	end
    	votingMachine:setChoice(GeneralUtils.getLeader().id, cutscene:choicer({"End\nReality", "No"}) == 1)

    	dess:spin(0.5)
    	local wait = cutscene:slideTo(dess, 320, 255, nil, "out-cubic")
    	cutscene:during(function()
    		if wait() then
    			dess:spin(0)
    			return false
    		end
    	end)

    	cutscene:text("* The results are iiiiiiiiiiiiin", "swag", "dess")
    	cutscene:text("* Let's see who's based and who's cringe.", "swag", "dess")

    	cutscene:wait(wait)

    	cutscene:look(dess, "up")

    	cutscene:wait(0.5)

    	local votes = votingMachine:getResults()

    	if votes <= 0 then
    		cutscene:text("* Y'all are laaaame.", "neutral_c", "dess")
    		cutscene:text("* You don't understand the beauty of everything just dying.", "condescending", "dess")
    		cutscene:text("* Anyways you already know what I'm gonna vote for.", "teehee", "dess")
    	else
    		cutscene:text("* Holy shit you guys actually wanna die", "wtf_b", "dess")
    		cutscene:text("* That's awesome dude let me join in. Like a blood pact.", "teehee", "dess")
    	end
    	votingMachine:addVoter("dess")
    	votingMachine:setChoice("dess", true)

    	cutscene:wait(0.5)

    	if susie then
    		cutscene:text("* Wait, who said you could vote??", "teeth_b", "susie")
    		cutscene:text("* Uh, me? I'm the mod here, dumbass.", "neutral", "dess")
    	end

    	votes = votingMachine:getResults()
    	cutscene:wait(1)

    	if votes <= 0 then

    		Game.world.music:stop()

    		cutscene:text("* God fucking damn it it wasn't enough.", "mspaint", "dess")
    		cutscene:text("* Guess we'll have to keep living after all.", "mspaint", "dess")
    		cutscene:text("* Bummer.", "mspaint", "dess")

    		local e = votingMachine:explode()
    		e.y = e.y - 200
    		trolley:explode()

    		cutscene:wait(1)

    		cutscene:text("* Alright game's done. Fuck you. I'll see you tomorrow. Bye bye.", "genuine", "dess")

    		dess:explode()

    		cutscene:enableMovement()

    		cutscene:wait(3)

    		if susie then
    			cutscene:text("* Wait... How do we even get out of here?", "sus_nervous", "susie")

    			cutscene:disableMovement()

    			dess = cutscene:spawnNPC("dess", SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
    			dess.visible = false

    			Assets.playSound("badexplosion_r")
    			local e = Sprite("misc/realistic_explosion", dess.x-dess.width, dess.y-dess.height*2)
    			e:setAnimation({nil, 0.1, false, frames={"17-1"}})
    			e:setLayer(dess:getLayer()+0.001)
    			dess.parent:addChild(e)

    			cutscene:wait(function()
    				return e.frame == 7
    			end)
    			dess.visible = true
    			cutscene:wait(function()
    				return not e.playing
    			end)
    			e:remove()

    			cutscene:text("* Oh yeah I forgot about that.", "genuine", "dess")
    			cutscene:text("* There's none.", "condescending", "dess")

    			cutscene:text("* What??", "surprise_frown", "susie")

    			cutscene:text("* Yeah.", "genuine", "dess")
    			cutscene:text("* Also remember how I got this room from Tenna or something?", "genuine_b", "dess")
    			cutscene:text("* Yeah I got it from one of the mafia Tennas.", "mspaint", "dess")
    			cutscene:text("* And I didn't provide any entertaiment so now we're all gonna die.", "mspaint", "dess")
    			cutscene:text("* Hope y'all don't mind that.", "wink", "dess")

    			dess:explode()
    			cutscene:enableMovement()

    			cutscene:wait(1.5)

    			cutscene:text("* ...", "suspicious", "susie")
    			cutscene:text("* Even dealing with the Knight was better.", "suspicious", "susie")

    			local exTimerMax = 30
    			local exTimer = exTimerMax
    			cutscene:during(function()
    				if exTimer < 0 then
    					return false
    				end
    				exTimer = MathUtils.approach(exTimer, exTimerMax, DTMULT)

    				if exTimer >= exTimerMax then
    					Game.world:spawnObject(Explosion(MathUtils.random(30, SCREEN_WIDTH-30), MathUtils.random(30, SCREEN_HEIGHT-30)))
    					exTimer = 0
    					exTimerMax = math.max(exTimerMax-1,5)
    				end
    			end)

    			cutscene:wait(1)

    			cutscene:text("* Damn it!!", "sad_frown", "susie")

    			cutscene:text("* Dess!! Come back HERE Dess!!", "teeth_b", "susie")
    			cutscene:text("* There has to be an exit here!", "shy_b", "susie")

    			cutscene:disableMovement()

    			local tenna = cutscene:spawnNPC("tenna", SCREEN_WIDTH+20, 330)
    			tenna.sprite:setTennaSprite(9, "point_left", 1)

    			local player = Game.world.player
    			if player.x > SCREEN_WIDTH/2 then
    				cutscene:walkTo(player, SCREEN_WIDTH/2-100, player.y, 0.8, "right", true)
    			end

    			cutscene:wait(cutscene:slideTo(tenna, 460, tenna.y, 1, "out-elastic"))

    			cutscene:text("* There is one!!", nil, tenna)
    			cutscene:text("* The exit is hidden behind this wall, Susie!!", nil, tenna)

    			cutscene:text("* Te-Tenna???", "surprise", "susie")
    			cutscene:text("* Thanks man!", "surprise_smile", "susie")

    			tenna.sprite:setTennaAnim(0, "laugh", 1)

    			cutscene:text("* Anything for my favorite showstar!", nil, tenna)

    			local walks = {}
    			for i, member in ipairs(Game.party) do
    				local chara = cutscene:getCharacter(member.id)
    				table.insert(walks, cutscene:walkTo(chara, chara.x-SCREEN_WIDTH/2, chara.y))
    			end

    			local fade
    			Game.world.timer:after(0.4, function()
    				tenna.sprite:setPreset(7)
    				tenna.sprite:setSprite("sad_turned_a")

    				fade = cutscene:fadeOut()
    			end)

    			cutscene:wait(function()
    				local wait = false
    				for i,v in ipairs(walks) do
    					if not v() then
    						wait = true
    						break
    					end
    				end

    				return wait
    			end)

    			cutscene:wait(function()
    				if fade == nil then
    					return false
    				end
    				return fade()
    			end)
    		end
    		cutscene:loadMap("floortv/legacy_corridors")
    		cutscene:fadeIn()
    	else
    		cutscene:text("* Hell yeah you guys made the right choice.", "genuine_b", "dess")
    		cutscene:text("* Now let's all enjoy our last seconds of living.", "heckyeah", "dess")

    		cutscene:look(dess, "down")

    		local missile = Sprite("world/cutscenes/dessmissile", 0, 320)
    		missile:setOrigin(1, 0)
    		missile:setRotationOrigin(0.9) --???
    		missile:setScale(0.3, 0.5)
    		Game.world:addChild(missile)
    		missile:setLayer(999999)

    		cutscene:wait(cutscene:slideTo(missile, 400, missile.y))
    		missile.rotation = math.rad(-45)
    		cutscene:wait(cutscene:slideTo(missile, 505, 210))
    		missile.rotation = 0
    		missile.y = 240
    		cutscene:wait(cutscene:slideTo(missile, 610, 205))
    		missile:explode()
    		cutscene:wait(0.2)
    		i = 0
    		print("Crash!")
    		local save = Game:save()
    		save.save_id = Game.save_id
    		save.room_id = "floortv/legacy_corridors"
    		love.filesystem.write("saves/file_dessyoufuckingpretzel.json", JSON.encode(save))
    		while i < 50000 do
    			i = i + 1
    		end
    		love = nil
    	end
    end
}

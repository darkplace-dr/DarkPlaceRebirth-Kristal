return {
    start = function(cutscene, event)
        Game.world.map.sliding = true
    end,
    ending = function(cutscene, event)
        Game.world.map.sliding = false
		if Game.world.map.slide_time > 18 and Game:isDessMode() then
			cutscene:showNametag("Dess")
			cutscene:text("* FUCK", "annoyed", "dess")
			cutscene:text("* dude this slide is so fuckin aids", "angry", "dess")
			cutscene:text("* hey wait a minute", "neutral_b", "dess")
			cutscene:text("* i've got an idea!", "eurika", "dess")
			cutscene:hideNametag()
			Game.world.music:pause()
			Game.world.map.slide_time = 9
			Assets.playSound("noise")
			cutscene:wait(3)
			Game.world.music:resume()
			cutscene:showNametag("Dess")
			cutscene:text("* ezpz lemon squeezy", "hackerman", "dess")
			cutscene:hideNametag()
		elseif Game.world.map.slide_time <= 18 and Game:isDessMode() then
			cutscene:showNametag("Dess")
			cutscene:text("* first try baybeeeeee", "swag", "dess")
			cutscene:hideNametag()
		end
		if Game.world.map.slide_time < Game:getFlag("slide_hs", 999) and Game.world.map.slide_time > 8 then
			Game:setFlag("slide_hs", Game.world.map.slide_time)
		end
    end,
    mario = function(cutscene, event)
		local mario = cutscene:getCharacter("mario")
		
		cutscene:showNametag("Mario")
		cutscene:text("* Hey,[wait:5] you-a very good!", "main", "mario")
		cutscene:text("* It's-a my turn now!", "main", "mario")
		if Game:isDessMode() then
			cutscene:showNametag("Dess")
			cutscene:text("* no fuck off", "annoyed", "dess")
			cutscene:text("* only *I* get to lead the party", "angry", "dess")
			cutscene:text("* Imaginary Technique:[wait:10]\n[color:red]Cease[color:reset] and [color:#ff2000]Dessist", "hackerman", "dess")
			cutscene:hideNametag()
			Assets.playSound("bigcut", 2.5, 0.6)
			while mario.alpha > 0 do
				mario.alpha = mario.alpha - 0.1
				cutscene:wait(0.1)
			end
			mario:remove()
			Game:setFlag("mario_obtained", true)
			cutscene:wait(0.5)
			Assets.playSound("boost")
			local dess = Game:getPartyMember("dess")
			dess:increaseStat("health", 25)
			dess:increaseStat("attack", 1)
			dess:increaseStat("defense", 1)
			dess:increaseStat("magic", 1)
			cutscene:text("* (Dess became stronger!)")
			cutscene:showNametag("Dess")
			cutscene:text("* swag", "swag", "dess")
			cutscene:hideNametag()
		else
			cutscene:hideNametag()
			
			cutscene:detachFollowers()
			cutscene:detachCamera()
			local leader = Game.world.player
			local leaderx = leader.x
			local leadery = leader.y
			leader:explode(0, 0, true)
			cutscene:slideTo(leader, leader.x - 50, leader.y - 700, 1)
			cutscene:wait(1.5)
			local leader_id = Game.party[1].id
			
			if #Game.party >= 3 then
				local prev_leader_pm = Game.party[1]
				Game:removePartyMember(prev_leader_pm)
				Game:setFlag(prev_leader_pm.id.."_party", false)
			end
			
			Game:addPartyMember("mario", 1)
			Game:setFlag("mario_party", true)
			Game:setFlag("mario_obtained", true)
			Game.world:spawnPlayer(mario.x, mario.y, "mario")
			mario:remove()
			Game.world:removeFollower(leader)
			cutscene:walkTo("mario", leaderx, leadery, 1, "up")
			cutscene:attachFollowers(1)
			cutscene:interpolateFollowers()
			cutscene:attachCamera(0.5)
			cutscene:wait(0.5)
			
			Game:setFlag("gotMario", true)
			Game:unlockPartyMember("mario")
			
			if Game:hasPartyMember("brenda") and leader_id ~= "brenda" then
				cutscene:showNametag("Brenda")
				cutscene:text("* That joke is only funny the first time.", "dissapointed", "brenda")
				
				cutscene:showNametag("Mario")
				cutscene:text("* There was a first time?", "main", "mario")
			end
			
			if Game:hasPartyMember("jamm") and leader_id ~= "jamm" then
				cutscene:showNametag("Jamm")
				cutscene:text("* (Don't take anything he says or does to heart.)", "nervous", "jamm")
				cutscene:text("* (He's a good guy.)[wait:5]\n* (Just really stupid.)", "neutral", "jamm")
			end
			cutscene:hideNametag()
		end
    end,

	fonttest = function (cutscene)
		if false then
		local texts = {}
        local function genBigText(text, x, y, scale, goner, wait_time)
            scale = scale or 2
            wait_time = wait_time or 0.2

            local text_o = Game.world:spawnObject(Text(text, x, y, 300, 500, { style = goner and "GONER" or "dark", font = "sm64_hud_c" }))
            text_o:setScale(scale)
            text_o.parallax_x = 0
            text_o.parallax_y = 0
            if goner then
                text_o.alpha = 1
            end
            table.insert(texts, text_o)

            cutscene:wait(wait_time)

            return text_o
        end
		local function fadeOutBigText()
            for _, v in ipairs(texts) do
                Game.world.timer:tween(2, v, { alpha = 0 }, "linear", function()
                    v:remove()
                end)
            end
            cutscene:wait(2)
        end

		genBigText(
		"0123456789\n" ..
		"QWERTYUIOP\n" ..
		"          \n" ..
		"  ZXCVBNM\n"   ..
		" \"'?!&%★$x", 150, 120, 2, false, 0)
		genBigText("ASDFGHJKL", 175, 215, 2, false, 5)
		fadeOutBigText()
		end
	end
}

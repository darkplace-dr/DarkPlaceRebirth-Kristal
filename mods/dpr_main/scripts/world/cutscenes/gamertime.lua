return {

    labass = function(cutscene, event)
        cutscene:showNametag("Lab Assistant")
        cutscene:text("* This is the way to the gaming room.", nil, event)
        cutscene:text("* I oversee the gaming.", nil, event)
        cutscene:text("* Would you like to return to the Cyber City?", nil, event)
        cutscene:hideNametag()
        if cutscene:choicer({"Yes", "No"}) == 1 then
            Game.world:mapTransition("cybercity/alley2", "gamerexit", "up")
        else
            cutscene:showNametag("Lab Assistant")
            cutscene:text("* Understandable,[wait:5] have a nice day.", nil, event)
            cutscene:hideNametag()
        end
    end,

    station = function(cutscene, event)
        if Game:getFlag("omegaspamton_defeated") then
            cutscene:text("* The gaming stations don't seem to be working.")
        else
            local x,y = event:getRelativePos()
            if Game:isDessMode() then
                cutscene:showNametag("Dess")
                cutscene:text("* oh hey look", "heckyeah", "dess")
                cutscene:text("* a totally original looking game station", "condescending", "dess")
                cutscene:hideNametag()
                cutscene:panTo(x, y + 50, 0.25)
                cutscene:wait(cutscene:walkTo("dess", x + 50, y + 80, 0.25, "up"))
                cutscene:wait(1)
                cutscene:showNametag("Dess")
                cutscene:text("* oh dang it's for two players", "neutral_b", "dess")
                cutscene:text("* ...", "neutral_c", "dess")
                cutscene:text("* eh who cares", "challenging", "dess")
                cutscene:text("* (spoiler alert:[wait:5] I don't)", "teehee", "dess")
                cutscene:text("* okay let's start some[wait:10] [color:red]gaming", "condescending", "dess")
                cutscene:hideNametag()
                Assets.playSound("shadowpendant")
                cutscene:fadeOut(0.5, {color = {1, 1, 1}})
                cutscene:wait(1.5)
                Game.world:mapTransition("gamertime/mainarea", "spawn", "down")
            else
                cutscene:text("* It looks like there's two gaming stations here.")
                if cutscene:getCharacter("susie") and not cutscene:getCharacter("hero") then
                    cutscene:showNametag("Susie")
                    cutscene:text("* Huh,[wait:5] looks like some sort of two-player game?", "surprise", "susie")
                    cutscene:text("* Heh.[wait:5] I'd say I'm pretty good at video games,[wait:5] so...", "smile", "susie")
                    cutscene:text("* Who wants to play with me?", "sincere_smile", "susie")
                    if cutscene:getCharacter("dess") then
                        cutscene:showNametag("Dess")
                        cutscene:text("* ooo ooo me pick me I wanna play", "heckyeah", "dess")
                        cutscene:showNametag("Susie")
                        cutscene:text("* ...", "neutral_side", "susie")
                        cutscene:text("* Anyone other than her?", "annoyed", "susie")
                    end
			    	if Game:getFlag("marcy_joined") and cutscene:getCharacter("jamm") then
			    		cutscene:showNametag("Marcy")
			    		cutscene:text("* Can Marcy play,[wait:5] papa?", "neutral", "marcy")

			    		cutscene:showNametag("Jamm")
			    		cutscene:text("* How about we wait until you can reach the controls?", "wink", "jamm")

                        cutscene:showNametag("Susie")
                        cutscene:text("* Anyone else?", "annoyed", "susie")
			    	end
                    cutscene:hideNametag()
                    cutscene:wait(2)
                    cutscene:text("* ...", "shock_nervous", "susie")
                    cutscene:text("* ... Nobody?", "shy_b", "susie")
                    cutscene:text("* Damn,[wait:5] alright then.", "shy_down", "susie")
                    cutscene:hideNametag()
                    cutscene:text("* Looks like you need someone else in your party.")
                elseif not cutscene:getCharacter("susie") and cutscene:getCharacter("hero") then
                    cutscene:showNametag("Hero")
                    cutscene:text("* This thing looks like some kind of game console...", "neutral_closed", "hero")
                    cutscene:text("* Hm,[wait:5] I can only guess,[wait:5] but...", "suspicious", "hero")
                    cutscene:text("* It seems like 2 players are needed here.", "neutral_closed_b", "hero")
                    cutscene:text("* Any of you guys wanna play it with me?", "happy", "hero")
                    if cutscene:getCharacter("dess") then
                        cutscene:showNametag("Dess")
                        cutscene:text("* ooo ooo me pick me I wanna play", "heckyeah", "dess")
                        cutscene:showNametag("Hero")
                        cutscene:text("* ... Not including you,[wait:5] Dess.", "suspicious", "hero")
                        cutscene:showNametag("Dess")
                        cutscene:text("* This is literally George Orwell's 1984", "angry", "dess")
                    end
			    	if Game:getFlag("marcy_joined") and cutscene:getCharacter("jamm") then
			    		cutscene:showNametag("Marcy")
			    		cutscene:text("* Can Marcy play,[wait:5] papa?", "neutral", "marcy")

			    		cutscene:showNametag("Jamm")
			    		cutscene:text("* How about we wait until you can reach the controls?", "wink", "jamm")
			    	end
                    cutscene:hideNametag()
                    cutscene:wait(2)
                    cutscene:showNametag("Hero")
                    cutscene:text("* ... So nobody?", "neutral_closed_b", "hero")
                    cutscene:text("* Maybe some other time then.", "pout", "hero")
                    cutscene:hideNametag()
                    cutscene:text("* Looks like you need someone else in your party.")
                elseif cutscene:getCharacter("susie") and cutscene:getCharacter("hero") then
                    cutscene:detachCamera()
                    cutscene:detachFollowers()
                    cutscene:walkTo(Game.world.player, x + 40, y + 150, 0.75, "up")
                    for i, v in ipairs(Game.world.followers) do
                        local transformed_x = (i+1 - 1) % 2
                        local transformed_y = math.floor((i+1 - 1) / 2)

                        -- Transform the grid into coordinates
                        local offset_x = transformed_x * 120
                        local offset_y = transformed_y * 40
                        cutscene:walkTo(v, offset_x + x + 40, offset_y + y + 150, 0.75, "up")
                    end
                    cutscene:panTo(x, y + 50)
                    cutscene:wait(1)
                    cutscene:showNametag("Hero")
                    cutscene:text("* This thing looks like some kind of game console...", "neutral_closed", "hero")
                    cutscene:text("* And guessing by the look of it...", "suspicious", "hero")
                    cutscene:text("* I think it's a two-player game!", "neutral_closed_b", "hero")
                    cutscene:showNametag("Susie")
                    cutscene:text("* Really?", "surprise_smile", "susie")
                    cutscene:text("* Hey,[wait:5] wanna play it and see who's better at it?", "smile", "susie")
                    cutscene:showNametag("Hero")
                    cutscene:text("* Do you even need to ask?", "smug", "hero")
                    cutscene:hideNametag()
                    cutscene:walkTo("hero", x + 50, y + 80, 0.75, "up")
                    cutscene:walkTo("susie", x + 110, y + 80, 0.75, "up")
                    cutscene:wait(1)
                    cutscene:showNametag("Susie")
                    cutscene:text("* So,[wait:5] you ready?", "smile", "susie")
                    cutscene:showNametag("Hero")
                    cutscene:text("* Yup!", "happy", "hero")
                    cutscene:text("* Alright,[wait:5] let's get started!", "neutral_smile", "hero")
                    --Game:getPartyMember("hero"):addOpinion("susie", 15)
                    --Game:getPartyMember("susie"):addOpinion("hero", 15)
                    cutscene:hideNametag()
                    Assets.playSound("shadowpendant")
                    cutscene:fadeOut(0.5, {color = {1, 1, 1}})
                    cutscene:wait(1.5)
                    for k,chara in ipairs(Game.party) do
			    		Game:setFlag(chara.id .. "_party", false)
                        if chara.id == "noel" then
                            Game:setFlag("noel_at", "room1")
                        end
			    	end
			    	Game.party = {}
                    Game:addPartyMember("hero")
			    	Game:addPartyMember("susie")
                    Game:setFlag("hero_party", true)
			    	Game:setFlag("susie_party", true)
                    Game.world:mapTransition("gamertime/mainarea", "spawn", "down")
                else
                    cutscene:text("* Unfortunatly,[wait:5] none of your party seems interested in playing it.")
                    if cutscene:getCharacter("dess") then
                        cutscene:showNametag("Dess")
                        cutscene:text("* Hey,[wait:5] what about me?", "eyebrow", "dess")
                        cutscene:hideNametag()
                        cutscene:text("* Unfortunatly,[wait:5] none of your *important party members* seem interested in playing it.")
                        cutscene:showNametag("Dess")
                        cutscene:text("* Ey,[wait:5] fuck you Luigi", "angry", "dess")
                        if cutscene:getCharacter("noel") then
                            cutscene:text("* I hate this mod.", "...", "noel")
                        end
                    end
                    cutscene:hideNametag()
                end
            end
        end
    end,

    start = function(cutscene, event)
        local susie = cutscene:getCharacter("susie")
        local hero = cutscene:getCharacter("hero")
        local dess = cutscene:getCharacter("dess")
        if Game:isDessMode() then
            cutscene:fadeIn(0.5, {color = {1, 1, 1}})
            cutscene:wait(1.5)
            cutscene:showNametag("Dess")
            cutscene:text("* alright I'm in", "heckyeah", "dess")
            cutscene:text("* wait a sec", "eyebrow", "dess")
            cutscene:hideNametag()
            cutscene:wait(0.2)
            dess:setFacing("left")
            cutscene:wait(0.2)
            dess:setFacing("right")
            cutscene:wait(0.2)
            dess:setFacing("up")
            cutscene:wait(0.2)
            dess:setFacing("down")
            cutscene:wait(1)
            cutscene:showNametag("Dess")
            cutscene:text("* am I in one of those shitty kristal mods", "angry", "dess")
            cutscene:text("* oh wait I was already in one all this time", "mspaint", "dess")
            cutscene:text("* this is like just some parody shit", "calm", "dess")
            cutscene:text("* okay yeah uhh let's get moving btw", "neutral", "dess")
			cutscene:text("* oh wait a sec", "eyebrow", "dess")
            cutscene:hideNametag()
			Assets.playSound("boost")
            cutscene:wait(1.5)
			cutscene:text("* (Dess can now ACT!)")
			Game:setFlag("dess_canact", true)
			Game:getPartyMember("dess").has_act = true
            cutscene:showNametag("Dess")
            cutscene:text("* that's better", "heckyeah", "dess")
            cutscene:hideNametag()
        else
            cutscene:detachFollowers()
            susie:setPosition(hero.x - 80, hero.y)
            cutscene:fadeIn(0.5, {color = {1, 1, 1}})
            cutscene:wait(1.5)
            susie:setFacing("right")
            hero:setFacing("left")
            cutscene:showNametag("Susie")
            cutscene:text("* Nice,[wait:5] we're in!", "smile", "susie")
            cutscene:text("* Wait a second...", "suspicious", "susie")
            cutscene:hideNametag()
            hero:setFacing("down")
            cutscene:wait(cutscene:walkTo(susie, susie.x, susie.y + 80, 0.8, "down"))
            cutscene:wait(0.5)
            susie:setFacing("left")
            cutscene:wait(0.5)
            susie:setFacing("right")
            cutscene:wait(0.5)
            susie:setFacing("up")
            cutscene:wait(0.5)
            susie:setFacing("down")
            cutscene:wait(1)
            cutscene:showNametag("Susie")
            cutscene:text("* This kinda looks like the Hometown...", "sus_nervous", "susie")
            cutscene:text("* But at the same time,[wait:5] it's not.", "suspicious", "susie")
            cutscene:hideNametag()
            cutscene:wait(1)
            cutscene:wait(cutscene:walkTo(susie, susie.x, susie.y - 80, 0.8, "right"))
            hero:setFacing("left")
            cutscene:wait(1)
            susie:setSprite("turn_around")
            Assets.playSound("whip_hard")
            cutscene:wait(1)
            cutscene:showNametag("Susie")
            cutscene:text("* GOD DAMN IT HERO WHERE THE HELL ARE WE", "teeth_b", "susie")
            susie:resetSprite()
            susie:setFacing("right")
            cutscene:showNametag("Hero")
            cutscene:text("* No idea.", "neutral_closed", "hero")
            cutscene:text("* Why don't we go and find out?", "smug", "hero")
            cutscene:showNametag("Susie")
            cutscene:text("* Exactly what I thought.", "smile", "susie")
            cutscene:text("* Let's go!", "sincere_smile", "susie")
            cutscene:hideNametag()
            hero:setFacing("down")
            cutscene:alignFollowers()
            cutscene:attachFollowers()
            cutscene:wait(1)
        end
    end,

    berdly = function(cutscene, event)
        cutscene:detachFollowers()
        cutscene:detachCamera()
        local x = event.x + event.width/2
        local y = event.y + event.height/2
        local berdly = cutscene:getCharacter("berdly")
	    local dess = cutscene:getCharacter("dess")
        local hero = cutscene:getCharacter("hero")
        local susie = cutscene:getCharacter("susie")
        Game.world.music:fade(0, 1)
        cutscene:panTo(x, y, 1)
        if berdly then
            if Game:isDessMode() then
                cutscene:walkTo(dess, x, y + 120, 1, "up")
            else
                cutscene:walkTo(hero, x - 30, y + 120, 1, "up")
                cutscene:walkTo(susie, x + 30, y + 120, 1, "up")
            end
            cutscene:showNametag("Berdly")
            cutscene:text("* Open up you stupid door!", "angry_b", "berdly")
            cutscene:hideNametag()
            cutscene:walkTo(berdly, x, y + 40, 0.75, "up", true)
            cutscene:wait(1)
            cutscene:wait(cutscene:walkTo(berdly, x, y + 60, 0.5, "up", true))
            cutscene:wait(cutscene:walkTo(berdly, x, y, 0.2))
            Assets.playSound("impact")
            berdly:shake(4)
	        cutscene:wait(0.5)
	        cutscene:wait(cutscene:walkTo(berdly, x, y + 60, 0.5, "up", true))
            cutscene:wait(cutscene:walkTo(berdly, x, y, 0.2))
            Assets.playSound("impact")
            berdly:shake(4)
	        cutscene:wait(0.5)
	        cutscene:wait(cutscene:walkTo(berdly, x, y + 60, 0.5, "up", true))
            cutscene:wait(cutscene:walkTo(berdly, x, y, 0.2))
            Assets.playSound("impact")
            berdly:shake(4)
	        cutscene:wait(2)
            berdly:setFacing("down")
            cutscene:wait(0.5)
            berdly:alert()
            cutscene:wait(1)
            cutscene:showNametag("Berdly")
            if Game:isDessMode() then
                cutscene:text("* Ah,[wait:5] who might you be,[wait:5] dear maiden?", "neutral", "berdly")
                cutscene:hideNametag()
                local cover = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                cover:setColor(COLORS["black"])
                cover:setParallax(0, 0)
                cover:setLayer(WORLD_LAYERS["below_ui"])
                cover.alpha = 0
                Game.world:addChild(cover)
                dess.layer = cover.layer + 1
                berdly.layer = dess.layer
                Game:setBorder("simple")
                while cover.alpha < 1 do
                    cover.alpha = cover.alpha + 0.01
                    cutscene:wait(0.01)
                end
                cutscene:wait(1)
                Game.world.music:play("deltarune/wind_highplace", 0, 1)
                Game.world.music:fade(1, 1)
                cutscene:showNametag("Berdly")
                cutscene:text("[speed:0.5]* ...", "scared", "berdly")
                cutscene:text("* Uh,[wait:5] hello?", "worried_smile", "berdly")
                cutscene:hideNametag()
                cutscene:wait(cutscene:walkTo(dess, x, dess.y - 60, 3, "up"))
                cutscene:wait(1)
                dess:setSprite("walk/up_2")
                dess:shake(5)
                berdly:shake(5)
                Assets.playSound("impact")
                Game.world.music:fade(0, 1)
                cutscene:wait(1.5)
                cutscene:showNametag("Dess")
                cutscene:text("[speed:0.5][noskip]* ... Fall.", "dess.exe", "dess")
                cutscene:showNametag("Berdly")
                cutscene:text("[noskip]* W-[wait:5]wha-[wait:5]", "scared", "berdly", {auto = true})
                cutscene:hideNametag()

                Assets.playSound("vaporized", 1.2)

                local sprite = berdly.sprite

                sprite.visible = false

                local death_x, death_y = sprite:getRelativePos(0, 0, self)
                local death
                death = DustEffect(sprite:getTexture(), death_x, death_y, true, function() berdly:remove() end)

                death:setColor(sprite:getDrawColor())
                death:setScale(sprite:getScale())
                berdly:addChild(death)
                cutscene:wait(3)
                dess:resetSprite()
                dess:shake(5)
                Assets.playSound("wing")
                cutscene:wait(2)
                Game:setBorder("leaves")
                Game.world.music:play("yiik", 0, 1)
                Game.world.music:fade(1, 1)
                while cover.alpha > 0 do
                    cover.alpha = cover.alpha - 0.01
                    cutscene:wait(0.01)
                end
                dess.layer = 0.6
                cutscene:wait(1)
                Assets.playSound("boost")
                local dess_party = Game:getPartyMember("dess")
                dess_party:increaseStat("health", 25)
                dess_party:increaseStat("attack", 1)
                dess_party:increaseStat("defense", 1)
                dess_party:increaseStat("magic", 1)
                cutscene:text("* (Dess became stronger!)")
            else
                local mus = Music("deltarune/berdly_theme", 0.75)
                cutscene:text("* Susan?[wait:10] Oh thank the Gamer Gods that you're here.", "worried_smile", "berdly")
                cutscene:showNametag("Susie")
                cutscene:text("* Wait,[wait:5] Berdly?", "surprise", "susie")
                cutscene:text("* But if you're here,[wait:5] then...", "suspicious", "susie")
                cutscene:text("* ARE WE NOT ACTUALLY IN A VIDEO GAME RIGHT NOW?!", "teeth", "susie")
                cutscene:text("* Well,[wait:5] I mean,[wait:5] I guess we still are,[wait:5] but...", "shy", "susie")
                cutscene:text("* Something tells me we should probably try not to die.", "nervous", "susie")
                cutscene:showNametag("Berdly")
                cutscene:text("* So if you die in the game,[wait:5] you die in real life?", "surprised", "berdly")
                cutscene:text("* This is just like one of my favorite animes!", "LMAO", "berdly")
                cutscene:text("* Oh,[wait:5] and by the way...", "neutral", "berdly")
                cutscene:text("* Who's that with you?[wait:10] They look awfully a lot like Kris...", "worried_smile", "berdly")
                cutscene:showNametag("Hero")
                cutscene:text("* The name's Hero.", "neutral_closed", "hero")
                cutscene:text("* I guess you could say I'm a friend of Susie's.", "neutral_closed_b", "hero")
                cutscene:showNametag("Berdly")
                cutscene:text("* Ah.[wait:10] Well,[wait:5] any friend of Susan is a friend of mine.", "happy", "berdly")
                cutscene:showNametag("Susie")
                cutscene:text("* Anyways,[wait:5] why were you trying to break down that door?", "neutral", "susie")
                cutscene:showNametag("Berdly")
                cutscene:text("* Well,[wait:5] uh,[wait:5] the thing is...", "scared", "berdly")
                cutscene:text("* Some guy stole some rare items off of me!", "angry_sweat", "berdly")
                cutscene:showNametag("Susie")
                cutscene:text("* Pfft,[wait:5] did you got scammed?", "smile", "susie")
                cutscene:showNametag("Berdly")
                cutscene:text("* What?![wait:10] No,[wait:5] I just,[wait:5] uh...", "scared", "berdly")
                cutscene:text("* Okay so what if I DID get scammed?!", "sad_angry_b", "berdly")
                cutscene:text("* That Spamton guy said he was gonna give me some awesome stuff!", "angry", "berdly")
                cutscene:showNametag("Susie")
                cutscene:text("* Wait,[wait:5] Spamton?!", "shock", "susie")
                cutscene:text("* What's HE doing here???", "surprise_frown", "susie")
                cutscene:showNametag("Hero")
                cutscene:text("* Uh...[wait:5] Who's that?", "neutral_closed_b", "hero")
                cutscene:showNametag("Susie")
                cutscene:text("* A bad guy.", "annoyed", "susie")
                cutscene:text("* He attacked Kris during one of our adventures!", "angry", "susie")
                cutscene:showNametag("Hero")
                cutscene:text("* I see...", "neutral_closed_b", "hero")
                cutscene:hideNametag()
                mus:fade(0, 1)
                cutscene:wait(1)
                cutscene:showNametag("Berdly")
                cutscene:text("* Anyways,[wait:5] we need a bomb if we want to get this door open.", "neutral", "berdly")
                if Game.inventory:hasItem("bomb") then
                    cutscene:showNametag("Hero")
                    cutscene:text("* Oh,[wait:5] we already got that.", "neutral_closed_b", "hero")
                    cutscene:showNametag("Berdly")
                    cutscene:text("* Really?", "scared", "berdly")
                    cutscene:showNametag("Susie")
                    cutscene:text("* Yeah we went on a whole mini adventure without you.", "neutral_side", "susie")
                    cutscene:showNametag("Berdly")
                    cutscene:text("* Oh...", "worried_smile", "berdly")
                    cutscene:showNametag("Susie")
                    cutscene:text("* Sorry dude.", "shy", "susie")
                else
                    cutscene:showNametag("Susie")
                    cutscene:text("* Why specifically a bomb?", "neutral", "susie")
                    cutscene:text("* Can't we just break it down?", "teeth_smile", "susie")
                    cutscene:showNametag("Berdly")
                    cutscene:text("* Trust me,[wait:5] I tried.[wait:10] It's no use.", "sad_angry", "berdly")
                    cutscene:showNametag("Susie")
                    cutscene:text("* Dang.", "shy", "susie")
                    cutscene:text("* Well then,[wait:5] what are we waiting for?", "small_smile", "susie")
                    cutscene:text("* Let's go find that bomb!", "teeth_smile", "susie")
                end
                cutscene:hideNametag()
                Music("deltarune/charjoined", 1, 1, false)
                cutscene:text("* Berdly joined the party!", nil, nil, {skip=false})
                Game.world.music:fade(1, 1)
                Game:unlockPartyMember("berdly")
	            Game:addPartyMember("berdly")
                berdly:convertToFollower()
                cutscene:alignFollowers()
                cutscene:attachFollowers()
                cutscene:wait(1)
                Game:setFlag("berdly_inparty", true)
                Game:setFlag("berdly_party", true)
                if not Game:getFlag("drcastsplitup_known") then
                    cutscene:showNametag("Susie")
                    cutscene:text("* We should uh...", "neutral_side", "susie")
                    cutscene:text("* Probably go find the others after this.", "neutral", "susie")
                    cutscene:hideNametag()
                    Game:getQuest("krismissing"):unlock()
                    Game:getQuest("noellemissing"):unlock()
                    Game:getQuest("berdlymissing"):unlock()
                    Game:getQuest("berdlymissing"):setProgress(1)
                    Game:setFlag("drcastsplitup_known", true)
                else
                    Game:getQuest("berdlymissing"):setProgress(1)
                end
            end
            Game:setFlag("gamer_berdly", true)
        else
            if Game:isDessMode() then
                cutscene:walkTo(dess, x, y + 60, 1, "up")
                cutscene:wait(2)
                cutscene:showNametag("Dess")
                cutscene:text("* ...", "eyebrow", "dess")
                cutscene:text("* my Dess sensors tell me there's something really important missing here", "calm", "dess")
                cutscene:hideNametag()
            else
                cutscene:walkTo(hero, x - 30, y + 60, 1, "up")
                cutscene:walkTo(susie, x + 30, y + 60, 1, "up")
                cutscene:wait(2)
                cutscene:showNametag("Hero")
                cutscene:text("* Odd looking door.", "suspicious", "hero")
                cutscene:showNametag("Susie")
                cutscene:text("* Hey,[wait:5] if we're in a game...", "small_smile", "susie")
                cutscene:text("* I bet there's a lotta loot behind it!", "smile", "susie")
                cutscene:showNametag("Hero")
                cutscene:text("* You make a good point.", "happy", "hero")
                cutscene:hideNametag()
                cutscene:wait(cutscene:walkTo(susie, x, y, 1, "up"))
                cutscene:wait(2)
                susie:setFacing("down")
                cutscene:showNametag("Susie")
                cutscene:text("* Dang,[wait:5] it won't open.", "annoyed", "susie")
                cutscene:showNametag("Hero")
                cutscene:text("* Guess we'll have to find something to open it.", "neutral_closed", "hero")
                cutscene:text("* Perhaps a [color:yellow]key[color:reset]?", "neutral_closed_b", "hero")
                cutscene:showNametag("Susie")
                cutscene:text("* Or a [color:red]bomb[color:reset]!", "smile", "susie")
                cutscene:hideNametag()
                cutscene:wait(2)
                cutscene:showNametag("Susie")
                cutscene:text("* ...", "neutral", "susie")
                cutscene:text("* Oh,[wait:5] by the way...", "sus_nervous", "susie")
                cutscene:text("* Do you also feel like...", "shy", "susie")
                cutscene:showNametag("Hero")
                cutscene:text("* Like something's wrong?[wait:10] Yeah,[wait:5] defiently.", "neutral_opened", "hero")
                cutscene:text("* Though,[wait:5] I can't exactly tell what...", "pout", "hero")
                cutscene:showNametag("Susie")
                cutscene:text("* Weird.", "sus_nervous", "susie")
                cutscene:hideNametag()
                cutscene:alignFollowers()
                cutscene:attachFollowers()
                cutscene:wait(1)
            end
            Game.world.music:fade(1, 1)
        end
        cutscene:wait(cutscene:attachCamera())
    end,

    door = function(cutscene, event)
        if Game.inventory:hasItem("bomb") then
            cutscene:text("* Use the bomb?")
            if cutscene:choicer({"Yes", "No"}) == 1 then
                cutscene:fadeOut(1)
                Game.world.music:fade(0, 1)
		        cutscene:wait(1)
		        Assets.playSound("bomb")
                Game.inventory:removeItem("bomb")
		        cutscene:wait(1)
		        cutscene:fadeIn(1)
		        cutscene:wait(1)
                if Game:isDessMode() then
                    cutscene:showNametag("Dess")
                    cutscene:text("* ", "mspaint", "dess") -- add proper dialogue later
                else
                    cutscene:showNametag("Susie")
                    cutscene:text("* Well,[wait:5] the door's open now.", "small_smile", "susie")
                    if cutscene:getCharacter("berdly") then
                        cutscene:text("* Let's show Spamton how to REALLY steal items!", "smile", "susie")
                        cutscene:showNametag("Hero")
                        cutscene:text("* Let's kick some puppet ass!", "smug", "hero")
                        cutscene:showNametag("Spamton")
                        cutscene:text("[voice:spam_omega]* WHAT!!![wait:10]\n* YOU NEWBIES WANT TO TAKE MY [[Legally sourced]] RARE ITEMS?")
                        cutscene:text("[voice:spam_omega]* WELL,[wait:5] [You're gonna have to try a little HARDER than that]!")
                        cutscene:text("[voice:spam_omega]* I'VE BEEN STOCKING UP ON [[collector's items]]!")
                        cutscene:text("[voice:spam_omega]* THERE'S NO WAY YOU COULD BEAT ME IN [Omega Male] FORM!!")
                        cutscene:showNametag("Berdly")
                        cutscene:text("* Well,[wait:5] I think he's gonna fight us with his scammed loot.", "neutral", "berdly")
                        cutscene:text("* Time to show him who the TRUE gamers are!", "angry", "berdly")
                        cutscene:showNametag("Spamton")
                        cutscene:text("[voice:spam_omega]* I'LL TELL YOU WHAT,[wait:5] YOU [[Big Shots]]...")
                        cutscene:text("[voice:spam_omega]* IT'S ON LIKE [[Legally Distinct Ape]]!!")
                    else
                        cutscene:showNametag("Spamton")
                        cutscene:text("[voice:spam_omega]* WHAT!!![wait:10]\n* YOU NEWBIES WANT TO TAKE MY [[Legally sourced]] RARE ITEMS?")
                        cutscene:showNametag("Susie")
                        cutscene:text("* Wha-[wait:5] Who's there!?", "surprise_frown", "susie")
                        cutscene:showNametag("Spamton")
                        cutscene:text("[voice:spam_omega]* WELL,[wait:5] [You're gonna have to try a little harder than THAT.]!")
                        cutscene:text("[voice:spam_omega]* I'VE BEEN STOCKING UP ON [[collector's items]]!")
                        cutscene:text("[voice:spam_omega]* THERE'S NO WAY YOU COULD BEAT ME IN [Omega Male] FORM!!")
                        cutscene:showNametag("Susie")
                        cutscene:text("* Wait,[wait:5] is it that one guy from Queen's basement!?", "surprise", "susie")
                        cutscene:text("* What was his name again?[wait:5] Spam...[wait:5] Guy?", "surprise_frown", "susie")
                        cutscene:text("* Well,[wait:5] if it's the fight he wants...", "closed_grin", "susie")
                        cutscene:text("* Then it's a fight he'll get!", "teeth_smile", "susie")
                        cutscene:showNametag("Hero")
                        cutscene:text("* Let's kick some puppet ass!", "smug", "hero")
                        cutscene:showNametag("Spamton")
                        cutscene:text("[voice:spam_omega]* I'LL TELL YOU WHAT,[wait:5] YOU [[Big Shots]]...")
                        cutscene:text("[voice:spam_omega]* IT'S ON LIKE [[Legally Distinct Ape]]!!")
                    end
                end
                cutscene:hideNametag()
                cutscene:startEncounter("omegaspamtonbossfight", true)
                Game:setFlag("omegaspamton_defeated", true)
                cutscene:text("* This part is VERY WIP (as you can tell from Spamton not having any unique attacks)")
                cutscene:text("* Uhh I'll finish up the rest of this segment another time")
                cutscene:text("* -BrendaK7200")
                Assets.playSound("shadowpendant")
                cutscene:fadeOut(0.5, {color = {1, 1, 1}})
                cutscene:wait(0.75)
                Game.world:mapTransition("gamertime/entrance", "exit", "down")
                cutscene:wait(0.75)
                cutscene:fadeIn(0.5, {color = {1, 1, 1}})
                cutscene:wait(1.5)
                if Game:isDessMode() then
                    Game:setFlag("dess_canact", false)
			        Game:getPartyMember("dess").has_act = false
                    cutscene:text("* (Dess can no longer ACT.)", nil, nil, {skip=false})
                end
                if cutscene:getCharacter("berdly") then
                    Game:getQuest("berdlymissing"):setProgress(2)
                end
            end
        else
            if Game:isDessMode() then
                cutscene:showNametag("Dess")
                cutscene:text("* that god damn door", "eyebrow", "dess")
                cutscene:text("* can't belive I need a [color:red]nuke[color:reset] to open it", "calm", "dess")
            else
                cutscene:showNametag("Susie")
                cutscene:text("* Why the hell is this stupid door so hard to open?!", "teeth", "susie")
            end
            cutscene:hideNametag()
            cutscene:text("* You need a bomb to open this door.")
        end
    end,

    collision = function(cutscene, event)
        if Game:isDessMode() then
            cutscene:showNametag("Dess")
            cutscene:text("* what the fuck", "eyebrow", "dess")
            cutscene:text("* who designed this place", "mspaint", "dess")
            cutscene:text("* you're telling me I can't fit here?", "angry", "dess")
            cutscene:text("* bs", "angy", "dess")
            cutscene:hideNametag()
        else
            cutscene:showNametag("Susie")
            cutscene:text("* Why the hell can't we go through here?", "angry", "susie")
            cutscene:text("* THERE'S CLEARLY A GAP HERE!!!", "teeth_b", "susie")
            cutscene:showNametag("Hero")
            cutscene:text("* Dude,[wait:5] this collision is ass.", "annoyed", "hero")
            cutscene:hideNametag()
        end
    end,

    wtf = function(cutscene, event)
        if Game:isDessMode() then
            cutscene:showNametag("Dess")
            cutscene:text("* uhh do we have to go there?", "neutral", "dess")
            cutscene:text("* I kinda hate mazes", "eyebrow", "dess")
            cutscene:hideNametag()
            cutscene:choicer({"Yes", "Defiently", "For sure", "Of course"})
            cutscene:showNametag("Dess")
            cutscene:text("* ...", "angry", "dess")
            cutscene:hideNametag()
            cutscene:text("* (Dess will remember that.)")
        else
            cutscene:showNametag("Susie")
            cutscene:text("* ...", "suspicious", "susie")
            cutscene:text("* I REALLY don't wanna go in that maze...", "annoyed", "susie")
            if cutscene:getCharacter("berdly") then
                cutscene:showNametag("Berdly")
                cutscene:text("* Ah,[wait:5] but Susan...", "questioning", "berdly")
                cutscene:text("* What if there's some EPIC GAMER LOOT in there?", "chef_kiss", "berdly", {x = -4}) -- for Deltarune accuracy, Berdly's "chef_kiss" portrait should be offsetted like this.
                cutscene:showNametag("Susie")
                cutscene:text("* ...", "suspicious", "susie")
                cutscene:hideNametag()
            end
        end
    end,

    wasteoftime = function(cutscene, event)
        if Game:isDessMode() then
            cutscene:showNametag("Dess")
            cutscene:text("* okay was this long walk for fucking nothing", "angry", "dess")
            cutscene:text("* yeah I'm suing whoever made this place", "annoyed", "dess")
            cutscene:text("* right after I beat them up with my bat", "heckyeah", "dess")
            cutscene:hideNametag()
        else
            cutscene:showNametag("Susie")
            cutscene:text("* Well,[wait:5] this has been a complete waste of time.", "annoyed", "susie")
            cutscene:showNametag("Hero")
            cutscene:text("* There's gotta be a way to that chest...", "suspicious", "hero")
            cutscene:hideNametag()
        end
    end,

    oob = function(cutscene, event)
        if Game:isDessMode() then
            cutscene:showNametag("Dess")
            cutscene:text("* ah so we CAN go to that chest", "heckyeah", "dess")
            cutscene:text("* yup totally normal game design", "mspaint", "dess")
            cutscene:text("* no flaws at all", "reverse", "dess")
            cutscene:hideNametag()
        else
            if cutscene:getCharacter("berdly") then
                cutscene:showNametag("Berdly")
                cutscene:text("* Ah,[wait:5] clipping out of bounds.", "look_up", "berdly")
                cutscene:text("* The skeleton key for gamers.", "laugh", "berdly")
            end
            cutscene:showNametag("Hero")
            cutscene:text("* Heh,[wait:5] knew there was a way to that chest!", "happy", "hero")
            cutscene:showNametag("Susie")
            cutscene:text("* You do realize we have to walk all the way back,[wait:5] right?", "suspicious", "susie")
            if cutscene:getCharacter("berdly") then
                cutscene:showNametag("Berdly")
                cutscene:text("* ... Oh...", "worried_smile", "berdly")
            end
            cutscene:showNametag("Hero")
            cutscene:text("* God damnit...", "annoyed", "hero")
            cutscene:hideNametag()
        end
    end,

    getbombs = function(cutscene, event)
        if Game:isDessMode() then
            cutscene:showNametag("Dess")
            cutscene:text("* oh look it's very original looking structure", "condescending", "dess")
            cutscene:text("* that is totally not made with stolen assets from Deltarune:tm:", "heckyeah", "dess")
            cutscene:text("* oh yeah there better be something to open the damn door", "neutral", "dess")
            cutscene:text("* or else I'm gonna make sure this place gets added to lostmedia.com", "dess.exe", "dess")
            cutscene:hideNametag()
        else
            if cutscene:getCharacter("berdly") then
                cutscene:showNametag("Berdly")
                cutscene:text("* Ah,[wait:5] there should be bombs in this here structure.", "happy", "berdly")
                cutscene:showNametag("Susie")
                cutscene:text("* How do you know?", "suspicious", "susie")
                cutscene:showNametag("Berdly")
                cutscene:text("* Well Susan,[wait:4] it's simple.", "smirk", "berdly")
                cutscene:text("* Process of elimination.", "smile", "berdly")
                cutscene:text("* This is the only place we haven't explored yet.", "smirk", "berdly")
                cutscene:showNametag("Hero")
                cutscene:text("* Well...", "neutral_closed", "hero")
                cutscene:text("* That actually makes sense...", "neutral_closed_b", "hero")
                cutscene:showNametag("Susie")
                cutscene:text("* Yeah,[wait:5] honestly I'm impressed by that.", "neutral_side", "susie")
                cutscene:showNametag("Berdly")
                cutscene:text("* Oh stop,[wait:5] you're going to make me blush,[wait:5] Susan", "godly", "berdly")
                cutscene:hideNametag()
            else
                cutscene:showNametag("Hero")
                cutscene:text("* Oh hey,[wait:5] there might be bombs in there.", "neutral_closed", "hero")
                cutscene:showNametag("Susie")
                cutscene:text("* Well then,[wait:5] let's check it out.", "small_smile", "susie")
                cutscene:hideNametag()
            end
        end
    end

}

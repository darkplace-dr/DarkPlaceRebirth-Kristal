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
            cutscene:text("* It looks like there's two gaming stations here.")
            if cutscene:getCharacter("susie") and not cutscene:getCharacter("brenda") then
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
            elseif not cutscene:getCharacter("susie") and cutscene:getCharacter("brenda") then
                cutscene:showNametag("Brenda")
                cutscene:text("* Oh shoot,[wait:5] I think I've seen one of these things before.", "shock", "brenda")
                cutscene:text("* So basically,[wait:5] I think this is a two-player game.", "happy", "brenda")
                cutscene:text("* Any of you guys wanna play it with me?", "happy_side", "brenda")
                if cutscene:getCharacter("dess") then
                    cutscene:showNametag("Dess")
                    cutscene:text("* ooo ooo me pick me I wanna play", "heckyeah", "dess")
                    cutscene:showNametag("Brenda")
                    cutscene:text("* ... Not including you,[wait:5] Dess.", "dissapointed", "brenda")
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
                cutscene:showNametag("Brenda")
                cutscene:text("* ... Wow okay,[wait:5] so none of you guys?", "suspicious", "brenda")
                cutscene:text("* Can't believe I'm the only person into video games here.", "frown", "brenda")
                cutscene:hideNametag()
                cutscene:text("* Looks like you need someone else in your party.")
            elseif cutscene:getCharacter("susie") and cutscene:getCharacter("brenda") then
                local x,y = event:getRelativePos()
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
                cutscene:showNametag("Brenda")
                cutscene:text("* Oh shoot,[wait:5] I think I've seen one of these things before.", "shock", "brenda")
                cutscene:showNametag("Susie")
                cutscene:text("* You have?", "surprise_smile", "susie")
                cutscene:showNametag("Brenda")
                cutscene:text("* Yeah,[wait:5] I'm pretty sure this is some two-player game.", "happy", "brenda")
                cutscene:showNametag("Susie")
                cutscene:text("* Really?", "surprise_smile", "susie")
                cutscene:text("* Hey,[wait:5] wanna see who's better at this game?", "smile", "susie")
                cutscene:showNametag("Brenda")
                cutscene:text("* Yeah,[wait:5] sure!", "grin", "brenda")
                cutscene:hideNametag()
                cutscene:walkTo("susie", x + 50, y + 80, 0.75, "up")
                cutscene:walkTo("brenda", x + 110, y + 80, 0.75, "up")
                cutscene:wait(1)
                cutscene:showNametag("Susie")
                cutscene:text("* So,[wait:5] you ready?", "smile", "susie")
                cutscene:showNametag("Brenda")
                cutscene:text("* Yup!", "happy_b", "brenda")
                cutscene:text("* Alright,[wait:5] let's get started!", "happy", "brenda")
                Game:getPartyMember("brenda"):addOpinion("susie", 15)
                Game:getPartyMember("susie"):addOpinion("brenda", 15)
                cutscene:hideNametag()
                for k,chara in ipairs(Game.party) do
					Game:setFlag(chara.id .. "_party", false)
                    if chara.id == "noel" then
                        Game:setFlag("noel_at", "room1")
                    end
				end
				Game.party = {}
				Game:addPartyMember("susie")
				Game:addPartyMember("brenda")
				Game:setFlag("susie_party", true)
				Game:setFlag("brenda_party", true)
                Game.world:mapTransition("gamertimemain", "spawn", "down")
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
        
    end,

    start = function(cutscene, event)
    end,

    berdly = function(cutscene, event)
        cutscene:detachFollowers()
        local x = event.x + event.width/2
        local y = event.y + event.height/2
        local berdly = cutscene:getCharacter("berdly")
	    local dess = cutscene:getCharacter("dess")
        Game.world.music:fade(0, 1)
        if berdly then
            if Game:isDessMode() then
                cutscene:walkTo(dess, x, y + 120, 1, "up")
            end
            cutscene:showNametag("Berdly")
            cutscene:text("* Open up you stupid door!", "angry_b", "berdly")
            cutscene:hideNametag()
            cutscene:walkTo(berdly, x, y + 40, 0.75, "up", true)
            cutscene:wait(1)
            cutscene:wait(cutscene:walkTo(berdly, x, y + 60, 0.5, "up", true))
            cutscene:wait(cutscene:walkTo(berdly, x, y + 20, 0.2))
            Assets.playSound("impact")
            berdly:shake(4)
	        cutscene:wait(0.5)
	        cutscene:wait(cutscene:walkTo(berdly, x, y + 60, 0.5, "up", true))
            cutscene:wait(cutscene:walkTo(berdly, x, y + 20, 0.2))
            Assets.playSound("impact")
            berdly:shake(4)
	        cutscene:wait(0.5)
	        cutscene:wait(cutscene:walkTo(berdly, x, y + 60, 0.5, "up", true))
            cutscene:wait(cutscene:walkTo(berdly, x, y + 20, 0.2))
            Assets.playSound("impact")
            berdly:shake(4)
	        cutscene:wait(2)
            if Game:isDessMode() then
                berdly:setFacing("down")
                cutscene:wait(0.5)
                berdly:alert()
                cutscene:wait(1)
                cutscene:showNametag("Berdly")
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
                death = DustEffect(sprite:getTexture(), death_x, death_y, function() berdly:remove() end)
                 
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
            end
            Game:setFlag("gamer_berdly", true)
        end
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
                cutscene:showNametag("Susie")
                cutscene:text("* Well,[wait:5] the door's open now.", "small_smile", "susie")
                if cutscene:getCharacter("berdly") then
                    cutscene:text("* Let's show Spamton how to REALLY steal items!", "smile", "susie")
                    cutscene:showNametag("Brenda")
                    cutscene:text("* Let's kick some puppet ass!", "smug", "brenda")
                    cutscene:showNametag("Spamton")
                    cutscene:text("[voice:spamton2]* WHAT!!![wait:10]\n* YOU NEWBIES WANT TO TAKE MY [[Legally sourced]] RARE ITEMS?")
                    cutscene:text("[voice:spamton2]* WELL,[wait:5] [You're gonna have to try a little HARDER than that]!")
                    cutscene:text("[voice:spamton2]* I'VE BEEN STOCKING UP ON [[collector's items]]!")
                    cutscene:text("[voice:spamton2]* THERE'S NO WAY YOU COULD BEAT ME IN [Omega Male] FORM!!")
                    cutscene:showNametag("Berdly")
                    cutscene:text("* Well,[wait:5] I think he's gonna fight us with his scammed loot.", "neutral", "berdly")
                    cutscene:text("* Time to show him who the TRUE gamers are!", "angry", "berdly")
                    cutscene:showNametag("Spamton")
                    cutscene:text("[voice:spamton2]* I'LL TELL YOU WHAT,[wait:5] YOU [[Big Shots]]...")
                    cutscene:text("[voice:spamton2]* IT'S ON LIKE [[Legally Distinct Ape]]!!")
                else
                    cutscene:showNametag("Spamton")
                    cutscene:text("[voice:spamton2]* WHAT!!![wait:10]\n* YOU NEWBIES WANT TO TAKE MY [[Legally sourced]] RARE ITEMS?")
                    cutscene:showNametag("Susie")
                    cutscene:text("* Wha-[wait:5] Who's there!?", "surprise_frown", "susie")
                    cutscene:showNametag("Spamton")
                    cutscene:text("[voice:spamton2]* WELL,[wait:5] [You're gonna have to try a little HARDER than that]!")
                    cutscene:text("[voice:spamton2]* I'VE BEEN STOCKING UP ON [[collector's items]]!")
                    cutscene:text("[voice:spamton2]* THERE'S NO WAY YOU COULD BEAT ME IN [Omega Male] FORM!!")
                    cutscene:showNametag("Susie")
                    cutscene:text("* Wait,[wait:5] is it that one guy from Queen's basement!?", "surprise", "susie")
                    cutscene:text("* What was his name again?[wait:5] Spam...[wait:5] Guy?", "surprise_frown", "susie")
                    cutscene:showNametag("Brenda")
                    cutscene:text("* You mean Spamton?", "neutral_side", "brenda")
                    cutscene:showNametag("Susie")
                    cutscene:text("* Yeah,[wait:5] HIM!", "teeth", "susie")
                    cutscene:text("* Well,[wait:5] if it's the fight he wants...", "closed_grin", "susie")
                    cutscene:text("* Then it's a fight he'll get!", "teeth_smile", "susie")
                    cutscene:showNametag("Brenda")
                    cutscene:text("* Let's kick some puppet ass!", "smug", "brenda")
                    cutscene:showNametag("Spamton")
                    cutscene:text("[voice:spamton2]* I'LL TELL YOU WHAT,[wait:5] YOU [[Big Shots]]...")
                    cutscene:text("[voice:spamton2]* IT'S ON LIKE [[Legally Distinct Ape]]!!")
                end
                cutscene:hideNametag()
                cutscene:startEncounter("omegaspamtonbossfight", true)
                Game:setFlag("omegaspamton_defeated", true)
                cutscene:text("* This part is VERY WIP (as you can tell from Spamton not having any unique attacks)")
                cutscene:text("* Uhh I'll finish up the rest of this segment another time")
                cutscene:text("* -BrendaK7200")
                Game.world:mapTransition("gamertimeentrance", "exit", "down")
                local susie_party = Game:getPartyMember("susie")
                susie_party.has_act = false
                Game:setFlag("susie_canact", false)
                if cutscene:getCharacter("berdly") then
                    Kristal.callEvent("setDesc", "berdlymissing", "Berdly has been saved! Unfortunatly the gaming stations used to access him seem to not be working anymore, so returning to that place seems to be impossible, at least for now.")
                    Kristal.callEvent("completeQuest", "berdlymissing")
                end
            end
        else
            cutscene:showNametag("Susie")
            cutscene:text("* Why the hell is this stupid door so hard to open?!", "teeth", "susie")
            cutscene:hideNametag()
            cutscene:text("* You need a bomb to open this door.")
        end
    end,

    collision = function(cutscene, event)
        cutscene:showNametag("Susie")
        cutscene:text("* Why the hell can't we go through here?", "angry", "susie")
        cutscene:text("* THERE'S CLEARLY A GAP HERE!!!", "teeth_b", "susie")
        cutscene:showNametag("Brenda")
        cutscene:text("* Dude,[wait:5] this collision is ass!", "grin", "brenda")
        cutscene:hideNametag()
    end,

    wtf = function(cutscene, event)
        cutscene:showNametag("Susie")
        cutscene:text("* ...", "suspicious", "susie")
        cutscene:text("* I REALLY don't wanna go in that maze...", "annoyed", "susie")
        if cutscene:getCharacter("berdly") then
            cutscene:showNametag("Berdly")
            cutscene:text("* Ah,[wait:5] but Susan...", "questioning", "berdly")
            cutscene:text("* What if there's some EPIC GAMER LOOT in there?", "chef_kiss", "berdly", {x = -4}) -- for Deltarune accuracy, Berdly's "chef_kiss" portrait should be offsetted like this.
            cutscene:showNametag("Susie")
            cutscene:text("* ...", "suspicious", "susie")
        end
        cutscene:hideNametag()
    end,

    wasteoftime = function(cutscene, event)
        cutscene:showNametag("Susie")
        cutscene:text("* Well,[wait:5] this has been a complete waste of time.", "annoyed", "susie")
        cutscene:showNametag("Brenda")
        cutscene:text("* There's gotta be a way to that chest...", "neutral_side", "brenda")
        cutscene:hideNametag()
    end,

    oob = function(cutscene, event)
        if cutscene:getCharacter("berdly") then
            cutscene:showNametag("Berdly")
            cutscene:text("* Ah,[wait:5] clipping out of bounds.", "look_up", "berdly")
            cutscene:text("* The skeleton key for gamers.", "laugh", "berdly")
        end
        cutscene:showNametag("Brenda")
        cutscene:text("* Hah,[wait:5] knew there was a way to that chest!", "happy_b", "brenda")
        cutscene:showNametag("Susie")
        cutscene:text("* You do realize we have to walk all the way back,[wait:5] right?", "suspicious", "susie")
        if cutscene:getCharacter("berdly") then
            cutscene:showNametag("Berdly")
            cutscene:text("* ... Oh...", "worried_smile", "berdly")
        end
        cutscene:showNametag("Brenda")
        cutscene:text("* God damnit...", "miffed", "brenda")
        cutscene:hideNametag()
    end,

    getbombs = function(cutscene, event)
        if cutscene:getCharacter("berdly") then
            cutscene:showNametag("Berdly")
            cutscene:text("* Ah,[wait:5] there should be bombs in this here structure.", "happy", "berdly")
            cutscene:showNametag("Susie")
            cutscene:text("* How do you know?", "suspicious", "susie")
            cutscene:showNametag("Berdly")
            cutscene:text("* Well Susan,[wait:4] it's simple.", "smirk", "berdly")
            cutscene:text("* Process of elimination.", "smile", "berdly")
            cutscene:text("* This is the only place we haven't explored yet.", "smirk", "berdly")
            cutscene:showNametag("Brenda")
            cutscene:text("* That...", "neutral_side", "brenda")
            cutscene:text("* Actually makes sense????", "shock", "brenda")
            cutscene:showNametag("Susie")
            cutscene:text("* Yeah,[wait:5] honestly I'm impressed.", "neutral_side", "susie")
            cutscene:showNametag("Berdly")
            cutscene:text("* Oh stop,[wait:5] you're going to make me blush,[wait:5] Susan", "godly", "berdly")
            cutscene:hideNametag()
        else
            cutscene:showNametag("Brenda")
            cutscene:text("* Oh hey,[wait:5] there might be bombs in there.", "happy_side", "brenda")
            cutscene:showNametag("Susie")
            cutscene:text("* Well then,[wait:5] let's check it out.", "small_smile", "susie")
            cutscene:hideNametag()
        end
    end

}

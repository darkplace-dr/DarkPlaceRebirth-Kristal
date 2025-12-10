return {
    ---@param cutscene WorldCutscene
    i_remember_youre = function(cutscene, event, player)
        local sans_meme = cutscene:getCharacter("sans_meme")
        local trashnado = Game.world:getEvent(12)
		
        if not Game.world.sanscheck then
            Game.world.sanscheck = 0
        end

        local function flashScreen()
            local flash = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
            flash.layer = 100
            flash.color = { 1, 1, 1 }
            flash.alpha = 1
            flash.parallax_x = 0
            flash.parallax_y = 0
            Game.world:addChild(flash)
            Game.world.timer:tween(1.5, flash, { alpha = 0 }, "linear", function()
                flash:remove()
            end)
        end

        local function shakeScreen()
            cutscene:shakeCamera(10)
        end

		local function remembering()
            Game.world.music:pause()
            if Game.world.sanscheck == 1 then
                sans_meme:setSprite("neutrals")
            elseif Game.world.sanscheck == 2 then
                sans_meme:setSprite("pacifists")
            elseif Game.world.sanscheck == 3 then
                sans_meme:setSprite("non_binary")
            elseif Game.world.sanscheck == "3alt" then
                sans_meme:setSprite("transgender")
            elseif Game.world.sanscheck == 4 then
                sans_meme:setSprite("search_history")
            elseif Game.world.sanscheck == 5 then
                sans_meme:setSprite("depressed")
            elseif Game.world.sanscheck == 7 then
                sans_meme:setSprite("wtf")
            end
		end

        if Game.world.sanscheck == 0 then
            cutscene:showNametag("Sans?", {font = "sans"})
            cutscene:text("[font:sans]* human..[wait:5] i remember you're [wait:10][facec:sans/meme/genocides][func:1][func:2][sound:vineboom][style:GONER][color:red][instant]genocides.[stopinstant][color:reset]", "serious", "sans", {
                functions = {
                    flashScreen,
                    remembering,
                }
            })
            cutscene:hideNametag()
            Game.world.music:resume()
        elseif Game.world.sanscheck == 1 then
            cutscene:showNametag("Sans?", {font = "sans"})
            cutscene:text("[font:sans]* human..[wait:5] i remember you're [wait:10][facec:sans/meme/neutrals][func:1][func:2][sound:mercyadd][style:GONER][instant][color:yellow]neutrals.[stopinstant][color:reset]", "serious", "sans", {
                functions = {
                    flashScreen,
                    remembering,
                }
            })
            cutscene:hideNametag()
            Game.world.music:resume()
        elseif Game.world.sanscheck == 2 then
            cutscene:showNametag("Sans?", {font = "sans"})
            cutscene:text("[font:sans]* human..[wait:5] i remember you're [wait:10][facec:sans/meme/pacifists][func:1][func:2][sound:sparkle_glock][style:GONER][color:green][instant]pacifists.[stopinstant][color:reset]", "serious", "sans", {
                functions = {
                    flashScreen,
                    remembering,
                }
            })
            cutscene:hideNametag()
            Game.world.music:resume()
        elseif Game.world.sanscheck == 3 then
            cutscene:showNametag("Sans?", {font = "sans"})
            cutscene:text("[font:sans]* human..[wait:5] i remember you're [wait:10][facec:sans/meme/nonbinary][func:1][func:2][sound:sparkle_gem][style:GONER][instant][color:yellow]no[color:white]n-[color:purple]bin[color:404040]ary.[stopinstant][color:reset]", "serious", "sans", {
                functions = {
                    flashScreen,
                    remembering,
                }
            })
            if Game.world:getCharacter("brenda_lw") then
                cutscene:showNametag("Brenda")
                cutscene:text("* Uh,[wait:5] I'm trans,[wait:5] not non-binary.", "suspicious", "brenda")
                cutscene:showNametag("Sans?", {font = "sans"})
                cutscene:text("[font:sans]* oh.", "neutral", "sans")
                Game.world.sanscheck = "3alt"
                sans_meme:resetSprite()
                cutscene:text("[font:sans]* human..[wait:5] i remember you're [wait:10][facec:sans/meme/nonbinary][func:1][func:2][sound:sparkle_gem][style:GONER][instant][color:#00FFFF]tr[color:pink]an[color:white]sge[color:pink]nd[color:#00FFFF]er.[stopinstant][color:reset]", "serious", "sans", {
                    functions = {
                        flashScreen,
                        remembering,
                    }
                })
                Game.world.sanscheck = 3
            end
            cutscene:hideNametag()
            Game.world.music:resume()
        elseif Game.world.sanscheck == 4 then
            cutscene:showNametag("Sans?", {font = "sans"})
            cutscene:text("[font:sans]* human..[wait:5] i remember you're [wait:10][facec:sans/meme/searchhistory][func:1][func:2][sound:fartrevshort][style:GONER][instant][color:ff8000]search history.[stopinstant][color:reset]", "serious", "sans", {
                functions = {
                    flashScreen,
                    remembering,
                }
            })
            cutscene:hideNametag()
            Game.world.music:resume()
        elseif Game.world.sanscheck == 5 then
            cutscene:showNametag("Sans?", {font = "sans"})
            cutscene:text("[font:sans]* human[wait:10]\n* i am [wait:10][facec:sans/meme/depressed][func:1][func:2][sound:boowomp][style:GONER][instant][color:4782c9]depressed.[stopinstant][color:reset]", "serious", "sans", {
                functions = {
                    flashScreen,
                    remembering,
                }
            })
            cutscene:hideNametag()
            Game.world.music:resume()
        elseif Game.world.sanscheck == 6 then
            Game.world.music:pause()
            sans_meme:explode(0, 0, true)
            cutscene:wait(0.2)
            sans_meme:setSprite("bbg")
            cutscene:wait(2)
            cutscene:showNametag("Sans?", {font = "sans"})
            cutscene:text("[noskip][voice:none][font:sans]*[sound:daddygirl] baby girl?[wait:50]\n* [sound:babyhome][sound:vineboom][func:1][style:GONER][color:red]daddy's[stopinstant][style:none][color:reset] home.", "meme/bbg", "sans", {
                functions = {
                    flashScreen,
                }
            })
            cutscene:hideNametag()
            Game.world.music:resume()
        elseif Game.world.sanscheck == 7 then
            Game.world.music:pause()
            cutscene:showNametag("Sans?", {font = "sans"})
            cutscene:text("[font:sans]* what[wait:20] the [wait:20][facec:sans/meme/wtf][func:1][func:2][sound:heavydamage][instant]FUCK.[stopinstant]", "serious", "sans", {
                functions = {
                    remembering,
                    shakeScreen,
                }
            })
            cutscene:hideNametag()
            Game.world.music:resume()
        elseif Game.world.sanscheck >= 8 then
		    local FUN = Game:getFlag("FUN")
            if FUN == 8 then
                cutscene:showNametag("Sans?", {font = "sans"})
                cutscene:text("[font:sans]* human...", "eyes_closed", "sans")
                cutscene:hideNametag()
                cutscene:wait(1)
                Game.world.music:pause()
                Assets.playSound("noise")
            
                local dark = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                dark.layer = 9999
                dark.color = { 0, 0, 0 }
                dark.alpha = 1
                dark.parallax_x = 0
                dark.parallax_y = 0
                Game.world:addChild(dark)

                cutscene:wait(0.2)
                Assets.playSound("noise")
                dark.layer = sans_meme.layer - 0.1
                sans_meme:setSprite("lich")
                trashnado:remove()

                cutscene:wait(0.5)
                cutscene:text("* [facec:sans/meme/lich, -18, -10][voice:nil][sound:fall_lich][style:GONER][color:18be14]F a l l .", nil, "sans")
                cutscene:hideNametag()
			
                Assets.playSound("locker")

                for _, party in ipairs(Game.party) do
                    local pc = cutscene:getCharacter(party:getActor().id)
                    pc:shake(4, 0)
                    pc:setSprite("battle/hurt")
                    if player.facing == "left" then
                        pc.flip_x = true
                    end
                end
                cutscene:wait(0.25)

                Assets.stopSound("locker")
                Kristal.hideBorder(0)
                Game.state = "GAMEOVER"
                Game.world:remove()
                Game.gameover = GameOver(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, "[voice:sans]You are alone,[wait:5]\nchild.") -- custom message doesn't work??? Ah well.
                Game.stage:addChild(Game.gameover)
            else
                cutscene:showNametag("Sans?", {font = "sans"})
                cutscene:text("[font:sans]* human..[wait:5] i remember you're...", "serious", "sans")
                cutscene:text("[font:sans]* ...", "serious", "sans")
                cutscene:hideNametag()
                cutscene:wait(2)
                Assets.playSound("wing")
                sans_meme:setSprite("forgor")
                sans_meme:shake(4, 0)
                cutscene:wait(0.5)
                cutscene:text("[font:sans]* uhhh [wait:5][func:1][func:2][sound:vineboom][style:GONER][color:red][instant]shit[stopinstant][style:none][color:reset][wait:5] uhhh[wait:10] the [func:1][func:2][sound:vineboom][style:GONER][color:red][instant]fuck[stopinstant][style:none][color:reset]\n was i gonna say uhh", "meme/forgor", "sans", {
                    functions = {
                        flashScreen,
                        remembering,
                    }
                })
                cutscene:hideNametag()
                Game.world.music:resume()
            end
        end
        sans_meme:resetSprite()
		
        if Game.world.sanscheck < 8 then
            Game.world.sanscheck = Game.world.sanscheck + 1
        end
    end,

    hospitalpiano = function(cutscene, event)

        cutscene:text("* (It's an obligatory hospital piano,[wait:5] shrunk to fit in the corner.)")
        cutscene:text("* (As a result,[wait:5] it's missing most of the good keys.)")
        cutscene:text("* (Play it?)")
        local opinion = cutscene:choicer({"Yes", "No"})
            if opinion == 1 then
                Assets.playSound("pianonoise")
                cutscene:text("* (Plink...)")
            else
                cutscene:text("* (Your hands linger over the keys doing nothing.)")
                
            end
        
    end,

    pre_knight_corner = function (cutscene, event)
        local susie = cutscene:getCharacter("susie")
        if Game:getFlag("knight_corner", false) then
            if cutscene:getCharacter(susie) then
                cutscene:text("* (It's a door.)")
                cutscene:text("* That's the uh, mayor's office.", "sus_nervous", susie)
                cutscene:text("* If we got in we would be in big trouble.", "nervous_side", susie)
                cutscene:text("* Not like i care, let's go.", "teeth_smile", susie)
            end
        end
    end,

    hospitaltoy = function(cutscene, event)

        cutscene:text("* (It's a toy with beads on a track.)")
        if Game:getFlag("POST_SNOWGRAVE") then
            cutscene:text("* (One of the blue beads is broken and torn off.)")
        else
            cutscene:text("* (The beads of the toy march on.)")
        end
        
    end,

    asgorefridge = function(cutscene, event)
        
        cutscene:text("* (It's a rusty fridge with some photos on it.)")
        local opinion = cutscene:choicer({"\nOpen\nFridge\n", "Don't", "See photos"})
        if opinion == 1 then
          cutscene:text("* (All that's inside is a jar with a single pickle in it...)")
        elseif opinion == 3 then
            local characters_who_knows_dreemurr = {
                "susie",
                "noelle",
                "berdly",
                "jamm",
                "ceroba",
                "noel"
            }
            local leader_id = GeneralUtils:getLeader().id
            if leader_id == "kris" then
                cutscene:text("* (A photo of your mother and father on their wedding day.)")
            elseif Utils.containsValue(characters_who_knows_dreemurr, leader_id) then
                cutscene:text("* (A photo of Toriel and Asgore on their wedding day.)")
            else
                cutscene:text("* (A photo of two goat monsters on their wedding day.)")
            end
          cutscene:text("* (She's holding a bouquet of seven flowers.)")
          cutscene:text("* (A reindeer-looking monster stands nearby in a tuxedo.)")
          cutscene:text("* (They all look happy.)")
        else
          cutscene:text("* (You decide not to look.)")  
        end
    end,

    asgoretruck = function(cutscene, event)
        local leader_id = GeneralUtils:getLeader().id
        if leader_id == "kris" then
            cutscene:text("* (It's your dad's truck.)")
            cutscene:text("* (The floor of the front seat is littered with old papers and country CDs...)")
        elseif leader_id == "dess" or Game:isDessMode() then
            local dess = cutscene:getCharacter("dess")

            cutscene:showNametag("Dess")
            cutscene:text("* ...", "neutral", dess)
            cutscene:text("* ...", "neutral_b", dess)
	        dess:setFacing("down")
            cutscene:text("* Oh you think you're REAL fuckin' funny, dont'cha", "angry", dess)
            cutscene:text("* you think I DON'T know why you're making me look at the truck?", "annoyed", dess)
            cutscene:text("* well guess wHAT", "angy", dess)
            cutscene:hideNametag()

            Game.world.timer:tween(3, Game.world.music, { pitch = 0.01 })
            cutscene:wait(3)
            Game.world.music:pause()

            cutscene:showNametag("Dess")
            cutscene:textTagged("* Hope ya saved yer game bitch", "wink", dess)
            cutscene:hideNametag()

            Game.world.fader:fadeOut(nil, {alpha = 1, speed = 10})
            Assets.playSound("noise")
            cutscene:wait(1)

		    Kristal.returnToMenu() -- :]
        else
            cutscene:text("* (It's a blue pickup truck.)")
            cutscene:text("* (The floor of the front seat is littered with old papers and country CDs...)")
        end
    end,

    librarybook1 = function(cutscene, event)

      cutscene:text("* How To Care For A Human")
      cutscene:text("* (It's a book for monsters about how to care for humans.)")
      local opinion = cutscene:choicer({"Look in\nthe back", "Look inside"})
        if opinion == 1 then
          cutscene:text("* (According to the card in the back...)")
          cutscene:text("* (... looks like your mother took it repeatedly many years ago.)")
        else
            cutscene:text("* (There are photos of unfamiliar humans inside.)")
            local leader_id = GeneralUtils:getLeader().id
            if leader_id == "kris" then
                cutscene:text("* (You shut the book quickly.)")
            end
        end

    end,

    librarybook2 = function(cutscene, event)

      cutscene:text("* (It's BOOK 1 about SOULS. Read it?)")
      local opinion = cutscene:choicer({"Read", "Don't"})
        if opinion == 1 then
          cutscene:text("* The SOUL has been called many things.")
          cutscene:text("* The font of our compassion. The source of our will.")
          cutscene:text("* The container of our \"life force.\"")
          cutscene:text("* But even now,[wait:5] the true function of it is unknown.")
        end

    end,

    papyrushouse = function(cutscene, event)

      Assets.playSound("knock")
      cutscene:text("* (Knock knock knock...)")
      cutscene:text("* (...)")
      cutscene:text("* (No response...)\n[wait:5]* (... not even the distant trousle of bones.)")

    end,

    sansplin = function(cutscene, event)

      Assets.playSound("bell")

    end,

    iceesoda = function(cutscene, event)

      cutscene:text("* (It's a soda-dispensing machine.)")
      local opinion = cutscene:choicer({"Inspect", "Not"})
        if opinion == 1 then
          cutscene:text("* (You took a look at the flavors.)")
          cutscene:text("* WATER")
          cutscene:text("* ICE")
          cutscene:text("* DOUBLE-ICE")
          cutscene:text("* BREAD")
          cutscene:text("* FLAMIN HOT CHEESE SODA")
          cutscene:text("* GAMER BLOOD ENERGY DRINK")
          cutscene:text("* Juice (Red Flavor)")
        end

    end,
	
    toilet = function(cutscene, event)
        cutscene:text("* (It's a toilet.)[wait:5]\n* (Flush it?)")
        local choice = cutscene:choicer({"Yes", "No"})
        if choice == 1 then
            Game.world.music:fade(0,0.001)
            Assets.playSound("toilet")
			
            cutscene:wait(1)
			
            Assets.playSound("won")
            cutscene:text("* (You flushed the toilet!)")
            Game.world.music:fade(1,1)
        end
    end,
	
    asriel_bed = function(cutscene, event)
        if Game.party[1].id == "YOU" then
            cutscene:text("* It looks like one of the beds from the inn you were staying at.")
            cutscene:text("* Still in perfect condition...[wait:1s] for now.")
            if Game:hasPartyMember("susie") then
                cutscene:showNametag("Susie")
                cutscene:text("* (Why do they look like they want to eat it???)", "nervous_side", "susie")
                cutscene:hideNametag()
            end
        else
            cutscene:text("* There are CDs under the bed.\n[wait:5]* Classical,[wait:5] jazz,[wait:5] religious ska...")
            cutscene:text("* There's also a game console.\n[wait:5]* It has one normal controller,[wait:5] and one knock-off one.")
        end
    end,

    torcar = function(cutscene, event)
        if Game.party[1].id == "kris" then
            cutscene:text("* (It's your mom's car.)")
            cutscene:text("* (Seems like she hasn't replaced the tires yet, judging by the slashes.)")
        elseif Game.party[1].id == "YOU" then
            cutscene:text("* (Looks like the same car that you and Toriel drove in to the orphanage.)")
            cutscene:text("* (...)")
            cutscene:text("* (Actually wait,[wait:5] wasn't it a freight train?)")
            cutscene:text("* (Wait,[wait:5] no. It was an airliner,[wait:5] wasn't it?)")
            cutscene:text("* (No no no,[wait:5] it was a tricycle that suddenly sprouted legs and ran off,[wait:5] right???)")
            cutscene:text("* (...)")
            cutscene:text("* (Well regardless,[wait:5] the car just looks familiar to you.)")
        else
            cutscene:text("* (A red car that can hold up to at least four people.)")
            cutscene:text("* (The tires on the car appear to be slashed.)")
        end
    end,
	
    secret_path = function(cutscene, event)
        local hometown_foundSecretPath = Game:getFlag("hometown_foundSecretPath", false)
        local player = Game.world.player
		
        if hometown_foundSecretPath == false then
            cutscene:text("* (!?)[wait:5]\n* (There's a secret path hidden \nin the tree line.)")
            cutscene:text("* (Will you follow it?)")

            local choice = cutscene:choicer({"Yes", "No"})
            if choice == 1 then
                Game:setFlag("hometown_foundSecretPath", true)
                Game.world:mapTransition("light/hometown/secret_path", "entry_down", "up")
            else
                cutscene:text("* (Perhaps some things are best left unexplored for now.)")
                player:walkTo(player.x, player.y + 20)
                cutscene:wait(2)
            end
        else
            Game.world:mapTransition("light/hometown/secret_path", "entry_down", "up")
        end
    end,

    rudy = function(cutscene, event)
        local rudy = cutscene:getCharacter("rudy")
        local noelle = cutscene:getCharacter("noelle_lw")
        local susie = cutscene:getCharacter("susie_lw")
        local kris = cutscene:getCharacter("kris_lw")
        Assets.playSound("rudycough")
        rudy:setAnimation("cough")
        cutscene:wait(1.5)
        rudy:setSprite("d")
        if not Game.world.map.rudy_greeting then
            if noelle then
                cutscene:text("* Well,[wait:5] if it isn't my dear Noelle!", "happier", "rudy")
                if susie then
                    cutscene:text("* I see you've brought...", "smile", "rudy")
                    local notreally = "friend"
                    local susieline = "???"
                    if kris then
                        notreally = "friends"
                        susieline = "???\nKris???"
                    end
                    cutscene:text("* Your \""..notreally.."\",[wait:5] as well![react:1][wait:5][react:2]", "wink", "rudy", {reactions={
                        {"DAD!!!", "mid", "mid", "shock", "noelle"},
                        {susieline, "right", "bottom", "shy_b", "susie"}
                    }})
                end
                cutscene:text("* How have you been,[wait:5] sweetheart?", "smile_side", "rudy")
                cutscene:text("* Not much...[wait:5] Lately I've just been having fun with my friends.", "smile_closed", "noelle")
                cutscene:text("* Ah,[wait:5] that's great,[wait:5] that's great.", "happy", "rudy")
            elseif susie then
                if kris then
                    cutscene:text("* Susie![wait:5] Kris![wait:5] Isn't it wonderful to see you two!", "happier", "rudy")
                    cutscene:text("* What is it?[wait:5] Susie needs me for some Noelle advice?", "wink", "rudy")
                else
                    cutscene:text("* Susie! Isn't it wonderful to see you!", "happier", "rudy")
                    cutscene:text("* What is it?[wait:5] Need me for some Noelle advice?", "wink", "rudy")
                end
                cutscene:text("* Wh-[wait:5] I-[wait:5][face:teeth_b] NO!!!", "blush", "susie")
                cutscene:text("* Heh,[wait:5] heh...[wait:10] Whatever you say.", "smile", "rudy")
            elseif kris then
                cutscene:text("* Hey Krismas![wait:5] What's up?", "happier", "rudy")
                if #Game.party == 1 then
                    cutscene:text("* Where's your friend?[wait:5] Is she busy?", "neutral", "rudy")
                    cutscene:text("* Now,[wait:5] don't worry.[wait:5] I'm sure she'll get some free time for you.", "neutral", "rudy")
                else
                    cutscene:text("* You've got some new friends I see.", "smile", "rudy")
                    cutscene:text("* Well,[wait:5] in the meantime...[wait:10] Kris,[wait:5] let me tell you something.", "neutral", "rudy")
                    cutscene:text("* Noelle,[wait:5] Susie...[wait:10] Don't forget about them,[wait:5] alright?", "upset", "rudy")
                    cutscene:text("* They seem to be happy around you.", "wink", "rudy")
                end
            else
                cutscene:text("* Heh,[wait:5] heh...", "smile_side", "rudy")
                cutscene:text("* Wow,[wait:5] this is gotta be the first time I have visitors...", "happy", "rudy")
                cutscene:text("* Whom I don't even know!", "happier", "rudy")
                Assets.playSound("rudylaugh")
                rudy:setAnimation("laugh")
                cutscene:wait(1.5)
                rudy:setSprite("d")
            end
            cutscene:text("* Oh,[wait:5] you wanted to chat about something?", "smile_side", "rudy")
            Game.world.map.rudy_greeting = true
        else
            cutscene:text("* Want to chat?", "smile", "rudy")
        end
        local topic = cutscene:choicer({"Sickness", "Leave"})
        if topic == 1 then
            if noelle then
                cutscene:text("* Don't worry sweetie,[wait:5] I'm gonna be outta here in no time.", "smile", "rudy")
                cutscene:text("* I just...[wait:10] Need a bit more rest,[wait:5] that's all.", "smile_side", "rudy")
            else
                local names = ""
                if kris then
                    names = ",[wait:5] Kris"
                    if susie then
                        names = ",[wait:5] Kris,[wait:5] Susie"
                    end
                elseif susie then
                    names = ",[wait:5] Susie"
                end
                cutscene:text("* Hey"..names.."...[wait:10] Don't tell that to Noelle,[wait:5] but...", "upset", "rudy")
                cutscene:text("* I'm not sure if I'm gonna be out of here anytime soon.", "serious", "rudy")
                cutscene:text("* The coughing's been getting worse recently.", "upset", "rudy")
                cutscene:text("* Now,[wait:5] don't worry.[wait:5] I'm not going down yet.", "wink", "rudy")
                if kris or susie then
                    if Game:getFlag("rudy_promise") then
                        cutscene:text("* Hey...", "happy", "rudy")
                        cutscene:text("* Thanks again for that promise.", "happier", "rudy")
                        cutscene:text("* And don't worry about me,[wait:5] I'm more than fine for now.", "wink", "rudy")
                    else
                        if kris then
                            if susie then
                                cutscene:text("* But if...[wait:10] Kris...[wait:10] Kris,[wait:5] Susie,[wait:5] if something happens,[wait:5] then...", "serious", "rudy")
                            else
                                cutscene:text("* But if...[wait:10] Kris...[wait:10] Kris,[wait:5] if something happens,[wait:5] then...", "serious", "rudy")
                            end
                        elseif susie then
                            cutscene:text("* But if...[wait:10] Susie...[wait:10] Susie,[wait:5] if something happens,[wait:5] then...", "serious", "rudy")
                        end
                        cutscene:text("* Promise me you'll take good care of Noelle,[wait:5] alright?", "smile_side", "rudy")
                        cutscene:text("* She can't be left all alone by herself...", "neutral", "rudy")
                        cutscene:text("* Is that not too much to ask?", "smile_side", "rudy")
                        if kris then
                            cutscene:choicer({"Promise", "Promise"})
                            if susie then
                                cutscene:text("* We...[wait:10] We promise.", "shy_down", "susie")
                            end
                        elseif susie then
                            cutscene:text("* I...[wait:10] I promise.", "shy_down", "susie")
                        end
                        cutscene:text("* H...[wait:10] Heh,[wait:5] thank you.", "smile_side", "rudy")
                        Assets.playSound("rudycough")
                        rudy:setAnimation("cough")
                        cutscene:wait(1.5)
                        rudy:setSprite("d")
                        Game:setFlag("rudy_promise", true)
                    end
                else
                    cutscene:text("* Huh?[wait:5] What I'm diagnosed with?", "serious", "rudy")
                    cutscene:text("* I appreciate your concern,[wait:5] but...", "smile_side", "rudy")
                    cutscene:text("* It's not like there's anything you could do,[wait:5] heh.", "happy", "rudy")
                end
            end
        else
            cutscene:text("* Have a good day.", "happy", "rudy")
        end
    end,

    hospitalroom2bed = function(cutscene, event)
        if Game:getFlag("POST_SNOWGRAVE") then
            cutscene:text("* (He's breathing slowly.)")
        else
            cutscene:text("* (It's an empty bed.)")
        end
    end,

    brenda = function(cutscene, event)
        local susie = cutscene:getCharacter("susie_lw")
        local jamm = cutscene:getCharacter("jamm_lw")
        local jammarcy = cutscene:getCharacter("jammarcy_light")
        if Game:isDessMode() then
            if not Game:getFlag("hometown_brenda") then
                Game:setFlag("hometown_brenda", true)
                event:alert()
                cutscene:showNametag("Dess")
                cutscene:text("* hey breloom how have you been", "condescending", "dess")
                cutscene:hideNametag()
                event:setFacing("down")
                cutscene:wait(2/3)
                event:setFacing("right")
                cutscene:wait(1/2)
                cutscene:showNametag("Breloom...?")
                cutscene:text("* Did you just...[wait:10] call me 'Breloom'???", "suspicious_b", "brenda_lw")
                cutscene:showNametag("Dess")
                cutscene:text("* yeah that's your name is it not?", "eyebrow", "dess")
                cutscene:showNametag("Brenda")
                cutscene:text("* No,[wait:5] it's Brenda.", "angry", "brenda_lw")
                cutscene:text("* Who the hell even are you?", "suspicious_b", "brenda_lw")
                cutscene:showNametag("Dess")
                cutscene:text("* aw c'mon breloom you don't recognize me?", "checkoutmynewcut", "dess")
                cutscene:showNametag("Brenda")
                cutscene:text("* Stop calling me that.", "angry_b", "brenda_lw")
                cutscene:showNametag("Dess")
                cutscene:text("* alright fine", "angry", "dess")
                cutscene:text("* jeez i thought you'd at least recognize me", "neutral_b", "dess")
                cutscene:showNametag("Brenda")
                cutscene:text("* ...", "suspicious_b", "brenda_lw")
                cutscene:text("* Ma'am,[wait:5] did you hit your head or something?", "dissapointed", "brenda_lw")
                cutscene:text("* I have literally zero idea who you are.", "suspicious", "brenda_lw")
                cutscene:showNametag("Dess")
                Game.world.music:pause()
                cutscene:text("[speed:0.05][noskip]* ...", "dess.exe", "dess")
                Game.world.music:resume()
                cutscene:text("* (no dess you can't kill her,[wait:5] she's a main character)", "neutral_b", "dess")
                cutscene:text("* hey why are you looking at those trees", "genuine", "dess")
                cutscene:showNametag("Brenda")
                cutscene:text("* Oh uh,[wait:5] I'm heading into this forest.", "neutral", "brenda_lw")
                cutscene:text("* Word on the street is that there's a so called 'cult' in there.", "dissapointed", "brenda_lw")
                cutscene:text("* Of course all of this comes from occult magazines.", "suspicious", "brenda_lw")
                cutscene:text("* So I'm calling total BS on it.", "angry_b", "brenda_lw")
                cutscene:text("* The issue is there's a ton of people that believe this crap.", "dissapointed", "brenda_lw")
                cutscene:text("* So I'm going in there to prove there's nothing there at all.", "smug", "brenda_lw")
                cutscene:showNametag("Dess")
                cutscene:text("* okay have fun getting mauled to death by bears", "calm", "dess")
                cutscene:showNametag("Brenda")
                cutscene:text("* H-HUH?!", "shocked", "brenda_lw")
                cutscene:text("* There's bears here?", "shocked_b", "brenda_lw")
                cutscene:showNametag("Dess")
                cutscene:text("* i mean yeah duh its a forest", "angry", "dess")
                cutscene:text("* but dw,[wait:5] for the low low price of buying me a mug:tm: roobeer", "wink", "dess")
                cutscene:text("* ill fend off any bears that'll try to maul you to death", "heckyeah", "dess")
                cutscene:showNametag("Brenda")
                cutscene:text("* ...", "shocked", "brenda_lw")
                cutscene:text("* Alright fine.", "dissapointed", "brenda_lw")
                cutscene:showNametag("Dess")
                cutscene:text("* lets fuckin gooooooo", "heckyeah", "dess")
                cutscene:hideNametag()
                cutscene:text("* (Will you follow Brenda into\nthe woods?)")
                local choice = cutscene:choicer({"Yes", "No"})
                if choice == 1 then
                    Game.world.music:fade(0, 1)
                    cutscene:wait(cutscene:fadeOut(1))
                    Game:addFollower("brenda_lw")
                    Game:swapIntoMod("dlc_forest", false)
                else
                    cutscene:showNametag("Brenda")
                    cutscene:text("* Alright,[wait:5] I'll be here when you're ready.", "neutral", "brenda_lw")
                    cutscene:hideNametag()
                    event:setFacing("left")
                end
            else
                event:setFacing("right")
                cutscene:showNametag("Brenda")
                cutscene:text("* You ready to head out?", "neutral", "brenda_lw")
                cutscene:hideNametag()
                local choice = cutscene:choicer({"Yes", "No"})
                if choice == 1 then
                    Game.world.music:fade(0, 1)
                    cutscene:wait(cutscene:fadeOut(1))
                    Game:addFollower("brenda_lw")
                    Game:swapIntoMod("dlc_forest", false)
                else
                    cutscene:showNametag("Brenda")
                    cutscene:text("* Alright,[wait:5] I'll be here when you're ready.", "neutral", "brenda_lw")
                    cutscene:hideNametag()
                    event:setFacing("left")
                end
            end
        elseif susie then
            if not Game:getFlag("hometown_brenda") then
                Game:setFlag("hometown_brenda", true)
                event:alert()
                cutscene:showNametag("Susie")
                cutscene:text("* Hey,[wait:5] I haven't seen you around town before,[wait:5] who the hell are you?", "annoyed", "susie")
                cutscene:hideNametag()
                event:setFacing("down")
                cutscene:wait(2/3)
                event:setFacing("right")
                cutscene:wait(1/2)
                cutscene:showNametag("???")
                cutscene:text("* Huh?[wait:10] Me?", "shocked", "brenda_lw")
                cutscene:showNametag("Brenda")
				if #Game.party > 1 then
					cutscene:text("* I'm Brenda![wait:10]\n[face:smile]* What are your names?", "happy", "brenda_lw")
				else
					cutscene:text("* I'm Brenda![wait:10]\n[face:smile]* What's your name?", "happy", "brenda_lw")
				end
                cutscene:showNametag("Susie")
                cutscene:text("* Heh,[wait:5] the name's Susie!", "smile", "susie")
				if (jamm or jammarcy) and not Game:getFlag("dungeonkiller") then
					cutscene:showNametag("Jamm")
					cutscene:text("* And my name's Luthane,[wait:10] but I really go by Jamm.", "side_smile", "jamm")
					if jammarcy then
						cutscene:text("* This little girl is my daughter,[wait:10] Marcy.", "smile", "jamm")
						cutscene:showNametag("Marcy")
						cutscene:text("* H-hello!", "happy", "marcy")
					end
				end
				cutscene:showNametag("Susie")
                cutscene:text("* You moved here recently?", "neutral_side", "susie")
                cutscene:showNametag("Brenda")
                cutscene:text("* Oh nono,[wait:5] not at all.", "neutral", "brenda_lw")
                cutscene:text("* I'm here as a paranormal investigator.", "wink", "brenda_lw")
                cutscene:showNametag("Susie")
                cutscene:text("* What,[wait:5] you believe in ghosts or something?", "smile", "susie")
                cutscene:showNametag("Brenda")
                cutscene:text("* What?[wait:10] Pshhh of course not!", "dissapointed", "brenda_lw")
                cutscene:text("* I'm here to debunk that sorta stuff.", "smug", "brenda_lw")
                cutscene:text("* I've heard about rumors of there being a cult here in these woods.", "smile_b", "brenda_lw")
                cutscene:text("* So I'm gonna go in there and prove there's nothing there.", "smug", "brenda_lw")
                cutscene:showNametag("Susie")
                cutscene:text("* Alone?", "sus_nervous", "susie")
                cutscene:showNametag("Brenda")
                cutscene:text("* [speed:0.3]Yyyyy[speed:1]yes?", "neutral", "brenda_lw")
                cutscene:showNametag("Susie")
                cutscene:text("* What if there's like a bear or something?", "suspicious", "susie")
                cutscene:showNametag("Brenda")
                cutscene:text("* Pshh,[wait:5] there's no bears in these woods.", "smug", "brenda_lw")
                cutscene:text("* I think.", "suspicious", "brenda_lw")
				if (jamm or jammarcy) and not Game:getFlag("dungeonkiller") then
					cutscene:showNametag("Jamm")
					cutscene:text("* You \"think\"?", "suspicious", "jamm")
					cutscene:text("* Wait,[wait:5] are you even licensed in your work?", "suspicious", "jamm")
					cutscene:showNametag("Brenda")
					cutscene:text("* Licensed?[wait:10] What,[wait:5] do you think I'm just here for game hunting?", "shocked", "brenda_lw")
					cutscene:text("* The only thing I'm hunting here are urban legends to disprove.", "angry_b", "brenda_lw")
					cutscene:text("* Geez,[wait:5] I didn't think you'd need a license to explore some woods.", "suspicious", "brenda_lw")
					cutscene:showNametag("Jamm")
					cutscene:text("* Hey,[wait:5] I didn't mean it like that![wait:10][face:look_left] I was just...[wait:5][face:neutral] curious.", "shocked", "jamm")
					if jammarcy then
						cutscene:showNametag("Marcy")
						cutscene:text("* But Marcy thought...", "confused", "marcy")
						cutscene:showNametag("Jamm")
						cutscene:text("* Marcy,[wait:5] what harm is going to come of this?", "look_left", "jamm")
						cutscene:text("* There's literally nothing wrong with exploration.", "side_smile", "jamm")
					cutscene:showNametag("Brenda")
					cutscene:text("* Uh huh...", "suspicious", "brenda_lw")
					end
				end
                cutscene:showNametag("Susie")
                cutscene:text("* Hey,[wait:5] if you're gonna go in the woods alone,[wait:5] maybe I could tag along?", "smile", "susie")
                cutscene:showNametag("Brenda")
                cutscene:text("* But...[wait:10] you're just a kid.", "suspicious_b", "brenda_lw")
                cutscene:showNametag("Susie")
                cutscene:text("* HEY![wait:10]\n* I'M A TEENAGER,[wait:5] NOT A KID!", "teeth", "susie")
                cutscene:text("* Besides,[wait:5] I can kick some serious ass.", "smile", "susie")
				if (jamm or jammarcy) and not Game:getFlag("dungeonkiller") then
					cutscene:showNametag("Jamm")
					cutscene:text("* Look,[wait:5] if it's any consolation,[wait:5] I'm an adult.", "neutral", "jamm")
					cutscene:text("* I'm just...[wait:5] short for my age.", "nervous_left", "jamm")
				end
                cutscene:showNametag("Brenda")
                cutscene:text("* [speed:0.3]...", "suspicious_b", "brenda_lw")
                cutscene:text("* Sigh,[wait:10] fine.", "dissapointed", "brenda_lw")
                cutscene:text("* Just stay out of trouble.", "suspicious", "brenda_lw")
                cutscene:showNametag("Susie")
                cutscene:text("* No promises!", "smile", "susie")
                cutscene:hideNametag()
                cutscene:text("* (Will you follow Brenda into\nthe woods?)")
                local choice = cutscene:choicer({"Yes", "No"})
                if choice == 1 then
                    Game.world.music:fade(0, 1)
                    cutscene:wait(cutscene:fadeOut(1))
                    Game:addFollower("brenda_lw")
                    Game:swapIntoMod("dlc_forest", false)
                else
                    cutscene:showNametag("Brenda")
                    cutscene:text("* Alright,[wait:5] I'll be here when you're ready.", "neutral", "brenda_lw")
                    cutscene:hideNametag()
                    event:setFacing("left")
                end
            else
                event:setFacing("right")
                cutscene:showNametag("Brenda")
                cutscene:text("* You ready to head out?", "neutral", "brenda_lw")
                cutscene:hideNametag()
                local choice = cutscene:choicer({"Yes", "No"})
                if choice == 1 then
                    Game.world.music:fade(0, 1)
                    cutscene:wait(cutscene:fadeOut(1))
                    Game:addFollower("brenda_lw")
                    Game:swapIntoMod("dlc_forest", false)
                else
                    cutscene:showNametag("Brenda")
                    cutscene:text("* Alright,[wait:5] I'll be here when you're ready.", "neutral", "brenda_lw")
                    cutscene:hideNametag()
                    event:setFacing("left")
                end
            end
        else
            cutscene:text("* (This monster seems to be staring intensely at the woods.)")
            cutscene:text("* (Perhaps [color:#ff00ff]another monster[color:reset] could get her attention.)")
        end
    end,

    blook = function(cutscene, event) --placeholder dialogue lol
        local blook = cutscene:getCharacter("napstablook")
        blook:setFacing("right")
        cutscene:textTagged("* oh...[wait:5] hey...", nil, blook)
        cutscene:textTagged("* if you're looking for officer undyne... she's not here at the moment...", nil, blook)
        blook:setFacing("down")
    end,

    digicall = function(cutscene, event)
        if Game:hasDLC("dlc_digimon") and (#Game.party == 1 and Game:hasPartyMember("hero")) and Game:getFlag("jamm_closure") == true and Game:getFlag("marcy_unlocked") == true and (Game:hasUnlockedPartyMember("dess") and Game:hasUnlockedPartyMember("susie") and Game:hasUnlockedPartyMember("noelle") and Game:hasUnlockedPartyMember("brenda")) and (Game:hasUnlockedPartyMember("ceroba") or Game:getFlag("whatevertheflagfordeadcerobais") == true) then
            Game:setFlag("hometown_digicall", true)
            Game:setFlag("hometown_digisetup", true)
            Game.world.music:stop()
            Assets.playSound("phone")
            cutscene:wait(1)
            Assets.playSound("phone")
            cutscene:wait(1)
            Assets.playSound("phone")
            cutscene:wait(1)
            cutscene:showNametag("Hero")
            cutscene:text("* ... Huh?", "shocked", "hero")
            cutscene:text("* That's...[wait:5] odd...", "pout", "hero")
            cutscene:text("* I don't have a phone,[wait:5] but...[wait:10] There's a ring coming from my pocket...", "suspicious", "hero")
            cutscene:text("* Might as well see what it is...", "neutral_closed", "hero")
            cutscene:hideNametag()
            Assets.playSound("item")
            cutscene:wait(0.5)
            cutscene:showNametag("Hero")
            cutscene:text("* Hello...?", "neutral_closed_b", "hero")
            cutscene:showNametag("???")
            cutscene:text("* Greetings, Hero.")
            cutscene:text("* You,[wait:5] along side seven other people,[wait:5] have been chosen for something very special.")
            cutscene:text("* Please make your way to the library.")
            cutscene:text("* Once all eight of you make it,[wait:5] open the door to the computer lab.")
            cutscene:text("* Your destiny awaits,[wait:5] Hero.")
            cutscene:hideNametag()
            Assets.playSound("item")
            cutscene:text("[voice:nil]* (Click)")
            cutscene:showNametag("Hero")
            cutscene:text("* ...", "shocked", "hero")
            cutscene:text("* What WAS that...?", "shocked", "hero")
            local hero = cutscene:getCharacter("hero_lw")
            hero:setFacing("down")
            cutscene:text("* Do YOU have any idea who that was?", "neutral_closed_b", "hero")
            cutscene:hideNametag()
            local choice = cutscene:choicer({"No clue", "Could be\nGaster?"})
            cutscene:showNametag("Hero")
            if choice == 1 then
                cutscene:text("* That makes two of us then.", "neutral_closed", "hero")
                cutscene:text("* Well,[wait:5] we should see who,[wait:5] or what,[wait:5] called me.", "neutral_closed_b", "hero")
            else
                cutscene:text("* ...", "really", "hero")
                cutscene:text("* I've talked with Gaster before,[wait:5] he sounds nothing like that.", "pout", "hero")
                cutscene:text("* Seriously,[wait:5] what is up with people nowadays...", "suspicious", "hero")
                cutscene:text("* ... thinking everything is related to him?", "suspicious", "hero")
                cutscene:text("* Uh,[wait:5] regardless,[wait:5] [face:neutral_closed]we should head to the library.", "shocked", "hero")
            end
            cutscene:hideNametag()
            hero:setFacing("up")
            event:remove()
        end
    end,

    digiwrongway_a = function(cutscene, event)
        if Game:getFlag("hometown_digisetup") == true then
            cutscene:showNametag("Hero")
            cutscene:text("* That's the wrong way.", "neutral_closed", "hero")
            cutscene:hideNametag()
            local hero = cutscene:getCharacter("hero_lw")
            cutscene:wait(cutscene:walkTo(hero, hero.x, hero.y - 80, 1))
        end
    end,

    digiwrongway_b = function(cutscene, event)
        if Game:getFlag("hometown_digisetup") == true then
            cutscene:showNametag("Hero")
            cutscene:text("* That's the wrong way.", "neutral_closed", "hero")
            cutscene:hideNametag()
            local hero = cutscene:getCharacter("hero_lw")
            cutscene:wait(cutscene:walkTo(hero, hero.x + 80, hero.y, 1))
        end
    end,

    digiwrongway_c = function(cutscene, event)
        if Game:getFlag("hometown_digisetup") == true then
            cutscene:showNametag("Hero")
            cutscene:text("* That's the wrong way.", "neutral_closed", "hero")
            cutscene:hideNametag()
            local hero = cutscene:getCharacter("hero_lw")
            cutscene:wait(cutscene:walkTo(hero, hero.x - 80, hero.y, 1))
        end
    end,

    digiwrongway_d = function(cutscene, event)
        if Game:getFlag("hometown_digisetup") == true then
            cutscene:showNametag("Hero")
            cutscene:text("* That's the wrong way.", "neutral_closed", "hero")
            cutscene:hideNametag()
            local hero = cutscene:getCharacter("hero_lw")
            cutscene:wait(cutscene:walkTo(hero, hero.x, hero.y + 80, 1))
        end
    end,

    digi_library = function(cutscene, event)
        local hero = cutscene:getCharacter("hero_lw")
        local susie = cutscene:getCharacter("susie_lw")
        local noelle = cutscene:getCharacter("noelle_lw")
        local dess = cutscene:getCharacter("dess")
        local ceroba = cutscene:getCharacter("ceroba")
        local brenda = cutscene:getCharacter("brenda_lw")
        local jammarcy = cutscene:getCharacter("jammarcy_light")
        Game.world.music:fade(0, 0.5)
        cutscene:walkTo(hero, hero.x, hero.y - 40, 2)
        cutscene:wait(0.5)
        susie:alert()
        noelle:alert()
        dess:alert()
        ceroba:alert()
        brenda:alert()
        jammarcy:alert()
        cutscene:wait(0.5)
        susie:resetSprite()
        dess:setFacing("left")
        ceroba:setFacing("down")
        brenda:setFacing("left")
        jammarcy:setFacing("right")
        cutscene:showNametag("Susie", {top = false})
        cutscene:text("* Hero?[wait:5] The hell're you doing here?", "surprise", "susie", {top = false})
        cutscene:text("* Wait,[wait:5] did you get a weird phone-call too?", "annoyed", "susie", {top = false})
        cutscene:showNametag("Hero")
        cutscene:text("* Yup,[wait:5] I'm guessing you guys all had that call too?", "neutral_closed_b", "hero")
        cutscene:showNametag("Ceroba", {top = false})
        cutscene:text("* Mhm.", "closed_eyes", "ceroba", {top = false})
        cutscene:showNametag("Brenda")
        cutscene:text("* Yeah,[wait:5] I got kinda spooked because I almost never get calls.", "smile_b", "brenda_lw")
        cutscene:showNametag("Noelle", {top = false})
        cutscene:text("* Me too,[wait:5] I a-almost had a heart attack, fahah!", "blush_finger", "noelle", {top = false})
        cutscene:showNametag("Dess")
        cutscene:text("* oh yeah,[wait:5] i'm the chosen one, baby", "heckyeah", "dess")
        cutscene:showNametag("Jamm")
        cutscene:text("* You're acting like you're the only one who got this call.", "suspicious", "jamm")
        cutscene:showNametag("Marcy")
        cutscene:text("* Papa,[wait:5] this makes Marcy special,[wait:5] right?", "smile", "marcy")
        cutscene:showNametag("Jamm")
        cutscene:text("* You've always been special, Marcy.", "side_smile", "jamm")
        cutscene:text("* I guess this just makes you even more special,[wait:5] haha!", "happy", "jamm")
        cutscene:showNametag("Ceroba", {top = false})
        cutscene:text("* ...", "dissapproving_1", "ceroba", {top = false})
        cutscene:text("* So,[wait:5] I suppose that makes all eight of us here?", "neutral", "ceroba", {top = false})
        cutscene:showNametag("Hero")
        cutscene:text("* Looks like it.", "neutral_closed", "hero")
        cutscene:text("* You guys ready to head into the computer lab?", "neutral_closed_b", "hero")
        cutscene:showNametag("Susie", {top = false})
        cutscene:text("* Yeah,[wait:5] you head in whenever you're ready,[wait:5] and we'll follow.", "smirk", "susie", {top = false})
        cutscene:showNametag("Hero")
        cutscene:text("* Got it.", "happy", "hero")
        cutscene:hideNametag()
        susie:setSprite("chill")
        dess:setFacing("up")
        ceroba:setFacing("left")
        brenda:setFacing("right")
        jammarcy:setFacing("up")
    end,

    digiwrongway_library = function(cutscene, event)
        if Game:getFlag("hometown_digisetup") == true then
            cutscene:showNametag("Hero")
            cutscene:text("* No going back now.", "neutral_closed", "hero")
            cutscene:hideNametag()
            local hero = cutscene:getCharacter("hero_lw")
            cutscene:wait(cutscene:walkTo(hero, hero.x, hero.y - 80, 1))
        end
    end,

    digi_brenda = function(cutscene, event)
        if cutscene:getCharacter("hero_lw").facing == "right" then
            event:setFacing("left")
        else
            event:setFacing("up")
        end
        cutscene:showNametag("Brenda")
        cutscene:text("* Man,[wait:5] I wonder who was calling us.", "down", "brenda_lw")
        cutscene:text("* It wasn't a voice I recognized,[wait:5] so it can't be anyone I know.", "neutral", "brenda_lw")
        cutscene:hideNametag()
        event:setFacing("right")
    end,

    digi_dess = function(cutscene, event)
        event:setFacing("left")
        cutscene:showNametag("Dess")
        cutscene:text("* hell yeah i'm special and you guys are not", "condescending", "dess")
        cutscene:getCharacter("jammarcy_light"):setFacing("right")
        cutscene:showNametag("Jamm")
        cutscene:text("* Didn't I just say we all got this call?", "determined", "jamm")
        cutscene:showNametag("Dess")
        cutscene:text("* lalalalala can't hear you", "calm_b", "dess")
        cutscene:hideNametag()
        event:setFacing("up")
        cutscene:getCharacter("jammarcy_light"):setFacing("up")
    end,

    digi_ceroba = function(cutscene, event)
        cutscene:showNametag("Ceroba")
        cutscene:text("* I'm worried that this could be a trap.", "dissapproving", "ceroba")
        cutscene:showNametag("Susie")
        cutscene:text("* Nah,[wait:5] I don't think there's anyone in town that'd do that.", "neutral_side", "susie")
        cutscene:text("* If anything,[wait:5] it's gonna be a surprise party!", "smile", "susie")
        cutscene:text("* Man I hope there's lots of cake,[wait:5] ice cream,[wait:5]\nham sandwiches...", "sincere_smile", "susie")
        cutscene:showNametag("Ceroba")
        cutscene:text("* ...[wait:10]\n[face:unsure_alt]* You're drooling.", "wat", "ceroba")
        cutscene:showNametag("Susie")
        cutscene:text("* Oh,[wait:5] oops.", "shock_down", "susie")
        cutscene:text("* Besides,[wait:5] even if it IS a trap...", "closed_grin", "susie")
        cutscene:text("* We can just kick the ass of whoever's behind it to next Sunday.", "teeth_smile", "susie")
        cutscene:showNametag("Ceroba")
        cutscene:text("* I guess you're right,[wait:5] Susie.", "closed_eyes", "ceroba")
        cutscene:showNametag("Susie")
        cutscene:text("* I'm always right!", "closed_grin", "susie")
        cutscene:text("* Uh,[wait:5] except for when I'm not.", "shock_nervous", "susie")
        cutscene:hideNametag()
    end,

    digi_susie = function(cutscene, event)
        cutscene:showNametag("Susie")
        cutscene:text("* You can go in whenever you're ready, Hero.", "neutral", "susie")
        cutscene:text("* We'll be right behind you!", "sincere_smile", "susie")
        cutscene:hideNametag()
    end,

    digi_noelle = function(cutscene, event)
        if cutscene:getCharacter("hero_lw").facing == "left" then
            event:setFacing("right")
        end
        cutscene:showNametag("Noelle")
        cutscene:text("* G-gosh,[wait:5] I h-hope there isn't some sorta prank waiting for us.", "blush_smile", "noelle")
        cutscene:text("* I think I'd literally DIE if it's Kris trying to spook me again,[wait:5] faha!", "blush_smile_closed", "noelle")
        cutscene:text("* G-gosh,[wait:5] but then I'd b-be able to hold Susie for safety,[wait:5] a-and...", "blush_smile", "noelle")
        cutscene:showNametag("Susie")
        cutscene:text("* Huh?[wait:10] You said somethin' about me, Noelle?", "surprise", "susie")
        cutscene:showNametag("Noelle")
        event:setSprite("shocked")
        cutscene:text("* H-huh?!", "shock", "noelle")
        event:resetSprite()
        event:setFacing("right")
        cutscene:text("* O-oh, um,[wait:5] n-not at all, Susie,[wait:5] fahahaha!", "blush_big_smile", "noelle")
        cutscene:showNametag("Susie")
        cutscene:text("* If you say so.", "suspicious", "susie")
        cutscene:showNametag("Noelle")
        event:setFacing("down")
        cutscene:text("* ...", "blush_side", "noelle")
        cutscene:showNametag("Hero")
        cutscene:text("* ...", "shocked", "hero")
        cutscene:hideNametag()
    end,

    digi_jammarcy = function(cutscene, event)
        cutscene:showNametag("Marcy")
        cutscene:text("* Marcy can't wait to see what's in the computer lab!", "happy", "marcy")
        cutscene:text("* What if it's a gift just for Marcy?", "happy_closed", "marcy")
        cutscene:showNametag("Jamm")
        cutscene:text("* Settle down, Marcy,[wait:5] we gotta wait for Hero to be ready first.", "look_left", "jamm")
        cutscene:text("* (Also,[wait:5] you're not the only one invited here...)", "look_left", "jamm")
        cutscene:showNametag("Marcy")
        cutscene:text("* Aww...[wait:5] but Marcy wants to go now...", "sad", "marcy")
        cutscene:showNametag("Jamm")
        cutscene:text("* I'm sure they'll be ready soon.", "smile", "jamm")
        cutscene:hideNametag()
    end,

    digicomputer = function(cutscene, event)
        local hero = cutscene:getCharacter("hero_lw")
        local susie = cutscene:getCharacter("susie_lw")
        local noelle = cutscene:getCharacter("noelle_lw")
        local dess = cutscene:getCharacter("dess")
        local ceroba = cutscene:getCharacter("ceroba")
        local brenda = cutscene:getCharacter("brenda_lw")
        local jammarcy = cutscene:getCharacter("jammarcy_light")
        local computer = cutscene:getCharacter("digicomputer")
        cutscene:wait(0.5)
        hero:alert()
        cutscene:wait(0.5)
        Game.world.music:play("deltarune/creepydoor", 1, 1)
        cutscene:showNametag("Hero")
        cutscene:text("* Huh?[wait:10] It's a...[wait:5] computer?", "shocked", "hero")
        cutscene:hideNametag()
        cutscene:walkTo(hero, computer.x - 10, computer.y + 40, 2)
        cutscene:walkTo(susie, susie.x, susie.y - 120, 1)
        cutscene:walkTo(noelle, noelle.x, noelle.y - 120, 1)
        cutscene:walkTo(dess, dess.x, dess.y - 120, 1)
        cutscene:walkTo(ceroba, ceroba.x, ceroba.y - 120, 1)
        cutscene:walkTo(brenda, brenda.x, brenda.y - 120, 1)
        cutscene:walkTo(jammarcy, jammarcy.x, jammarcy.y - 120, 1)
        cutscene:wait(1)
        cutscene:walkTo(susie, 280, 280, 1, "right")
        cutscene:walkTo(noelle, 410, 310, 1, "left")
        cutscene:walkTo(dess, 420, 370, 1, "left")
        cutscene:walkTo(brenda, 350, 390, 1, "up")
        cutscene:walkTo(jammarcy, 260, 340, 1, "right")
        cutscene:walkTo(ceroba, 220, 385, 1, "right")
        cutscene:wait(1)
        cutscene:showNametag("Noelle", {top = true})
        cutscene:text("* I d-don't think I've seen this computer in here before.", "afraid", "noelle", {top = true})
        cutscene:showNametag("Susie", {top = true})
        cutscene:text("* You think the person who called us put it here?", "suspicious", "susie", {top = true})
        cutscene:showNametag("Brenda", {top = true})
        cutscene:text("* Seems likely to me.", "neutral", "brenda_lw", {top = true})
        cutscene:text("* But why would they put it here?", "down", "brenda_lw", {top = true})
        cutscene:showNametag("Dess", {top = true})
        cutscene:text("* oh oh oh maybe they want us to play space pinball", "teehee", "dess", {top = true})
        cutscene:showNametag("Hero", {top = true})
        cutscene:text("* It's not even plugged in,[wait:5] Dess.", "really", "hero", {top = true})
        cutscene:showNametag("Susie", {top = true})
        cutscene:text("* Damnit!", "teeth", "susie", {top = true})
        cutscene:showNametag("Jamm", {top = true})
        cutscene:text("* Susie,[wait:5] please.[wait:10]\n* My daughter is right here.", "stern", "jamm", {top = true})
        cutscene:showNametag("Ceroba", {top = true})
        cutscene:text("* Hmm...[wait:5] All of this is so strange...", "closed_eyes", "ceroba", {top = true})
        cutscene:showNametag("Hero", {top = true})
        cutscene:text("* That's odd...", "annoyed", "hero", {top = true})
        cutscene:text("* Even though it's not plugged in,[wait:5] the lights are still on...", "suspicious", "hero", {top = true})
        cutscene:showNametag("Susie", {top = true})
        cutscene:text("* Maybe you should turn it on then?", "neutral", "susie", {top = true})
        cutscene:showNametag("Hero", {top = true})
        cutscene:text("* It's worth a shot...", "pout", "hero", {top = true})
        cutscene:hideNametag()
        cutscene:wait(0.2)
        Assets.playSound("noise")
        cutscene:wait(3)
        cutscene:showNametag("Hero", {top = true})
        cutscene:text("* ...", "neutral_closed", "hero", {top = true})
        cutscene:hideNametag()
        cutscene:wait(3)
        cutscene:showNametag("Hero", {top = true})
        hero:setFacing("down")
        cutscene:text("[noskip]* Well,[wait:5] I dunno what I was expecti", "annoyed", "hero", {auto = true, top = true})
        cutscene:hideNametag()
        hero:setFacing("up")
        cutscene:slideTo(hero, hero.x, hero.y + 20, 0.5, "out-cubic")
        susie:setSprite("shock_down")
        computer:setSprite("on")
        computer:flash()
        Game.world.music:stop()
        Assets.playSound("great_shine")
        cutscene:wait(2)
        cutscene:showNametag("Hero", {top = true})
        cutscene:text("* ...", "shocked", "hero", {top = true})
        cutscene:showNametag("Susie", {top = true})
        cutscene:text("* ...", "shock", "susie", {top = true})
        susie:resetSprite()
        cutscene:text("* Did...[wait:10] Did it just turn on?", "shock_nervous", "susie", {top = true})
        cutscene:showNametag("Noelle", {top = true})
        cutscene:text("* The screen's so bright,[wait:5] I c-can't see anything on it...", "surprise_frown_b", "noelle", {top = true})
        cutscene:hideNametag()
        Game.world:shake(5)
        Assets.playSound("closet_impact")
        Game.world.music:play("deltarune/deep_noise", 0, 1)
        Game.world.music:fade(1, 1)
        noelle:setSprite("shocked")
        cutscene:wait(1)
        cutscene:showNametag("Noelle", {top = true})
        cutscene:text("* Hey,[wait:5] d-did you guys feel that?", "shock_b", "noelle", {top = true})
        cutscene:hideNametag()
        Game.world:shake(5)
        Assets.playSound("closet_impact")
        cutscene:wait(1)
        cutscene:showNametag("Hero", {top = true})
        cutscene:text("* I...[wait:5] I can't...", "shocked", "hero", {top = true})
        cutscene:hideNametag()
        susie:setSprite("shock_down")
        Game.world:shake(5)
        Assets.playSound("closet_impact")
        cutscene:wait(1)
        cutscene:showNametag("Susie", {top = true})
        cutscene:text("* Why can't I move?!", "bangs/nervous_b", "susie", {top = true})
        cutscene:hideNametag()
        Game.world:shake(5)
        Assets.playSound("closet_impact")
        cutscene:wait(1)
        cutscene:showNametag("Marcy", {top = true})
        cutscene:text("* Papa![wait:10] Marcy's scared!", "surprised", "marcy", {top = true})
        cutscene:hideNametag()
        Game.world:shake(5)
        Assets.playSound("closet_impact")
        cutscene:wait(1)
        cutscene:showNametag("Jamm", {top = true})
        cutscene:text("* Just keep holding onto me,[wait:5] okay?!", "ouch", "jamm", {top = true})
        cutscene:hideNametag()
        Game.world:shake(5)
        Assets.playSound("closet_impact")
        cutscene:wait(1)
        cutscene:showNametag("Dess", {top = true})
        cutscene:text("* hm yes i appear to be in immense pain right now", "mspaint", "dess", {top = true})
        cutscene:hideNametag()
        ceroba:setSprite("flashback/worried")
        ceroba.flip_x = true
        Game.world:shake(5)
        Assets.playSound("closet_impact")
        cutscene:wait(1)
        cutscene:showNametag("Ceroba", {top = true})
        cutscene:text("* W-what the hell is going on?!", "confounded", "ceroba", {top = true})
        cutscene:hideNametag()
        Game.world:shake(5)
        Assets.playSound("closet_impact")
        cutscene:wait(1)
        cutscene:showNametag("Brenda", {top = true})
        cutscene:text("* I DON'T WANNA DIE![wait:5]\n* I DON'T WANNA DIE!![wait:5]\n* I DON'T WANNA DIE!!!", "crying", "brenda_lw", {top = true})
        cutscene:hideNametag()
        Game.world:shake(5)
        Assets.playSound("closet_impact")
        cutscene:wait(1)
        cutscene:showNametag("Hero", {top = true})
        cutscene:text("[noskip][speed:0.5]* Everything's...[wait:5][speed:0.3]\n* going.....[wait:10][speed:0.15]\n* numb..........", "shade", "hero", {top = true})
        cutscene:hideNametag()
        Game.world:shake(5)
        Assets.playSound("closet_impact")
        cutscene:wait(1)
        cutscene:wait(cutscene:fadeOut(3, {color = {1,1,1}}))
        Game.world.music:fade(0, 1)
        cutscene:wait(2)
    end,

    sans = function(cutscene, event)
        local susie = cutscene:getCharacter("susie_lw")
        cutscene:showNametag("sans.", {font = "sans"})
        cutscene:text("[font:sans]* heya.", "neutral", "sans")
        if susie and not Game:getFlag("hometown_sans") then
            Game:setFlag("hometown_sans", true)
            cutscene:showNametag("Susie")
            cutscene:text("* Aren't you supposed to be guarding the elevator?", "suspicious", "susie")
            cutscene:showNametag("sans.", {font = "sans"})
            cutscene:text("[font:sans]* yup", "neutral", "sans")
            cutscene:showNametag("Susie")
            cutscene:text("* Then why are you still here?", "annoyed", "susie")
            cutscene:showNametag("sans.", {font = "sans"})
            cutscene:text("[font:sans]* what,[wait:5] never seen a guy with two jobs before?", "wink", "sans")
            cutscene:showNametag("Susie")
            cutscene:text("* ...", "bangs/annoyed", "susie")
            cutscene:text("* I feel like I'm talking to a brick wall whenever I talk to you.", "annoyed", "susie")
            cutscene:showNametag("sans.", {font = "sans"})
            cutscene:text("[font:sans]* nah,[wait:5] i'm not a brick wall,[wait:5] i'm a cashier.", "joking", "sans")
            cutscene:showNametag("Susie")
            cutscene:text("* I thought you were...", "suspicious", "susie")
            cutscene:text("* Oh nevermind.", "annoyed", "susie")
            cutscene:showNametag("sans.", {font = "sans"})
            cutscene:text("[font:sans]* anyways...", "look_left", "sans")
        end
        cutscene:text("[font:sans]* you need somethin'?", "neutral", "sans")
        cutscene:hideNametag()
        local choice = cutscene:choicer({"When can\nwe see your\nbrother?", "Nothing"})
        cutscene:showNametag("sans.", {font = "sans"})
        if choice == 1 then
            cutscene:text("[font:sans]* you wanna see my brother,[wait:5] huh?", "look_left", "sans")
            cutscene:text("[font:sans]* hmm...", "eyes_closed", "sans")
            cutscene:text("[font:sans]* yeah you can see him.", "neutral", "sans")
            cutscene:text("[font:sans]* as for when?", "look_left", "sans")
            cutscene:text("[font:sans]* tomorrow.", "wink", "sans")
            cutscene:text("[font:sans]* give or take three years.", "joking", "sans")
			if (cutscene:getCharacter("jamm_lw") or cutscene:getCharacter("jammarcy_light")) then
				cutscene:showNametag("Jamm")
				cutscene:text("* (Do we even have os.time() here?)", "nervous", "jamm")
			end
        else
            cutscene:text("[font:sans]* seeya.", "wink", "sans")
        end
        cutscene:hideNametag()
    end,

    susie_house = function(cutscene)
        local kris = cutscene:getCharacter("kris")
        local susie = cutscene:getCharacter("susie")

        if not susie or #Game.party > 2 then
            cutscene:text("* (It's locked...)")
            cutscene:text("* (...[wait:5] the town it's pretty empty today.)")
            if susie then
                cutscene:text("* ...", "neutral_side", "susie")
            end
            return
        end

        if susie and not kris then
            cutscene:text("* ...", "neutral_side", "susie")
            cutscene:text("* We should go look somewhere else.", "nervous", "susie")
            cutscene:text("* I'd prefer to check out this place with [color:yellow]Kris[color:reset].", "smile", "susie")
            if cutscene:getCharacter("hero") then
                cutscene:text("* ...[wait:4]Sure?", "neutral_closed", "hero")
            end

            local text = Text("BTW: YOU CAN'T GET KRIS YET")
            text:setColor(COLORS.white)
            Game.world:addChild(text)
            text:setParallax(0)
            text:setLayer(WORLD_LAYERS["top"])
            text:setPosition(SCREEN_WIDTH+10, 0)
            text.physics.speed_x = -4

            text.siner = 0
            text.hscroll = 0
            Utils.hook(text, "update", function(orig, self, ...)
                orig(self, ...)
                self.siner = self.siner + DTMULT*10

                self.hscroll = self.hscroll + DTMULT
                if self.hscroll > 240 then
                    self.hscroll = self.hscroll - 240
                end

                local function fcolor(h, s, v)
                    self.hue = (h / 255) % 1
                    return Utils.hsvToRgb((h / 255) % 1, s / 255, v / 255)
                end

                self:setColor(fcolor(self.siner / 4, 160 + (math.sin(self.siner / 32) * 60), 255))

                if self.x+self:getTextWidth() <= 0 then
                    self:remove()
                end
            end)
            return
        end

        if kris then
            cutscene:text("* ...", "neutral_side", "susie")
            cutscene:text("* Hey Kris...", "smirk", "susie")
            cutscene:text("* Do you think the Knight also created a fountain here...?", "smirk", "susie")
            cutscene:text("* Why?[wait:5] Well,[wait:3] uh...", "surprise", "susie")
            cutscene:text("* I guess I don't need to hide it from you, Kris.", "sincere", "susie")
            cutscene:text("* That's where I live!", "sincere_smile", "susie")
            cutscene:text("* I,[wait:3] uh,[wait:3] yeah.[wait:5] I live here.", "smirk", "susie")
            cutscene:text("* It's pretty...[wait:5] ok.[wait:5] I guess.", "shy_down", "susie")
            cutscene:text("* ...", "shy", "susie")
            cutscene:text("* Ah whatever,[wait:3] that's not the point!!", "teeth_b", "susie")
            cutscene:text("* The point is:[wait:3] we never checked my own appartment!", "smile", "susie")
            cutscene:text("* Even YOUR house got a Dark World![wait:5] Why not mine?", "smile", "susie")
            cutscene:text("* And honestly...[wait:5] I'm curious...", "neutral_side", "susie")
            cutscene:text("* I wonder what a Dark Fountain could have done in there.", "nervous", "susie")
            cutscene:text("* So watcha say,[wait:3] Kris?[wait:5] Do we risk opening this door?", "smile", "susie")
            local choice = cutscene:choicer({"Let's go!", "No."})
            if choice == 1 then
                Assets.playSound("drive")

                local dog = Sprite("world/npcs/dog/dogcar")
                Game.world:addChild(dog)
                dog:setLayer(kris:getLayer()+1)
                local x, y = kris:getScreenPos()
                dog:setScreenPos(SCREEN_WIDTH+60, y-dog.height)
                dog:play(1/2, true)

                cutscene:look(kris, "right")

                local wait = true
                local dog_y = dog.y
                cutscene:during(function()
                    dog.x = dog.x - 15*DTMULT

                    if dog.frame == 2 then
                        dog.y = dog_y+2
                    else
                        dog.y = dog_y
                    end

                    if dog.x <= kris.x+kris.width then
                        wait = false
                        return false
                    end
                end)

                cutscene:wait(function() return not wait end)

                Assets.stopSound("drive")
                Assets.playSound("hurt")
                Game.world.fader.alpha = 1
                dog:remove()
                cutscene:wait(1.5)

                cutscene:text("* (The shock was so bad,\n[wait:3]It send you back in time.)")
                cutscene:text("* (Maybe this is [color:yellow]something you should check out later[color:reset].)")

                cutscene:detachFollowers()
                kris:setPosition(3610, 310)
                cutscene:look(kris, "down")
                susie:setPosition(3685, 310)
                cutscene:look(susie, "left")
                cutscene:interpolateFollowers()
                cutscene:attachFollowersImmediate()

                cutscene:wait(cutscene:fadeIn())
            else
                cutscene:text("* Coward.", "smile", "susie")
            end
        end
    end
}

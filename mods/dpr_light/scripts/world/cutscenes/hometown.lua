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
                cutscene:text("* That's the uh, mayor's office.", "sus_nervous", "susie")
                cutscene:text("* If we got in we would be in big trouble.", "nervous_side", "susie")
                cutscene:text("* Not like i care, let's go.", "teeth_smile", "susie")
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
				if (jamm or jammarcy) then
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
				if (jamm or jammarcy) then
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
				if (jamm or jammarcy) then
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
    end,

    noellegate = function(cutscene, event)
        local susie = Game.world:getCharacter("susie_lw")
        cutscene:text("* (It's an ornate gate.)\n[wait:5]* (It appears to be locked.)")
        cutscene:runIf(susie and not Game:getFlag("holiday_mansion_quest_started"), function(cutscene)
			cutscene:text("* You know...[wait:5] Come to think of it...", "nervous", "susie")
            cutscene:text("* I haven't seen Noelle...[wait:5] In,[wait:5] like...[wait:5] A while.", "sus_nervous", "susie")
            cutscene:textVariant("* Is that your friend?", {
                hero = "neutral_closed_b",
                ceroba = "neutral",
			    jamm = "neutral"
		    }, {priority={ -- --> order of piority
		    	"hero", "ceroba", "jamm"
		    }})
            if Game:hasPartyMember("hero") or Game:hasPartyMember("ceroba") or Game:hasPartyMember("jamm") then
                cutscene:text("* Yeah,[wait:5] she...[wait:5] She is.", "annoyed_down_smile", "susie")
            else
                cutscene:text("* She's sort of a friend of mine", "annoyed_down_smile", "susie")
            end
            cutscene:text("* Actually,[wait:5] I was at her house once with Kris.", "smile", "susie")
            if Game:getFlag("POST_SNOWGRAVE") then
                cutscene:text("* Though,[wait:5] it was kind of...[wait:5] Weird?", "sus_nervous", "susie")
                cutscene:text("* It was fine until she said she needs to talk with Kris.", "sus_nervous", "susie")
            else
                cutscene:text("* And we had a pretty good time!", "sincere_smile", "susie")
                cutscene:text("* Explored her basement,[wait:5] found a mouse...", "small_smile", "susie")
                cutscene:text("* I even got to play guitar a bit!", "sincere_smile", "susie")
            end
            cutscene:text("* But then,[wait:5] like...[wait:5] Her mom came home and...", "suspicious", "susie")
            cutscene:text("* Kinda kicked us all out.", "nervous", "susie")
            cutscene:text("* And I haven't seen her since.", "neutral_side", "susie")
            cutscene:wait(1)
            susie:setSprite("shock_down")
            susie:shake()
            Assets.playSound("wing")
            cutscene:wait(1)
            cutscene:text("* OH SHOOT,[wait:5] I haven't seen her SINCE!", "shock", "susie")
            susie:resetSprite()
            cutscene:text("* Something TOTALLY happened!", "surprise_frown", "susie")
            cutscene:text("* Normally I wouldn't say we should break in,[wait:5] buuut...", "nervous_side", "susie")
            cutscene:text("* We should totally break in.", "closed_grin", "susie")
            local susieline = "* Thoguh,[wait:5] for that we need to open that gate."
            cutscene:runIfExists("dess", function(cutscene, dess)
			    cutscene:text("* 'kay now you're talking my language pal", "challenging", dess)
			    cutscene:text("* one hit with my trusty bat and the gate is no more", "swag", dess)
                cutscene:text("* No.", "annoyed", "susie")
                cutscene:text("* hell you mean no?", "annoyed", dess)
                cutscene:text("* Her mom is like,[wait:5] the mayor.[wait:5] We're gonna get in BIG trouble.", "annoyed", "susie")
                cutscene:text("* you're so lame man", "eyebrow", dess)
                susieline = "* We need some way to OPEN that thing."
		    end)
            cutscene:text(susieline, "suspicious", "susie")
            cutscene:textVariant("* Any suggestion on where should we start?", {
                hero = "neutral_closed",
                ceroba = "alt",
			    jamm = "look_left"
		    }, {priority={ -- --> order of piority
		    	"hero", "ceroba", "jamm"
		    }})
            cutscene:text("* Well,[wait:5] since her mom is like,[wait:5] the [color:red]mayor[color:reset] and stuff...", "nervous", "susie")
            cutscene:text("* She should have something like a spare key,[wait:5] right?", "nervous_side", "susie")
            cutscene:text("* Maybe at her...[wait:5] Workplace?", "suspicious", "susie")
            cutscene:text("* So let's start looking there then.", "smile", "susie")
            Game:setFlag("holiday_mansion_quest_started", true)
            Game:getQuest("holiday_mansion"):unlock()
            Assets.playSound("dimbox", 0.7)
		end)
    end,
}

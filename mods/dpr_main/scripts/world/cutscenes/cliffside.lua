local function getBind(name)
    if Input.usingGamepad() then
        return Input.getText(name)
    end
    return Input.getText(name) .. " "
end

---@type table<string, fun(cutscene:WorldCutscene, event: Event|NPC)>
local cliffside = {
    ---@param cutscene WorldCutscene

    slide_controls = function (cutscene, event)
        local text = Game.world.map.textobjjj
        text:slideTo(-300, text.y, 4, "out-cubic")
    end,

    intro = function (cutscene, event)
        Kristal.hideBorder(0)
        cutscene:wait(function ()
            if Game.world.map.id == [[grey_cliffside/cliffside_start]] then -- why is this using brackets instead of quotation marks lol. - J.A.R.U. -- Spamton G. Spamton / That's my fucking name / I am secret boss / in Deltarune game - BrendaK7200
                return true
            else
                return false
            end
        end)
        Game.fader:fadeIn { speed = 0 }
        Game.world.music:stop()
        local darknessoverlay = DarknessOverlay()
        darknessoverlay.layer = 1
        Game.world:addChild(darknessoverlay)
        local lightsource = LightSource(15, 28, 60)
        lightsource.alpha = 0.25
        Game.world.player:addChild(lightsource)

        local textobj = shakytextobject("Press " .. getBind("menu") .. "to open your menu.", 115, 810)
        textobj.layer = 2
        Game.world:addChild(textobj)


        local hero = cutscene:getCharacter("hero")
        hero:setSprite("fell")

        local function openMenulol(menu, layer)
            local self = Game.world
            if self.menu then
                self.menu:remove()
                self.menu = nil
            end

            if not menu then
                menu = self:createMenu()
            end

            self.menu = menu
            if self.menu then
                self.menu.layer = layer and self:parseLayer(layer) or WORLD_LAYERS["ui"]

                if self.menu:includes(AbstractMenuComponent) then
                    self.menu.close_callback = function ()
                        self:afterMenuClosed()
                    end
                elseif self.menu:includes(Component) then
                    -- Sigh... traverse the children to find the menu component
                    for _, child in ipairs(self.menu:getComponents()) do
                        if child:includes(AbstractMenuComponent) then
                            child.close_callback = function ()
                                self:afterMenuClosed()
                            end
                            break
                        end
                    end
                end

                self:addChild(self.menu)
                self:setState("MENU")
            end
            return self.menu
        end
        Game.tutorial = true


        --cutscene:text("* press c")

        cutscene:wait(function ()
            return Input.pressed("menu")
        end)
        openMenulol()
        --Game.world.menu:addChild()

        textobj:setText("Press " .. getBind("confirm") .. "to select the TALK option.")
        textobj.x, textobj.y = 10, 560


        cutscene:wait(function ()
            return Input.pressed("confirm")
        end)
        Assets.playSound("ui_select")
        textobj:setText ""

        Game.world:closeMenu()

        local choicer = cutscene:choicer({ "* Hero..." })
        if choicer == 1 then
            cutscene:wait(0.5)
            Game.stage.timer:tween(1, lightsource, { alpha = 0.50 })
            local wing = Assets.playSound("wing")
            Game.world.player:shake()
            cutscene:wait(1.5)
            wing:play()
            Game.world.player:shake()
            cutscene:wait(0.5)
            wing:stop()
            wing:play()
            Game.world.player:shake()
            lightsource.y = 25
            hero:setSprite("walk/right")
            cutscene:wait(2)
            cutscene:textTagged("* Hello?", "neutral_closed_b", "hero")
            local stime = 0.30
            cutscene:wait(stime)
            hero:setSprite("walk/up")
            cutscene:wait(stime)
            hero:setSprite("walk/left")
            cutscene:wait(stime)
            hero:setSprite("walk/down")
            cutscene:wait(stime)
            hero:setSprite("walk/right")
            cutscene:wait(0.75)

            cutscene:textTagged("* Is someone there?", "neutral_closed", "hero")

            textobj:setText "What will you do?"
            textobj.x, textobj.y = 200, 560

            local choicer = cutscene:choicer({ "Speak", "Do not" })
            textobj:setText ""
            if choicer == 1 then
                hero:setSprite("walk/down")

                cutscene:wait(1)
                cutscene:textTagged("* Ah.[wait:10] So it was you who called out to me.", "neutral_closed", "hero")
                cutscene:textTagged("* Should've guessed. I believe I overheard you conversing with [color:yellow]HIM[color:reset].", "neutral_closed", "hero")
                hero:setSprite("walk/left")
                cutscene:wait(0.5)
                cutscene:textTagged("* Unless he was talking to himself again...", "pout", "hero")
                cutscene:textTagged("* Wouldn't be the first time.[wait:10]\n* I guess...", "really", "hero")
                cutscene:wait(0.5)
                hero:setSprite("walk/down")
                cutscene:textTagged("* Regardless,[wait:5] it seems you're stuck with me,[wait:5] so...", "neutral_opened", "hero")
                cutscene:textTagged("* We should find out what caused reality to collapse in on itself.", "neutral_closed", "hero")
				
                cutscene:wait(0.5)
                hero:setFacing("up")
                hero:resetSprite()
                cutscene:wait(0.5)

                cutscene:textTagged("* Actually,[wait:5] where even ARE we?", "suspicious", "hero")
            elseif choicer == 2 then
                cutscene:wait(2)
                cutscene:textTagged("* Hello?", "neutral_closed_b", "hero")

                cutscene:wait(4)

                cutscene:textTagged("* Wow...[wait:30]\n* It's sad how I'm waiting for a reply...", "really", "hero")

                hero:setSprite("walk/down")

                cutscene:textTagged("* But,[wait:5] I know you're there though.[wait:10] I overheard you talking to [color:yellow]HIM[color:reset].", "neutral_closed", "hero")
                cutscene:hideNametag()

                cutscene:wait(0.5)
                hero:setSprite("walk/left")
                cutscene:wait(0.5)

                cutscene:textTagged("* Unless he was talking to himself again...", "pout", "hero")
                cutscene:textTagged("* Wouldn't be the first time.[wait:10]\n* I guess...", "really", "hero")
                cutscene:hideNametag()

                cutscene:wait(0.5)
                hero:setSprite("walk/right")
                cutscene:wait(0.5)

                cutscene:textTagged("* But I could've sworn I heard someone call out to me.", "suspicious", "hero")

                cutscene:wait(0.5)
                hero:setFacing("up")
                hero:resetSprite()
                cutscene:wait(0.5)

                cutscene:textTagged("* Actually,[wait:5] where even am I?", "neutral_closed", "hero")
            end
            hero:resetSprite()
            Game.stage.timer:tween(1, lightsource, { radius = 900 })
            Game.stage.timer:tween(1, lightsource, { alpha = 1 })
            Kristal.showBorder(1.5)
            cutscene:wait(0.75)
            Game.world.music:play()
            Game.world:spawnObject(MusicLogo("demonic little grey cliffs", 30, 20), WORLD_LAYERS["ui"])
        elseif choicer == 2 then

        end

        cutscene:wait(function ()
            if lightsource.alpha >= 0.95 or lightsource.radius >= 890 then
                return true
            else
                return false
            end
        end)
        Game.tutorial = nil
        darknessoverlay:remove()
    end,
    welcome = function (cutscene, event)
        cutscene:text("* Welcome to Cliffside![wait:10]\n* Watch your step!")
    end,
    light = function (cutscene, event)
        if Game.light == false then

            for e,a in ipairs(Game.party) do
                Game.world:getCharacter(a.actor.id):setActor(a.lw_actor.id)
            end

            Game.light = true
        end
    end,
    dark = function (cutscene, event)

        if Game.light == true then

            for e,a in ipairs(Game.party) do
                Game.world:getCharacter(a.lw_actor.id):setActor(a.actor.id)
            end

            Game.light = false
        end
    end,
    stranger = function (cutscene, event)
        cutscene:text("* [image:ui/replacement_char,0,0,2,2][image:ui/replacement_char,0,0,2,2][image:ui/replacement_char,0,0,2,2][image:ui/replacement_char,0,0,2,2][image:ui/replacement_char,0,0,2,2][image:ui/replacement_char,0,0,2,2][image:ui/replacement_char,0,0,2,2][image:ui/replacement_char,0,0,2,2][image:ui/replacement_char,0,0,2,2][image:ui/replacement_char,0,0,2,2]")
        if not Game:getFlag("met_stranger") then
            Game:setFlag("met_stranger", 1)
        end
    end,
    stranger_item = function (cutscene, event)
        if Game.inventory:addItem("oddstone") then
            cutscene:wait(0.1)
            cutscene:text("* You didn't see it happen,[wait:5] but you felt it,[wait:5] something entered your inventory.")
            Game:setFlag("met_stranger", 2)
        else
            Game:setFlag("met_stranger", 0)
        end
    end,
    first_reverse_cliff = function (cutscene, event)
        local text

        local function gonerTextFade(wait)
            local this_text = text
            Game.world.timer:tween(1, this_text, { alpha = 0 }, "linear", function ()
                this_text:remove()
            end)
            if wait ~= false then
                cutscene:wait(1)
            end
        end

        local function createsprite(kris)
            kris.parallax_x = 0
            kris.parallax_y = 0
            kris:setScale(2)
            kris.layer = WORLD_LAYERS["top"] + 100
            Game.world:addChild(kris)
        end

        local function gonerText(str, advance, option)
            text = DialogueText("[speed:0.5][spacing:6][style:GONER]" .. str, 160, 100, 640, 480, { auto_size = true })
            text.layer = WORLD_LAYERS["top"] + 100
            text.skip_speed = true
            text.parallax_x = 0
            text.parallax_y = 0

            Game.world:addChild(text)
            if option then
                if option == "shake" then
                    cutscene:shake(10, 10)
                end
            end

            if advance == "auto" then
                cutscene:wait(function () return not text:isTyping() end)
                text:remove()
            elseif advance ~= false then
                cutscene:wait(function () return not text:isTyping() end)
                gonerTextFade(true)
            end
        end
        Assets.playSound("noise")

        Game.world.player:setState("SLIDE")

        --cutscene:text("* Oh okay.")
        local cat = cutscene:getCharacter("cat")
        if not cat then
            Game.world:spawnNPC("cat", 460, 160)
            cat = cutscene:getCharacter("cat")
        end

        local player = Game.world.player
        cutscene:slideTo(player, 459, 1300, 4, "out-cubic")
        cutscene:wait(3)
        Game.world.player.slide_in_place = true
        local plx = player.x
        local num = 1
        local mum = 2
        local sam = "sdtart"
        cutscene:during(function ()
            if sam == "start" then
                local oh = plx + love.math.random(-num * mum, num * mum)
                player.x = oh
            end
        end)
        cutscene:wait(1)
        sam = "start"
        cutscene:slideTo(player, 459, 1100, 9, "out-cubic")
        cutscene:wait(1)

        local time = 0.25
        local plir = 0.01
        for _ = 1, 25 do
            Game.world.player.y = Game.world.player.y - 10
            Assets.playSound("wing")
            Game.world.player:shake(0, 5)
            cutscene:wait(time)
            time = time - plir
        end
        Game.world.player.slide_sound:stop()

        Game.world.player:setState("WALK")
        Assets.playSound("jump", 1, 0.5)
        cutscene:slideTo(player, 459, 260, 0.2)
        cutscene:wait(0.2)
        Game.world:shake(1, 50)
        sam = "stop"
        Assets.playSound("dtrans_flip", 1, 0.5)
        Assets.playSound("impact")
        Game.world.player:setAnimation("wall_slam")
        cutscene:wait(1)
        Game.world.player:setState("SLIDE")
        cutscene:slideTo(player, 459, 320, 0.2)
        cutscene:wait(0.2)
        Game.world.player:setState("WALK")
        Game.world.player:shake(5)
        Assets.playSound("bump")
        cutscene:wait(2)
        --gonerText("\nCareful.[wait:10]\nYou can't go down\nthose cliffs.", false)

        local whodis = {nametag = "???"}
        cutscene:textTagged("* Cyaweful.[wait:10]\nnyu cyan't go dyown doshe cliffs.", nil, "cat", whodis)

        local wat = 0.5
        Game.world.player:setFacing("left")
        cutscene:wait(wat)
        Game.world.player:setFacing("right")
        cutscene:wait(wat)
        Game.world.player:setFacing("left")
        cutscene:wait(wat)
        Game.world.player:setFacing("right")
        cutscene:wait(wat)

        --[[local choicer = cutscene:choicer({"Hello?", "Who's there?", "Thanks for the heads up.",  "No shit."})
       if choicer == 1 then
           cutscene:showNametag("???")
           cutscene:text("* Hello there.[wait:5]\n* Up here.", nil, "cat")
       elseif choicer == 2 then
           cutscene:showNametag("???")
           cutscene:text("* Up here.", nil, "cat")
           Game.world.player:setFacing("up")
           cutscene:wait(1)
           cutscene:showNametag("Cat?")
           cutscene:text("* Hello there.", nil, "cat")
       elseif choicer == 3 then
       elseif choicer == 4 then
       end]]

        --cutscene:setSpeaker("hero")
        --cutscene:textTagged("* Who's there?", "neutral_closed_b")

        cutscene:textTagged("* up hewe tiny humwan.", nil, "cat", whodis)
        Game.world.player:setFacing("up")
        cutscene:wait(1)
        local cattag = {nametag = "Cat?"}
        cutscene:textTagged("* Hewwo thewe-", nil, "cat", cattag, {auto = true})
        cutscene:textTagged("* [shake:5]*COUGH* [wait:5]*COUGH*", nil, "cat", cattag)
        cutscene:textTagged("* Pardon me.", nil, "cat", cattag)
        cutscene:textTagged("* Hello there.", "neutral", "cat", cattag)
        cutscene:hideNametag()
        cutscene:setSpeaker("cat")
        local choicer = cutscene:choicer({ "Hello?", "Is that a\ntalking cat?!" })
        if choicer == 1 then
            cutscene:textTagged("* Yes,[wait:10] hello.", "neutral", cattag)
            cutscene:textTagged("* Hm...[wait:10]\n* You seem to be confused...", "neutral", cattag)
        elseif choicer == 2 then
            cutscene:textTagged("* Yes,[wait:5] I am a cat[wait:5] and I can talk.", "neutral", cattag)
            cutscene:textTagged("* How very observant you are for someone with [color:red]their[color:white] eyes closed.", "neutral", cattag)

            --cutscene:text("* You seem to already know me.", "neutral", "cat")
        end

        cattag = {nametag = "Cat"}

        cutscene:textTagged("* My name is cat.", "neutral", "cat", cattag)
        cutscene:textTagged("* Say... You don't look like you're from around here.", "neutral", "cat", cattag)
        cutscene:textTagged("* The both of you...", "neutral", "cat", cattag)
        cutscene:textTagged("* Has fate brought you here?\n[wait:10]* Perchance Lady Luck?", "neutral", "cat", cattag)

        cat = cutscene:getCharacter("cat")
        cutscene:wait(cutscene:walkTo(cat, cat.x, cat.y - 50, 1.5, "up"))
        cutscene:wait(1)

        cutscene:textTagged("* Follow me...", "neutral", "cat", cattag)

        cutscene:wait(cutscene:walkTo(cat, cat.x, cat.y - 200, 3, "up"))

        cutscene:hideNametag()
        Game:setFlag("met_cat", true)
        Game:getQuest("cliffsides_cat"):unlock()
    end,

    fun_gus = function (cutscene, event)
        local --returns true if prime
        function isPrime(n)
            local n = tonumber(n)
            --catch nil, 0, 1, negative and non int numbers
            if not n or n<2 or (n % 1 ~=0) then 
                return false
            --catch even number above 2
            elseif n>2 and (n % 2 == 0) then 
                return false
            --primes over 5 end in 1,3,7 or 9
            --catch numbers that end in 5 or 0 (multiples of 5)
            elseif n>5 and (n % 5 ==0) then 
                return false
            --now check for prime
            else
                --only do the odds
                for i = 3, math.sqrt(n), 2 do
                    --did it divide evenly
                    if (n % i == 0) then
                        return false
                    end
                end
                --can defeat optimus
                return true
            end
        end
        
        local gus = cutscene:getCharacter("gus")

        gus:setAnimation("idle")
        cutscene:textTagged("* HEEEEY THERE,[wait:5] LIL' BUDDY!", nil, gus, { nametag = "???" })
        cutscene:textTagged("* NAME'S GUS.\n[wait:5]* [color:yellow]fun[color:reset] GUS!", nil, gus)
        cutscene:textTagged("* AND I'M 'ERE TO TELL YA 'BOUT HOW MUCH [color:yellow]fun[color:reset] YOU'LL HAVE ON THIS 'ERE ADVENTURE!", nil, gus)
        cutscene:textTagged("* ACCORDIN' TO MY \nSOURCES 'ERE...", nil, gus)
		
        local FUN = Game:getFlag("FUN")
        local prime = isPrime(FUN)
        cutscene:textTagged("* THE AMOUNT OF [color:yellow]fun[color:reset] YOU'LL HAVE WILL BE [color:yellow]"..FUN.."%[color:reset]!", nil, gus)
        if FUN >= 0 and FUN <= 20 then
            gus:setSprite("asleep")
            cutscene:textTagged("* OOF... [wait:5]\n* PRETTY LOW PERCENTAGE THERE.", nil, gus)
            gus:setAnimation("idle")
            cutscene:textTagged("* BUT DON'TCHA WORRY!", nil, gus)
            cutscene:textTagged("* I'M SURE YOU'LL STILL HAVE SUM [color:yellow]fun[color:reset] REGARDLESS,[wait:5] YA 'ERE?", nil, gus)
            if prime then
                cutscene:textTagged("* I MEAN, IT'S IT'S PRIME TIME TO HAVE SUM [color:yellow]fun[color:reset], AFTER ALL!", nul, gus)
                Game.inventory:addItem("the_mushroom_hat_that_increases_the_rate_at_which_you_gain_nightmares")
            end
        elseif prime and not FUN == 67 then
            -- Note the fact that nothing tells you that you got this. Isn't that such great game design?
            cutscene:textTagged("* HEEEY, S'POSE THAT MEANS IT'S PRIME TIME TO HAVE SUM [color:yellow]fun[color:reset], HUH?", nul, gus)
            Game.inventory:addItem("the_mushroom_hat_that_increases_the_rate_at_which_you_gain_nightmares")
        elseif FUN >= 21 and FUN <= 40 then
            cutscene:textTagged("* AH!\n * PRETTY DECENT PERCENTAGE!", nil, gus)
            cutscene:textTagged("* YOU MIGHT FIND QUITE A FEW VERY INTERESTING THINGS ALONG YER WAY!", nil, gus)
        elseif FUN >= 41 and FUN <= 59 then
            cutscene:textTagged("* ", nil, gus)
        elseif FUN >= 60 and FUN <= 80 then
            if FUN == 67 then
                local darkness = Rectangle(0, 0, 640, 480)
                darkness.layer = Game.world.player.layer - 0.1
                darkness.alpha = 0
                darkness:setScale(1)
                darkness:setColor(0, 0, 0)
                darkness:setParallax(0, 0)
                Game.world:addChild(darkness)

                Game.world.timer:tween(3.5, Game.world.music, {pitch = 0.05})
                Game.world.timer:tween(2.5, darkness, {alpha = 1})
                gus:setSprite("spooky")
                cutscene:text("[spacing:2.5][speed:0.15][voice:nil][noskip]* .....[wait:5]")
                cutscene:text("[voice:nil]* Funny number, ain't it?")
                cutscene:text("[voice:nil]* Sometimes a joke don't stop...")
                cutscene:text("[voice:nil]* And it keeps walking, right past the punchline.")
                cutscene:text("[voice:nil]* And when it does... you'll see what follows.")
                cutscene:text("[voice:nil]* Consider this as a threat, cruel chance.")

                Game.party[1].stats.health = 67
                Game.party[1].health = 67
                Game.party[1].stats.max_health = 67
                darkness:remove()
                Game.world.timer:tween(2.5, Game.world.music, {pitch = 1})
            else
                cutscene:textTagged("* GOOOLLLY!![wait:5]\n* THAT'S A LOTTA [color:yellow]fun[color:reset]!", nil, gus)
                if FUN >= 60 and FUN <= 69 then
                    cutscene:textTagged("* SAY, CAN I TELL YA A SECRET?", nil, gus)
                    cutscene:textTagged("* NUMBERS IN THE SIXTIES ARE MY FAAAVORITES!", nil, gus)
                    cutscene:textTagged("* YOU WANNA KNOW WHY?", nil, gus)
    
                    local darkness = Rectangle(0, 0, 640, 480)
                    darkness.layer = Game.world.player.layer - 0.1
                    darkness:setScale(1)
                    darkness:setColor(0, 0, 0)
                    darkness:setParallax(0, 0)
                    Game.world:addChild(darkness)
    
                    Game.world.music:setPitch(0.25)
                    Assets.playSound("noise")
                    gus:setSprite("spooky")
                    cutscene:text("[spacing:2.5][speed:0.3][voice:nil][noskip]* Because there's a chance you'll meet someone special that way.")
    
                    cutscene:wait(2)
                    darkness:remove()
                    Game.world.music:setPitch(1)
                    Assets.playSound("noise")
                    gus:setAnimation("idle")
                end
            end
        elseif FUN >= 81 and FUN <= 100 then
            cutscene:text("* HOLY SMOKES!!!", nil, gus)
            cutscene:text("* YER [color:yellow]fun[color:reset] IS OFF THE CHARTS!!", nil, gus)
            cutscene:text("* EXPECT SUM GREAT THINGS COMIN' YER WAY, BUDDY!!!\n* AH-HA!!!", nil, gus)
        -- FUN ~= FUN in case it's NaN (NaN is not the same as Nil)
        elseif FUN < 0 or FUN > 100 or FUN ~= FUN then
            cutscene:textTagged("* WOOAAH NELLY![wait:5]\n* THAT RIGHT THERE IS A [shake:4]WACKY[shake:0] \nPERCENTAGE!!", nil, gus)
            cutscene:textTagged("* ACCORDING TO MY SOURCES 'ERE THE AMOUNT RANGES FROM ONE TO A HUNDRED!", nil, gus)
            cutscene:textTagged("* SO EITHER MY SOURCES 'ERE ARE INCORRECT...", nil, gus)

            local darkness = Rectangle(0, 0, 640, 480)
            darkness.layer = Game.world.player.layer - 0.1
            darkness:setScale(1)
            darkness:setColor(0, 0, 0)
            darkness:setParallax(0, 0)
            Game.world:addChild(darkness)

            Game.world.music:setPitch(0.25)
            Assets.playSound("noise")
            gus:setSprite("spooky")
            cutscene:text("[spacing:2.5][speed:0.3][voice:nil][noskip]* ...or you're one of those good-for-nothin' hackers.")

            cutscene:wait(2)
            darkness:remove()
            Game.world.music:setPitch(1)
            Assets.playSound("noise")
            gus:setAnimation("idle")

            cutscene:textTagged("* AH-HA!!!\n* WELL WHATEVER IT IS, I'M SURE IT'LL BE FIXED SOON!", nil, gus)
            cutscene:textTagged("* AFTER ALL,[wait:5] THIS WORLD IS FULL INFINITE POSIBILITIES!!", nil, gus)
        end

        if FUN ~= 67 then
            cutscene:textTagged("* WELP !\n* THAT'LL BE ALL FROM YER OL' PAL GUS 'ERE!", nil, gus)
            cutscene:textTagged("* CHECK BACK FOR HOW MUCH [color:yellow]fun[color:reset] YOU'LL HAVE THE NEXT TIME!!", nil, gus)
            cutscene:textTagged("* AH-HA!!!", nil, gus)
        end

        Assets.playSound("mysterygo")
        gus:remove()
		Game:setFlag("talkedToGus", true)
		cutscene:wait(2)

        if cutscene:getCharacter("hero") then
            cutscene:textTagged("* ...", "shocked", "hero")
            cutscene:textTagged("* (What the hell was all that about?!)", "suspicious", "hero")
        end
    end,

    --finalized susie cutscene
    break_crystal = function (cutscene, event)
        cutscene:text("* (A large crystal towers before you...)")
        cutscene:text("* (Someone seems to be trapped inside it.)")
        cutscene:text("* (Would you like to free them?)")

        local choicer = cutscene:choicer({"Yes", "No"})
        local crystal
        if Game.world.map.id == "grey_cliffside/dead_room1" then
            crystal = Game.world:getEvent(49)
        elseif Game.world.map.id == "seal_room/seal_room_2" then
            crystal = Game.world:getEvent(50)
        end

        if choicer == 1 then
            if Game.world.player.facing == "up" then
		        cutscene:wait(cutscene:walkTo(Game.world.player, 300, 260, 1))
		        Game.world.player:setFacing("up")
		        Game.world.music:pause()
                cutscene:wait(1)

		        local white_glows = Game.world.map.white_glows
		        if white_glows then
                    Game.world.timer:tween(5, white_glows, {alpha = 0})
                end
				
                for i,v in ipairs(Game.world.map.tile_layers) do
                    Game.world.timer:tween(5, Game.world.map.tile_layers[i], {alpha = 0})
                end

                local leader = Game.world.player
                local soul = Game.world:spawnObject(UsefountainSoul(leader.x, leader.y - leader.height + 10), "ui")
                soul.color = Game:getPartyMember(Game.party[1].id).soul_color or {1,0,0}
                cutscene:playSound("great_shine")

                cutscene:wait(3)
				cutscene:detachCamera()
                Assets.playSound("kristal_intro", 1, 0.25)

                Game.world.timer:tween(170/30, soul, {y = 160})
                Game.world.timer:tween(5, crystal.trapped_party_member, {alpha = 0.70})
                cutscene:wait(5)
                local rev = Assets.playSound("revival")
                soul:shine()
    
                local flash_parts = {}
                local flash_part_total = 12
                local flash_part_grow_factor = 0.5
                for i = 1, flash_part_total - 1 do
                    -- width is 1px for better scaling
                    local part = Rectangle((SCREEN_WIDTH / 2) - 20, 0, 1, SCREEN_HEIGHT)
                    part:setOrigin(0.5, 0)
                    part.layer = soul.layer - i
                    part:setColor(1, 1, 1, -(i / flash_part_total))
                    part.graphics.fade = flash_part_grow_factor / 16
                    part.graphics.fade_to = math.huge
                    part.scale_x = i*i * 2
                    part.graphics.grow_x = flash_part_grow_factor*i * 2
                    table.insert(flash_parts, part)
                    Game.world:addChild(part)
                end
                cutscene:wait(2)
		        rev:stop()
		        if white_glows then
		            white_glows.alpha = 1
                end
                for i,v in ipairs(Game.world.map.tile_layers) do
                    Game.world.map.tile_layers[i].alpha = 1
                end
		        soul:remove()
                for i,v in ipairs(flash_parts) do
                    flash_parts[i]:remove()
                end

                local susie
                if crystal.char == "susie" then
                    susie = cutscene:spawnNPC("susie", Game.world.player.x, 180)
                    susie:setSprite("shock_right")
                else
                    susie = cutscene:spawnNPC("suzy_lw", Game.world.player.x, 180)
                end
                crystal.broken = true
                crystal.spawn_shards = true
		        Assets.stopSound("kristal_intro")

		        Assets.playSound("glassbreak", 0.4, 0.6)
		        Assets.playSound("sparkle_glock", 0.5, 0.8)
		        Assets.playSound("sparkle_glock", 0.5, 0.71)

		        susie:shake()
		        susie.alpha = 1
		        cutscene:slideTo(susie, susie.x, 245, 0.5, "out-cubic")
		        Game.world.player.x, Game.world.player.y = 300, 320
		        cutscene:wait(0.3)
		        susie:setSprite("fell")
		        susie:shake()
                Assets.playSound("bump")
		        susie.sprite:removeFX()
		        cutscene:wait(4)
		        susie:shake()
                Assets.playSound("bump")
		        cutscene:wait(1)
		        susie:shake()
                Assets.playSound("bump")
		        cutscene:wait(1)
		        Assets.playSound("wing")

                if susie.actor.name == "Suzy" then
		            susie.x = Game.world.player.x
		            susie:shake()
		            susie:setFacing("up")
		            susie:resetSprite()
		            cutscene:wait(0.5)

		            susie.x = Game.world.player.x
		            susie:shake()
		            susie:setFacing("down")
		            susie:resetSprite()
		            cutscene:wait(0.5)
		            susie:alert()
		            cutscene:wait(1)
                    cutscene:text("* Is that you, [color:yellow]Mu[color:reset]-", nil, "suzy_lw", {auto = true})
                    cutscene:text("* [shake:0.8]Nope.[wait:5] Nope.[wait:5]Nope.[wait:5]Nope.", "shocked", "hero")
                    cutscene:text("* It's Hero.[wait:5][face:neutral_closed] My name is Hero.", "suspicious", "hero")

                    --Game.world.music:play("demonic_little_grey_cliffs")
                    cutscene:text("* This is all very much a placeholder text/cutscene. Please rewrite it if you want.")

                    susie:convertToFollower()
                    Game:addPartyMember("suzy")
                    Game:unlockPartyMember("suzy")
                    cutscene:attachCamera()
                    cutscene:wait(cutscene:attachFollowers())
                end
                if susie.actor.name == "Susie" then
                    susie.x = Game.world.player.x
                    susie:shake()
                    susie:setFacing("up")
                    susie.actor.default = "walk_bangs_unhappy"
                    susie:resetSprite()
                    cutscene:wait(0.5)

                    susie:setFacing("left")
                    cutscene:wait(0.4)
                    susie:setFacing("right")
                    cutscene:wait(0.5)
                    susie:setFacing("down")
                    cutscene:wait(0.3)
                    susie:setFacing("up")
                    cutscene:wait(0.6)
                    susie:alert()
                    cutscene:wait(0.2)
                    susie:setSprite("shock_behind")
                    cutscene:wait(0.3)
                    local susi_sound = Assets.playSound("whip_crack_only")
                    susie:setSprite("turn_around")
                    cutscene:wait(0.1)
                    susi_sound:stop()
                    susie:setSprite("shock_down")
                    local sus_sound = Assets.playSound("sussurprise")

                    cutscene:wait(cutscene:slideTo(susie, susie.x, susie.y - 20, 0.2, "out-cubic"))

                    sus_sound:stop()
                    susie:shake()
                    Assets.playSound("impact")
                    susie:setSprite("battle/hurt")
                    cutscene:wait(0.5)

                    susie:setSprite("battle/attackready_1")
                    Assets.playSound("weaponpull_fast")
                    cutscene:wait(cutscene:slideTo(susie, 130, 240, 0.5, "out-cubic"))
                    local hero = Game.world:getCharacter("hero")
                    hero:setFacing("left")

                    cutscene:showNametag("???")
                    cutscene:text("* Hey![wait:5] Back off-", "bangs/nervous_b", "susie", {auto = true})
                    cutscene:text("* ...", "bangs/nervous_smile", "susie")
                    cutscene:hideNametag()

                    cutscene:showNametag("???")
                    cutscene:text("* Oh,[wait:5] uh,[wait:5] sorry.", "bangs/nervous_smile", "susie")
                    cutscene:text("* Thought you were something else.", "bangs/nervous", "susie")
                    cutscene:hideNametag()
                    cutscene:wait(1)
                    Assets.playSound("equip")
                    susie:setFacing("right")
                    susie:resetSprite()
                    cutscene:wait(1)

                    cutscene:wait(cutscene:walkTo(susie, Game.world.player.x - 50, Game.world.player.y, 2, "right"))
                    cutscene:text("[speed:0.3]* ...", "bangs/neutral", "susie")
                    cutscene:showNametag("???")
                    cutscene:text("* Who the hell are you anyway??", "bangs/annoyed", "susie")
                    cutscene:showNametag("Hero")
                    cutscene:text("* Uh,[wait:5] I'm Hero.", "neutral_closed", "hero")
                    cutscene:text("* And you are?", "neutral_closed_b", "hero")
                    cutscene:showNametag("???")
                    cutscene:text("* Hero,[wait:5] huh?", "bangs/smile", "susie")
                    cutscene:hideNametag()
                    Assets.playSound("suslaugh")
                    susie:setAnimation("laugh_right")
                    cutscene:wait(1.5)
                    susie:resetSprite()
                    cutscene:showNametag("???")
                    cutscene:text("* That is THE most cliche name I have ever heard.", "bangs/smile_c", "susie")
                    cutscene:showNametag("Hero")
                    cutscene:text("[speed:0.2]* ...", "really", "hero")
                    cutscene:text("* ... and YOU[wait:2] are?", "really", "hero")
                    susie:setFacing("up")
                    cutscene:showNametag("???")
                    cutscene:text("[speed:0.3]* ...", "bangs/down", "susie")
                    cutscene:text("* You're the one who freed me from this crystal,[wait:5] right?", "bangs/neutral", "susie")
                    cutscene:showNametag("Hero")
                    cutscene:text("* Yyyyes?", "annoyed", "hero")
                    cutscene:showNametag("???")
                    cutscene:text("* Got it...", "bangs/neutral", "susie")
                    cutscene:hideNametag()
                    cutscene:wait(1.5)

                    Assets.playSound("jump")
                    susie:setFacing("right")
                    cutscene:wait(0.1)
                    susie:setFacing("down")
                    cutscene:wait(0.1)
                    susie:setFacing("left")
                    cutscene:wait(0.1)
                    susie:setFacing("up")
                    cutscene:wait(0.1)
                    susie:setFacing("right")
                    cutscene:wait(0.1)
                    susie:setFacing("down")
                    cutscene:wait(0.1)
                    susie:setFacing("left")
                    cutscene:wait(0.1)
                    susie:setFacing("up")
                    cutscene:wait(0.1)
                    susie:setFacing("right")
                    cutscene:wait(0.1)
                    Assets.playSound("impact")
                    susie:setSprite("pose")
                    cutscene:wait(0.5)

                    local get_bus = Music("get_on_the_bus")
                    --Game.world:spawnObject(MusicLogo(" Get on the Bus\n    Earthbound OST", 360, 220), WORLD_LAYERS["ui"]) --commenting this out cuz its a bit distracting.

                    cutscene:showNametag("Susie")
                    cutscene:text("* The name's Susie!", "closed_grin", "susie")
                    susie.actor.default = "walk"
                    susie:resetSprite()
                    cutscene:text("* Hey,[wait:5] thanks for saving me.[wait:5] Dunno how long I was gonna be in there.", "smirk", "susie")
                    cutscene:showNametag("Hero")
                    cutscene:text("[speed:0.2]* ...", "really", "hero")
                    susie:setSprite("shock_down")
                    cutscene:showNametag("Susie")
                    cutscene:text("* Uhhh,[wait:5] right.", "shock", "susie")
                    susie:setAnimation("away_scratch")
                    cutscene:text("* Sorry for calling your name cliched,[wait:5] I guess.", "shock_nervous", "susie")
                    cutscene:showNametag("Hero")
                    cutscene:text("* ...[wait:5] uh-huh.", "really", "hero")
                    cutscene:text("* Anyways, how'd you wind up trapped in that crystal?", "neutral_closed_b", "hero")
                    cutscene:text("* More importantly,[wait:5] how did you even end up here to begin with?", "neutral_closed", "hero")
                    susie:resetSprite()
                    get_bus:fade(0, 1)
                    susie:setFacing("up")
                    cutscene:showNametag("Susie")
                    cutscene:text("* ...", "shy_down", "susie")
                    cutscene:text("* I...[wait:5] don't really know...", "annoyed_down", "susie")
                    cutscene:text("* Last thing I can remember was that I was chasing-", "neutral_side", "susie", {auto = true})
                    cutscene:text("* ...!", "shock", "susie")

                    Game.world.music:play("deltarune/creepydoor")
                    Assets.playSound("wing")
                    susie:shake()
                    susie:setSprite("shock_down")
                    cutscene:text("* Crap,[wait:5] right,[wait:5] The Knight!!", "surprise_frown", "susie")
                    susie:setSprite("walk")
                    susie:setFacing("up")
                    cutscene:text("* They must've been the one who trapped me in this thing!", "angry_b", "susie")
                    susie:setAnimation("look_down_arm_shake")
                    cutscene:text("* Ugh,[wait:5] when I get my hands on that goddamn-", "angry_c", "susie")
                    susie:setSprite("look_down_right_surprise")
                    cutscene:showNametag("Hero")
                    cutscene:text("* (ahem)", "neutral_opened", "hero")
                    cutscene:hideNametag()
                    susie:setSprite("walk_unhappy")
                    susie:setFacing("right")

                    cutscene:wait(1)
                    cutscene:showNametag("Susie")
                    cutscene:text("* Right,[wait:5] right...", "annoyed_down", "susie")
                    cutscene:text("* Last I remember, I was chasing the Knight back at the Church.", "annoyed", "susie")
                    cutscene:text("* They were trying to flee from me and my friends after it failed at...", "neutral_side", "susie")
                    Assets.playSound("wing")
                    susie:setAnimation("away_scratch")
                    cutscene:text("* ...well,[wait:5] WHATEVER their plan was.", "sus_nervous", "susie")
                    susie:setSprite("confused_right")
                    cutscene:text("* What was it that Ralsei said?[wait:5] Something about a \"Titan\"?", "annoyed_down", "susie")
                    cutscene:hideNametag()
                    Game.world.music:fade(0, 1)
                    cutscene:wait(0.5)
                    susie:resetSprite()
                    cutscene:showNametag("Susie")
                    Assets.playSound("wing")
                    susie:setSprite("away")
                    cutscene:text("* Ehh,[wait:5] what does it matter?", "closed_grin", "susie")
                    susie:setSprite("away_hand")
                    cutscene:text("* I now know that whole prophecy's total bunk anyways.", "annoyed", "susie")
                    susie:setSprite("walk_back_arm")
                    susie:setFacing("left")
                    cutscene:text("* Which means Kris and I don't need to worry about saving the world!", "closed_grin", "susie")
                    cutscene:hideNametag()

                    cutscene:wait(1)
                    cutscene:showNametag("Hero")
                    cutscene:text("* Uhhhhh yeah,[wait:5] about that...", "shocked", "hero")
                    susie:setSprite("walk_unhappy")
                    susie:setFacing("right")
                    cutscene:showNametag("Susie")
                    cutscene:text("* Huh?", "neutral_side", "susie")
                    cutscene:showNametag("Hero")
                    cutscene:text("* While,[wait:5] yes,[wait:5] the prophecy DID turn out to be false...", "neutral_closed_b", "hero")
                    cutscene:text("* ... the fate of the world is still at stake,[wait:5] unfortunately.", "pout", "hero")
                    Assets.playSound("wing")
                    susie:shake()
                    susie:setSprite("shock_right")
                    cutscene:showNametag("Susie")
                    cutscene:text("* WHAT?!", "surprise_frown", "susie")
                    cutscene:slideTo(hero, hero.x + 10, hero.y, 0.2, "out-cubic")
                    susie:shake()
                    susie:setSprite("point_right_unhappy")
                    cutscene:text("* How the hell would YOU know anything about that!?", "angry", "susie")
                    cutscene:showNametag("Hero")
                    cutscene:text("* (Oh boy...)", "pout", "hero")
                    susie:setSprite("walk_unhappy")
                    susie:setFacing("right")
                    cutscene:text("* You might wanna sit down. This is gonna take a bit to explain...", "pout", "hero")
                    cutscene:hideNametag()
                    cutscene:wait(cutscene:fadeOut(1))
                    cutscene:wait(2)

                    local lore_board = Sprite("world/cutscenes/cliffside/lore_board")
                    lore_board.x, lore_board.y = 190, 120
                    Game.world:addChild(lore_board)
                    lore_board:setScale(2)
                    lore_board.layer = 0.6

                    hero.x, hero.y = 366, 290
                    susie.x, susie.y = 260, 290
                    hero:setFacing("up")
                    susie:setFacing("up")

					cutscene:text("[noskip][speed:0.5]* (One excessively long lore summary later...)")
                    cutscene:wait(cutscene:fadeIn(1))
                    cutscene:wait(1)
                    susie:setFacing("right")
                    susie:setSprite("surprised_right")
                    cutscene:showNametag("Susie")
                    cutscene:text("* Oh damn.", "shock", "susie")
                    hero:setFacing("left")
                    cutscene:showNametag("Hero")
                    cutscene:text("* Yeah...", "neutral_closed", "hero")
                    cutscene:showNametag("Susie")
                    susie:setSprite("confused_right")
                    cutscene:text("* That, uh... certainly explains a lot.", "shock_nervous", "susie")
                    susie:setSprite("exasperated_right")

                    get_bus:fade(1, 1)
                    Assets.playSound("whip_hard")
                    susie:shake()
                    cutscene:showNametag("Susie")
                    cutscene:text("* Why didn't Ralsei ever tell me ANY of this?!", "teeth_b", "susie")
                    susie:resetSprite()
                    cutscene:text("* Like,[wait:5] the Roaring sounds more badass than what's going on here.", "teeth_smile", "susie")
                    cutscene:text("* I'd get to fight TITANS and stuff!", "closed_grin", "susie")
                    susie:setFacing("up")
                    cutscene:text("* But reality collapsing in on itself??", "neutral_side", "susie")
                    susie:setFacing("right")
                    cutscene:text("* That's just lame,[wait:5] dude.", "annoyed", "susie")
                    cutscene:showNametag("Hero")
                    cutscene:text("* Well,[wait:5] I suppose that settles it then.", "smug_b", "hero")
                    cutscene:text("* We'll find your friends, seal the fountains that the Knight made...", "smug", "hero")
                    cutscene:text("* ... and just like that, reality will be saved.", "smug", "hero")
                    cutscene:text("* Well, unless the Knight opens up MORE fountains but uh...", "shocked", "hero")
                    cutscene:text("* I'm sure we can handle it.", "happy", "hero")
                    cutscene:showNametag("Susie")
                    cutscene:text("* Uhh,[wait:5] where even IS the Dark Fountain of this place anyways?", "nervous_side", "susie")
                    cutscene:showNametag("Hero")
                    cutscene:text("* That...[wait:5] is something I don't know.", "annoyed", "hero")
                    susie:setSprite("exasperated_right")
                    cutscene:showNametag("Susie")
                    cutscene:text("* Oh great,[wait:5] don't tell me we're stuck here!", "teeth", "susie")
                    susie:resetSprite()
                    cutscene:showNametag("Hero")
                    cutscene:text("* Hey,[wait:2] I'm sure there's a way out of here.", "neutral_closed_b", "hero")
                    susie:setFacing("left")
                    cutscene:text("* We just gotta keep going forward.", "neutral_closed", "hero")
                    susie:setFacing("right")
                    cutscene:showNametag("Susie")
                    cutscene:text("* Yeah,[wait:5] guess I don't really have much of a choice now.", "annoyed_down", "susie")
                    cutscene:text("* Well uhh,[wait:5] lead the way, Hero.", "sincere_smile", "susie")
                    cutscene:hideNametag()
            
                    get_bus:stop()
                    get_bus:remove()
					
					Game.world.music:pause()
                    local party_jingle = Music("deltarune/charjoined")
                    party_jingle:play()
                    party_jingle.source:setLooping(false)
                    cutscene:text("[noskip]* Susie joined the party.")
                    party_jingle:remove()

                    cutscene:wait(0.5)
                    hero:setFacing("up")
                    cutscene:wait(1)
                    cutscene:showNametag("Hero")
                    cutscene:text("* Oh yeah.[wait:5]\n* I should get rid of this thing for now.", "neutral_opened", "hero")
                    cutscene:hideNametag()
					
                    Assets.playSound("impact")
                    lore_board:shake()
                    hero:setSprite("walk/up_4")
                    cutscene:wait(0.5)
                    hero:setSprite("walk")
                    hero:setFacing("up")
                    susie:setFacing("up")
                    cutscene:wait(1)
                    susie:shake()
                    susie:setSprite("shock_behind")
					
                    local explosion = Explosion(lore_board.x + (lore_board.width), lore_board.y + (lore_board.height))
                    explosion:setOrigin(0.5, 0.5)
                    explosion:setScale(8, 4)
                    explosion:setLayer(Game.world.player.layer - 0.1)
                    Game.world:addChild(explosion)
                    cutscene:wait(0.5)
                    lore_board:remove()
					
                    cutscene:wait(1)
                    susie:setSprite("walk")
                    susie:setFacing("up")
                    cutscene:wait(1)
                    hero:setFacing("left")
                    susie:setFacing("right")

                    cutscene:showNametag("Hero")
                    cutscene:text("* Aight,[wait:5] let's get movin'.", "smug", "hero")
                    cutscene:hideNametag()

                    susie:convertToFollower()
                    Game:setFlag("cliffside_susie", true)
                    Game:addPartyMember("susie")
                    Game:unlockPartyMember("susie")
                    cutscene:attachCamera()
                    cutscene:wait(cutscene:attachFollowers())
                    cutscene:interpolateFollowers()
                    
                    Game.world.music:play("demonic_little_grey_cliffs", 1, 1)
                end
                if Game:getFlag("claimb_cat") == true then
                    Game:setFlag("suscla", true)
                    cutscene:getEvent(65):remove()
                end
                Game:setFlag(crystal.flag, true)
            else
                --cutscene:text("* You can't break a seal from the side you[color:yellow][wait:5] dummy[color:reset]!")
            end
        else
            cutscene:text("* You decide to not free them for now...")
        end
    end,

    cat_1 = function(cutscene, event)
        local hero = cutscene:getCharacter("hero")
        local cat = cutscene:getCharacter("cat")
        cutscene:wait(cutscene:walkTo(hero, 400, 460, 2, "right"))
        cutscene:showNametag("Cat")
        cutscene:text("* Hello,[wait:5] I've been expecting you.", "neutral", cat)
        cutscene:text("* As you can [color:yellow]see[color:reset][wait:5]\nthere are many hidden paths here.", "neutral", cat)
        cutscene:text("* I will show you the ones needed to progress.", "neutral", cat)
        cutscene:text("* I suggest you look around for [color:yellow]secret[color:reset] paths.", "neutral", cat)
        cutscene:text("* Let's move on.", "neutral", cat)
        cutscene:hideNametag()
        cutscene:wait(cutscene:walkTo(cat, cat.x + 300, cat.y + 80, 3, "up"))
        cat:remove()
        Game:setFlag("cliffsidecat_1", true)
    end,

    pebblin = function(cutscene, event)
        local hero = cutscene:getCharacter("hero")
        local pebblin = cutscene:getCharacter("pebblin")
        --cutscene:walkTo(hero, 465, hero.y, 4, "right")
        Game.world.music:fade(0, 4)
        --cutscene:wait(3)
        Assets.playSound("criticalswing")
        cutscene:wait(cutscene:slideTo(pebblin, Game.world.player.x, 260, 0.25, "in-cubic"))
        Assets.playSound("rudebuster_hit")
        pebblin:shake(5)
        hero:setSprite("battle/defeat")
        cutscene:wait(cutscene:slideTo(hero, hero.x - 250, hero.y, 1, "out-cubic"))
        cutscene:wait(0.5)
        Assets.playSound("wing")
        hero:shake(5)
        cutscene:wait(1)
        Assets.playSound("wing")
        hero:shake(5)
        hero:resetSprite()
        cutscene:wait(1)
        local encounter = cutscene:startEncounter("pebblin_tutorial", true, {{"pebblin", pebblin}})
        local defeated_enemies = encounter:getDefeatedEnemies()
        local done_state = defeated_enemies[1].done_state
        -- TODO: Make the Pebblin & Cat spawning happen before the fade in so it doesn't look jank
        if done_state ~= "KILLED" then
            Game:getPartyMember("hero"):addKarma(1)
        end
        pebblin:remove()
        local cat = cutscene:getCharacter("cat")
        if not cat then
            Game.world:spawnNPC("cat", 340, 60)
            cat = cutscene:getCharacter("cat")
        end
        Game.world.music:fade(1, 0.5)
        cutscene:wait(1)
        cutscene:showNametag("Cat")
        cutscene:text("* Well,[wait:5] that's certainly one way to skin a rock.", "neutral", cat)
        hero:setFacing("up")
        cutscene:text("* Hello,[wait:5] I was watching your battle.", "neutral", cat)
        cutscene:text("* It seems I do not need to explain [color:yellow]BATTLES[color:reset] to you.", "neutral", cat)
        cutscene:text("* But I shall explain a mechanic that the [color:#FF8800]kid in the striped shirt[color:reset] has.", "neutral", cat)
        cutscene:text("* [color:red]KARMA[color:reset].", "neutral", cat)
        cutscene:text("* If you do good actions,[wait:5] it will go up.", "neutral", cat)
        cutscene:text("* Befriend people,[wait:5]\nrecruit foes,[wait:5]\nsolve problems.", "neutral", cat)
        cutscene:text("* If you do bad actions,[wait:5] it will go down.", "neutral", cat)
        cutscene:text("* Antagonize friends,[wait:5] slaughter your foes,[wait:5] hurt the innocent.", "neutral", cat)
        cutscene:text("* Will you be a [color:green]PARAGON of VIRTUE[color:reset] or an [color:red]ANGEL of DEATH[color:reset]?", "neutral", cat)
        cutscene:text("* Or perhaps you wish to [color:yellow]walk the middle path[color:reset]?", "neutral", cat)
        cutscene:text("* The choice is yours.", "neutral", cat)
        cutscene:text("* I'm not some kind of [color:yellow]judge[color:reset].[wait:10]\n* I am but a simple Cat.", "neutral", cat)
        cutscene:text("* Take the cliff upwards,[wait:5] there's one last thing I need to explain.", "neutral", cat)
        cutscene:hideNametag()
        cutscene:wait(cutscene:walkTo(cat, cat.x, cat.y - 120, 2, "up"))
        cat:remove()
        Game:setFlag("cliffsidecat_2", true)
        hero:setFacing("right")
    end,

    reverse_cliff_1 = function (cutscene, event)


        local data = event.data

        local end_y = 80
        local p_y = Game.world.player.y
        local tiles = 12
        local length = tiles * 40
        local reverse_spot = p_y + length / 2

        Assets.playSound("noise")

        Game.world.player:setState("SLIDE")

        cutscene:wait(function ()
            if Game.world.player.base_speed_multiplier <= -2 then
                Assets.playSound("jump", 1, 0.5)
                Game.world.player.physics.speed_y = -10
                Game.world.player.physics.friction = -1.5
                Game.world.player.base_speed_multiplier = -2

                return true
            else
                Game.world.player.base_speed_multiplier = Game.world.player.base_speed_multiplier - DT * 2
                return false
            end
        end)

        cutscene:wait(function ()
            if Game.world.player.y < p_y then
                Game.world.player:setState("WALK")
                Game.world.player:setSprite("walk/down_1")
                Game.world.player.noclip = true

                return true
            else
                return false
            end
        end)

        cutscene:wait(function ()
            if Game.world.player.y < -20 then
                local x = Game.world.player.x - data.x + 420
                phys_speed = Game.world.player.physics.speed_y
                Game.world:mapTransition("grey_cliffside/cliffside_right_4", x, 1040)

                return true
            else
                return false
            end
        end)

        cutscene:wait(function ()
            if Game.world.map.id == "grey_cliffside/cliffside_right_4" then
                Game.world.player:setSprite("walk/down_1")
                Game.world.player.noclip = true

                Game.world.player.physics.speed_y = phys_speed
                Game.world.player.physics.friction = -1.5

                return true
            else
                return false
            end
        end)

        cutscene:wait(function ()
            if Game.world.player.y < 500 then
                Game.world.player.physics.friction = 4

                return true
            else
                return false
            end
        end)

        cutscene:wait(function ()
            if Game.world.player.physics.speed_y == 0 then
                Game.world.player.physics.friction = -1

                Game.world.player.physics.speed_y = 1

                return true
            else
                return false
            end
        end)

        cutscene:wait(function ()
            if Game.world.player.y > 260 then
                return true
            else
                return false
            end
        end)

        Game.world.player.noclip = false
        Game.world.player.physics.friction = 0
        Game.world.player.physics.speed_y = 0
        Game.world.player:setFacing("down")
        Game.world.player:resetSprite()
        Game.world.player:shake(5)
        Assets.playSound("dtrans_flip")
        Game.world.player.base_speed_multiplier = 1
    end,

    badge_tutorial = function(cutscene, event)
        local hero = cutscene:getCharacter("hero")
        hero:setFacing("up")
        cutscene:wait(0.3)
        cutscene:showNametag("Cat")
        cutscene:text("* Hello again.", "neutral", "cat")
        cutscene:text("* It is time to give you one last tutorial.", "neutral", "cat")
        cutscene:text("* Inside this chest is what is called a [color:yellow]BADGE[color:reset].", "neutral", "cat")
        cutscene:text("* Badges can be equipped to give you special effects.", "neutral", "cat")
        cutscene:text("* However,[wait:5] they require [color:yellow]BP[color:reset] to use.", "neutral", "cat")
        cutscene:text("* What does \"BP\" stand for?", "neutral", "cat")
        cutscene:text("* ...", "neutral", "cat")
        cutscene:text("* Boilet Paper.", "neutral", "cat")
        cutscene:text("* You start out with only 3 BP.", "neutral", "cat")
        cutscene:text("* However,[wait:5] there may be certain consumable items that raise your BP.", "neutral", "cat")
        cutscene:text("* Now,[wait:5] open that chest,[wait:5] open your menu,[wait:5] and go to the badge menu.", "neutral", "cat")
        cutscene:text("* Equip that badge and then come talk to me.", "neutral", "cat")
        cutscene:hideNametag()
    end,

    claimb_cat = function(cutscene, event)
        local hero = cutscene:getCharacter("hero")
        hero:setFacing("up")
        cutscene:wait(0.3)
        cutscene:showNametag("Cat")
        cutscene:text("* Hello again.", "neutral", "cat")
        cutscene:text("* Inside this chest are the [color:yellow]ClaimbClaws[color:reset].", "neutral", "cat")
        cutscene:text("* They will allow you to climb obvious walls.", "neutral", "cat")
        cutscene:text("* Collect it and then come talk to me.", "neutral", "cat")
        cutscene:hideNametag()
    end,

    force_claimb = function(cutscene, event)
        local hero = cutscene:getCharacter("hero")
        cutscene:showNametag("Cat")
        cutscene:text("* You cannot leave just yet.", "neutral", "cat")
        cutscene:hideNametag()
        hero:walkTo(hero.x, hero.y - 20, 0.5, "up")
        cutscene:wait(0.5)
    end,
    
    cat_claimb_done = function(cutscene, event)
        cutscene:showNametag("Cat")
            if Game.inventory:hasItem("claimbclaws") then
                cutscene:text("* Very excelent.", "neutral", "cat")
                cutscene:text("* You can now proceed.", "neutral", "cat")
                Game:setFlag("claimb_cat", true)
                if Game:getFlag("susie_freed") == true then
                    Game:setFlag("suscla", true)
                end
                cutscene:getEvent(16):remove()
            else
                cutscene:text("* You have not yet collected the item.", "neutral", "cat")
            end
        cutscene:hideNametag()
    end,

    force_suscla = function(cutscene, event)
        local hero = cutscene:getCharacter("hero")
        cutscene:text("* You cannot leave just yet.")
        cutscene:hideNametag()
        hero:walkTo(hero.x + 20, hero.y, 0.5, "right")
        cutscene:wait(0.5)
    end,

    force_badge_tutorial = function(cutscene, event)
        local hero = cutscene:getCharacter("hero")
        cutscene:showNametag("Cat")
        cutscene:text("* You cannot leave just yet.", "neutral", "cat")
        cutscene:text("* I still need to see if you know how to equip badges.", "neutral", "cat")
        cutscene:hideNametag()
        hero:walkTo(hero.x, hero.y - 20, 0.5, "up")
        cutscene:wait(0.5)
    end,

    cat_badge = function(cutscene, event)
        cutscene:showNametag("Cat")
        if not Game:getFlag("badge_tutorial") then
            if Game:getBadgeEquipped("stellar_lens") >= 1 then
                cutscene:text("* Very excelent.", "neutral", "cat")
                cutscene:text("* It may seem like that badge may be useless right now...", "neutral", "cat")
                cutscene:text("* But I forsee you potentially meeting someone...", "neutral", "cat")
                cutscene:text("* ... who can cast STAR element spells.", "neutral", "cat")
                cutscene:text("* Well,[wait:5] I have taught you everything you need to know.", "neutral", "cat")
                cutscene:text("* Go back to where we first met.", "neutral", "cat")
                cutscene:text("* I have a [color:yellow]friend[color:reset] who will show you the way forward.", "neutral", "cat")
                cutscene:text("* Until we meet again.", "neutral", "cat")
                cutscene:text("* ...", "neutral", "cat")
                cutscene:text("* [color:yellow]Perchance[color:reset].", "neutral", "cat")
                Game:setFlag("badge_tutorial", true)
                Game:getQuest("cliffsides_cat"):setProgress(1)
                cutscene:getEvent(11):remove()
            else
                cutscene:text("* You have not yet equipped the badge.", "neutral", "cat")
                cutscene:text("* Press the menu button and navigate to your badge menu.", "neutral", "cat")
                cutscene:text("* Then equip the badge,[wait:5] then talk to me.", "neutral", "cat")
            end
        else
            local rnd = love.math.random(1, 3)
            if rnd == 1 then
                cutscene:text("* I have nothing left to teach you.", "neutral", "cat")
            elseif rnd == 2 then
                cutscene:text("* Don't you have anything better to do?", "neutral", "cat")
            elseif rnd == 3 then
                cutscene:text("* ...", "neutral", "cat")
            end
        end
        cutscene:hideNametag()
    end,

    reverse_cliff_2 = function (cutscene, event)


        local data = event.data

        local end_y = 80
        local p_y = Game.world.player.y
        local tiles = 12
        local length = tiles * 40
        local reverse_spot = p_y + length / 2

        Assets.playSound("noise")

        Game.world.player:setState("SLIDE")

        cutscene:wait(function ()
            if Game.world.player.base_speed_multiplier <= -2 then
                Assets.playSound("jump", 1, 0.5)
                Game.world.player.physics.speed_y = -10
                Game.world.player.physics.friction = -1.5
                Game.world.player.base_speed_multiplier = -2

                return true
            else
                Game.world.player.base_speed_multiplier = Game.world.player.base_speed_multiplier - DT * 2
                return false
            end
        end)

        cutscene:wait(function ()
            if Game.world.player.y < p_y then
                Game.world.player:setState("WALK")
                Game.world.player:setSprite("walk/down_1")
                Game.world.player.noclip = true

                return true
            else
                return false
            end
        end)

        cutscene:wait(function ()
            if Game.world.player.y < -20 then
                local x = Game.world.player.x - data.x + 400
                phys_speed = Game.world.player.physics.speed_y
                Game.world:mapTransition("grey_cliffside/cliffside_start", x, 1040)

                return true
            else
                return false
            end
        end)

        cutscene:wait(function ()
            if Game.world.map.id == "grey_cliffside/cliffside_start" then
                Game.world.player:setSprite("walk/down_1")
                Game.world.player.noclip = true

                Game.world.player.physics.speed_y = phys_speed
                Game.world.player.physics.friction = -1.5

                return true
            else
                return false
            end
        end)

        cutscene:wait(function ()
            if Game.world.player.y < 520 then
                Game.world.player.physics.friction = 4

                return true
            else
                return false
            end
        end)

        cutscene:wait(function ()
            if Game.world.player.physics.speed_y == 0 then
                Game.world.player.physics.friction = -1

                Game.world.player.physics.speed_y = 1

                return true
            else
                return false
            end
        end)

        cutscene:wait(function ()
            if Game.world.player.y > 420 then
                return true
            else
                return false
            end
        end)

        Game.world.player.noclip = false
        Game.world.player.physics.friction = 0
        Game.world.player.physics.speed_y = 0
        Game.world.player:setFacing("down")
        Game.world.player:resetSprite()
        Game.world.player:shake(5)
        Assets.playSound("dtrans_flip")
        Game.world.player.base_speed_multiplier = 1
    end,

    reverse_cliff_up = function (cutscene, event)
        local data = event.data

        local top = data.properties["top"]
        local ssss = Game.world.player.layer

        if Game.world.player.jumping then return end

        Game.world.player:setState("SLIDE")
        Game.world.player.noclip = true

        Game.world.player.layer = 22

        Game.world.player.base_speed_multiplier = -3
        print(top)

        cutscene:wait(function ()
            if Game.world.player.y < top then
                return true
            else
                return false
            end
        end)

        Game.world.player:setState("WALK")

        Game.world.player.base_speed_multiplier = 1
        Game.world.player.noclip = false
        Game.world.player.layer = ssss
    end,
    warp_0 = function (cutscene, event)
        local data = event.data

        local tox = data.properties["to_x"]
        local toy = data.properties["to_y"]

        Game.world.player.x, Game.world.player.y = tox, toy
        Game.world.player:setFacing("down")
    end,


    reverse_cliff_0 = function (cutscene, event)
        if Game.world.player.jumping then return end

        local data = event.data

        local end_y = 80
        local p_y = Game.world.player.y
        local tiles = 12
        if p_y < 750 then tiles = 15 end
        local length = tiles * 40
        local reverse_spot = p_y + length / 2

        Assets.playSound("noise")

        Game.world.player.cliff = true

        Game.world.player:setState("SLIDE")

        cutscene:wait(function ()
            if Game.world.player.base_speed_multiplier <= -2 then
                Assets.playSound("jump", 1, 0.5)
                Game.world.player.physics.speed_y = -10
                Game.world.player.physics.friction = -1.5
                Game.world.player.base_speed_multiplier = -2

                return true
            else
                Game.world.player.base_speed_multiplier = Game.world.player.base_speed_multiplier - DT * 2
                return false
            end
        end)

        cutscene:wait(function ()
            if Game.world.player.y < p_y then
                Game.world.player:setState("WALK")
                Game.world.player:setSprite("walk/down_1")
                Game.world.player.noclip = true

                return true
            else
                return false
            end
        end)

        cutscene:wait(function ()
            if Game.world.player.y < reverse_spot then
                local x = Game.world.player.x - 240 + 400
                phys_speed = Game.world.player.physics.speed_y

                return true
            else
                return false
            end
        end)

        cutscene:wait(function ()
            if Game.world.player.y < 520 then
                Game.world.player.physics.friction = 4

                return true
            else
                return false
            end
        end)

        cutscene:wait(function ()
            if Game.world.player.physics.speed_y == 0 then
                Game.world.player.physics.friction = -1

                Game.world.player.physics.speed_y = 1

                return true
            else
                return false
            end
        end)

        cutscene:wait(function ()
            if Game.world.player.y > 420 then
                return true
            else
                return false
            end
        end)

        Game.world.player.noclip = false
        Game.world.player.physics.friction = 0
        Game.world.player.physics.speed_y = 0
        Game.world.player:setFacing("down")
        Game.world.player:resetSprite()
        Game.world.player:shake(5)
        Assets.playSound("dtrans_flip")
        Game.world.player.base_speed_multiplier = 1
        Game.world.player.cliff = nil
    end,

    warp_bin = function (cutscene, event)
        if Game:getFlag("susie_freed") then
            if not Game:getFlag("warpbin_tutorial") then
                Game:setFlag("warpbin_tutorial", true)
                cutscene:showNametag("Susie")
                cutscene:text("* Hmm...[wait:10] Looks like some kind of dumpster...", "neutral", "susie")
                cutscene:text("* Oh hey,[wait:5] there's a note on here.", "surprise", "susie")
                cutscene:text("* But...[wait:5] it's in some weird font or something...", "suspicious", "susie")
                cutscene:showNametag("Hero")
                cutscene:text("* Here,[wait:5] let me read it.", "neutral_closed_b", "hero")
                cutscene:hideNametag()
                cutscene:text("* (The note is scratched up and hard to read,[wait:5] but you could just barely make it out.)")
                cutscene:text("* (Warp Bin...[wait:10] enter code...[wait:10] transport to destination...)")
                cutscene:text("* (There also seems to be a list of codes as well,[wait:5] but all the codes are scratched out.)")
                cutscene:text("* (Save for \"THETOWER\"...)")
                cutscene:showNametag("Hero")
                cutscene:text("* Alright,[wait:5] I think I know how to use this.", "happy", "hero")
                cutscene:showNametag("Susie")
                cutscene:text("* That's good cause you did not read that out loud at all.", "smile", "susie")
                cutscene:text("* So I have no idea how to use this junk!", "sincere_smile", "susie")
                cutscene:showNametag("Hero")
                cutscene:text("* You...[wait:10] couldn't hear the narration?", "neutral_opened", "hero")
                cutscene:showNametag("Susie")
                cutscene:text("* What.", "shock", "susie")
                cutscene:showNametag("Hero")
                cutscene:text("* Nevermind.", "suspicious", "hero")
                cutscene:hideNametag()
            end
    -- HUGE NOTE: THIS IS THE UGLIEST OF ALL BUTT UGLY HACKS
    -- DO NOT DO WHAT I'M DOING, THIS SHOULD BE REPLACED WITH A SPECIAL EVENT INSTEAD OF DOING EVERYTHING IN THIS CUTSCENE
    -- It is almost 1 AM for me so I can't be bothered to do it myself
    --                                                                     - BrendaK7200
    cutscene:text("* It's the warp bin.")
    cutscene:text("* Would you like to warp?[wait:10]\n* You only need the code.")

    if cutscene:choicer({"Sure", "Nope"}) == 2 then
        return
    end

    local action_raw = cutscene:getUserText(8, "warpbin", nil, nil, {
        ---@type fun(text:string,key:string,object:WarpBinInputMenu|GonerKeyboard)
        key_callback = function (text, key, object, fade_rect)
            -- Kristal.Console.log(text..key)
            local code = Kristal:getBinCode(text..key)
            if code and code.instant then
                if object.__includes_all[GonerKeyboard] then
                    object.callback(text..key)
                else
                    object:finish_cb(text..key)
                end
                fade_rect:remove()
                object:remove()
            end
        end
    })
    if action_raw == "THETOWER" then
        cutscene:wait(0.2)
        Game.world.music:stop()
        -- Hell naw is this the only way to stop all sounds?
        for key,_ in pairs(Assets.sound_instances) do
            Assets.stopSound(key, true)
        end
        cutscene:fadeOut(0)
        cutscene:playSound("impact")

        cutscene:wait(1)
        cutscene:loadMap("main_outdoors/tower_outside")
        cutscene:fadeIn(0.25)
    else
        if not Game:getFlag("warpbin_tutorial_wrongcount") then
            Game:setFlag("warpbin_tutorial_wrongcount", 1)
        else
            Game:addFlag("warpbin_tutorial_wrongcount", 1)
        end
        cutscene:text("* (That code didn't seem to work...)")
        if Game:getFlag("warpbin_tutorial_wrongcount") == 2 then
            cutscene:showNametag("Susie")
            cutscene:text("* ...", "shy", "susie")
        elseif Game:getFlag("warpbin_tutorial_wrongcount") == 3 then
            cutscene:showNametag("Susie")
            cutscene:text("* You sure you actually read that note, dude?", "suspicious", "susie")
            cutscene:showNametag("Hero")
            cutscene:text("* Yeah of course I did.", "pout", "hero")
            cutscene:text("* I'm just uh...", "shocked", "hero")
            cutscene:text("* Having troubles inputing the code,[wait:5] that's all!", "happy", "hero")
            cutscene:showNametag("Susie")
            cutscene:text("* ...[wait:5] Right...", "suspicious", "susie")
        elseif Game:getFlag("warpbin_tutorial_wrongcount") == 4 then
            cutscene:showNametag("Hero")
            cutscene:text("* ("..Game.save_name..",[wait:5] could you actually put in the right code?)", "suspicious", "hero")
        elseif Game:getFlag("warpbin_tutorial_wrongcount") >= 5 then
            cutscene:text("* (You recalled that the only visible code was \"THETOWER\"...)")
        end
        cutscene:hideNametag()
    end
        else
            cutscene:text("* Error: 2 or more lightners required to activate a broken bin.")
        end
    end,

    video = function (cutscene, event)
        local video = Video("spongebob", true, 0, 0, 640, 480) -- assets/videos/video_here.ogv
        video.parallax_x, video.parallax_y = 0, 0
        video:play()
        video:addFX(ShaderFX(Assets.getShader("chromakey"), {
                        ["keyColor"] = { 0.0, 1.0, 0.0, 1.0 }, -- Pure green (R=0, G=1, B=0)
                        ["threshold"] = 0.4,         -- Adjust the threshold for green color tolerance
                    }), 66)
        Game.stage:addChild(video)

        cutscene:wait(function ()
            local check = video:isPlaying()

            if video.was_playing and not video.video:isPlaying() then
                return true
            else
                return false
            end
        end)
        video:remove()
    end,

    --old susie cutscene
    --[[
	susie = function (cutscene, event)
        local hero = cutscene:getCharacter("hero")
        local susie = cutscene:getCharacter("susie")

        hero:walkTo(300, 820, 1.5, "up")
        cutscene:wait(1.5)
        susie:alert()
        local whodis = {nametag = "???"}
        hero:setFacing("left")
        cutscene:textTagged("* Hey,[wait:5] who are you?", "neutral_closed_b", "hero")
        susie:setFacing("right")
        cutscene:textTagged("* Woah.", "surprise", "susie", whodis)
        susie:walkTo(230, 820, 0.75, "right")
        cutscene:wait(0.75)
        cutscene:textTagged("* Are you like,[wait:5] another person?", "surprise_smile", "susie", whodis)
        cutscene:textTagged("* Uh,[wait:5] I guess?", "neutral_closed", "hero")
        susie:setSprite("exasperated_right")
        cutscene:textTagged("* Thank GOD.", "teeth_b", "susie", whodis)
        cutscene:textTagged("* There's nothing but rocks and that stupid cat here! [wait:1][react:1]", "teeth", "susie",
                      {
                          reactions = {
                              { "I can still hear\nyou...", "right", "bottom", "neutral", "cat" }
                          }, nametag = "???"
                      })

        susie:resetSprite()
        cutscene:textTagged("*[react:1] Uh,[wait:5] you asked who I was,[wait:5] right?", "sus_nervous", "susie",
                      {
                          reactions = {
                              { "You're very [color:yellow]rude[color:rest].", "right", "bottom", "neutral", "cat" }
                          }, nametag = "???"
                      })
        cutscene:textTagged("* Yeah.", "neutral_closed", "hero")
        cutscene:textTagged("* Well,[wait:5] the name's Susie!", "sincere_smile", "susie")
        cutscene:hideNametag()

        Game.world.music:pause()

        Assets.playSound("jump")
        susie:setFacing("down")
        cutscene:wait(0.1)
        susie:setFacing("left")
        cutscene:wait(0.1)
        susie:setFacing("up")
        cutscene:wait(0.1)
        susie:setFacing("right")
        cutscene:wait(0.1)
        susie:setFacing("down")
        cutscene:wait(0.1)
        susie:setFacing("left")
        cutscene:wait(0.1)
        susie:setFacing("up")
        cutscene:wait(0.1)
        susie:setFacing("right")
        cutscene:wait(0.1)
        Assets.playSound("impact")
        susie:setSprite("pose")
        cutscene:wait(0.5)
        cutscene:setSpeaker("susie")
        local get_bus = Music("get_on_the_bus")
        Game.world:spawnObject(MusicLogo(" Get on the Bus\n    Earthbound OST", 360, 220), WORLD_LAYERS["ui"])



        cutscene:textTagged("* You may have heard of my name before.", "small_smile")
        cutscene:textTagged("* After all,[wait:5] I AM a Delta Warrior.", "smile")
        cutscene:setSpeaker("hero")
        get_bus:pause()
        cutscene:textTagged("* I have literally never heard of you in my life.", "annoyed_b")
        susie:resetSprite()
        cutscene:setSpeaker("susie")
        cutscene:textTagged("* Oh.", "shock")
        susie:setSprite("away_scratch")
        get_bus:resume()
        cutscene:textTagged("* Anyways...", "shy")
        susie:resetSprite()
        cutscene:textTagged("* What's YOUR name?", "neutral")
        cutscene:setSpeaker("hero")
        cutscene:textTagged("* It's Hero.", "neutral_closed")
        cutscene:setSpeaker("susie")
        cutscene:textTagged("* Hero?", "surprise")
        cutscene:textTagged("* Dude,[wait:5] that is the most cliche name I have ever heard!", "sincere_smile")
        cutscene:textTagged("* Uh,[wait:5] no offense.", "shock_nervous")
        cutscene:setSpeaker("hero")
        cutscene:textTagged("* ... Right.", "really")
        cutscene:textTagged("* Wait a second...", "neutral_closed")
        cutscene:textTagged("* I'm actually looking for a Delta Warrior.", "neutral_closed_b")
        cutscene:setSpeaker("susie")
        cutscene:textTagged("* Oh,[wait:5] you lookin' for a fight?", "teeth_smile")
        cutscene:setSpeaker("hero")
        cutscene:textTagged("* Uh,[wait:5] hopefully not.", "shocked")
        cutscene:textTagged("* So basically...", "neutral_closed_b")
        cutscene:hideNametag()

        get_bus:fade(0, 1)

        cutscene:wait(cutscene:fadeOut(1))
        cutscene:wait(2)

        local lore_board = Sprite("world/cutscenes/cliffside/lore_board")

        lore_board.x, lore_board.y = 220, 680

        Game.world:addChild(lore_board)

        lore_board:setScale(2)
        lore_board.layer = 0.6

        cutscene:wait(cutscene:fadeIn(1))
        cutscene:textTagged("* Oh damn.", "shock", "susie")
        cutscene:textTagged("* Yeah.", "neutral_closed", "hero")
        if Game:getFlag("cliffside_askedDeltaWarrior") == "susie" then
            cutscene:textTagged("* Plus you look just like the person who I was told did all this.", "really", "hero")
        end
        cutscene:textTagged("* Uhh,[wait:5] guess I'm not opening any more Dark Fountains then.", "shock_nervous", "susie")
        susie:setSprite("exasperated_right")

        get_bus:fade(1, 0.01)

        cutscene:setSpeaker("susie")
        cutscene:textTagged("* WHY THE HELL DID RALSEI NOT TELL ME ABOUT THIS?!", "teeth_b")
        susie:resetSprite()
        cutscene:textTagged("* The Roaring?[wait:10]\nCool and badass end of the world.", "teeth_smile")
        cutscene:textTagged("* I'd get to fight TITANS!", "closed_grin")
        susie:setFacing("up")
        cutscene:textTagged("* But reality collapsing in on itself?", "neutral_side")
        susie:setFacing("right")
        cutscene:textTagged("* That's just lame.", "annoyed")
        cutscene:setSpeaker("hero")
        cutscene:textTagged("* Well,[wait:5] that's settled then.", "smug_b")
        cutscene:textTagged("* We'll go seal this fountain and the world is saved.", "smug")
        cutscene:textTagged("* Y'know unless anyone else decides to open up fountains but uh...", "shocked")
        cutscene:textTagged("* I'm sure it'll be fine.", "happy")
        cutscene:showNametag("Susie")
        cutscene:textTagged("* Uhh,[wait:5] where even IS the Dark Fountain?", "nervous_side", "susie")
        cutscene:showNametag("Hero")
        cutscene:textTagged("* That...[wait:5] is something I don't know.", "annoyed", "hero")
        cutscene:showNametag("Susie")
        susie:setSprite("exasperated_right")
        cutscene:textTagged("* Oh great,[wait:5] don't tell me we're stuck here!", "teeth", "susie")
        susie:resetSprite()
        cutscene:showNametag("Hero")
        cutscene:textTagged("* Hey,[wait:2] I'm sure there's a way out of here.", "neutral_closed_b", "hero")
        susie:setFacing("left")
        cutscene:textTagged("* We just gotta keep going forward.", "happy", "hero")
        cutscene:showNametag("Susie")
        susie:setFacing("right")
        cutscene:textTagged("* Yeah,[wait:5] you're right.", "small_smile", "susie")
        cutscene:textTagged("* Well,[wait:5] lead the way, Hero!", "sincere_smile", "susie")
        cutscene:hideNametag()

        get_bus:stop()

        local fan = Music("deltarune/fanfare", 1, 1, false)

        lore_board:slideTo(-120, 680, 15)

        cutscene:text("[noskip][speed:0.1]* (Susie joined the[func:remove] party!)[wait:20]\n\n[speed:1]UwU",
            {
                auto = true,
                functions = {
                    remove = function ()
                        lore_board:explode()
                    end
                }
            })
        fan:remove()

        susie:convertToFollower()
        Game:setFlag("cliffside_susie", true)
        Game:addPartyMember("susie")
        Game:unlockPartyMember("susie")
        cutscene:wait(cutscene:attachFollowers())

        Game.world.music:resume()
    end,
	]]
	
    worse_vents = function (cutscene, event)
        cutscene:detachFollowers()
        local walktime,waittime = 0.2, 0.2
        local data = event.data.properties
        local party = Utils.merge({Game.world.player}, Game.world.followers)
        local waiters = {}
        local impactfuse = {}
        local tx,ty = cutscene.world.map:getMarker(data.target and data.target.id or data.marker)
        local center_x = event.x + (event.width/2)
        local center_y = event.y + (event.height/2)
        Game.world.timer:script(function (wait)
            for i, chara in pairs(party) do
                local waiter = (cutscene:walkTo(chara, center_x, center_y, walktime))
                repeat wait(1/30) until waiter()
                Assets.playSound("jump")
                local sx,sy = chara:getPosition()
                local distance = Utils.dist(sx,sy,tx,ty)
                table.insert(waiters, cutscene:jumpTo(chara, tx, ty, 20, distance * 0.003, "jump_ball", "landed"))
                wait(waittime)
                for j, nextchara in ipairs(party) do
                    if j <= i then goto continue end
                    if j >= #party then goto continue end
                    cutscene:walkTo(party[j+1], party[j].x, party[j].y, walktime)
                    ::continue::
                end
            end
        end)
        cutscene:wait(function ()
            for i,v in ipairs(waiters) do
                if not v() then
                    return false
                elseif not impactfuse[i] then
                    if i == 1 then
                        cutscene:enableMovement()
                    else
                        party[i]:interpolateHistory()
                        party[i]:updateIndex()
                        party[i]:returnToFollowing()
                    end
                    impactfuse[i] = true
                    Assets.playSound("impact", 0.7)
                end
            end
            return #waiters == #party
        end)
        cutscene:interpolateFollowers()
        cutscene:attachFollowers()
    end,
}
return cliffside

---@type table<string,fun(cutscene:WorldCutscene, event?: Event|NPC)>
local hub = {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `WorldCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene WorldCutscene
    wall = function(cutscene, event)
        -- Open textbox and wait for completion
        cutscene:text("* The wall seems cracked.")
        if Game:isDessMode() then
            local dess = cutscene:getCharacter("dess")

            cutscene:detachCamera()
            cutscene:detachFollowers()

            cutscene:showNametag("Dess")
            if Game:getFlag("wall_hit", false) then
                cutscene:text("* okay this time for SURE im gonna wreck it", "annoyed", "dess")
            else
                cutscene:text("* as a wise man once said", "calm_b", "dess")
                cutscene:text("* I'm gonna wreck it!", "angry", "dess")
            end
            cutscene:hideNametag()
            local x = event.x + event.width/2
            local y = event.y + event.height/2

            if Game:getFlag("wall_hit", false) then
                cutscene:walkTo(dess, x, y + 60, 0.75, "up")
                cutscene:wait(1)

                -- wall guardian appearing
                local wall = Game.world:spawnObject(NPC("wall", x, 0, {cutscene = "hub.wall_guardian"}))

                Assets.playSound("drive")
                cutscene:slideTo(wall, wall.x, y + 60, 0.5)
                cutscene:wait(0.25)
                cutscene:slideTo(dess, x - 60, y + 120, 0.25, "linear")
                dess:setSprite("battle/hurt")
                cutscene:wait(0.25)
                Assets.playSound("impact")
                cutscene:shakeCamera(0,16,1)
                cutscene:wait(1)
                cutscene:showNametag("Dess")
                cutscene:text("* oh you gotta be fuckin kidding me", "angry", "dess")
                cutscene:hideNametag()
                dess:shake(4)
                Assets.playSound("wing")
                dess:resetSprite()
            else
                cutscene:walkTo(dess, x, y + 40, 0.75, "up")
                
                cutscene:wait(1.5)
                
                cutscene:wait(cutscene:walkTo(dess, x, y + 60, 0.5, "up", true))
                cutscene:wait(cutscene:walkTo(dess, x, y + 20, 0.2))
                
                Assets.playSound("impact")
                dess:shake(4)
                
                cutscene:slideTo(dess, x, y + 60, 0.1)
                cutscene:wait(1.5)
                
                dess:resetSprite()
                dess:shake(4)
                Assets.playSound("wing")
                
                cutscene:wait(1)

                cutscene:showNametag("Dess")
                cutscene:text("* damn", "neutral_b", "dess")
                cutscene:hideNametag()
            end

            cutscene:wait(cutscene:attachCamera(1))
            cutscene:attachFollowers()
            Game:setFlag("wall_hit", true)
        else
    
            -- If we have Susie, play a cutscene
            local susie = cutscene:getCharacter("susie")
            if susie then
                -- Detach camera and followers (since characters will be moved)
                cutscene:detachCamera()
                cutscene:detachFollowers()
    
                -- All text from now is spoken by Susie
                cutscene:showNametag("Susie")
                cutscene:setSpeaker(susie)
                cutscene:text("* Hey,[wait:5] think I can break\nthis wall?", "smile")
                cutscene:hideNametag()
    
                -- Get the bottom-center of the broken wall
                local x = event.x + event.width/2
                local y = event.y + event.height/2
    
                if Game:getFlag("wall_hit", false) then
                    cutscene:walkTo(Game.world.player, x, y + 100, 0.75, "up")
                    cutscene:walkTo(susie, x, y + 60, 0.75, "up")
                    if cutscene:getCharacter("ralsei") then
                        cutscene:walkTo("ralsei", x, y + 100, 0.75, "up")
                    end
                    if cutscene:getCharacter("noelle") then
                        cutscene:walkTo("noelle", x, y + 100, 0.75, "up")
                    end
                    cutscene:wait(1)
    
                    -- wall guardian appearing
                    local wall = Game.world:spawnObject(NPC("wall", x, 0, {cutscene = "hub.wall_guardian"}))
    
                    Assets.playSound("drive")
                    cutscene:slideTo(wall, wall.x, y + 60, 0.5)
                    cutscene:wait(0.25)
                    cutscene:slideTo(susie, x - 60, y + 120, 0.25, "linear")
                    cutscene:slideTo(Game.world.player, x + 60, y + 120, 0.25, "linear")
                    susie:setSprite("shock_right")
                    cutscene:wait(0.25)
                    Assets.playSound("impact")
                    cutscene:shakeCamera(0,16,1)
                    cutscene:wait(1)
                    cutscene:showNametag("Susie")
                    cutscene:text("* Guess not!", "surprise_frown")
                    susie:setAnimation({"away_scratch", 0.25, true})
                    susie:shake(4)
                else
                    
                    -- Move Susie up to the wall over 0.75 seconds
                    cutscene:walkTo(susie, x, y + 40, 0.75, "up")
                    -- Move other party members behind Susie
                    cutscene:walkTo(Game.world.player, x, y + 100, 0.75, "up")
                    if cutscene:getCharacter("ralsei") then
                        cutscene:walkTo("ralsei", x + 60, y + 100, 0.75, "up")
                    end
                    if cutscene:getCharacter("noelle") then
                        cutscene:walkTo("noelle", x - 60, y + 100, 0.75, "up")
                    end
                    
                    -- Wait 1.5 seconds
                    cutscene:wait(1.5)
                    
                    -- Walk back,
                    cutscene:wait(cutscene:walkTo(susie, x, y + 60, 0.5, "up", true))
                    -- and run forward!
                    cutscene:wait(cutscene:walkTo(susie, x, y + 20, 0.2))
                    
                    -- Slam!!
                    Assets.playSound("impact")
                    susie:shake(4)
                    susie:setSprite("shock_up")
                    
                    -- Slide back a bit
                    cutscene:slideTo(susie, x, y + 40, 0.1)
                    cutscene:wait(1.5)
                    
                    -- owie
                    susie:setAnimation({"away_scratch", 0.25, true})
                    susie:shake(4)
                    Assets.playSound("wing")
                    
                    cutscene:wait(1)
    
                    cutscene:showNametag("Susie")
                    cutscene:text("* Guess not.", "nervous")
                end
                cutscene:hideNametag()
    
                -- Reset Susie's sprite
                susie:resetSprite()
    
                -- Reattach the camera
                cutscene:attachCamera()
    
                -- Align the follower positions behind Kris's current position
                cutscene:alignFollowers()
                -- And reattach them, making them return to their target positions
                cutscene:attachFollowers()
                Game:setFlag("wall_hit", true)

            end
        end
    end,

    wall_guardian = function(cutscene)
        local wallnpc = cutscene:getCharacter('wall')
        cutscene:setSpeaker(wallnpc)
        cutscene:text("* I Am the Wall Guardian.[wait:5]\n* This Wall is Off Limits for you\nno-good wall slammers.")
    end,
	
    nokia_dog = function(cutscene, event)
        local dog = cutscene:getCharacter("dog")

        cutscene:showNametag("Dog")
        cutscene:text("* I'm just a dog, but I'm also...")
        cutscene:hideNametag()

        Game.world.music:pause()
        local nokia = Music("nokia")
        nokia:play()
        cutscene:wait(2.5)

        cutscene:showNametag("Dog")
        dog:setAnimation("holdphone")
        cutscene:text("* Who the...")
		cutscene:text("* Excuse me for a sec.")
		nokia:remove()
		dog:setAnimation("talkphone")
		cutscene:text("* .[wait:5].[wait:5].[wait:10]Hello?")
        cutscene:hideNametag()

        local dmc2 = Music("voiceover/plaeDMC2")
        dmc2:play()
        cutscene:wait(2.5)

        cutscene:showNametag("Dog")
        cutscene:text("* ...[wait:10]You again.")
        cutscene:text("* I already told you...[wait:5]\nTHIS ISN'T FUNNY!")
        dog:setAnimation("holdphone")
        cutscene:text("* Hey...[wait:5] Hey![wait:5] HEEEY![wait:5] \nARE YOU LISTENING TO ME?")
        cutscene:text("* I've had enough of this!")
        cutscene:text("* I have your number you know,[wait:5]\nI know where you live.[wait:8]\n* YOU...[wait:10][shake:2]SCUM!!!")
        cutscene:hideNametag()

		dmc2:remove()
		Game.world.music:resume()
		dog:resetSprite()
    end,

    malius = function(cutscene, event)
        cutscene:text("* Well, [wait:5]well. [wait:5]Welcome to the FUSING ROOM.")
        cutscene:text("* I am this room's smith, [wait:5]MALIUS.")
        cutscene:text("* Using my skills, [wait:5]I can FUSE items to create NEW ONES.")
        cutscene:text("* Or I can REPAIR whatever broken items you possess.")
	
        local choice = cutscene:choicer({"Fix Item", "Fuse", "Fix Us", "Leave"})
        if choice == 2 then

    local items_list = {
        {
            result = "soulmantle",
            item1 = "flarewings",
            item2 = "discarded_robe"
        },
        {
            result = "dd_burger",
            item1 = "darkburger",
            item2 = "darkburger"
        },
        {
            result = "silver_card",
            item1 = "amber_card",
            item2 = "amber_card"
        },
        {
            result = "twinribbon",
            item1 = "pink_ribbon",
            item2 = "white_ribbon"
        },
        {
            result = "spikeband",
            item1 = "glowwrist",
            item2 = "ironshackle"
        },
        {
            result = "tensionbow",
            item1 = "bshotbowtie",
            item2 = "tensionbit"
        },
        {
            result = "gold_card",
            item1 = "silver_card",
            item2 = "silver_card",
        },
    }
    Kristal.callEvent("setItemsList", items_list)

            cutscene:after(function()
                Game.world:openMenu(FuseMenu())
            end)	
        elseif choice == 3 then
            local malius = cutscene:getCharacter("malius")
            cutscene:detachCamera()
            cutscene:detachFollowers()
            cutscene:text("* Your body is a weapon,[wait:5]too. [wait:5]You must take care of it from time to time.")
            cutscene:text("* Huh-hah![wait:5] Let's feel my technique.")

            Game.world.music:pause()
            Assets.playSound("noise")
            malius:setAnimation("powerup")
            cutscene:wait(1.5)

            local order = {}

            for i = #Game.party, 1, -1 do
                table.insert(order, Game.party[i])
            end

            for i, party in pairs(order) do
                local id = party.actor.id 

                local char = cutscene:getCharacter(id)
                local x, y = char.x, char.y
                local facing = char.facing

                char.layer = 0.39
                char.x, char.y = 460, 348
                char:setFacing("down")

                if id == "susie" then
                    char:setSprite("shock_left")
                elseif id == "dess" then
                    char:setSprite("beatbox")
                elseif id == "ceroba_dw" then
                    char.x = char.x - 10
                    char.y = char.y + 15
                    char:setSprite("fall")
                elseif id == "mario" then
                    char.x = char.x - 30
                    char:setSprite("slide")
                elseif id == "noelle" then
                    char:setSprite("shocked")
                end

                malius:setAnimation("hit")
                Assets.playSound("squeaky")
                cutscene:wait(9/15)
                malius:setAnimation("hit")
                Assets.playSound("squeaky")
                cutscene:wait(9/15)
                
                char:resetSprite()

                char.x, char.y = x, y
                char.layer = 0.4
                char:setFacing(facing)
            end

            malius:resetSprite()

            Game.world.music:resume()
            Assets.playSound("power")
            for _,chara in ipairs(Game.party) do
                chara:heal(math.huge, false)
            end
            cutscene:text("* (Somehow, [wait:5]everyone's HP was restored.)")
            cutscene:interpolateFollowers()
            cutscene:attachFollowers()
            cutscene:attachCamera()
        end
    end,

    fun_fax = function(cutscene, event)
        Assets.playSound("bell")
        cutscene:wait(0.25)
        Assets.playSound("bell")
        cutscene:wait(1)

        local fun_fax = Game.world:spawnNPC("fun_fax", -210, 660)

        Game.world.music:fade(0, 0.25)

        Assets.playSound("mac_start")
        cutscene:slideTo(fun_fax, 310, 660, 0.8, "in-out-quint")

        if not Game:getFlag("met_fun_fax") then
            Game:setFlag("met_fun_fax", true)

            cutscene:wait(5)

            cutscene:text("* [speed:0.2]Mmmmm,[wait:20][speed:0.2]\nyes[speed:0.1]..........")

            fun_fax:setSprite("watching")
            cutscene:wait(3)
            fun_fax:setSprite("searching")
            cutscene:wait(2)
            fun_fax:setSprite("watching")
            cutscene:wait(1)
            fun_fax:setSprite("searching")
            cutscene:wait(0.5)
            fun_fax:setSprite("watching")
            cutscene:wait(0.5)
            fun_fax:setSprite("searching")
            cutscene:wait(0.5)
            fun_fax:setSprite("watching")
            cutscene:wait(0.5)
            fun_fax:setSprite("searching")
            cutscene:wait(0.25)
            fun_fax:setSprite("searching")
            cutscene:wait(0.12)
            fun_fax:setSprite("watching")
            cutscene:wait(0.05)
            fun_fax:setSprite("searching")
            cutscene:wait(0.05)
            fun_fax:setSprite("watching")
            cutscene:wait(0.05)
            fun_fax:setSprite("searching")
            cutscene:wait(0.05)
            fun_fax:setSprite("watching")
            cutscene:wait(0.05)
            fun_fax:setSprite("searching")
            cutscene:wait(0.005)
            fun_fax:setSprite("watching")
            cutscene:wait(0.0005)
            fun_fax:setSprite("searching")
            cutscene:wait(0.00005)
            fun_fax:setSprite("watching")
            cutscene:wait(0.000005)
            fun_fax:setSprite("searching")
            cutscene:wait(0.0000005)
            for _ = 1, 8 do
                fun_fax:setSprite("watching")
                cutscene:wait(0.0000005)
                fun_fax:setSprite("searching")
                cutscene:wait(0.0000005)
            end
            fun_fax:setSprite("searching")
            cutscene:wait(3)
            fun_fax:setSprite("watching")
            cutscene:wait(5)

            cutscene:text("* Alola...")
            cutscene:text("* [speed:0.5]That's a pokemon yaknow...[wait:25]\n...[wait:25]\n...")
            cutscene:text("* [speed:0.25]...[wait:25]\n...[wait:25]\n...")
            cutscene:text("* [speed:0.25]...[wait:25]\n...[wait:25]\n...")

            cutscene:wait(3)
        else
            cutscene:wait(4)
            fun_fax:setSprite("watching")
            cutscene:wait(1)
            fun_fax:setSprite("searching")
            cutscene:wait(0.5)
            fun_fax:setSprite("watching")
            cutscene:wait(0.25)
        end

        fun_fax:setSprite("searching")
        cutscene:wait(0.5)
        Assets.playSound("ui_select")
        cutscene:wait(0.1)

        local music_assets = Assets.data.music

        local track_names = {}

        for track_name, _ in pairs(music_assets) do
            if not Utils.startsWith(track_name, "voiceover/") then
                table.insert(track_names, track_name)
            end
        end

        local random_theme = Music(Utils.pick(track_names), 0.8, 1)

        cutscene:wait(0.4)
        fun_fax:setSprite("watching")
        cutscene:wait(2)

        local dialogue_pairs = {
            {"* I wrote a book recently...", "* It had a few quotes..."},
            {"* Mama always said life was like a box-o-chocolates...", "* Ya never know what ya might get..."},
            {"* Have you heard of the woody theory...", "* It means there is a friend inside you..."},
            {"* AcousticJamm once said...", "* Brb, I gotta iron my fish..."},
            {"* Did you know sans is Ness...", "* Game Theory told me so..."},
            {"* Did you know Dess is Ness...", "* JaruJaruJ told me so..."},
            {"* I can see your FUN value...", "* I'm not allowed to tell you though..."},
            {"* Don't forget...", "* I'm with you in the dark..."},
            {"* You need to go fast...", "* As fast as you can..."},
            {"* A room in between...", "* It may go on forever..."},
            {"* The DEVS don't know they aren't the real ones...", "* Never tell them this information..."},
            {"* DeltaDreams died for this...", "* Not really..."},
            {"* I can see things far away...", "* I can't see you..."},
            {"* Drink soda...", "* It'll help you see faster..."},
            {"* I had a wife...", "* But they took her in the devorce..."},
            {"* I was created in a night...", "* Sleep deprivation is unhealthy..."},
            {"* This is a full quote in the code...", "* It was just split into two..."},
            {"* If it's not worth it...", "* You should not do it..."},
            {"* Hunger strikes me...", "* I must proceed..."},
            {"* The lore doesn't matter...", "* Just enjoy the fun..."},
            {"* There is nobody behind the tree...", "* I checked..."},
            {"* Time does not matter...", "* It always ends..."},
            {"* Do your choices matter...", "* It always depends..."},
            {"* What is a dark world...", "* A world in darkness..."},
            {"* Is there a light fountain...", "* I would not know..."},
            {"* Do you miss them...", "* You probably don't know who I'm talking about..."},
            {"* Is it fate...", "* Or is it chance..."},
            {"* Gender is odd to me...", "* It keeps being updated..."},
            {"* The end is never...", "* Or so I was told..."},
            {"* The line between fact and fiction can be blurred...", "* Until it isn't there anymore..."},
            {"* Our universe doesn't have a lightner strong enough to seal our fountain...", "* So we looked in other worlds..."},
            {"* Our world grows unstable...", "* A single BAD HOOK could end it all..."},
            {"* A giant schoolgirl and a boot are lurking...", "* They both seem famillar somehow..."},
            {"* What counts as a duplicate...", "* And what does not..."},
            {"* There is only one being more aware then the self aware characters here...", "* How does it feel to be that being?\n* Don't answer,[speed:0.25]I can't hear you."},
            {"* If my thoughts were still in order...", "* I would be able to socialize agian..."},
            {"* The timelines...", "* They're three of them..."},
            {"* A DEV tried to fix me...", "* But I was never broken..."}, --But holy hell did you optimize my fucking shitty code
            {"* I've heard a story once...", "* I forgot how it ends..."},
            {"* The shop out of bounds...", "* The guy inside it is an handful..."},
            {"* People often ask what's my head...", "* I'm getting too old for this..."},
            {"* Simbel once said...", "* I don't have his quote yet..."},
            {"* I tried to talk to people once...", "* But they all just said \"Why are you in my house?\"..."},
            {"* Here's a fact about Kristal...", "* It's a combination of \"Crystal\" and \"Kris\"..."},
            {"* You can recruit your enemies now...", "* But where do they go after the battle..."},
            {"* Keep your friends close to you...", "* And your enemies even closer..."},
            {"* What's canon...", "* Well it's a weapon..."},
            {"* Don't forget to take a break...", "* Lack of sleep is bad, y'know..."},
            {"* It's raining somewhere else...", "* So take out your umbrella..."},
            {"* [color:grey]GREY[color:reset]...", "* [color:grey]AREA[color:reset]..."},
            {"* We are reborn...", "* Despite never being born..."},
            {"* Have you seen my friend...", "* His name is [color:yellow]Wocter Ding Dings[color:reset]..."},
            {"* Don't mess with reality...", "* This is a [color:red]threat[color:reset]..."},
            {"* The discovery channel would never lie to you...", "* It would lie to everyone..."},
            {"* There is no fridge...", "* I lied..."}
        }

        cutscene:text("[speed:0.5]" .. Utils.pick(dialogue_pairs)[1])

        fun_fax:setSprite("searching")
        cutscene:wait(1.5)
        fun_fax:setSprite("watching")
        cutscene:wait(1.5)

        cutscene:text("[speed:0.5]" .. Utils.pick(dialogue_pairs)[2])

        cutscene:wait(3)
        fun_fax:setSprite("searching")
        Assets.playSound("ui_select")
        random_theme:stop()
        cutscene:wait(0.2)
        fun_fax:setSprite("watching")
        cutscene:wait(2)

        cutscene:slideTo(fun_fax, 800, 660, 0.8, "in-out-quint")
        Assets.playSound("mac_start")
        cutscene:wait(0.2)
        fun_fax:setSprite("searching")
        cutscene:wait(2)

        fun_fax:remove()
        random_theme:remove()
        Game.world.music:fade(1, 0.25)
    end,

    sans = function(cutscene, event)
        local sans = Game.world:getCharacter("sans")

        local susieHasMetSans = Game:getFlag("susieHasMetSans", false)
        local dessHasMetSans = Game:getFlag("dessHasMetSans", false)
		
		if (not Game:getFlag("sansHint")) or (Game:getFlag("sansHint") and Game.world.player.facing ~= "right") then
            if cutscene:getCharacter("susie") and susieHasMetSans == false then
                cutscene:textTagged("* YOU!?", "teeth_b", "susie")
                cutscene:textTagged("* 'sup.", "neutral", "sans")
                cutscene:textTagged("* What the hell are you doing here???", "teeth", "susie")
                cutscene:textTagged("* i'm keeping people away from the elevator.", "neutral", "sans")
                cutscene:textTagged("* Why?! We got places to be here, dude!!", "angry_b", "susie")
                cutscene:textTagged("* contractual obligations.", "joking", "sans")
                cutscene:textTagged("* ...[wait:10]right.", "suspicious", "susie")
                cutscene:textTagged("* anyways, what's up?", "neutral", "sans")
                Game:setFlag("susieHasMetSans", true)

            -- commenting out noelle's dialogue for now.
            --[[elseif cutscene:getCharacter("noelle") and Game:getFlag("noelleHasMetSans") == false then
                cutscene:showNametag("Sans", {font = "sans"})
                cutscene:text("[font:sans]* hey.", "neutral", "sans")

                cutscene:showNametag("Noelle")
                cutscene:text("* Uhm...[wait:4] Hello?", "smile_closed", "noelle")
                cutscene:text("* Wait, aren't you the guy keeping the store in Hometown?", "smile", "noelle")

                cutscene:showNametag("Sans", {font = "sans"})
                cutscene:text("[font:sans]* nah, i'm just the cashier.", "neutral", "sans")

                cutscene:showNametag("Noelle")
                cutscene:text("* Oh? But isn't the store named after you?", "question", "noelle")

                cutscene:showNametag("Sans", {font = "sans"})
                cutscene:text("[font:sans]* nah, that's the name of the owner.", "look_left", "sans")

                cutscene:showNametag("Noelle")
                cutscene:text("* Oh! Sorry for the confusion![wait:3] Can I ask for your name then?", "smile_closed", "noelle")

                cutscene:showNametag("Sans", {font = "sans"})
                cutscene:text("[font:sans]* woah there girl, you don't just ask a hard worker like me his name. it's weird.", "joking", "sans")

                cutscene:showNametag("Noelle")
                cutscene:text("* O-Oh... Sorry.", "surprise_frown_b", "noelle")

                cutscene:showNametag("Sans", {font = "sans"})
                cutscene:text("[font:sans]* it's okay.[wait:3] i don't get pay enough to get mad at people.", "wink", "sans")
                cutscene:hideNametag()
                else
                    cutscene:showNametag("Sans", {font = "sans"})
                    cutscene:text("[font:sans]* what's up?", "neutral", "sans")

                    cutscene:showNametag("Noelle")
                    cutscene:text("* Nothing special, mister... Uh..", "smile_closed", "noelle")

                    cutscene:showNametag("Sans", {font = "sans"})
                    cutscene:text("[font:sans]* sans.[wait:2] sans the skeleton.", "wink", "sans")

                    cutscene:showNametag("Noelle")
                    cutscene:text("* Oh okay, mister...[wait:4] [face:confused_surprise]Sans..?[wait:4][face:confused_surprise_b] Skeleton??[wait:4][face:question] The Skeleton???", "smile", "noelle")

                    cutscene:showNametag("Sans", {font = "sans"})
                    cutscene:text("[font:sans]* how about you just call me sans?[wait:3] sounds nicer, right?", "look_left", "sans")

                    cutscene:showNametag("Noelle")
                    cutscene:text("* I guess so, yeah..", "smile_side", "noelle")
                    cutscene:text("* Wait... So your name IS Sans!", "surprise_smile_b", "noelle")

                    cutscene:showNametag("Sans", {font = "sans"})
                    cutscene:text("[font:sans]* that's me.", "neutral", "sans")

                    cutscene:showNametag("Noelle")
                    cutscene:text("* I thought I shouldn't ask an hard worker his name!", "smile_closed", "noelle")

                    cutscene:showNametag("Sans", {font = "sans"})
                    cutscene:text("[font:sans]* wow, the guy who told you that must be really weird.", "joking", "sans")
                    cutscene:text("[font:sans]* there's nothing wrong with knowing someone's name, you know?", "wink", "sans")

                    cutscene:showNametag("Noelle")
                    cutscene:text("* ...", "what", "noelle")
                    cutscene:text("* Then uh.. Aren't you the owner of the shop in Hometown?", "question", "noelle")

                    cutscene:showNametag("Sans", {font = "sans"})
                    cutscene:text("[font:sans]* nah, i'm their janitor.", "neutral", "sans")

                    cutscene:showNametag("Noelle")
                    cutscene:text("* But didn't you tell us you were their cashier?", "frown", "noelle")

                    cutscene:showNametag("Sans", {font = "sans"})
                    cutscene:text("[font:sans]* i'm just filling in.[wait:3] employees are hard to find nowadays.", "look_left", "sans")

                    cutscene:showNametag("Noelle")
                    cutscene:text("* Did you try to start some employment campaign?", "smile_closed_b", "noelle")

                    cutscene:showNametag("Sans", {font = "sans"})
                    cutscene:text("[font:sans]* can't do that on a janitor's salary unfortunately.", "eyes_closed", "sans")
                    cutscene:hideNametag()
                end]]
            elseif Game:isDessMode() and dessHasMetSans == false then
                if Game:getFlag("can_kill") then
                    cutscene:showNametag("sans.", {font = "sans"})
                    cutscene:text("[font:sans]* hey.[wait:5] what's u", "wink", "sans", {auto=true, skip=false})
                    cutscene:hideNametag()
                    Game.world.music:pause()
                    Assets.playSound("knight_cut2", 1, 0.06)
                    Assets.playSound("knight_cut2", 1, 0.1)
                    Assets.playSound("knight_cut2", 1, 0.12)
                    Assets.playSound("knight_cut2", 1, 0.18)
                    Assets.playSound("knight_cut2", 1, 0.24)
                    local rect = Rectangle(Game.world.camera.x-SCREEN_WIDTH/2, Game.world.camera.y-SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT)
                    rect.color = {0,0,0}
                    rect.layer = WORLD_LAYERS["below_ui"]
                    Game.world:addChild(rect)
                    local slash = Sprite("world/cutscenes/floor1/roaringknight_slash_white_horizontal", sans.x, sans.y - 40)
                    if Game.world.player.facing == "up" then
                        slash:setOrigin(0.75, 0.5)
                    else
                        slash = Sprite("world/cutscenes/floor1/roaringknight_slash_white_horizontal", sans.x, sans.y + 80)
                        slash:setOrigin(0.5, 0.5)
                        slash.rotation = math.rad(-90)
                    end
                    slash:setScale(2)
                    slash.layer = WORLD_LAYERS["below_ui"] + 0.1
                    Game.world:addChild(slash)
                    cutscene:wait(3)
                    rect:remove()
                    slash:remove()
                    Game.world.camera:shake(6, 0)
                    Assets.playSound("impact")
                    Assets.playSound("closet_impact")
                    Assets.playSound("closet_impact", 1, 0.5)
                    Assets.playSound("bageldefeat", 0.8, 0.8)
                    Assets.playSound("glassbreak", 0.8, 0.4)
                    Assets.playSound("glassbreak", 0.6, 0.3)
                    sans:setSprite("dead")
                    if Game.world.player.facing == "up" then
                        cutscene:slideToSpeed(sans, sans.x + 90, sans.y, 6)
                    end
                    cutscene:wait(3)
                    cutscene:showNametag("Dess")
                    cutscene:text("* you pmo", "dess.exe", "dess")
                    cutscene:hideNametag()
                    cutscene:wait(2)
                    Assets.playSound("vaporized", 1.2)
                    local sprite = sans.sprite
                    sprite.visible = false
                    local death_x, death_y = sprite:getRelativePos(0, 0, sans)
                    local death
                    death = DustEffect(sprite:getTexture(), death_x, death_y, true, function() sans:remove() end) -- broken :((((
                    death:setColor(sprite:getDrawColor())
                    death:setScale(sprite:getScale())
                    sans:addChild(death)
                    cutscene:wait(2)
                    Game.world.music:resume()
                    sans = Game.world:spawnNPC("sans", 940, 240)
                    cutscene:wait(cutscene:walkToSpeed(sans, 660, sans.y, 6, "left"))
                    Game.world.player:setFacing("right")
                    Game.world.player:alert(nil, {play_sound=false})
                    cutscene:showNametag("sans.", {font = "sans"})
                    cutscene:text("[font:sans]* woah.[wait:5] sure glad i'm not that guy.", "look_left", "sans")
                    cutscene:text("[font:sans]* anyways.", "neutral", "sans")
                    cutscene:text("[font:sans]* since you seem like you [color:red]really [color:yellow]want to use this elevator[color:reset]...", "tired", "sans")
                    cutscene:text("[font:sans]* i give you personal permission for it's use.", "neutral", "sans")
                    cutscene:text("[font:sans]* ...", "eyes_closed", "sans")
                    Game.world.music:pause()
                    cutscene:text("[font:sans][speed:0.5][voice:none]* and hell if i'm showing up here again.", "serious", "sans")
                    cutscene:hideNametag()
                    Assets.playSound("noise")
                    rect = Rectangle(Game.world.camera.x-SCREEN_WIDTH/2, Game.world.camera.y-SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT)
                    rect.color = {0,0,0}
                    rect.layer = WORLD_LAYERS["below_ui"]
                    Game.world:addChild(rect)
                    cutscene:wait(1.5)
                    Assets.playSound("noise")
                    sans:remove()
                    rect:remove()
                    cutscene:wait(2)
                    Game.world.player:setFacing("down")
                    Game.world.music:resume()
                    Game:setFlag("hasPushedSans", true)
                    Game:setFlag("dessTriedToKillSans", true)
                    cutscene:text("* (You can now use the Elevator.)")
                    return
                else
                    cutscene:showNametag("Dess")
                    cutscene:text("* holy shit is that the i remember you're genocides guy", "wtf_b", "dess")
                    cutscene:showNametag("sans.", {font = "sans"})
                    cutscene:text("[font:sans][speed:0.5]* ...", "look_left", "sans")
                    cutscene:text("[font:sans]* who?", "neutral", "sans")
                    cutscene:showNametag("Dess")
                    cutscene:text("* y'know,[wait:5] the funny bone man?", "eyebrow", "dess")
                    cutscene:text("* the megalovania guy[wait:10]\n* the bad time guy[wait:10]\n* the gaster blaster guy", "neutral_c", "dess")
                    cutscene:text("* i'm pretty sure the pope knows you exist btw", "neutral", "dess")
                    cutscene:showNametag("sans.", {font = "sans"})
                    cutscene:text("[font:sans]* hmm...", "look_left", "sans")
                    cutscene:text("[font:sans]* sorry kid,[wait:5] you must be thinkin' about someone else.", "wink", "sans")
                    cutscene:text("[font:sans]* after all,[wait:5] i'm nothin' more than a simple janitor.", "joking", "sans")
                    cutscene:showNametag("Dess")
                    cutscene:text("* damn", "neutral_b", "dess")
                    cutscene:showNametag("sans.", {font = "sans"})
                    cutscene:text("[font:sans]* anyways, what's up?", "neutral", "sans")
                    cutscene:hideNametag()
                    Game:setFlag("dessHasMetSans", true)
                end
            else
                cutscene:showNametag("sans.", {font = "sans"})
                cutscene:text("[font:sans]* 'sup?", "neutral", "sans")
            end
				
            local choice = cutscene:choicer({"Elevator", "How are\nyou here?", "Brother", "Nothing"})

            if choice == 1 then
                if not Game:getFlag("hasPushedSans") then
                    local kid = #Game.party > 1 and "kids" or "kid"
                    cutscene:textTagged(string.format("* sorry %s,[wait:5] but you can't access the elevator.", kid), "neutral", "sans")
                    cutscene:textTagged("* i've been hired to keep anyone from entering it.", "eyes_closed", "sans")
                    cutscene:textTagged("* so i unfortunately can't move from this spot.", "neutral", "sans")
                    if Game.world.player.facing == "left" then
                        cutscene:textTagged("* that's right...", "look_left", "sans")
                        cutscene:textTagged("* camera [color:yellow]right[color:reset] that is.", "joking", "sans")
                        cutscene:textTagged("* my [color:yellow]right[color:reset] is camera [color:yellow]left[color:reset].", "wink", "sans")
                    else
                        cutscene:textTagged("* that's right.[wait:5] not even if you talk to me from my [color:yellow]right[color:reset].", "look_left", "sans")
                    end
                    Game:setFlag("sansHint", true)
                else
                    cutscene:textTagged("* ...", "look_left", "sans")
                end
            elseif choice == 2 then
                if cutscene:getCharacter("susie") then
                    cutscene:showNametag("Susie")
                    cutscene:text("* How are you here by the way?", "neutral", "susie")

                    cutscene:showNametag("sans.", {font = "sans"})
                    cutscene:textTagged("* i don't know. i'm just here for the work.", "neutral", "sans")

                    cutscene:showNametag("Susie")
                    cutscene:text("* Do you even know something?", "annoyed", "susie")

                    cutscene:showNametag("sans.", {font = "sans"})
                    cutscene:textTagged("* hey, if you have a complaint[wait:1] you can tell my manager.", "joking", "sans")

                    cutscene:showNametag("Susie")
                    cutscene:text("* And who would that be?", "neutral_side", "susie")

                    cutscene:showNametag("sans.", {font = "sans"})
                    cutscene:textTagged("* me.", "neutral", "sans")

                    cutscene:showNametag("Susie")
                    cutscene:text("* Aren't you already the cashier at Hometown??", "angry", "susie")

                    cutscene:showNametag("sans.", {font = "sans"})
                    cutscene:textTagged("* nah, i'm the janitor.", "wink", "sans")
                    cutscene:hideNametag()
                else
                    cutscene:textTagged("* well, best answer i can give is that i'm just here for the work.", "look_left", "sans")
                    cutscene:textTagged("* which is basically just loitering and guarding this elevator.", "wink", "sans")
                    if Game.world.player.actor.id == "hero" then
                        cutscene:textTagged("* by the way,[wait:5] have we met before somewhere?", "look_left", "sans")
                        cutscene:textTagged("* you look very familiar to me...", "look_left", "sans")
                        cutscene:textTagged("* maybe it's the way you're dressed?", "neutral", "sans")
                        cutscene:textTagged("* yeah, that's probably it.", "eyes_closed", "sans")
                        cutscene:textTagged("* there's a lotta kids running around in striped shirts these days.", "joking", "sans")
                    end
                    cutscene:hideNametag()
                end
            elseif choice == 3 then
                cutscene:textTagged("* my brother?", "neutral", "sans")
                cutscene:textTagged("* well,[wait:5] there's not much i can say about him [color:yellow]right now[color:reset].", "eyes_closed", "sans")
                cutscene:textTagged("* other than the fact that he has a very...", "look_left", "sans")
                cutscene:textTagged("* [speed:0.8]...[speed:1]actually,[wait:5] nevermind.", "wink", "sans")
                if cutscene:getCharacter("susie") then
                    local me = #Game.party > 1 and "us" or "me"
                    cutscene:textTagged("* Are you trying to keep something from "..me.."?", "suspicious", "susie")
                    cutscene:textTagged("* yep.", "neutral", "sans")
                    cutscene:textTagged("* And what's that?", "suspicious", "susie")
                    cutscene:textTagged("* the elevator.", "neutral", "sans")
                    cutscene:textTagged("* THAT'S NOT WHAT I MEANT!", "teeth_b", "susie")
                end
            elseif choice == 4 then
                cutscene:textTagged("* see ya.", "wink", "sans")
            end
        else
            if (Game.world.player.facing == "right" and sans.x < 545) and not Game:isDessMode() then
                Assets.playSound("noise")
                cutscene:wait(cutscene:slideTo(sans, sans.x + 20, sans.y, 0.1))

                if sans.x >= 545 then
                    cutscene:wait(1)
                    sans:setFacing("left")
                    cutscene:wait(0.5)
                    sans:setFacing("right")
                    cutscene:wait(0.5)
                    sans:setFacing("left")
                    cutscene:wait(1)
				
                    cutscene:textTagged("* ...", "neutral", "sans")
                    cutscene:textTagged("* ...well,[wait:5] would you look at that.", "eyes_closed", "sans")

                    local you_kids = #Game.party > 1 and "you kids" or "you"
                    cutscene:textTagged(string.format("* looks like %s made me move after all.", you_kids), "joking", "sans")
                    cutscene:textTagged("* guess that means you can use the elevator for now.", "neutral", "sans")
                    cutscene:textTagged("* just,[wait:2.5] uh,[wait:5] don't go yapping about this to anyone,[wait:5] k?", "look_left", "sans")
                    cutscene:textTagged("* don't want word of this getting out to my employers.", "eyes_closed", "sans")

                    Game:setFlag("sansHint", false)
                    Game:setFlag("hasPushedSans", true)

                    sans:setSprite("walk")
                    sans:setFacing("down")
                    Assets.playSound("dimbox")
                    cutscene:text("* (You can now use the Elevator!)")
                end
            elseif Game.world.player.facing == "right" and Game:isDessMode() and Game:getFlag("dessHasMetSans") == true and not Game:getFlag("hasPushedSans") then
                local dess = cutscene:getCharacter("dess")

                Game.world.music:pause()
                local music_cut = Music()
                sans:setSprite("idle")

                Assets.playSound("noise")
                dess:setAnimation("battle/attack_ready")
                cutscene:wait(2)
                Assets.playSound("laz_c")
                dess:setAnimation("battle/attack")
                cutscene:wait(0.2)
                Assets.playSound("impact")
                Assets.playSound("damage")
                Assets.playSound("smash_homerun")
                cutscene:shakeCamera(4)
			
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
			
                sans.physics.speed_x = 10
                sans.physics.speed_y = -10
			
                cutscene:wait(2)
                Assets.playSound("equip")
                dess:setSprite("walk")
                dess:setFacing("right")
                cutscene:wait(1)
			
                cutscene:textTagged("* haha HELL YEAH I did it", "swag", "dess")
		
                music_cut:play("deltarune/fanfare")
			
                for i,_ in ipairs(Game.party) do
                    local chara = Game.party[i]
                    local actor = Game.world:getCharacter(chara.actor.id)
                    cutscene:walkTo(actor, 460, actor.y + 80, 3)
                end

                sans.physics.speed_x = 0
                sans.physics.speed_y = 0

                cutscene:wait(3)
                music_cut:stop()

                local elevator = Game.world:getEvent(65)
                elevator.sprite_inside.visible = false

                --hacky layering method, but it works
                local elevator_inside = Sprite("world/events/elevatordoor/floor1/inside", elevator.x + 15, elevator.y - 65)
                elevator_inside:setScale(2)
                elevator_inside:setLayer(elevator.layer - 0.1)
                Game.world:addChild(elevator_inside)

                sans:setLayer(elevator_inside.layer + 0.01)
                sans.x = 462
                sans.y = 122
                elevator:open()
                cutscene:wait(0.5)
                dess:setFacing("up")
                cutscene:wait(2.5)
                cutscene:textTagged("* wait how the fu", "wtf", "dess", {auto = true})
				
                music_cut:play("deltarune/muscle")				
				
                local you_kids = #Game.party > 1 and "you kids" or "you"
                cutscene:textTagged("* heya.", "neutral", "sans")
                cutscene:textTagged("* so,[wait:5] you won't believe what just happened.", "joking", "sans")
                cutscene:textTagged("* but they literally [wait:10]JUST[wait:10] finished the elevator.", "wink", "sans")
                cutscene:textTagged("* guess my work here is done.", "eyes_closed", "sans")
                cutscene:textTagged(string.format("* so, %s won't be seeing me anytime soon.", you_kids), "joking", "sans")
                cutscene:textTagged("* see ya.", "wink", "sans")
				
                music_cut:stop()
                Game.world.fader:fadeOut(nil, {alpha = 1, speed = 10})
                elevator.sprite_inside.visible = true
                elevator:close()
                elevator_inside:remove()
                sans.x = 545
                sans.y = 150
                dess:setFacing("down")

                Assets.playSound("noise")
                cutscene:wait(1)
                cutscene:attachFollowers()
                Assets.playSound("noise")
                Game.world.fader:fadeIn(nil, {alpha = 1, speed = 0.1})
                Game.world.music:resume()
                cutscene:wait(1)

                Game:setFlag("sansHint", false)
                Game:setFlag("hasPushedSans", true)

                sans:setSprite("walk")
                sans:setFacing("down")
                Assets.playSound("dimbox")
                cutscene:text("* (You can now use the Elevator!)")
            end
        end
    end,

    sans_under_attack = function(cutscene, event, chara)
        if chara.sprite.facing == "up" then
            local sans = Game.world:getCharacter("sans")
            if not sans then event:remove() cutscene:endCutscene() return end
            --TODO: The cutscene if Susie is not in the party
            if not cutscene:getCharacter("susie") then event:remove() cutscene:endCutscene() return end
            Game.world.music:fade(0, 1, function() Game.world.music:stop() end)
            sans.x = 462
			
            local metalsonic_plush = Game.world:getEvent(82)
            local save = Game.world:getEvent(48)
            metalsonic_plush.visible = false
            save.visible = false

            local shadowguy1 = Game.world:spawnNPC("shadowguy", sans.x - 143, sans.y + 40)
            shadowguy1.flip_x = true
            local shadowguy2 = Game.world:spawnNPC("shadowguy", sans.x + 90, sans.y + 40)
            shadowguy1.sprite:stop(false)
            shadowguy2.sprite:stop(false)
            Game.world:addChild(shadowguy1)
            Game.world:addChild(shadowguy2)

            cutscene:textTagged("* Listen closely, ya little skelepunk.", nil, shadowguy1, { nametag = "???" })

            cutscene:wait(cutscene:panTo(sans))

            cutscene:setTextboxTop(false)
            shadowguy2.sprite:stop(false)
            shadowguy1:play(1/4)
            cutscene:textTagged("* We only gave ya one job: preventing folks from enterin' that elevator.", nil, shadowguy1, { nametag = "Shadowguy 1" })
            cutscene:textTagged("* And ya didn't even do it properly??", nil, shadowguy1, { nametag = "Shadowguy 1" })
            shadowguy1.sprite:stop(false)
            sans:setFacing("left")
            cutscene:textTagged("* well it's working now,[wait:5] isn't it?", "look_left", "sans")
            sans:setFacing("right")
            shadowguy2:play(1/4)
            cutscene:textTagged("* Don't play dumb with us,[wait:5] skeleman.", nil, shadowguy2, { nametag = "Shadowguy 2" })
            cutscene:textTagged("* The BOSS ain't happy with what he heard.[wait:5] So ya gonna come with us right now or else-", nil, shadowguy2, { nametag = "Shadowguy 2" })
            shadowguy2.sprite:stop(false)

            --TODO: Make the party members walk along the stairways of the map, instead of walking on air.
            cutscene:detachFollowers()
            local moved_player = cutscene:walkTo(chara, 400, 260, 2)
            local move_party = {}
            local nb_followers = #Game.world.followers
            for i,follower in ipairs(Game.world.followers) do
                if i == 1 then
                    table.insert(move_party, cutscene:walkTo(follower, 520, 260, 2))
                elseif i == 2 then
                    if nb_followers == 3 then
                        table.insert(move_party, cutscene:walkTo(follower, 400, 330, 2))
                    else
                        table.insert(move_party, cutscene:walkTo(follower, 300, 330, 2))
                    end
                elseif i == 3 then
                    table.insert(move_party, cutscene:walkTo(follower, 520, 330, 2))
                end
            end

            sans:setFacing("down")
            cutscene:textTagged("* HEY!", "angry", "susie")

            cutscene:wait(function()
                local moved_followers = true

                for k,func in pairs(move_party) do
                    if not func() then
                        moved_followers = false
                        break
                    end
                end

                return moved_player() and moved_followers
            end)

            cutscene:setTextboxTop(false)
            shadowguy1:play(1/4)
            cutscene:text("* What do ya want, kids?", nil, shadowguy1, { nametag = "Shadowguy 1" } )
            shadowguy1.sprite:stop(false)
            shadowguy2:play(1/4)
            cutscene:text("* It's adult talkin' here, so \nget lost.", nil, shadowguy2, { nametag = "Shadowguy 2" } )
            shadowguy2.sprite:stop(false)
            cutscene:text("* Threats over an elevator don't sound very \"adult\" to me.", "annoyed", "susie")
            cutscene:text("* So how about YOU get lost instead?", "teeth_smile", "susie")
            shadowguy2:play(1/4)
            cutscene:text("* So ya think y'all are tough 'cause you can show your teeths, girl?", nil, shadowguy2, { nametag = "Shadowguy 2" } )
            shadowguy2.sprite:stop(false)
            shadowguy1:play(1/4)
            cutscene:text("* Fine by us. You walked right into that one anyway!", nil, shadowguy1, { nametag = "Shadowguy 1" } )
            shadowguy1.sprite:stop(false)
            cutscene:hideNametag()


            cutscene:startEncounter("shadowguy", nil, {shadowguy1, shadowguy2})
            shadowguy1.visible = true --No idea why it gets hidden


            if Game:getFlag("shadowguy_violence", false) then
                if Game:getFlag("shadowguy_special_end", nil) == "FROZEN" then
                    local susie = cutscene:getCharacter("susie")
                    susie:setSprite("shock")
                    susie:setFacing("down")
                    susie:shake()
                    cutscene:wait(1)

                    if cutscene:getCharacter("hero") then
                        cutscene:textTagged("* ...", "shocked", "hero")
                    end
                    cutscene:textTagged("* Uhhhh...", "shock_nervous", "susie")
                    if cutscene:getCharacter("dess") then
                        cutscene:textTagged("* ", "wtf", "dess")
                        cutscene:textTagged("* Holy shit", "wtf", "dess")
                    end
                    susie:setSprite("walk")
                    susie:setFacing("up")
                    cutscene:textTagged("* wow kids. that's some powerful magic you got there.", "look_left", "sans")
                    cutscene:textTagged("* you should totally NOT use it on random folks, y'know?", "wink", "sans")
                    cutscene:textTagged("* I, uh... I guess so, yeah.", "sus_nervous", "susie")
                    cutscene:textTagged("* ("..Game.world.player.actor.name:upper()..", WHAT THE HELL WAS THAT???)", "teeth", "susie")
                    cutscene:textTagged("* i think you guys should go before someone else see this.", "neutral", "sans")
                    cutscene:textTagged("* wouldn't want to get in trouble, right?", "look_left", "sans")
                    cutscene:textTagged("* You're, uh.. Okay with what just happened?", "sus_nervous", "susie")
                    cutscene:textTagged("* let's just say that as long as you've learn your lesson and don't do it again..", "eyes_closed", "sans")
                    cutscene:textTagged("* i'll keep my eyes closed.", "wink", "sans")
                    cutscene:textTagged("* Okay... Cool... I guess.", "sus_nervous", "susie")
                    cutscene:textTagged("* Let's go, then.", "nervous", "susie")
                elseif Game:getFlag("shadowguy_special_end", nil) == "KILLED" then
                    cutscene:wait(1)

                    cutscene:showNametag("Susie")
                    cutscene:text("* ...", "sad_frown", "susie")
                    if cutscene:getCharacter("hero") then
                        cutscene:textTagged("* ...", "shade", "hero")
                    end
                    if cutscene:getCharacter("dess") then
                        cutscene:textTagged("* ...", "wtf", "dess")
                    end
                    cutscene:textTagged("* ...", "look_left", "sans")
                    cutscene:textTagged("* ("..Game.world.player.actor.name:upper()..", WHAT THE HELL???)", "teeth", "susie")
                    cutscene:textTagged("* So, uh...", "sus_nervous", "susie")
                    cutscene:textTagged("* did your parents never tell you that killing was bad?", "wink", "sans")
                    cutscene:textTagged("* Well...", "shy_down", "susie")
                    if cutscene:getCharacter("dess") then
                        cutscene:textTagged("* We did it for the vine.[react:1]", "wink", "dess", {reactions={
                            {"(BE SERIOUS!!)", "right", "bottommid", "teeth", "susie"}
                        }})
                    end
                    cutscene:textTagged("* eh,[wait:5] don't sweat too much about it.", "look_left", "sans")
                    cutscene:textTagged("* as long as you've learn not to do it again, it's fine.", "neutral", "sans")
                    cutscene:textTagged("* Are you... For real?", "nervous", "susie")
                    cutscene:textTagged("* as real as can be.", "joking", "sans")
                    cutscene:textTagged("* ...", "nervous_side", "susie")
                    cutscene:textTagged("* Then I guess we'll just go then.", "smirk", "susie")
                    cutscene:textTagged("* Go and do some good deeds... Yeah...", "nervous", "susie")
                    cutscene:textTagged("* alright, later kids.", "wink", "sans")
                else
                    shadowguy1:play(1/4)
                    shadowguy2.sprite:stop(false)
                    cutscene:textTagged("* W-[wait:2]Wow wow! Come on, kids! We don't have to get to such extremes, ya know..?", nil, shadowguy1, { nametag = "Shadowguy 1" } )
                    shadowguy2:play(1/4)
                    shadowguy1.sprite:stop(false)
                    cutscene:textTagged("* Yeah, let's all have a nice discussion, adults to teens..!", nil, shadowguy2, { nametag = "Shadowguy 2" } )
                    shadowguy2.sprite:stop(false)
                    cutscene:textTagged("* Scram.[wait:10] Now.", "bangs_teeth", "susie")
                    shadowguy1:play(1/4)
                    shadowguy2:play(1/4)
                    cutscene:textTagged("* Y-[wait:2]Yes m'am!", nil, shadowguy1, { nametag = "Shadowguys 1 & 2" } )

                    cutscene:slideTo(shadowguy2, sans.x + 110, shadowguy2.y)

                    cutscene:wait(cutscene:slideTo(shadowguy1, sans.x - 163, shadowguy1.y))

                    Game.world.timer:after(0.5, function()
                        for _, member in ipairs(Game.party) do
                            cutscene:look(cutscene:getCharacter(member.id), "down")
                        end
                    end)

                    cutscene:slideTo(shadowguy2, shadowguy2.x, 355)
                    cutscene:wait(cutscene:slideTo(shadowguy1, shadowguy1.x, 355))
				
                    cutscene:slideTo(shadowguy1, shadowguy1.x - 80, shadowguy1.y)
                    cutscene:wait(cutscene:slideTo(shadowguy2, shadowguy2.x + 80, shadowguy2.y))
				
                    cutscene:slideTo(shadowguy2, shadowguy2.x, 600)
                    cutscene:wait(cutscene:slideTo(shadowguy1, shadowguy1.x, 600))

                    cutscene:wait(1)

                    cutscene:textTagged("* welp...[wait:5] that was something.", "look_left", "sans")
                    cutscene:textTagged("* Yeah uh...[wait:5]\n* Maybe we went a bit overboard.", "neutral", "susie")
                    cutscene:textTagged("* hey,[wait:5] don't beat yourself over it too much.", "neutral", "sans")
                    cutscene:textTagged("* it's not like they're dead or something.", "wink", "sans")
                    cutscene:textTagged("* ...Sure...", "suspicious", "susie")
                    cutscene:textTagged("* But anyway,[wait:2] I think we'll just go.", "nervous", "susie")
                    cutscene:textTagged("* Cool to talk to you and save your ass,[wait:2] I guess??", "nervous_side", "susie")
                    cutscene:textTagged("* anytime, kid.", "wink", "sans")
                end
            else
                shadowguy1:play(1/4)
                cutscene:textTagged("* Hey kids! You're pretty cool actually!", nil, shadowguy1, { nametag = "Shadowguy 1" } )
                local nb_to_text = {"", " two", " three", " four"}
                cutscene:textTagged("* The boss would love to hear from folks like you"..nb_to_text[#Game.party].."!", nil, shadowguy1, { nametag = "Shadowguy 1" } )
                shadowguy2:play(1/4)
                shadowguy1.sprite:stop(false)
                cutscene:textTagged("* Whaddya say?[wait:2]\n* You could go on the big screen in no time!", nil, shadowguy2, { nametag = "Shadowguy 2" } )
                shadowguy2.sprite:stop(false)
                cutscene:textTagged("* Yeah uh,[wait:5] how about you just get lost like we said before the battle?", "annoyed", "susie")
                cutscene:textTagged("* And also leave that guy alone.", "neutral_side", "susie")
                if cutscene:getCharacter("dess") then
                    cutscene:textTagged("* But Susie imagine all the fame and money that could come with it", "genuine_b", "dess")
                    cutscene:textTagged("* That's...[wait:5] not something that interest me.", "nervous", "susie")
                    cutscene:textTagged("* Less for you more for me I guess.", "condescending", "dess")
                    cutscene:textTagged("* Where could I star in?", "genuine", "dess")
                    shadowguy1:play(1/4)
                    cutscene:textTagged("* Hmm... That dumb look on ya face..", shadowguy1, { nametag = "Shadowguy 1" } )
                    cutscene:textTagged("* What's 9+10?", shadowguy1, { nametag = "Shadowguy 1" } )
                    shadowguy1.sprite:stop(false)
                    cutscene:textTagged("* 21 yuh", "wink", "dess")
                    cutscene:textTagged("* ...", nil, shadowguy1, { nametag = "Shadowguy 1" } )
                    cutscene:textTagged("* ...", nil, shadowguy2, { nametag = "Shadowguy 2" } )
                    shadowguy2:play(1/4)
                    shadowguy1:play(1/4)
                    cutscene:textTagged("* Perfect for reality shows.", nil, shadowguy1, { nametag = "Shadowguys 1 & 2" } )
                    shadowguy1.sprite:stop(false)
                end
                shadowguy2:play(1/4)
                cutscene:textTagged("* Okay,[wait:5] here's what we gonna do.", nil, shadowguy2, { nametag = "Shadowguy 2" } )
                cutscene:textTagged("* We're gonna leave your lil' skelefriend here be...", nil, shadowguy2, { nametag = "Shadowguy 2" } )
				
                local leader_surnames = {
                    hero = "human",
                    kris = "blue person",
                    susie = "purple dino",
                    noelle = "nice deer",
                    berdly = "twitter bird",
                    dess = "dumb deer",
                    brenda = "gunslingin' gal",
                    dumbie = "dummy",
                    bor = "ball",
                    osw = "unoriginal",
                    jamm = "thunder guy"
                }
                cutscene:textTagged("* But you,[wait:5] the "..(leader_surnames[Game.world.player.actor.id] or "leader")..",[wait:5] take our number!", nil, shadowguy2, { nametag = "Shadowguy 2" } )

                local leader = cutscene:getCharacter(Game.world.player.actor.id)
                local x, y = shadowguy2:getPosition()
                cutscene:wait(cutscene:slideTo(shadowguy2, leader.x + shadowguy2.width/2, leader.y - 20))
                Assets.playSound("item")
                cutscene:text("* (You've got the Shadowguys' number!)")
                cutscene:text("* ...despite the fact that you can't make calls in the Dark World.)")
                cutscene:wait(cutscene:slideTo(shadowguy2, x, y))
                shadowguy1:play(1/4)
                shadowguy2.sprite:stop(false)
                cutscene:textTagged("* If you ever feel like becoming superstars, we'll always be one call ahead!", nil, shadowguy1, { nametag = "Shadowguy 1" } )
                cutscene:textTagged("* Later![wait:5] The showbiz doesn't wait!", nil, shadowguy1, { nametag = "Shadowguy 1" } )
                shadowguy1.sprite:stop(false)
                cutscene:hideNametag()

                cutscene:slideTo(shadowguy2, sans.x + 110, shadowguy2.y)

                cutscene:wait(cutscene:slideTo(shadowguy1, sans.x - 163, shadowguy1.y))

                Game.world.timer:after(0.5, function()
                    for _, member in ipairs(Game.party) do
                        cutscene:look(cutscene:getCharacter(member.id), "down")
                    end
                end)

                cutscene:slideTo(shadowguy2, shadowguy2.x, 355)
                cutscene:wait(cutscene:slideTo(shadowguy1, shadowguy1.x, 355))
				
                cutscene:slideTo(shadowguy1, shadowguy1.x - 80, shadowguy1.y)
                cutscene:wait(cutscene:slideTo(shadowguy2, shadowguy2.x + 80, shadowguy2.y))
				
                cutscene:slideTo(shadowguy2, shadowguy2.x, 600)
                cutscene:wait(cutscene:slideTo(shadowguy1, shadowguy1.x, 600))

                cutscene:wait(1)

                for _, member in ipairs(Game.party) do
                    cutscene:look(cutscene:getCharacter(member.id), "up")
                end

                cutscene:textTagged("* welp.[wait:2]\n* that was something.", "neutral", "sans")
                cutscene:textTagged("* thanks kids.[wait:5]\n* i own you one.", "wink", "sans")
                cutscene:textTagged("* Yeah uh...[wait:5]\n* No problem,[wait:2] I guess.", "neutral", "susie")
                cutscene:textTagged("* and i know exactly what you kids want.", "neutral", "sans")
                cutscene:textTagged("* ...?", "nervous_side", "susie")
                cutscene:textTagged("* you're free to use the elevator whenever you like.[wait:5] isn't that cool?", "joking", "sans")
                cutscene:textTagged("* Didn't we already have access to it?", "sus_nervous", "susie")
                cutscene:textTagged("* yeah,[wait:2] but now it's official access.", "wink", "sans")
                cutscene:textTagged("* ...Sure...", "suspicious", "susie")
                cutscene:textTagged("* But anyway,[wait:2] I think we'll just go.", "nervous", "susie")
                cutscene:textTagged("* Cool to talk to you and save your ass,[wait:2] I guess??", "nervous_side", "susie")
                cutscene:textTagged("* anytime, kid.", "wink", "sans")
            end

            cutscene:getCharacter(Game.world.player.actor.id):setFacing("down")
            cutscene:wait(cutscene:walkTo(Game.world.player.actor.id, sans.x, Game.world.player.y, 1))
            cutscene:wait(cutscene:alignFollowers())
            cutscene:wait(cutscene:attachFollowers())
            cutscene:attachCameraImmediate()
            shadowguy1:remove()
            shadowguy2:remove()
            -- Don't ask me why, I don't know either
            shadowguy1.sprite:remove()
            shadowguy2.sprite:remove()

            cutscene:wait(0.5)

            cutscene:fadeOut(0)
            Assets.playSound("noise")
            cutscene:wait(0.5)
            cutscene:getCharacter("sans"):remove()
            metalsonic_plush.visible = true
            save.visible = true
            Assets.playSound("noise")
            cutscene:fadeIn(0)

            cutscene:wait(0.5)

            if Game:getFlag("shadowguy_special_end", nil) ~= nil then
                local sfx = Assets.playSound("ominous")
                cutscene:wait(function()
                    return not sfx:isPlaying()
                end)
            end

            Game.world.music:play(nil, 1)
            event:remove()
            event:setFlag("dont_load", true)
        end
    end,

    wah = function(cutscene, event)
        if event.interact_count == 1 then
            -- The 1st WAH!
            cutscene:showNametag("Takodachi")
            cutscene:text("* Pray to the 1st WAH![wait:10]\n* We Are Here!")
            cutscene:hideNametag()
        elseif event.interact_count == 2 then
            -- The 2nd WAH!
            cutscene:showNametag("Takodachi")
            cutscene:text("* Pray to the 2nd WAH![wait:10]\n* We Are Happy!")
            cutscene:hideNametag()
        elseif event.interact_count == 3 then
            -- The 3rd WAH!
            cutscene:showNametag("Takodachi")
            cutscene:text("* Pray to the 3rd WAH![wait:10]\n* We Are Hungry!")
            cutscene:hideNametag()
        elseif event.interact_count == 4 then
            -- The 4th... wah..?
            local wah4_sprite_list = {
                YOU = "date",
                susie = "shock",
                ralsei = "surprised_down",
                noelle = "shocked",
                dess = "battle/hurt"
            }

            cutscene:showNametag("Takodachi")
            cutscene:text(
            "[noskip]* Pray to the 4th WAH![wait:10]\n[func:oshit]* We Are[wait:25][func:thicc][instant] H O R N Y![stopinstant][wait:15]",
            nil, nil, {
                functions = {
                    oshit = function()
                        Assets.stopAndPlaySound("the4thWah")
                    end,
                    thicc = function()
                        cutscene:showNametag("Takolyshit")
                        Game.fader:fadeIn(nil, { speed = 0.8, color = { 1, 1, 1 }, alpha = 1 })
                        event:setSprite("takolyshit")
                        -- Credits to Dobby233Liu for making this not awful code
                        for member, sprite in pairs(wah4_sprite_list) do
                            local char = cutscene:getCharacter(member)
                            if char ~= nil then
                                char:setSprite(sprite)
                            end
                        end
                        Game.world.map.ina:pause()
                    end
                }
            })
            cutscene:hideNametag()

            event:setSprite("idle")
            for member, _ in pairs(wah4_sprite_list) do
                local char = cutscene:getCharacter(member)
                if char ~= nil then
                    char:resetSprite()
                end
            end
            Game.world.map.ina:resume()

            --Kristal.callEvent("completeAchievement", "takodownbad")
        else
            cutscene:showNametag("Takodachi")
            cutscene:text("* Pray to the priestess,[wait:2] Ina!")
            cutscene:hideNametag()
        end
    end,

    transition = function(cutscene, event)
        if love.math.random(1, 100) <= 5 then
            cutscene:mapTransition("floor1/spamgolor_meeting", "west")
            -- default wait func waits for the fade animation to end. movement should be allowed slightly before that
            cutscene:wait(function () return Game.world.map.id == "floor1/spamgolor_meeting" end)
            local timeout = .5
            cutscene:during(function () timeout = timeout - DT end)
            -- prevent player from accidentally exiting the room
            cutscene:wait(function ()
                return Input.up("left") or (timeout <= 0)
            end)
        else
            cutscene:mapTransition("floor1/traininggrounds", "entry")
        end
    end,

    transitionS = function(cutscene, event)
        if love.math.random(1, 1000) <= 5 then
            cutscene:mapTransition("satan", "spawn")
            -- default wait func waits for the fade animation to end. movement should be allowed slightly before that
            cutscene:wait(function () return Game.world.map.id == "satan" end)
            local timeout = .5
            cutscene:during(function () timeout = timeout - DT end)
            -- prevent player from accidentally exiting the room
            cutscene:wait(function ()
                return Input.up("left") or (timeout <= 0)
            end)
        else
            cutscene:mapTransition("floor1/fuseroom", "entry")
        end
    end,

    warp_bin_note = function(cutscene, event)
        local dess = cutscene:getCharacter("dess")
	
        cutscene:text("* HOW TO USE THE WARP BIN\n* A two-step guide to all your dumpster-traveling needs.")
        cutscene:text("* STEP 1:\nEnter a valid code on the keypad beneath the bin's lid.")
        cutscene:text("* STEP 2:\nHappy traveling!")
        cutscene:text("* (NOTICE: If you ever get lost or run out of codes to input, type FLOORONE get back here.)")
        cutscene:text("* (Management is also not responsible for any odors emitting from the bin.)")
        cutscene:text("* (This is due to a certain public menace throwing cans of Mug Root Beer into it.)")
		
        if dess then
            cutscene:textTagged("* gee, I wonder who that could be", "condescending", dess)
        end
    end,

    morshu = function(cutscene, morshu)
        local magolor = cutscene:getCharacter("magolor")
        local m_anim = Character("billboard/room3_morshu", SCREEN_WIDTH/2, SCREEN_HEIGHT)
        Game.world:spawnObject(m_anim, "textbox")
        m_anim.visible = false
        m_anim:setParallax(0, 0)
        m_anim:setScale(2)
        cutscene:after(function()
            m_anim:remove()
        end)

        local cust_wait_timer = 0
        local function waitForTimeOrUserCancellation(time)
            cust_wait_timer = time
            return function()
                cust_wait_timer = Utils.approach(cust_wait_timer, 0, DT)
                if morshu.interact_count > 1 and Input.pressed("cancel") then
                    cust_wait_timer = 0
                    return true
                end
                return cust_wait_timer == 0
            end
        end

        local function showMorshuAnim(anim)
            m_anim.visible = true
            m_anim:setAnimation(anim)
            return function(time, disallow_cancel)
                if time > 0 then
                    cutscene:wait(not disallow_cancel and waitForTimeOrUserCancellation(time) or time)
                end
                m_anim.visible = false
            end
        end

        local music_inst = Music()
        cutscene:after(function()
            music_inst:remove()
        end)
        local function showMorshuAnimWithVoc(anim, clip, time, disallow_cancel)
            local rem = showMorshuAnim(anim)
            Game.world.music:pause()
            music_inst:play(clip, 1, 1, false)
            rem(time, disallow_cancel)
            music_inst:stop()
            Game.world.music:resume()
        end

        Input.clear("cancel")

        showMorshuAnimWithVoc("rubies", "voiceover/morshu_rubies", 8.8)

        cutscene:text("* (Buy Lamp Oil for 40 dolla-[wait:5] er-[wait:5] rupee-[wait:5] er-[wait:5] rubies?)")
        cutscene:showShop()
        local choice = cutscene:choicer({ "Buy", "Do not" })
        cutscene:hideShop()

        if choice == 2 then
            showMorshuAnimWithVoc("menacing", "menace", 18.8, false)
            return
        end

        if Game.money < 40 then
            showMorshuAnimWithVoc("richer", "voiceover/morshu_richer", 7)
            return
        end

        if not Game.inventory:addItem("lampoil") then
            cutscene:text('* (There is no "inventory full" clip for Morshu,[wait:5] so all you get is this dinky-ass text box.)')
            return
        end

        Game.money = Game.money - 40

        Game.world.music:pause()
        local danceparty = Music("danceparty", 0.8)
        danceparty:play()

        -- show character dance animations
        local svfx = Kristal.Config["simplifyVFX"]
        local svfx_suffix = svfx and "_svfx" or ""
        morshu.dance = true
        local dance_anim_rem = showMorshuAnim("dance" .. svfx_suffix)
        magolor.dance = true
        magolor:setAnimation("speen" .. svfx_suffix)

        dance_anim_rem(svfx and (9.694 * 2) or 31)

        -- show character idle animations
        morshu.dance = false
        magolor.dance = false
        magolor:setSprite("shop")
        if doobie then
            doobie:setAnimation("idle")
        end

        danceparty:remove()
        Game.world.music:resume()

        cutscene:text("* (You stashed the Lamp Oil inside your [color:yellow]ITEMS[color:reset].)")
    end,
    
    magshop = function(cutscene, event)
        local menu = {
            {
                name = "food",
                first_level_disp = "Food",
                prompt = "kind of food",
                items = {
                    { id = "pepbrew", name = "Pep Brew", price = 100, some = "some" },
                    { id = "apple_uneaten", name = "Apple", price = 250, some = "an" },
                    { id = "maximtomato", name = "Maxim Tomato", price = 5000 },
                }
            },
            {
                name = "weapon",
                name_counted = "weapons",
                first_level_disp = "Weapons",
                items = {
                    { id = "mets_bat", name = "Mets Bat", price = 700, post_purchase = function()
                        cutscene:text("* Actually,[wait:10] did you know...", "happy", "magolor")
                        cutscene:text("* that this bat is signed and autographed by Daniel Vogelbach?", "wink",
                        "magolor")
                        cutscene:text("* I know![wait:10] I thought it was crazy too!", "pensive", "magolor")
                        cutscene:text("* But it's true![wait:10] I met Daniel Vogelbach and I got this bat signed!", "happy", "magolor")
                        cutscene:text("* Y'know I think it's really been a shame that...", "angry", "magolor")
                        cutscene:text("* The Mets have been on a drystreak lately!", "angry", "magolor")
                        cutscene:text("* And people keep making fun of them!", "upset", "magolor")
                        cutscene:text("* BUT NOT ANYMORE BABY!!", "wink", "magolor")
                        cutscene:text("* It's not about the theme parks anymore!", "sad", "magolor")
                        cutscene:text("* IT'S ABOUT THE METS BABY, THE METS!", "happy", "magolor")
                        if cutscene:getCharacter("dess") then
                            cutscene:showNametag("Dess")
                            cutscene:text("* YEAHHHHHH!", "condescending", "dess")
                        end
                    end },
                    { id = "powerring", name = "PowerRing", price = 1000 },
                    { id = "superscope", name = "SuperScope", price = 650 },
                }
            },
            {
                name = "armor",
                name_counted = "armors",
                first_level_disp = "Armor",
                items = {
                    { id = "leadmaker", name = "Leadmaker", price = 750 }
                }
            }
        }

        local function onDeclined()
            cutscene:showNametag("Magolor")
            cutscene:text("* Uh,[wait:5] okay then.", "pensive", "magolor")
            cutscene:text("* Nobody likes a window shopper.", "unamused", "magolor")
            cutscene:hideNametag()
        end
        local function onCateHasNoItems(category_name)
            cutscene:showNametag("Magolor")
            cutscene:text(string.format("* Sorry,[wait:5] I don't have any %s right now.", category_name), "sad", "magolor")
            cutscene:hideNametag()
        end
        local function onCateSelected(prompt)
            cutscene:showNametag("Magolor")
            cutscene:text(string.format("* What %s would you like?", prompt), "happy", "magolor")
            cutscene:hideNametag()
        end
        local function onItemSelected(item)
            cutscene:showNametag("Magolor")
            cutscene:text(string.format("* Do you want to buy %s %s for %dD$?", item.some or "a", item.name, item.price), "neutral", "magolor")
            cutscene:hideNametag()
        end
        local function onMoneyNotEnough()
            cutscene:showNametag("Magolor")
            cutscene:text("* Come back when you can actually afford this...", "unamused", "magolor")
            cutscene:hideNametag()
        end
        local function onInventoryFull()
            cutscene:showNametag("Magolor")
            cutscene:text("* Your pockets look too full for this...", "unamused", "magolor")
            cutscene:hideNametag()
        end
        local function onPurchaseComplete(special_message)
            cutscene:playSound("locker")
            cutscene:showNametag("Magolor")
            cutscene:text("* Here you go!", "happy", "magolor")
            cutscene:text("* Pleasure doing business with you!", "wink", "magolor")
            if special_message then special_message() end
            cutscene:hideNametag()
        end

        cutscene:showNametag("Magolor")
        cutscene:text("* Welcome to my shoppe!", "happy", "magolor")
        cutscene:text("* What would you like to buy?", "neutral", "magolor")
        cutscene:hideNametag()

        local cate_opinions = {}
        for _, v in ipairs(menu) do
            table.insert(cate_opinions, v.first_level_disp)
        end
        table.insert(cate_opinions, "None")
        local cate_opinion = cutscene:choicer(cate_opinions)
        if cate_opinion == #cate_opinions then
            onDeclined()
            return
        end

        local cate = menu[cate_opinion]
        if #cate.items <= 0 then
            onCateHasNoItems(cate.name_counted or cate.name)
            return
        end
        onCateSelected(cate.prompt or cate.name)
        local item_opinions = {}
        for _, v in ipairs(cate.items) do
            table.insert(item_opinions, v.name)
        end
        table.insert(item_opinions, "None")
        local item_opinion = cutscene:choicer(item_opinions)
        if item_opinion == #item_opinions then
            onDeclined()
            return
        end

        local item = cate.items[item_opinion]
        cutscene:showShop()
        onItemSelected(item)
        local buy = cutscene:choicer({ "Yes", "No" })
        cutscene:hideShop()
        if buy == 2 then
            onDeclined()
            return
        end

        if Game.money < item.price then
            onMoneyNotEnough()
        elseif not Game.inventory:addItem(item.id) then
            onInventoryFull()
        else
            Game.money = Game.money - item.price
            onPurchaseComplete(item.post_purchase)
        end
    end,
	
    sansshop = function(cutscene, event) -- note: currently unfinished
        local sans = cutscene:getCharacter("sans")
		
        local function onDeclinedOffer()
            cutscene:textTagged("* don't you know a \ngood deal when you \nhear one?", "joking", "sans")
        end
		 
        cutscene:textTagged("* heya.", "neutral", "sans")
        cutscene:textTagged("* i decided to try selling some goods in this marketplace.", "look_left", "sans")
        cutscene:textTagged("* anything you want?", "neutral", "sans")
		
        local choice = cutscene:choicer({ "Food", "Nevermind" })
		
        if choice == 1 then
            cutscene:textTagged("* i'm currently selling some fried snow for 5G...", "joking", "sans")
            cutscene:textTagged("* and some hot dogs,\n[wait:5] 30G for each one.", "neutral", "sans")
            cutscene:textTagged("* which one will it be?", "wink", "sans")
			
            local choice = cutscene:choicer({ "Hot Dog", "Fried Snow" })
			
            if choice == 1 then
                cutscene:showShop()
                cutscene:textTagged("* cool.\n[wait:5]* that'll be 30G.", "neutral", "sans")
                local dog_choice = cutscene:choicer({ "Buy", "No" })
                if dog_choice == 1 then
                    if Game.money <= 30 then
                        cutscene:textTagged("* whoops, you don't have\n enough cash.")
					else
                        --not done yet

                        cutscene:playSound("locker")
                        --Game.inventory:addItem("ut_hotdog")
                        --Game.money = Game.money - 30
                        cutscene:textTagged("* thanks, kid.\n[wait:5]* here's your 'dog.", "wink", "sans")
                    end
                else
                end
                cutscene:hideShop()
            elseif choice == 2 then
                cutscene:showShop()
                cutscene:textTagged("* cool.\n[wait:5]* that'll be 5G.", "neutral", "sans")
                local snow_choice = cutscene:choicer({ "Buy", "No" })
                if snow_choice == 1 then
                    cutscene:textTagged("* did i say 5G?\n[wait:5]* i meant 50G.", "look_left", "sans")
                    local snow_choice2 = cutscene:choicer({ "Buy", "No" })
                    if snow_choice2 == 1 then
                        cutscene:textTagged("* really?\n[wait:5]* how about 5000G?", "joking", "sans")
                        local snow_choice3 = cutscene:choicer({ "Buy", "No" })
                        if snow_choice3 == 1 then
                            cutscene:textTagged("* 50000G.\n[wait:5]* that's my final offer.", "neutral", "sans")
                            local snow_choice4 = cutscene:choicer({ "Buy", "No" })
                            if snow_choice4 == 1 then
                                if Game.money >= 50000 then
                                    cutscene:textTagged("* wow,[wait:5] that's a lot \nof cash.", "neutral", "sans")
                                    cutscene:textTagged("* that's why i'm sorry \nto say...", "eyes_closed", "sans")
                                    cutscene:textTagged("* i can't sell you \nthis fried snow.", "neutral", "sans")
                                    cutscene:textTagged("* it's got too much \nsentimental value.", "wink", "sans")
                                else
                                    cutscene:textTagged("* what? \n[wait:5]* you don't have the \nmoney?", "neutral", "sans")
                                    cutscene:textTagged("* hey, that's okay.", "eyes_closed", "sans")
                                    cutscene:textTagged("* i don't have any snow.", "wink", "sans")
                                end
                            else
                                onDeclinedOffer()
                            end
                        else
                            onDeclinedOffer()
                        end
                    else
                        onDeclinedOffer()
                    end
                else
                    cutscene:textTagged("* dang.", "eyes_closed", "sans")
                    cutscene:textTagged("* i should probably charge way more for it then.", "wink", "sans")
                end
                cutscene:hideShop()
            end
        else
            cutscene:textTagged("* i'll be here if you need anything.", "wink", "sans")
        end
    end,

    lemonade = function(cutscene, event)
        local lemonade_stand = cutscene:getCharacter("lemonade_stand")
		cutscene:setSpeaker(lemonade_stand)
		
        local function onPurchase()
		    cutscene:playSound("locker")
            cutscene:textTagged("* Here you go!\n* Some of my finest lemonade.")
            cutscene:textTagged("* Oh,[wait:5] one more thing.")
            cutscene:textTagged("* If,[wait:5] by any chance,[wait:5] you see a duck wandering around somewhere...")
            cutscene:textTagged("* Don't let him know I'm here or I'll glue you to a tree.")
        end
        local function onDeclined()
            cutscene:textTagged("* Oh!\n* Alright then.")
            cutscene:textTagged("* Feel free to come back if you've changed your mind!")
            cutscene:textTagged("* (You better not ask if I've got any grapes though.)")
        end
        local function onMoneyNotEnough()
            cutscene:textTagged("* Uh oh![wait:5]\n* Looks like you don't have enough money.")
            cutscene:textTagged("* I'll keep this glass ready for you when you have enough though!")
        end
        local function onInventoryFull()
            cutscene:textTagged("* Hold on there.[wait:5]\n* Your inventory's looking pretty packed right now.")
            cutscene:textTagged("* Try clearing sone of that stuff out first, before I can give you a glass.")
        end
		
		cutscene:textTagged("* Hey there!\n* I'm selling some lemonade.")
		cutscene:textTagged("* It's cold,[wait:5] it's fresh,[wait:5] and \nit's all home-made!")
		cutscene:textTagged("* Can I get you a glass?")
		cutscene:setSpeaker(nil)
		cutscene:text("* (Buy Lemonade for 60 D$?)")
		
		cutscene:showShop()
        local choice = cutscene:choicer({ "Buy", "Do Not" })
		cutscene:hideShop()
		
        if choice == 2 then
            cutscene:setSpeaker(lemonade_stand)
            onDeclined()
            return
        end
        if Game.money < 60 then
            cutscene:setSpeaker(lemonade_stand)
            onMoneyNotEnough()
            return
        end
		if not Game.inventory:addItem("lemonade") then
		    cutscene:setSpeaker(lemonade_stand)
            onInventoryFull()
            return
		end
		
        Game.money = Game.money - 60
		cutscene:setSpeaker(lemonade_stand)
        onPurchase()
	end,

    money_hole = function(cutscene, event)
        if Game:getFlag("money_hole") == 1 then
            cutscene:text("* (The hole is filled to the brim with cash.)")
        else
            cutscene:text("* \"Donation Hole\"")
            cutscene:text("* (If you like our tutorials, please throw your money into a hole.)")
            local choicer = cutscene:choicer({"Throw $1", "Do not"})
            if choicer == 1 then
                if Game.money < 1 then
                    cutscene:text("* (You don't have enough money.)")
                    cutscene:text("* (You failed to budget enough money to throw into a hole...)")
                else
                    Game.money = Game.money - 1
                    cutscene:text("* (You put a dollar in the \"Hole.\")")
                    cutscene:text("* (The \"Hole\" became \"Full.\")")
                    Game:setFlag("money_hole", 1)
                end
            end
        end
    end,

    square_hole = function(cutscene, event)
            cutscene:text("* Square Hole")
            local choicer = cutscene:choicer({"Look into it", "Do not"})
            if choicer == 1 then
                    cutscene:text("* (It's a square-shaped hole.)")
                    cutscene:text("* (There appears to be a variety of shapes in it.)")
                    cutscene:text("* (...But there aren't any squares.)")
        end
    end,

    garbage = function(cutscene, event)
        local texts = {}
        local function genBigText(text, x, y, scale, goner, wait_time)
            scale = scale or 2
            wait_time = wait_time or 0.2

            local text_o = Game.world:spawnObject(Text(text, x, y, 300, 500, { style = goner and "GONER" or "dark" }))
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
        local function fadeOutBigText()
            for _, v in ipairs(texts) do
                Game.world.timer:tween(2, v, { alpha = 0 }, "linear", function()
                    v:remove()
                end)
            end
            cutscene:wait(2)
        end

        local garbage = cutscene:getCharacter("diamond_trash")

        Game.world.music:pause()
        local music_inst = Music()
        cutscene:after(function() music_inst:remove() end)

        if event.interact_count == 1 then
            cutscene:showNametag("Trash Rudinn")
            music_inst:play("voiceover/garbage", 1, 1, false)
            cutscene:text("[noskip][voice:nil]* Hellooo...[wait:1.5]", nil, garbage, { auto = true })
            cutscene:hideNametag()
            genBigText("I'm", 240, 40)
            genBigText("a", 360, 40, 2, false, 0.1)
            genBigText("piece", 205, 110)
            genBigText("of", 370, 110)
            flashScreen()
            genBigText("GARBAGE", 35, 160, 6, true, 2)
            fadeOutBigText()
        else
            cutscene:showNametag("Trash Rudinn")
            music_inst:play("voiceover/stillgarbage", 1, 1, false)
            cutscene:text("[noskip][voice:nil]* Oh hi,[wait:1] thanks for checking in.[wait:2]\n* I'm...", nil, garbage, { auto = true })
            cutscene:hideNametag()
            genBigText("still", 210, 40)
            genBigText("a", 380, 40, 2, false, 0.1)
            genBigText("piece", 205, 110)
            genBigText("of", 370, 110)
            flashScreen()
            genBigText("GARBAGE", 35, 160, 6, true, 2)
            fadeOutBigText()
        end

        cutscene:wait(1)
        cutscene:look("down")
        Game.world.music:resume()
    end,

    starwalker = function(cutscene, event)
        local susie = cutscene:getCharacter("susie")
        local dess = cutscene:getCharacter("dess")
        local star = cutscene:getCharacter("starwalker")

		--original starcheck code by AcousticJamm
        if not Game.world.starcheck then
            Game.world.starcheck = 0
        end
        if Game.world.starcheck < 9 or Game.world.starcheck > 9 then
            cutscene:showNametag("Starwalker?")
            cutscene:text("* My old [color:yellow]sprite[color:reset] was [color:yellow]Pissing[color:reset] me\noff...", nil, event)
            cutscene:text("* I was the original   [color:yellow]Starwalker[color:reset]")
            cutscene:hideNametag()

            Game.world.starcheck = Game.world.starcheck + 1
            --Kristal.callEvent("completeAchievement", "starwalker")
        else
            Game.world.music:stop()
            cutscene:text("* [color:yellow]You[color:reset] are [color:yellow]Pissing[color:reset] me off...", nil, event)

            if not Game:isDessMode() then
                if susie then
                    cutscene:textTagged("* I,[wait:5] uh,[wait:5] what?", "sus_nervous", "susie")
                    cutscene:textTagged("* Well,[wait:5] hey,[wait:5] you know\nwhat?", "annoyed", "susie")
                    cutscene:textTagged("* You piss us off too.", "smirk", "susie")
                    local cutscene_music = Music("deltarune/s_neo")
                    cutscene:detachFollowers()

                    if GeneralUtils:getLeader().id ~= "susie" then
                        cutscene:walkTo(Game.world.player, Game.world.player.x, Game.world.player.y - 40, 1, "down", true)
                        cutscene:wait(cutscene:walkTo(susie, Game.world.player.x, Game.world.player.y, 1, facing))
                    end
				
                    cutscene:textTagged("* If you have a problem\nwith us,[wait:5] then we have\na problem with you.", "smirk", "susie")
                    cutscene:textTagged("* Do you know what we do\nwith problems?", "smirk", "susie")
                    cutscene:textTagged("* We stomp.[wait:10] Them.[wait:10] Into.[wait:10]\nThe.[wait:10] Ground.", "smile", "susie")
                    cutscene_music:stop()
                end
            else
                cutscene:textTagged("* Oh[speed:0.5]...[wait:10][speed:1] am i?", "condescending", "dess")
                cutscene:textTagged("* Wouldn't be the first time I've heard that sentence", "neutral_b", "dess")
                cutscene:textTagged("* Given being annoying is what I do best", "smug", "dess")
                cutscene:textTagged("* Bring it, starman", "challenging", "dess")
            end

            Assets.playSound("boost")

            star.sprite:set("wings")

            if susie then
                susie:setSprite("shock_right")
            end

            local offset = star.sprite:getOffset()

            local flash_x = star.x - (star.actor:getWidth() / 2 - offset[1]) * 2
            local flash_y = star.y - (star.actor:getHeight() - offset[2]) * 2

            local flash = FlashFade("battle/enemies/starwalker/starwalker_wings", flash_x, flash_y)
            flash.flash_speed = 0.5
            flash:setScale(2, 2)
            flash.layer = star.layer + 1
            star.parent:addChild(flash)

            cutscene:wait(1)

            if not Game:isDessMode() then
                if susie then
                    cutscene:text("* Uh,[wait:5] what-", "surprise_frown", "susie", {auto=true})
                end
            else
                cutscene:text("* WAIT SHIT I'M NOT READY-", "wtf_b", "dess", {auto=true})
            end

            local encounter = cutscene:startEncounter("starwalker", true, {{"starwalker", star}})

            local defeated_enemies = encounter:getDefeatedEnemies()

            local done_state = defeated_enemies[1].done_state
			
            if done_state == "KILLED" or done_state == "FROZEN" then
                if not Game:isDessMode() then
                    susie:resetSprite()
                    cutscene:wait(1)
                    cutscene:textTagged("* Hey,[wait:5] uh.", "neutral", "susie")
                    cutscene:textTagged("* I know they were in our way,[wait:5] but...", "annoyed_down", "susie")
                    susie:setFacing("up")
                    cutscene:textTagged("* What happened to the ACTing thing?", "neutral", "susie")
                    cutscene:textTagged("* ...", "annoyed_down", "susie")
                    if cutscene:getCharacter("dess") then
                        cutscene:textTagged("* Well there goes a potential party member", "condescending", "dess")
                    end
                else
                    cutscene:textTagged("*YEAHHHHHH I fuckin did it", "swag", "dess")
					
                    Assets.playSound("boost")
                    local dess_party = Game:getPartyMember("dess")
                    dess_party:increaseStat("health", 25)
                    dess_party:increaseStat("attack", 1)
                    dess_party:increaseStat("defense", 1)
                    dess_party:increaseStat("magic", 1)
                    cutscene:text("* (Dess became stronger!)")
                end

                Assets.playSound("ominous")
                cutscene:wait(1.5)
                Game:setFlag("ostarwalker_killed", true)
                Game.world.player:setFacing("down")
            else
                if susie then
                    susie:resetSprite()
                end
				
                local good_star = cutscene:spawnNPC("ostarwalker", star.x, star.y)
                Game.world.music:resume()

                cutscene:textTagged("* I changed my    [color:yellow]mind[color:reset]", nil, "ostarwalker")
				
                local guys = #Game.party > 1 and "You guys" or "You"
                cutscene:textTagged(string.format("* %s are actually pretty [color:yellow]cool[color:reset].", guys), nil, "ostarwalker")

                if susie then
                    cutscene:textTagged("* Uh...[wait:5]thanks??", "nervous_side", "susie")
                end

                good_star:setFacing("left")
                cutscene:textTagged("* As such, I will also    [color:yellow]join[color:reset]", nil, "ostarwalker")
                if susie then
                    cutscene:textTagged("* Join...[wait:5]what?", "suspicious", "susie")
                    cutscene:textTagged("* The\n[color:yellow]        party[color:reset]", nil, "ostarwalker")
                    cutscene:textTagged("* Oh.", "surprise", "susie")
                end

                if #Game.party >= 3 then
                    cutscene:wait(1)
                    cutscene:textTagged("* Wait", nil, "ostarwalker")
                    cutscene:textTagged("* Your [color:yellow]party[color:reset] is        full", nil, "ostarwalker")
                    cutscene:textTagged("* I will join             the [color:yellow]Party Room[color:reset]", nil, "ostarwalker")

                    local alpha = good_star:addFX(AlphaFX())
                    Game.world.timer:tween(1, alpha, { alpha = 0 })
                    Assets.playSound("hypnosis")
                    cutscene:wait(2)
                    good_star:remove()
                elseif Game:isDessMode() then
                    cutscene:textTagged("* Erm actually this is Dess Mode[font:main_mono,16]TM[font:reset]", "condescending", "dess")
                    cutscene:textTagged("* So I get to be the only party member", "challenging", "dess")
                    Game.world.music:stop()
                    cutscene:textTagged("* Oh", nil, "ostarwalker")
                    cutscene:textTagged("* I see", nil, "ostarwalker")
                    cutscene:textTagged("* I'll be on my     [color:yellow]way[color:reset] then", nil, "ostarwalker")

                    local alpha = good_star:addFX(AlphaFX())
                    Game.world.timer:tween(1, alpha, { alpha = 0 })
                    Assets.playSound("hypnosis")
                    cutscene:wait(4)
					
                    Game.world.timer:tween(0.5, alpha, { alpha = 1 })
                    Assets.playSound("hypnosis", 1, 1.5)
					
                    cutscene:wait(1)

                    cutscene:textTagged("* Oh wait actually", nil, "ostarwalker")
                    cutscene:textTagged("* Since you defeated    [color:yellow]me[color:reset]", nil, "ostarwalker")
                    cutscene:textTagged("* I'll give you [color:yellow]this[color:reset]", nil, "ostarwalker")
					
                    Assets.playSound("boost")
                    local dess_party = Game:getPartyMember("dess")
                    dess_party:increaseStat("health", 25)
                    dess_party:increaseStat("attack", 1)
                    dess_party:increaseStat("defense", 1)
                    dess_party:increaseStat("magic", 1)
                    cutscene:text("* (Dess became stronger!)")
					
                    cutscene:textTagged("* ...A free stat boost?", "wtf", "dess")
                    cutscene:textTagged("* and I DON'T have to kill anyone for it??", "doom_AURGHHHHHH", "dess")
                    cutscene:textTagged("*            Yes", nil, "ostarwalker")
                    cutscene:textTagged("* ...", "neutral", "dess")
                    cutscene:textTagged("* A bit anticlimatic ngl", "eyebrow", "dess")
                    cutscene:textTagged("* But I suppose any stat boost is a good one", "neutral_c", "dess")
                    cutscene:textTagged("* So uhh thanks ig", "genuine_b", "dess")
                    cutscene:textTagged("* You're    [color:yellow]welcome[color:reset]", nil, "ostarwalker")
                    cutscene:textTagged("* I'm [color:yellow]going[color:reset] now", nil, "ostarwalker")
                    cutscene:textTagged("* Bye", nil, "ostarwalker")
					
                    local alpha = good_star:addFX(AlphaFX())
                    Game.world.timer:tween(1, alpha, { alpha = 0 })
                    Assets.playSound("hypnosis")
                    cutscene:wait(2)
                    Game.world.music:resume()
                    good_star:remove()
                else
                    Game:addPartyMember("ostarwalker")
                    Game:unlockPartyMember("ostarwalker")
                    good_star:convertToFollower()
				
					Game.world.music:pause()
                    local party_jingle = Music("deltarune/charjoined")
                    party_jingle:play()
                    party_jingle.source:setLooping(false)
                    
                    cutscene:text("[noskip]* [color:yellow]Starwalker[color:reset] joined the party.")
					Game.world.music:resume()
                    party_jingle:remove()
                end
                Game:setFlag("ostarwalker_party", true)
                Game:unlockPartyMember("ostarwalker")
            end
            Game:setFlag("starwalker_defeated", true)
            cutscene:wait(cutscene:attachFollowers())
            cutscene:interpolateFollowers()
        end
    end,

    unreadable_legend = function(cutscene, event)
        if not Game:isDessMode() then
            cutscene:text("* (It appears some kind of legend is written here...)")
            cutscene:text("* (Read it?)")
			
            local choicer = cutscene:choicer({"Read", "Do not"})
			
            if choicer == 1 then
                cutscene:text("* (You attempted to read the legend transcribed on the plaque...)")
                cutscene:text("* ([speed:0.5]...[wait:10][speed:1]but it was so utterly incomprehensible that it made your head spin.)")
                cutscene:text("* (Perhaps some legends are best left forgotten...)")
            else
                if love.math.random(1, 10) == 1 then
                    cutscene:text("* (You legen't.)")
                else
                    cutscene:text("* (You decided to spare yourself of a headache.)")
                end
            end
        else
            cutscene:textTagged("* I tried reading this once but then i remembered i can't read", "neutral", "dess")
            cutscene:textTagged("* Such are the pros of being illiterate", "condescending", "dess")
        end
    end,

    diagonal_mario = function(cutscene, event)
        local susie = cutscene:getCharacter("susie")
        local diagonal_mario = cutscene:getCharacter("diagonal_mario")
        cutscene:setTextboxTop(true)
        cutscene:textTagged("* Cease and desist,[wait:5] you fucking idiot", nil, "diagonal_mario", { nametag = "Diagonal Mario of C.A. (Advanced)"})
        if cutscene:getCharacter("susie") then
            cutscene:textTagged("* Yeah?[wait:5]\n* Or what?", "annoyed", "susie")
            cutscene:textTagged("* DMCA", nil, "diagonal_mario", { nametag = "Diagonal Mario of C.A. (Advanced)"})
            if Game.party[2].id == "noel" then
			    cutscene:showNametag("Noel")
                cutscene:text("[speed:2]* SURPRISE ATTACK GORDON!!!", "loud", "noel", { auto = true })
                diagonal_mario:explode()
            else
                cutscene:text("* Well,[wait:5] shi--", "shock", "susie", { auto = true })
                Game:removePartyMember("susie")
                susie:remove()
                Game:setFlag("susie_party", false)
            end
        elseif Game:isDessMode() then
            Game.world.music:pause()
            Assets.playSound("no_fuck_off")
            cutscene:textTagged("[noskip][voice:nil]* no,[wait:2.5] fuck off[wait:7.5]", "dess.exe", "dess", {auto = true})

            local beam_of_death = Rectangle(diagonal_mario.x, 0, 1, diagonal_mario.y)
            beam_of_death = Rectangle(diagonal_mario.x, 0, 1, diagonal_mario.y)
            beam_of_death.layer = diagonal_mario.layer - 0.1
            beam_of_death:setColor(1, 1, 1, 1)
            beam_of_death:setOrigin(0.5, 0)
			Game.world:addChild(beam_of_death)
            Game.world.timer:tween(0.1, beam_of_death, { scale_x = 60})
			
            Game.world.timer:tween(0.25, diagonal_mario, { color = {0, 0, 0} })
			
            diagonal_mario:setScaleOrigin(0.5, 1)
            Game.world.timer:tween(1, diagonal_mario, { scale_x = 4, scale_y = 0 })
			
            cutscene:wait(2)
            Game.world.timer:tween(0.1, beam_of_death, { scale_x = 0})
            cutscene:wait(0.1)
            diagonal_mario:remove()
            beam_of_death:remove()
			
            cutscene:wait(2)
            cutscene:textTagged("* no copyright law in the universe can stop me", "condescending", "dess")
            Game:setFlag("diagonalMarioKilled", true)

            Game.world.music:resume()
        end
    end,

    poem_plate = function(cutscene, event)
        if event:getFlag("poem_plate") then
        else
            Game.inventory:addItem("poem_plate")
            cutscene:text("* (There appears to be something behind this banner...)")
            Assets.playSound("item")
            cutscene:text("* (You obtained the [color:yellow]Poem Plate[color:white].)")
            cutscene:text("* (The [color:yellow]Poem Plate[color:white] was added to your [color:yellow]ITEMs[color:white].)")
            event:setFlag("poem_plate", true)
        end
    end,

    missinfo = function(cutscene, event)
        cutscene:text("* YOU,[wait:5] looks like you're in the need of some,[wait:5] MISSINFORMATION!", nil, "miss_info")
    end,
}
return hub

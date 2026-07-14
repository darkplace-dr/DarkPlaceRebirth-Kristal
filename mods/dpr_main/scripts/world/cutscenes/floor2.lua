return {
    ---@param cutscene WorldCutscene
    wobblything = function(cutscene, map, partyleader)
        local wobblything = cutscene:getEvent("wobblything")
        
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
        
        local function removeBigText()
            for _, v in ipairs(texts) do
                v:remove()
            end
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

        local function zoom(scale, wait, overwrite_pos)
            local tx, ty = wobblything:getRelativePos(wobblything.width/2, wobblything.height/2)
            Game.world.camera:setZoom(scale)
            if overwrite_pos then
                Game.world.camera:setPosition(overwrite_pos[1], overwrite_pos[2])
            else
                Game.world.camera:setPosition(tx, ty)
            end
            cutscene:wait(wait)
        end
		
        Game.world.music:fade(0, 2.5)
        
        cutscene:detachCamera()
        cutscene:wait(5)
        
        Assets.playSound("vineboom")
        Game.world.music:play("wobblything_loop")
        Game.world.music:fade(1, 0.01)
        zoom(2, 0)
        flashScreen()
        genBigText("HOLY SHIT", 200, 115, 2)
        
        cutscene:wait(3)
        Assets.playSound("vineboom")
        genBigText("IT'S A WOBBLY THING", 200, 318, 1)
        
        cutscene:wait(3)
        Assets.playSound("vineboom")
        removeBigText()
        genBigText("11/10", 250, 115, 2)
        
        cutscene:wait(3)
        Assets.playSound("vineboom")
        genBigText("BEST LIBRARY", 161, 298, 2)
        
        cutscene:wait(3)
        local nyako = Sprite("world/cutscenes/floor2/wobblything_msg", 180, 180)
        nyako:setScale(0.7550, 1)
        nyako:setLayer(9999)
        Game.world:addChild(nyako)
		
        Assets.playSound("vineboom_louder")
    
        cutscene:wait(0.3)
        removeBigText()
        nyako:remove()
        Assets.stopSound("vineboom")
        Assets.stopSound("vineboom_louder")
        Game.world.music:stop()
        Game.world.music:play("mainhub")
        zoom(1, 0)
        cutscene:attachCameraImmediate()
		
    end,

    backrooms_entry = function(cutscene, event)
        --Game.world.music:fade(0, 0.25)
        Assets.playSound("dooropen")
        event:setSprite("world/events/floor2/backroomsdoor_open")
        cutscene:wait(0.5)

        --cutscene:wait(cutscene:mapTransition("backrooms/entrance", "entry")) --commented out cause backrooms aren't added yet.
        Assets.playSound("doorclose")
        if event then
            event:setSprite("world/events/floor2/backroomsdoor_closed")
        end
    end,

    queen_sip = function(cutscene, event)
        cutscene:showNametag("Queen")
		if not Game.world.map.queen_dialogue then
            Assets.playSound("queen/queensip_1")
            cutscene:text("[noskip]*[wait:3s]", "sip", "queen", {auto = true})

            if Game:hasPartyMember("hero") and Game:hasPartyMember("susie") then
                cutscene:text("* Susie How Do You Like My:", "smile", "queen")
            elseif Game:hasPartyMember("kris") and Game:hasPartyMember("susie") then
                cutscene:text("* Kris Susie How Do You Like My:", "smile", "queen")
		    elseif #Game.party == 1 then
                cutscene:text("* Greetings How Do You Like My:", "smile", "queen")
		    else
                cutscene:text("* Greetings Everyone How Do You Like My:", "smile", "queen")
            end

            Assets.playSound("queen/queensip_2")
            cutscene:text("[noskip]*[wait:1s]", "sip", "queen", {auto = true})
            cutscene:text("* Room", "smile", "queen")

            Assets.playSound("queen/queensip_3")
            cutscene:text("[noskip]*[wait:2s]", "sip", "queen", {auto = true})
            cutscene:text("* Do You Want A Sip", "smile", "queen")

            cutscene:hideNametag()

            if cutscene:getCharacter("susie") then
                cutscene:showNametag("Susie")
                cutscene:text("* Uhh...[wait:3] that's acid. We'd die.", "nervous_side", "susie")
                cutscene:hideNametag()

                if cutscene:getCharacter("jamm") then
                    cutscene:showNametag("Jamm")
                    cutscene:text("* Correction, Susie. YOU'd die.", "smug", "jamm")
                    cutscene:text("* Wait, why's everyone looking at me like that?", "neutral", "jamm")
                    cutscene:hideNametag()
                end

                cutscene:showNametag("Queen")
                cutscene:text("* Oh Dear First You Don't Want To Swim In The Free Pool", "smile", "queen")
                cutscene:text("* Now You Don't Want To Drink The Free Pool Water", "pout", "queen")
                cutscene:text("* More For Me I Suppose", "smile_side_l", "queen")
                cutscene:hideNametag()
            else
                cutscene:text("* (You decline without hesitation.)")
                cutscene:showNametag("Queen")
                cutscene:text("* Oh Well More For Me I Suppose", "smile_side_l", "queen")
                cutscene:hideNametag()
            end
            Game.world.map.queen_dialogue = true
        else
            cutscene:text("* And Look On The Right Check That Out", "smile_side_r", "queen")
            cutscene:text("* I Built A New City With The Free Space I Found In: The Wall", "smile_side_l", "queen")
            -- "* Umm, it's not free?" Ralsei would've said but it's not his Castle so
        end
        cutscene:hideNametag()
    end,

    queen_speakers = function(cutscene, event)
        cutscene:showNametag("Queen")
        if not Game.world.map.queen_speakers_dialogue then
            cutscene:text("* Wow This Tune Is Bangin' Who Made It[react:1]", "@@", "queen", {reactions={
                {"I Made It", 392, 71, "big_smile", "queen"}
            }})
            Game.world.map.queen_speakers_dialogue = true
        else
            if Game:hasPartyMember("ralsei") then
                cutscene:text("* State Of The Art 32kbps Bitrate For Audio Files[react:1][react:2]", "nice", "queen", {reactions={
                    {"Audiophiles?", 212, 61, "surprise_confused", "ralsei"},
                    {"Audio Files", 392, 71, "smile", "queen"}
                }})
            else
                cutscene:text("* State Of The Art 32kbps Bitrate For Audio Files", "nice", "queen")
            end
        end
        cutscene:hideNametag()
    end,

    rouxls = function(cutscene, event)
        local rouxls = cutscene:getCharacter("rouxls")

        cutscene:setSpeaker("rouxls")
        cutscene:text("* Don't mindeth mineself, I'm just a lampe!", "neutral", "rouxls")
        if Game:hasPartyMember("susie") then
            cutscene:text("* The finest lampe made for her majesty, Que-", "open", "rouxls", { auto = true })
            cutscene:setSpeaker(nil)

            cutscene:text("* Dude, what the hell are you doing?", "suspicious", "susie")

            cutscene:setSpeaker("rouxls")
            cutscene:text("* Ah![wait:5] Look whom decidedeth to slither in like the wormes thoust are!", "shock", "rouxls")
            cutscene:text("* What does thoust need from the Duke of Lampes,[wait:5] Rouxls Kaard?", "wink", "rouxls")
            cutscene:setSpeaker(nil)
			
            cutscene:text("* Well, I have SEVERAL questions actually.", "sus_nervous", "susie")
            cutscene:text("* First of all,[wait:5] why are you disguising yourself as Queen's lamp?", "annoyed", "susie")

            cutscene:setSpeaker("rouxls")
            cutscene:text("* [speed:0.5]...", "shock", "rouxls")
            cutscene:text("* DON'T ASKETH QUESTIONS THOUST AREN'T PREPARED TO HEAR THE ANSWER TO.", "shock_right", "rouxls")
            cutscene:setSpeaker(nil)

            cutscene:text("* ...[wait:5]okay...?", "suspicious", "susie")
            cutscene:text("* Secondly, are you gonna hop back into our pockets now?", "sus_nervous", "susie")
            cutscene:text("* Y'know,[wait:5] since we found you and all that.", "nervous_side", "susie")

            cutscene:setSpeaker("rouxls")
            cutscene:text("* Nay![wait:5] I shan't!", "shock", "rouxls")
            cutscene:setSpeaker(nil)

            cutscene:text("* What?[wait:2] WHY?!", "teeth", "susie")
			
            cutscene:setSpeaker("rouxls")
            cutscene:text("* I shall not removeth mineself from the premises...", "open", "rouxls")
            cutscene:text("* Unless her Majesty says otherwise.", "eyesclosed", "rouxls")
            cutscene:setSpeaker(nil)

            cutscene:text("* Oh,[wait:2] really?[wait:8]\n* Well, in that case...", "surprise", "susie")
			
            cutscene:text("* Hey, Queen! Can we borrow your lamp for a bit?[react:1]", "smirk", "susie", {reactions = { 
                {"Wait what-", "right", "bottom", "shock", "rouxls"}
            }})

            Assets.playSound("queen/queensip_3")
            cutscene:text("[noskip]*[wait:2s]", "sip", "queen", {top = false, auto = true})
            cutscene:text("* Processing Verification[react:1]", "smile", "queen", {top = false, reactions = { 
                {"No, wait I-", "right", "bottom", "shock_right", "rouxls"}
            }})
            cutscene:text("* ...", "down_a", "queen", {top = false})
            cutscene:text("* Yeah You Can Take It", "smile_side_l", "queen", {top = false})
			
            cutscene:text("* Sick! Thanks, Queen.", "smile", "susie")
			
            cutscene:setSpeaker("rouxls")
            cutscene:text("[speed:0.5]* ...", "shock", "rouxls")
            cutscene:text("[speed:0.5]* GOD", "shock", "rouxls")
            cutscene:text("[speed:0.5]* DAMMIT", "shock", "rouxls")
            cutscene:setSpeaker(nil)
			
            rouxls:remove()
            Game:setFlag("hasObtainedRouxls", true)
            Game.inventory:tryGiveItem("rouxls_kaard")
            Assets.playSound("item")
            cutscene:text("* Rouxls Kaard re-entered your [color:yellow]KEY ITEMS[color:reset]...[wait:10]reluctantly.")

            DP:completeAchievement("find_rouxls")
        else
            cutscene:text("* The finest lampe made for her majesty, Queen!", "open", "rouxls")
		end
    end,

    queen_arcade = function(cutscene, event)
        --placeholder dialogue
        cutscene:showNametag("Queen")
        cutscene:text("* Ah Yes The Smaller Version Of My Arcade Machine", "smile_side_r", "queen")
        cutscene:text("* It's Still Under Maintenance At The Moment", "smile_side_l", "queen")
        cutscene:text("* Especially After Burghley Squashed It With His \"Statue\"", "angry", "queen")
        cutscene:text("* So Unfortunately You Can't Play It Right Now Sorry", "sorry", "queen")
        cutscene:hideNametag()
    end,
	
    queen_shadowguys = function(cutscene, event)
        Assets.playSound("carhonk")
        cutscene:text("* (Looks like a touring band.)")
        cutscene:text("* (...[wait:5] They only do the touring part though.)")
    end,
	
    lancer_player = function(cutscene, event)
        cutscene:text("* (It's a music player.)[wait:5]\n* (Listen to the contents?)")
        local choice = cutscene:choicer({"Listen", "Do Not"})
        if choice == 1 then
			Assets.playSound("splat")
            cutscene:text("* (...)")
            cutscene:text("* (It's full of cartoon splat noises.)")
        else
            cutscene:text("* (You did not listen.)")
        end
    end,

    lancer = function(cutscene, event)
        Game:setFlag("lancer_obtained", true)
        Game.world.music:fade(0, 2)

        cutscene:wait(0.5)
        local lancer = cutscene:getCharacter("lancer")
        local susie = cutscene:getCharacter("susie")
        lancer:alert()
        cutscene:wait(0.5)
        lancer:setFacing("down")

        if susie then
            cutscene:showNametag("Susie", {top = false})
            cutscene:text("* Lancer?!", "surprise_frown", "susie", {top = false})
            cutscene:hideNametag()

            cutscene:wait(cutscene:walkTo(susie, 320, 280, 0.5, "up"))
            cutscene:wait(cutscene:walkTo(susie, lancer.x + 60, lancer.y, 0.5, "left"))
            lancer:setFacing("right")
            cutscene:text("insert the susie and lancer high fiving animation here")
            Game.world.music:play("deltarune/lancer", 1, 1)
            cutscene:showNametag("Lancer", {top = false})
            cutscene:text("* Susie!", "smile", "lancer", {top = false})
            cutscene:text("* How's my favorite purple person doing?", "tongue_b", "lancer", {top = false})
            cutscene:showNametag("Susie", {top = false})
            cutscene:text("* Yeah, uh,[wait:5] I'm doing great, but...", "shy", "susie", {top = false})
            cutscene:text("* How the hell'd you get here??", "surprise_frown", "susie", {top = false})
            cutscene:showNametag("Lancer", {top = false})
            cutscene:text("* Why,[wait:5] via Kris's spacious pants hole of course.", "handsome", "lancer", {top = false})
            cutscene:showNametag("Susie", {top = false})
            cutscene:text("* Oh,[wait:5] right.", "suspicious", "susie", {top = false})
            cutscene:text("* Hey,[wait:5] you should totally come along with us!", "surprise_smile", "susie", {top = false})
            cutscene:showNametag("Lancer", {top = false})
            cutscene:text("* Another adventure?", "tongue_b", "lancer", {top = false})
            cutscene:text("* Well sign me and my digging certification up!", "smile_tongue", "lancer", {top = false})
            cutscene:showNametag("Susie", {top = false})
            cutscene:text("* Your what now?", "nervous_side", "susie", {top = false})
            cutscene:hideNametag()
            lancer:setFacing("up")
            Game.world.music:fade(0, 0.5)
            cutscene:slideTo(lancer, lancer.x, lancer.y + 60, 0.5)
            cutscene:wait(0.75)
            Game.world.music:play("beans_tutorial", 1, 1)
            cutscene:showNametag("Lancer", {top = false})
            cutscene:text("* You may have seen these spots in the ground all over the place.", "tongue_c", "lancer", {top = false})
            lancer:setFacing("right")
            cutscene:text("* These are known as [color:yellow]BEAN SPOTS[color:reset],[wait:5] and each one contains their own [color:yellow]BEAN[color:reset].", "tongue_b", "lancer", {top = false})
            cutscene:text("* Unfortunately,[wait:5] the ground is too hard for most people to dig up...", "flat", "lancer", {top = false})
            lancer:setFacing("down")
            cutscene:text("* That's where I come in!", "smile", "lancer", {top = false})
            lancer:setFacing("up")
            cutscene:text("* If I'm in your inventory,[wait:5] then if you interact with these...", "tongue_a", "lancer", {top = false})
            lancer:setFacing("down")
            cutscene:text("* Then I'll dig it up for you!", "tongue_b", "lancer", {top = false})
            cutscene:text("* How about we give it a try?", "smile", "lancer", {top = false})
            if not cutscene:getCharacter("kris") then
                cutscene:text("* ...", "tongue_c", "lancer", {top = false})
                lancer:setFacing("right")
                cutscene:text("* Hey, Susie...[wait:10] where's Kris?", "flat", "lancer", {top = false})
                if not Game:hasUnlockedPartyMember("kris") then
                    cutscene:showNametag("Susie", {top = false})
                    cutscene:text("* Oh,[wait:5] uh...", "surprise", "susie", {top = false})
                    cutscene:text("* We're still trying to find them.", "shy_b", "susie", {top = false})
                end
                cutscene:text("* So in the meantime,[wait:5] we'll be taking care of inventory stuff.", "smirk", "susie", {top = false})
                cutscene:showNametag("Lancer", {top = false})
                cutscene:text("* Ohhh, okay!", "smile", "lancer", {top = false})
            end
            cutscene:hideNametag()
            local lancer_speen = true
            Game.world.music:play("deltarune/board_lancer_dig", 1, 1)
            cutscene:slideTo(lancer, Game.world.player.x, Game.world.player.y, 6.8)
            while lancer_speen do
                lancer:setFacing("down")
                cutscene:wait(1/15)
                lancer:setFacing("left")
                cutscene:wait(1/15)
                lancer:setFacing("up")
                cutscene:wait(1/15)
                lancer:setFacing("right")
                cutscene:wait(1/15)
                if lancer.x == Game.world.player.x and lancer.y == Game.world.player.y then
                    lancer_speen = false
                end
            end
            Game.world.music:play("beans_tutorial", 1, 1)
            lancer:remove()
            Assets.playSound("item")
            Game.inventory:tryGiveItem("lancer")
            cutscene:text("* (Lancer has re-entered your KEY ITEMs!)")
            cutscene:interpolateFollowers()
            
            DP:completeAchievement("find_lancer")
        end
    end,

    beans_forcer = function(cutscene, event)
        if Game:getFlag("darkess_beans") ~= 1 then
            cutscene:showNametag("Lancer")
            cutscene:text("* Hey,[wait:5] we still gotta dig up that bean!", "flat", "lancer")
            cutscene:hideNametag()
            cutscene:wait(cutscene:walkTo(Game.world.player, Game.world.player.x, Game.world.player.y - 20, 0.5))
        else
            cutscene:showNametag("Lancer")
            cutscene:text("* Nice going!", "smile", "lancer")
            cutscene:text("* Be sure to give me a call if you need any more bean digging.", "tongue_b", "lancer")
            cutscene:text("* I heard you can use them for something really cool on this floor!", "smile_tongue", "lancer")
            cutscene:hideNametag()
            event:remove()
        end
    end,

    spamgolor = function(cutscene, event)
        cutscene:text("* It's a door.")
        if not Game:getFlag("spamgolor_fight") then
            cutscene:text("* There is a note attached:")
            cutscene:text("[voice:spamgolor]* \"CURRENTLY OUT IN\n[[A room between...]]\"")
            cutscene:text("[voice:spamgolor]* \"COME CHECK BACK\n[[Coming soon!]]\"")
        else
            cutscene:text("* It's unlocked,[wait:5] will you go inside?")
            local choice = cutscene:choicer({"Yes", "No"})
            if choice == 1 then
                
            else
                cutscene:text("* You doorn't.")
            end
        end
    end,
	
	deathlordsign = function(cutscene, event)
        if Game:getFlag("deathlordsign_read") then
            cutscene:text("* Never again.")
            return
        end
		local susie = cutscene:getCharacter("susie")
        Game:setFlag("deathlordsign_read", true)
        cutscene:text("* The sign reads: 'i have a gun and im gonna shoot you lol'.")
		-- TODO: Improve these dialogue lines LMAO
        --[[if cutscene:getCharacter("dess") then
            cutscene:showNametag("Dess")
            cutscene:text("* bro what", "wtf_b", "dess")
        end
        if cutscene:getCharacter("susie") then
            cutscene:showNametag("Susie")
            cutscene:text("* Wait, what?", "sus_nervous", "susie")
        end
		if cutscene:getCharacter("jamm") then
			cutscene:showNametag("Jamm")
            cutscene:text("* How would a sign have a gun?", "neutral", "jamm")
		end
        if cutscene:getCharacter("brenda") then
            cutscene:showNametag("Brenda")
            cutscene:text("* I don't think it means anything.", "frown_side", "brenda")
        end
        if cutscene:getCharacter("dess") then
            cutscene:showNametag("Dess")
            cutscene:text("* OH SHIT BEHIND US", "wtf_b", "dess")
            cutscene:hideNametag()
            cutscene:startEncounter("deathlord", true)
            return
        end
        if cutscene:getCharacter("brenda") then
            cutscene:showNametag("Brenda")
            cutscene:text("* TURN AROUND", "shock", "brenda")
        end
		if cutscene:getCharacter("jamm") then
			cutscene:showNametag("Jamm")
            cutscene:text("* WAIT WHAT THE FU--", "neutral", "jamm", {auto=true})
		end
        cutscene:hideNametag()]]
		Assets.playSound("escaped")
		local deathlord = Game.world:spawnNPC("deathlord", Game.world.camera.x + SCREEN_WIDTH/2 + 40, Game.world.player.y)
		deathlord.physics.speed_x = -1
		deathlord.physics.friction = -1.5
		if susie then
			cutscene:wait(10/30)
			Assets.playSound("sussurprise")
			susie:shake()
			susie:setSprite("shock_right")
		end
		cutscene:wait(function()
			if deathlord.x <= Game.world.player.x + Game.world.player.width then
				return true
			end
			return false
		end)
        cutscene:startEncounter("deathlord", true, deathlord)
		deathlord:remove()
		if susie then
			susie:resetSprite()
		end
    end,

    ---@param cutscene WorldCutscene
    ---@param event Event
    podiumitem = function(cutscene, event)
        ---@param event Event
        local function getEventProperties(event)
            local data = event.data
            local properties = data.properties or {}
            return data, properties
        end

        if not event then return end
        local data, properties = getEventProperties(event)
        local item = properties["item"]
        if not item then return end
        ---@type PodiumItem
        local podiumitem_event = Game.world:getEvent(item.id)
        if not podiumitem_event or not podiumitem_event.parent then return end
        local podiumitem_event_data, podiumitem_properties = getEventProperties(podiumitem_event)
        local podiumitem = podiumitem_properties["item"]
        local skip_rsc = Game:getFlag("skip_red_spear_cutscene")
        if not skip_rsc then
            cutscene:text("* (You don't know anything about this item.)")
        end
        cutscene:text("* (Take it?)")
        local c = cutscene:choicer({"Yes", "No"})
        if c == 2 then return end

        local itempodiums = Game.world:getEvents("podiumitem")
        local success, result_text = podiumitem_event:tryGiveItem(true)
        if success then
            Assets.playSound("item")
            for _,itempodium in pairs(itempodiums) do
                itempodium:setFlag("grabbed", false)
                itempodium.visible = false
                if itempodium ~= podiumitem_event then
                    itempodium:setFlag("grabbed", true)
                    itempodium:explode(nil, nil, true)
                end
            end

            cutscene:text(result_text)

            local len = cutscene:getCharacter("len")
            if len then
                cutscene:detachCamera()
                cutscene:detachFollowers()
                
                if not skip_rsc then
                    local charas = cutscene:getPartyCharacters()
                    for i,chara in ipairs(charas) do
                        if chara.actor.id == len.actor.id then
                            table.remove(charas, i)
                            break
                        end
                    end
                    
                    for _,chara in pairs(charas) do
                        local x = chara.x - 40
                        cutscene:walkTo(chara, x, chara.y)
                    end

                    len:setFacing("up")
                    cutscene:wait(1)

                    cutscene:textTagged("* Wait!", "neutral", "len")

                    for _,chara in pairs(charas) do
                        chara:setFacing("right")
                    end
                end

                local time = 1
                if skip_rsc then
                    time = 0.4
                end

                local mx, my = cutscene:getMarker("spear_walk")
                if len.y > my then
                    cutscene:wait(cutscene:walkTo(len, mx, my, time))
                end
                local mx, my = cutscene:getMarker("spear")
                cutscene:wait(cutscene:walkTo(len, mx, my, time))
                len:setFacing("up")
                if not skip_rsc then
                    cutscene:textTagged("* This red spear looks soo cool.", "neutral", "len")
                    cutscene:textTagged("* I don't think whoever left this here would mind if i take it.", "neutral_b", "len")
                end

                ---@type TileLayer
                local spear = Game.world.map:getTileLayer("spear")
                spear.visible = false
                Assets.playSound("item")
                if not skip_rsc then
                    cutscene:wait(1)
                else
                    cutscene:wait(0.3)
                end

                len:setFacing("down")
                if not skip_rsc then
                    cutscene:textTagged("* Ok,[wait:5] lets go.", "neutral", "len")
                end

                cutscene:wait(cutscene:walkTo(len, len.x, len.y + 40, time))

                Assets.playSound("spearappear", 2, 1)
                cutscene:wait(0.2)
                cutscene:alert(len)

                if not skip_rsc then
                    cutscene:wait(1)
                else
                    cutscene:wait(0.3)
                end

                len:setFacing("up")
                if not skip_rsc then
                    cutscene:textTagged("* Uh...[wait:5] what was that noise?", "suprise", "len")
                    cutscene:wait(1)

                    cutscene:alert(len)
                    cutscene:setSpeaker("len_hood", false)
                    cutscene:text("* WHAT ARE YOU DOING?")
                    cutscene:text("* THE SIGN SAID TO ONLY TAKE ONE![wait:5] ONE!")
                    cutscene:text("* THIS,[wait:5] IS,[wait:5] MORE,[wait:5] THAN ONE!")
                    cutscene:text("* THIS IS AGAINST THE ROOM RULES!")

                    if not Game:getFlag("read_red_spear_sign") then
                        cutscene:textTagged("* What???[wait:5] the sign i didn't read???", "nervous", "len")
                    else
                        cutscene:textTagged("* What???", "nervous", "len")
                    end
                    
                    cutscene:text("* ENOUGH![wait:5] ENOUGH![wait:5] ENOUGH!!!")
                    cutscene:alert(len)
                    cutscene:text("* I'LL SHOW YOU THE CONSEQUENCES OF YOUR ACTIONS!")
                    cutscene:textTagged("* Wait! don't-", "dumb", "len", {auto = true})
                end
                
                len:setAnimation("reveal_forced")
                len:shake()
                Assets.playSound("wing")
                Assets.playSound("bell_bounce_short")
                local slide = 60
                local time = 0.4
                local x, y = len.x, len.y
                local hood_x, hood_y = x -20, y
                local hood = cutscene:spawnNPC("len_hood", hood_x, hood_y)
                hood:setAnimation("spear/idle")
                hood.flip_x = true
                hood.layer = len.layer + 1
                local offset_y = 22
                cutscene:slideTo(hood, hood_x + slide, hood_y - offset_y, time)
                cutscene:wait(cutscene:slideTo(len, x - slide, y - offset_y, time))

                Game:setFlag("skip_red_spear_cutscene", true)
                Kristal.saveGame()

                for _,itempodium in pairs(itempodiums) do
                    itempodium:setFlag("grabbed", true)
                    itempodium:remove()
                end

                Game:getPartyMember("len"):setFlag("hoodless", true)
                hood:setAnimation("spear/point")
                hood:shake()
                Assets.playSound("wing")
                cutscene:setSpeaker("len_hood", false)
                cutscene:text("* EN GUARDE!")

                cutscene:startEncounter("lenhoodredspear", true, hood)

                Game.world.music:play("forgottenbone", 2)
                hood:setAnimation("spear/idle")
                cutscene:text("* Woah![wait:5] What a good battle!")
                cutscene:text("* I hadn't had a battle like that in ages!")
                cutscene:text("* You have proven yourself worthy of my power.")
                cutscene:text("* Let me aid you on your adventure.")
                local success, result_text = Game.inventory:tryGiveItem("red_spear")
                if not success then
                    cutscene:setSpeaker()
                    cutscene:text(result_text)
                    cutscene:setSpeaker("len_hood", false)
                    cutscene:text("* ...")
                    cutscene:text("* ...?")
                    cutscene:text("* Nevermind then,[wait:5] i'll return to the wall until you need me.")
                end

                cutscene:textTagged("* Wait![wait:5] could you return me my hoodie first please?", "dumb", "len")
                cutscene:text("* Oh,[wait:5] sure...[wait:5] i almost forgot.")
                cutscene:text("* Catch![wait:1]", "", "len_hood", {wait = false, auto = true})
                cutscene:wait(0.2)
                len:alert()
                hood:setAnimation("spear_only/idle")
                hood:shake()
                local offset_y = 45
                local hood_sprite = Sprite("party/len_hood/idle", hood.x, hood.y - offset_y)
                hood_sprite:setScaleOrigin(0.5, 1)
                hood_sprite:setScale(2.4, 2.4)
                hood_sprite.layer = len.layer + 1
                hood_sprite.flip_x = true
                Game.world:addChild(hood_sprite)
                Assets.playSound("whip_throw_only")
                cutscene:wait(cutscene:slideTo(hood_sprite, len.x, len.y - offset_y, 0.4))
                hood_sprite:remove()
                Assets.playSound("wing")
                Game:getPartyMember("len"):setFlag("hoodless", false)
                len:shake()
                len:resetSprite()
                len:setFacing("right")
                cutscene:wait(1)
                cutscene:textTagged("* Ahh...[wait:5][face:happy][sound:voice/pink/mew] much better!", "neutral_closed", "len")
                cutscene:text("* Ok,[wait:5] now.")
                if success then
                    Assets.playSound("item")
                    hood:remove()
                    cutscene:setSpeaker()
                    cutscene:text(result_text)
                    Game:setFlag("gave_red_spear", true)
                else
                    cutscene:setSpeaker("len_hood", false)
                    local mx, my = cutscene:getMarker("spear_wall")
                    cutscene:wait(cutscene:slideTo(hood, mx, my))
                    Assets.playSound("equip")
                    hood:remove()
                    spear.visible = true
                end

                cutscene:setSpeaker("len")
                cutscene:textTagged("* ...[wait:5][face:happy_nervous_b]Could we pretend this never happened?", "nervous_closed_b", "len")

                local player = Game.world.player
                if player.actor.id == "len" then
                    local mx, my = cutscene:getMarker("spear_walk")
                    cutscene:wait(cutscene:walkTo(len, mx, my))
                    len:setFacing("down")
                end

                cutscene:attachFollowers()
                cutscene:attachCamera()
            end
        else
            cutscene:text(result_text)
        end
    end,

    ---@param cutscene WorldCutscene
    ---@param event Event
    redspear = function(cutscene, event)
        if Game:getFlag("gave_red_spear") then
            return
        end

        if Game:getFlag("encounter#dpr_main/lenhoodredspear:done") then
            cutscene:setSpeaker("len_hood", false)
            cutscene:text("* Hello![wait:5] ready to bring some [color:yellow]JUSTICE[color:reset]?")
            cutscene:setSpeaker()
            
            local c = cutscene:choicer({"Yes", "No"})
            if c == 2 then return end

            local success, result_text = Game.inventory:tryGiveItem("red_spear")
            if success then
                ---@type TileLayer
                local spear = Game.world.map:getTileLayer("spear")
                spear.visible = false
                Assets.playSound("item")
                Game:setFlag("gave_red_spear", true)
                cutscene:text(result_text)
                return
            end

            cutscene:text(result_text)
        else
            cutscene:text("* (It appears to be some kind of spear,[wait:5] and for some reason energy is emanating from it.)")
            cutscene:text("* (This item is not on a podium,[wait:5] alas,[wait:5] you cannot take it.)")
        end
    end,

    ---@param cutscene WorldCutscene
    ---@param event Event
    redspear_savepoint = function(cutscene, event)
        if Game:getFlag("encounter#dpr_main/lenhoodredspear:done") then
            if Game:getFlag("gave_red_spear") then
                cutscene:text("* (The empty room feels like a reminder.)")
                cutscene:text("* (...[wait:5][color:yellow]JUSTICE[color:reset] has been made.)")
            else
                cutscene:text("* (The half-empty room feels like a reminder.)")
                cutscene:text("* (...[wait:5][color:yellow]JUSTICE[color:reset]'s waiting.)")
            end

            return
        end

        local itempodiums = Game.world:getEvents("podiumitem")
        local count = 0
        for _,_ in pairs(itempodiums) do
            count = count + 1
        end
        if count == 2 then
            cutscene:text("* (Two green looking weapons shine at your view.)")
            cutscene:text("* (You're filled with the power of not knowing which one to choose.)")
        else
            cutscene:text("* (Your choosen weapon shines at your view.)")
            cutscene:text("* (You're filled with the power of not having to choose again.)")
        end
    end,
}

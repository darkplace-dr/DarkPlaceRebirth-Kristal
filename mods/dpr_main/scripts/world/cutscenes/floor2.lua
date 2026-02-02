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
		
        Assets.playSound("vineboom", 5)
    
        cutscene:wait(0.3)
        removeBigText()
        nyako:remove()
        Assets.stopSound("vineboom")
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
}
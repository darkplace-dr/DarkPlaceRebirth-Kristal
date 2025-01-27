local function getBind(name)
    if Input.usingGamepad() then
        return Input.getText(name)
    end
    return Input.getText(name) .. " "
end

---@type table<string, fun(cutscene:WorldCutscene, event: Event|NPC)>
local cliffside = {
    ---@param cutscene WorldCutscene
    intro = function (cutscene, event)
        Kristal.hideBorder(0)
        cutscene:wait(function ()
            if Game.world.map.id == [[grey_cliffside/cliffside_start]] then
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
            elseif choicer == 2 then
                cutscene:wait(2)
                cutscene:textTagged("* Hello?", "neutral_closed_b", "hero")

                cutscene:wait(4)

                cutscene:textTagged("* Wow...[wait:30]\n* It's sad how I'm waiting for a reply...", "really", "hero")

                hero:setSprite("walk/down")

                cutscene:textTagged(
                "* But,[wait:5] I know you're there though.[wait:10] I overheard you talking to [color:yellow]him[color:white].",
                    "neutral_closed", "hero")
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

                cutscene:textTagged("* Actually,[wait:5] where even IS[wait:5] me?", "neutral_closed", "hero") --haha grammer
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
        cutscene:textTagged("* Careful.[wait:10]\nYou can't go down those cliffs.", nil, "cat", whodis)

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

        cutscene:setSpeaker("hero")
        cutscene:textTagged("* Who's there?", "neutral_closed_b")

        cutscene:textTagged("* Me.[wait:10]\nI'm there.\n[wait:10]Up here.", nil, "cat", whodis)
        Game.world.player:setFacing("up")
        cutscene:wait(1)
        local cattag = {nametag = "Cat?"}
        cutscene:textTagged("* Hello there.", "neutral", "cat", cattag)
        cutscene:hideNametag()
        cutscene:setSpeaker("cat")
        local choicer = cutscene:choicer({ "Hello?", "Is that a\ntalking cat?!" })
        if choicer == 1 then
            cutscene:textTagged("* Yes,[wait:10] hello.", "neutral", cattag)
            cutscene:textTagged("* Hm...[wait:10]\n* You seem to be confused...", "neutral", cattag)
        elseif choicer == 2 then
            cutscene:textTagged("* Yes,[wait:5] I am a cat[wait:5] and I can talk.", "neutral", cattag)
            cutscene:textTagged("* How very observant you are for someone with [color:red]their[color:white] eyes closed.",
                "neutral", cattag)

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
        cutscene:walkTo(hero, 465, hero.y, 4, "right")
        Game.world.music:fade(0, 4)
        cutscene:wait(3)
        Assets.playSound("criticalswing")
        cutscene:wait(cutscene:slideTo(pebblin, pebblin.x, 260, 1, "in-cubic"))
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
        cutscene:startEncounter("pebblin_tutorial", true, {{"pebblin", pebblin}})
        pebblin:remove()
        Game.world.music:fade(1, 0.5)
    end,

    reverse_cliff_2 = function (cutscene, event)
        local end_y = 80
        local p_y = Game.world.player.y
        local tiles = 12
        local length = tiles * 40
        local reverse_spot = p_y + length / 2

        Assets.playSound("noise")

        Game.world.player:setState("SLIDE")

        cutscene:wait(function ()
            if Game.world.player.walk_speed < -8 then
                Assets.playSound("jump", 1, 0.5)
                Game.world.player.physics.speed_y = -10
                Game.world.player.physics.friction = -1.5
                Game.world.player.walk_speed = -8

                return true
            else
                Game.world.player.walk_speed = Game.world.player.walk_speed - DT * 8
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
                local x = Game.world.player.x - 240 + 400
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
        Game.world.player.walk_speed = 4
    end,
    warp_bin = function (cutscene, event)
        Game.world:mapTransition("main_hub")
    end,
    video = function (cutscene, event)
        local cool = [[
extern vec4 keyColor;    // The color to be made transparent (greenscreen color)
extern float threshold;  // The tolerance for matching the key color

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 pixel = Texel(texture, texture_coords);  // Get the pixel color
    float diff = distance(pixel.rgb, keyColor.rgb);  // Measure color difference

    // If the difference between the pixel color and the key color is less than the threshold, make it transparent
    if (diff < threshold) {
        return vec4(0.0, 0.0, 0.0, 0.0);  // Transparent pixel
    } else {
        return pixel * color;  // Return the original color
    }
}
]]





        local cooler = love.graphics.newShader(cool)

        local video = Video("spongebob", true, 0, 0, 640, 480) -- assets/videos/video_here.ogv
        video.parallax_x, video.parallax_y = 0, 0
        video:play()
        video:addFX(ShaderFX(cooler, {
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

        local fan = Music("fanfare", 1, 1, false)

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

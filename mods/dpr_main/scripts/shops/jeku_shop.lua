local JekuShop, super = Class(Shop,  "jeku_shop")

JekuShop.memory_file_name = ".mydata"
local memfile = JekuShop.memory_file_name
local memory_update_state = 0.1

Mod.jeku_memory = {
    -- Misc.
    meet_jeku = nil,
    meet_jeku_empty = nil,
    met_noel = false,
    removed_attrib = false,

    -- Related to Dark Place Legacy
    remember_legacy = nil,
    killed_in_legacy = nil,
    first_meet_legacy = false, -- Pretty sure nothing was set to check for this so...
    welcomed_back_player = 0,

    -- Threaten Talk
    killed = false,
    skipped_death = false,

    -- Frozen Heart
    os_timeleft = nil,
    is_back = false,

    -- Battle
    can_fight = false,
    has_fought = false
}

local function saveJekuMemory()
    if Mod == nil then
        Kristal.Console:warn("Jeku's memory was not saved!! Mod was nil!")
    else
        if love.filesystem.getInfo(memfile) and love.system.getOS() == "Windows" and not Mod.jeku_memory["removed_attrib"] then -- If Jeku's memory file is hidden on Windows, unhide it once and for all
            Mod.jeku_memory["removed_attrib"] = true
            os.execute("attrib -h "..love.filesystem.getSaveDirectory().."/"..memfile)
        end

        local ok, err = love.filesystem.write(memfile, JSON.encode(Mod.jeku_memory))

        if not ok then
            print("Writing error: "..err)
        end
    end
end

if love.filesystem.getInfo(memfile) then
    Mod.jeku_memory = Utils.merge(Mod.jeku_memory, JSON.decode(love.filesystem.read(memfile)))
end

-- Mod won't exist when leaving the error screen, so we'll try to save the file before letting Kristal handle the error
Utils.hook(Kristal, "errorHandler", function(orig, self, ...)
    if not pcall(saveJekuMemory) then
        Kristal.Console:warn("A crash occured and a problem occured while saving Jeku's memory!!")
    end

    return orig(self, ...)
end)
Utils.hook(love, "quit", function(orig, self, ...)
    saveJekuMemory()
    return orig(self, ...)
end)

-- Did the player play Dark Place Legacy?
if Mod.jeku_memory["remember_legacy"] == nil then
    Mod.jeku_memory["remember_legacy"] = GeneralUtils:hasSaveFiles("dark_place")
end

if Mod.jeku_memory["remember_legacy"] and (Mod.jeku_memory["first_meet_legacy"] == nil or Mod.jeku_memory["killed_in_legacy"] == nil) then
    -- Try to see if the player saw Jeku in Legacy by checking the shop's flags
    local paths = {
        "LOVE/kristal/saves/dark_place/", -- Source code version
        "kristal/saves/dark_place/",      -- Executable version
        "LOVE/dark_place/saves/",         -- Source code version but changed Kristal's id in conf.lua
        "dark_place/saves/",              -- Executable version but changed Kristal's id in conf.lua
    }

    for i=1,3 do
        --local path = os.getenv("APPDATA")
        local savefile
        for i,path in ipairs(paths) do
            savefile = GeneralUtils:openExternalJSONFile("Roaming/"..path.."file_"..i..".json")
            if savefile then break end
        end

        if savefile then

            for k,v in pairs(savefile.flags) do
                -- So turns out I did make a flag to check if the player met Jeku, I'm dumb
                -- But I already made all of this so fuck it we ball
                if k:find("shop#jeku_shop") or k == "meet_jeku" then
                    Mod.jeku_memory["first_meet_legacy"] = true
                    break
                end
            end

            break
        end
    end


    -- Did Jeku killed the player in Legacy?
    if Mod.jeku_memory["killed_in_legacy"] == nil then
        local ok = false
        for i=0,3 do
            ok = GeneralUtils:hasSaveFiles("dark_place", "ikilledyouoncedidn'ti_"..i)
            if ok then break end
        end
        Mod.jeku_memory["killed_in_legacy"] = ok
        -- If he did, that means they still met anyway, regardless of if first_meet_legacy is false
        if ok and Mod.jeku_memory["first_meet_legacy"] == false then
            Mod.jeku_memory["first_meet_legacy"] = true
        end
    end
end


saveJekuMemory()


-- You know what? Fuck you.
--
--   *Unhook your hook*
local function unhook(target, name)
    for i, hook in ipairs(Utils.__MOD_HOOKS) do
        if hook.target == target and hook.name == name then
            hook.target[hook.name] = hook.orig
            table.remove(Utils.__MOD_HOOKS, i)
            return true
        end
    end
end

function JekuShop:init()
    super.init(self)

    local function checkTimeLeft()
        local time = self:getFlag("jeku_left_time_left")
        if not time then return false end

        local elapsedTime = os.time() - time
        local sec_7days = 7 * (60 * 60 * 24)

        return elapsedTime >= sec_7days
    end

    -- Will be reimplemented later after the last Frozen Heart update
    -- Coming when Silksong releases
    --[[if Mod:hasSaveFiles("frozen_heart", "checkpass0") and (not checkTimeLeft() and not Mod:hasSaveFiles("frozen_heart", "checkpass1")) then
        Game:setFlag("meet_jeku_empt", true)
        self:initEmpty()
        self.empty = true
        if not self:getFlag("jeku_left_time_left") then
            self:setFlag("jeku_left_time_left", os.time())
        end
    else
        Game:setFlag("meet_jeku", true)
        if Game:getFlag("meet_jeku_empt") and not Game:getFlag("meet_jeku_back") then
            Game:setFlag("meet_jeku_back", true)
        end
        self:initJeku()
    end]]
    Game:setFlag("meet_jeku", true)
    Mod.jeku_memory["meet_jeku"] = true
    self:initJeku()

    self:registerItem("healitem")
    self:registerItem("makissyringe")
    self:registerItem("bin_weapon", {bonuses = {attack = 1010}})
    --self:registerItem("sfb_key", {stock=1})
    self:registerItem("duoplicate")

    self.background_asset = Assets.getTexture("shopkeepers/jeku/shop_bg")
    self.background_shader = love.graphics.newShader([[
        extern number bg_sine;
        extern number bg_mag;
        extern number wave_height;
        extern number sine_mul;
        extern vec2 texsize;
        vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
        {
            number i = texture_coords.y * texsize.y;
            number bg_minus = ((bg_mag * (i / wave_height)) * 1.3);
            number wave_mag = max(0.0, bg_mag - bg_minus);
            vec2 coords = vec2(max(0.0, min(1.0, texture_coords.x + (sine_mul * sin((i / 8.0) + (bg_sine / 30.0)) * wave_mag) / texsize.x)), max(0.0, min(1.0, texture_coords.y + 0.0)));
            return Texel(texture, coords) * color;
        }
    ]])
    self.animation_sine = 0

    self.fog_shader = Assets.newShader("fog")
    self.shader_bg = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    self.shader_bg:addFX(ShaderFX(self.fog_shader, {
        iTime = function() return Kristal.getTime() end
    }))
    self.shader_bg.alpha = 0.5
    self.shader_bg:setLayer(SHOP_LAYERS["shopkeeper"]-1000)
    self:addChild(self.shader_bg)

    self.bg_cover.visible = false

    self.background = ""
    self.shop_music = "exception"

    -- Don't mind me just visiting
    if Game:hasPartyMember("noel") then
        --self.noel_theme = Music("ticking", 0.5, 1):seek(self.music:tell()) -- might try agian in the future
        --self.shop_music
        self.noel = Sprite("face/noel/hey_jeku", 430, 100)
        self.noel:setScale(1.5)
        self.noel.layer = SHOP_LAYERS["shopkeeper"]
        self:addChild(self.noel)
        self.noel:addFX(OutlineFX())
        self.noel:getFX(OutlineFX):setColor(1, 1, 1)

        self.noel:addFX(OutlineFX())-- need to do this twice
        self.noel:getFX(OutlineFX):setColor(1, 1, 1)
    end

    self.bg_universes = {}
    self.link_lines = {}
end

function JekuShop:initJeku()
    self.encounter_text = "[emote:happy]* HE EH EH!! A PLAYER HAS FINALLY COME TO ME!!"
    if Mod.jeku_memory["remember_legacy"] and Mod.jeku_memory["welcomed_back_player"] == 0 then
        Mod.jeku_memory["welcomed_back_player"] = 1
        self.encounter_text = "[emote:happy]* YOU FOUND ME AGAIN, "..Game.save_name.."![emote:wink] HOW LONG HAS IT BEEN?"
    elseif Mod.jeku_memory["meet_jeku"] then
        self.encounter_text = "[emote:happy]* HE EH EH!! WELCOME BACK HERE, "..Game.save_name.."!!"
    end

    self.shop_text = "[emote:playful]* Eh he eh..."
    self.leaving_text = "[emote:wink_tongueout]* Back to play again, hah?\nEh he! Good luck, luck."
    -- Shown when you're in the BUY menu
    self.buy_menu_text = "[emote:wink]I CAN\nGIVE YOU\nSOME STUFF"
    -- Shown when you're about to buy something.
    self.buy_confirmation_text = "Buy it for\n%s ?"
    -- Shown when you refuse to buy something
    self.buy_refuse_text = "[emote:side]Too\nleveled up\nfor that?"
    -- Shown when you buy something
    self.buy_text = "[emote:happy]THANK YOU!!"
    -- Shown when you buy something and it goes in your storage
    self.buy_storage_text = "[emote:side]AS EXPECTED,\nIT VANISHED."
    -- Shown when you don't have enough money to buy something
    self.buy_too_expensive_text = "[emote:wink_tongueout]GO FARM MORE\nMONEY!!"
    -- Shown when you don't have enough space to buy something.
    self.buy_no_space_text = "[emote:side]Your inventory\nis full."
    -- Shown when something doesn't have a sell price
    self.sell_no_price_text = "[emote:happy]It doesn't have\na price value!!"
    -- Shown when you're in the SELL menu
    self.sell_menu_text = "[emote:side]You'd sell\nstuff to me?\nEh he he..."
    -- Shown when you try to sell an empty spot
    self.sell_nothing_text = "[emote:side]Your inventory\nis empty,\nplayer."
    -- Shown when you're about to sell something.
    self.sell_confirmation_text = "Sell it for\n%s ?"
    -- Shown when you refuse to sell something
    self.sell_refuse_text = "[emote:happy]SAD."
    -- Shown when you sell something
    self.sell_text = "[emote:happy]EH HE EH!!"
    -- Shown when you have nothing in a storage
    self.sell_no_storage_text = "[emote:happy]So empty,\nyour storage\nis."
    -- Shown when you enter the talk menu.
    self.talk_text = "[emote:playful]FINALLY,\nSOME\nDISCUSSION."

    self.sell_options_text["items"]   = "[emote:happy]I SELL MONEY!!"
    self.sell_options_text["weapons"] = "[emote:happy]I SELL MONEY!!"
    self.sell_options_text["armors"]  = "[emote:happy]I SELL MONEY!!"
    self.sell_options_text["storage"] = "[emote:happy]I SELL MONEY!!"

    --[[if Game:getFlag("meet_jeku_empt") and not self:getFlag("talk_came_back") and not Mod:hasSaveFiles("frozen_heart", "checkpass1") then
        self:registerTalk("Where were you")
    else
        self:registerTalk("Who are you")
    end
    self:registerTalk("This store")
    if love.math.random(1, 100) == 69 then
        self:registerTalk("Flirt") -- :D
    else
        self:registerTalk("Threaten")
    end
    if Game:getFlag("meet_jeku_empt") and not self:getFlag("talk_came_back") and Mod:hasSaveFiles("frozen_heart", "checkpass1") then
        self:registerTalk("The fight")
    else
        self:registerTalk("The Key")
    end]]

    if Mod.jeku_memory["remember_legacy"] and Mod.jeku_memory["welcomed_back_player"] < 2 then
        self:registerTalk("You know me?")
    else
        self:registerTalk("Who are you?")
        self:registerTalkAfter("What is true?", 1)
    end
    self:registerTalk("This shop")
    if love.math.random(1, 100) == 69 then
        self:registerTalk("Flirt") -- :D
    else
        self:registerTalk("Threaten")
    end
    self:registerTalk("Behind you")

    self.shopkeeper:setActor("jeku")
    self.shopkeeper:setScale(0.5)
    self.shopkeeper.sprite:setPosition(24, 50)
    self.shopkeeper.slide = true

    if Kristal.Shatter and Kristal.Shatter.active then
        self.jeku_sprites = {
            playful = love.graphics.newImage(Mod.info.path.."/assets/sprites/shopkeepers/jeku/playful.png"),
            crazy = love.graphics.newImage(Mod.info.path.."/assets/sprites/shopkeepers/jeku/crazy.png"),
            happy = love.graphics.newImage(Mod.info.path.."/assets/sprites/shopkeepers/jeku/happy.png"),
            insane = love.graphics.newImage(Mod.info.path.."/assets/sprites/shopkeepers/jeku/insane.png"),
            side = love.graphics.newImage(Mod.info.path.."/assets/sprites/shopkeepers/jeku/side.png"),
            wink = love.graphics.newImage(Mod.info.path.."/assets/sprites/shopkeepers/jeku/wink.png"),
            wink_tongueout = love.graphics.newImage(Mod.info.path.."/assets/sprites/shopkeepers/jeku/wink_tongueout.png"),
            surprised_side = love.graphics.newImage(Mod.info.path.."/assets/sprites/shopkeepers/jeku/surprised_side.png"),
        }
        --self.font = love.graphics.newFont("assets/fonts/main.ttf", 32)
        self.jeku_voice = love.audio.newSource(Mod.info.path.."/assets/sounds/voice/jeku.wav", "static")

        self.timer_pixel_check = 30*5
        self.pixel_judge = 0
    end

    self.voice = "jeku"
end

function JekuShop:initEmpty()
    self.encounter_text = "* There's no one here."
    self.shop_text = "* ..."
    self.buy_menu_text = "You look\nat the bubbles..."
    self.buy_refuse_text = self.buy_menu_text
    self.buy_text = "You took the item."
    self.buy_storage_text = self.buy_text

    self.menu_options[2] = {"Look", "LOOKAROUND"}
    self.menu_options[4] = {"Leave", "LEAVING"}

    self.bubbles = {
        Sprite("ui/shop/bubble_item", 35, 137),
        Sprite("ui/shop/bubble_ouchie", 145, 44),
        Sprite("ui/shop/bubble_binary", 399, 78),
        Sprite("ui/shop/bubble_key", 522, 127)
    }
    --[[if Kristal.Shatter and Kristal.Shatter.active then
        for i,bubble in ipairs(self.bubbles) do
            print(bubble.sprite, bubble.path)
            --bubble:setTexture(love.graphics.newImage(Mod.info.path.."/assets/sprites/"..bubble.sprite..".png"))
        end
    end]]

    self.bubbles_pos = {
        MAINMENU = {
            {35, 137},
            {145, 44},
            {399, 78},
            {522, 127}
        },
        BUYMENU = {
            {20, 142},
            {100, 34},
            {273, 32},
            {336, 124}
        }
    }

    self.bubbles_state = "MAINMENU"

    self.bubbles_y = {
        self.bubbles_pos[self.bubbles_state][1][2],
        self.bubbles_pos[self.bubbles_state][2][2],
        self.bubbles_pos[self.bubbles_state][3][2],
        self.bubbles_pos[self.bubbles_state][4][2],
    }
end

function JekuShop:onEnter()
    super.onEnter(self)

    self.timer:everyInstant(5, function()
        for i=1,10 do
            local rad = Utils.random(1, 3)
            local c = Ellipse(Utils.random(0, SCREEN_WIDTH), Utils.random(0, 240), rad, rad)
            c.alpha = 0
            c.timer = 0
            c:setPhysics({
                speed = Utils.random()*Utils.randomSign(),
                direction = math.rad(Utils.random(360)),
                friction = Utils.random()*0.01*Utils.randomSign()
            })
            c:setGraphics({
                grow = Utils.random()*0.001*Utils.randomSign()
            })
            c:setOrigin(0.5)
            c:setLayer(SHOP_LAYERS["background"]-1)
            Game.shop:addChild(c)
            table.insert(self.bg_universes, c)
        end
    end)
    self.timer:every(0.5, function()
        local uni1, uni2 = unpack(Utils.pickMultiple(self.bg_universes, 2))

        if not uni1 or not uni2 then return end

        local line_data = {
            universe1 = uni1,
            universe2 = uni2,

            timer = 0
        }
        table.insert(self.link_lines, line_data)
    end)

    if self.empty then
        Game.shop.music:setPitch(0.03)

        for i,b in ipairs(self.bubbles) do
            Game.shop:addChild(b)
            b:setScale(3)
        end
        if self.items[4].options["stock"] and self.items[4].options["stock"] <= 0 then
            self.bubbles[4].visible = false
        end
    else
        if self.noel and not Mod.jeku_memory["met_noel"] then
            Utils.hook(self, "onKeyPressed", function() end)
            Game.shop.timer:afterCond(function()
                return self.dialogue_text.state.current_node > #self.dialogue_text.nodes/2
            end,
            function()
                unhook(self, "onKeyPressed")
                Game.shop.music:pause()
                local savedData = Noel:loadNoel()

                local text = {
                    "[emote:surprised_side]* HOLD ON,[wait:1] WHO ARE YOU??",
                    "[voice:noel][speed:0.2]* ...Yo?",
                    "[speed:0.2]* ...",
                    "[emote:crazy]* OH I SEE WHO YOU ARE!! YOU WERE ALREADY IN THAT OTHER VERSION OF THIS WORLD!",
                    "[emote:playful]* YOU ARE THAT WEIRD GUY WHO EXISTS EVERYWHERE THAT APPEARED RECENTLY!![wait:3]\n* SO YOU'RE A PARTY MEMBER TOO??",
                    "[voice:noel]* You know who I am?",
                    "[emote:crazy]* YOU KNOW WHO [wait:5][color:blue]I[wait:5][color:reset] AM, DON'T YOU?",
                    "[voice:noel]* Not until I entered your shop right about now.",
                    "[emote:playful]* AWWWW...[wait:3] I thought you'd be the kind of character to know everything around here.",
                    "[emote:playful]* I saw you could even create textboxes,[wait:2] your power on this world is impressive for someone like you!",
                    "[voice:noel]* It's all in the name of the silly.",
                    "[emote:happy]* The silly?",
                    "[voice:noel]* If I can make a reference to a random popular game,[wait:2] I'll make it.",
                    "[emote:crazy]* HE EH HE...[wait:3] I SEE WHAT KIND OF CHARACTER YOU ARE NOW...",
                    "[voice:noel]* What the heck does that mean?",
                    "[emote:wink_tongueout]* ANYWAY, "..Game.save_name..", I'M SURE YOU'RE GETTING BORED OF ME![wait:3]\nI WOULDN'T WANT THAT.[wait:1] NO NO NO!!!",
                    "[voice:noel]* What do you mean,[wait:2] you see my character????"
                }
                -- I don't think Noel remembers the player's name for now?

                --if savedData.Player_Name ~= Game.save_name then
                --    table.insert(text, "[voice:noel]* Also aren't they called "..savedData.Player_Name.."??")
                --end

                self:startDialogue(text)
                Game.shop.timer:afterCond(function() return self.dialogue_text.line_index == 4 end, 
                function()
                    Game.shop.music:resume()
                end)
                Mod.jeku_memory["met_noel"] = true
            end)
        end
    end

    if self.noel then
        self.noel_theme = Music("ticking", 1, 0.873)
        self.noel_theme:seek(self.music:tell())
    end
end

function JekuShop:onRemoveFromStage(...)

    if self.noel_theme then
        Game.shop.noel_theme:remove()
    end
    saveJekuMemory()
    super.onRemoveFromStage(self, ...)
end

function JekuShop:update()
    super.update(self)
    if self.empty then
        self.bubbles[1].y = self.bubbles_y[1] + math.sin(Kristal.getTime()*2)*10
        self.bubbles[2].y = self.bubbles_y[2] + math.sin(Kristal.getTime()*4)*7
        self.bubbles[3].y = self.bubbles_y[3] + math.sin(Kristal.getTime()*5)*3
        self.bubbles[4].y = self.bubbles_y[4] + math.sin(Kristal.getTime()*3)*20

        for i,bubble in ipairs(self.bubbles) do
            bubble.x = Utils.approach(bubble.x, self.bubbles_pos[self.bubbles_state][i][1], 6 * DTMULT)
            self.bubbles_y[i] = Utils.approach(self.bubbles_y[i], self.bubbles_pos[self.bubbles_state][i][2], 6 * DTMULT)
        end
    end
end

function JekuShop:drawBackground()
    -- Draw a black backdrop
    self.animation_sine = self.animation_sine + (2 * DTMULT)

    love.graphics.setColor(0, 0, 0, 1)

    love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

    for i=#self.bg_universes, 1, -1 do
        local universe = self.bg_universes[i]

        universe.timer = universe.timer + DTMULT
        if universe.timer <= 300 then
            universe.timer = universe.timer - 0.1 * DTMULT
            universe.alpha = Utils.lerp(0, 1, universe.timer/300)
        elseif universe.timer >= 1000 then
            universe.alpha = Utils.approach(universe.alpha, 0, 0.125*DTMULT)
            if universe.alpha <= 0 then
                universe:remove()
                table.remove(self.bg_universes, i)
            end
        end
    end

    for i=#self.link_lines, 1, -1 do
        local link = self.link_lines[i]

        if link.universe1.parent == nil or link.universe2.parent == nil then
            table.remove(self.link_lines, i)
            goto skip
        end

        link.timer = link.timer + DTMULT

        local alpha = Utils.clamp(link.universe2.alpha+link.universe1.alpha, 0, 1)
        love.graphics.setColor(1, 1, 1, alpha)

        if link.timer > 100 and link.timer < 200 then
            love.graphics.line(link.universe1.x, link.universe1.y, link.universe2.x, link.universe2.y)
        elseif link.timer >= 200 then
            local timer = Utils.clamp((link.timer-200), 0, 100)
            local x = Utils.lerp(link.universe2.x, link.universe1.x, 1-timer/100)
            local y = Utils.lerp(link.universe2.y, link.universe1.y, 1-timer/100)
            love.graphics.line(link.universe2.x, link.universe2.y, x, y)
        elseif link.timer <= 100 then
            local x = Utils.lerp(link.universe1.x, link.universe2.x, link.timer/100)
            local y = Utils.lerp(link.universe1.y, link.universe2.y, link.timer/100)
            love.graphics.line(link.universe1.x, link.universe1.y, x, y)
        end

        if link.timer >= 310 then
            table.remove(self.link_lines, i)
        end
        ::skip::
    end

    -- Set the shader to use
    love.graphics.setShader(self.background_shader)
    self.background_shader:send("bg_sine", self.animation_sine)
    self.background_shader:send("bg_mag", 6)
    self.background_shader:send("wave_height", 240)
    self.background_shader:send("texsize", {self.background_asset:getWidth(), self.background_asset:getHeight()})

    self.background_shader:send("sine_mul", 20)
    love.graphics.setColor(1, 1, 1, 1 * 0.8)
    love.graphics.draw(self.background_asset, 0, 20)
    self.background_shader:send("sine_mul", -20)
    love.graphics.draw(self.background_asset, 0, 20)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setShader()
end

function JekuShop:startTalk(talk)
    if talk == "Who are you?" then
        self:startDialogue({
            "[emote:happy]* EH HE EH!![wait:5] I WAS EXPECTING THIS QUESTION!!",
            "[emote:side]* I am but a simple character.[wait:5] More precisely: a roleplay character.",
            "[emote:playful]* I was made to play a little game.[wait:5] A game of murders and trials.[wait:5] A game of \"Vivants\" and \"Tueurs\". A game made of characters controlled by players...[wait:5] By [color:red]strings[color:reset].",
            "[emote:happy]* But the game got cancelled and the world made for it collapsed.[wait:5]\n* But I wasn't erased alongside everyone.",
            "[emote:playful]* I got out of it and discover that what I always believed to be true was in fact[wait:1] true![wait:5] Eh he eh!",
        })
    elseif talk == "You know me?" then
        Game.shop:setFlag("talk_1", false)
        self:replaceTalk("Who are you?", 1, COLORS.white)
        self:registerTalkAfter("What is true?", 1)
        Mod.jeku_memory["welcomed_back_player"] = 2
        self:startDialogue({
            "[emote:playful]* Of course I know you![wait:5] You didn't already forget about me,[wait:2] didja?",
            "[emote:happy]* I was already there in [color:#000050]that other version of this world[color:reset]![wait:5] Before you abandoned it!",
            "[emote:crazy]* You know,[wait:2] it can hurt to just leave behind a world to rot,[wait:2] especially one as unstable as that place!",
            "[emote:wink_tongueout]* But oh well,[wait:2] that's just how it goes for fictionnal worlds,[wait:2] doesn't it?[wait:5]\n* It's not like we wouldn't do the same with our own fiction.",
            "[emote:crazy]* So "..Utils.titleCase(Game.save_name)..",[wait:2] tell me...[wait:5] What is the purpose of THIS world now?",
            "* And will you let it fall into darkness too?"
        })
    elseif talk == "What is true?" then
        self:startDialogue({
            "[emote:side]* I knew you would be interested.",
            "[emote:happy]* As simply as it is:[wait:5]\n[emote:crazy]THIS WORLD DOESN'T EXIST!! NOTHING DOES!!!",
            "[emote:crazy]* We are nothing but characters controlled by strings.[wait:5] You,[wait:2] me,[wait:2] everyone!!",
            "[emote:wink_tongueout]* But we are not alone.[wait:5] There are so many worlds.[wait:5] So many universes.[wait:5] So many people that ignores EVERYTHING!",
            "[emote:crazy]* I've tried my best to tell people the truth of this world.[wait:5] Most of those that listened however went INSANE because of it.[wait:5] EH HE HE!!",
            "[emote:happy]* ...[wait:10]Hm?[wait:5] Jevil?[wait:5] Spamton?",
            "[emote:playful]* Ooooooh right.[wait:5] They are secret bosses in your world, right?",
            "[emote:side]* As a matter of fact,[wait:2] I am inspired by the secret bosses of your world.[wait:5] So I never met them before.",
            "[emote:crazy]* I wonder if the person that made them go insane are as aware as I am...[wait:5] Eh he eh..."
        })
    elseif talk == "This shop" then
        if Kristal.Shatter and Kristal.Shatter.active then
            if not self.orig_kristal_keys then
                local wtf = "NOTHING MAKES ANY SENSE![wait:3]"
                local shop = "NOT EVEN MY OWN SHOP MAKES SENSE![wait:3]"
                if Kristal.Config["shatter/sounds"] then
                    wtf = wtf.." EVERYONE'S VOICE IS DIFFERENT!"
                end
                if Kristal.Config["shatter/textures"] then
                    wtf = wtf.."[wait:3] WHEN I INVOKE A THING, IT DOESN'T LOOK THE SAME,[wait:2] NOT EVEN YOUR PARTY MEMBERS MAKES ANY SENSE!!!"
                    shop = shop.."\n* WHERE DID MY BACKGROUND GO??[wait:3]\n* WHAT HAPPENED TO THE INTERFACE??"
                end
                if Kristal.Config["shatter/music"] then
                    shop = shop.."[wait:3]\n* WHAT IS THIS MELODY??"
                end
                self:startDialogue({
                    "[emote:side]* Whatever my creator touches, I can manifest in it.",
                    "[emote:happy]* Maybe he takes it as a curse? I take it as a wild ride around the universes, eh he he.",
                    "[emote:side]* I think this place is...[wait:5] Well...",
                    "[emote:crazy]* THIS PLACE IS EVEN FUNNIER NOW!!",
                    "[emote:crazy]* "..wtf,
                    "[emote:crazy]* "..shop,
                    "[emote:playful]* EH HE HE!!![wait:3]\n* I knew you guys loved messing with our worlds but to this level is a first to me!!",
                    "[emote:happy]* Normally, when assets get messed up, that's because the world is dying.[wait:3][emote:side] But here?[wait:3] [emote:crazy]It's completely unstable in a stable way!",
                    "[emote:side][speed:0.1]* ...",
                }, "CHECKCONSOLE")
            else
                self:startDialogue({
                    "[emote:happy]* What? Wanted me to loop my dialogue?",
                    "[emote:happy][speed:0.3]* ...[speed:1][emote:side]Nah.",
                    "[emote:playful]* Maybe later, though. I don't get bored of saying the same things over and over!",
                    "[emote:side]* Maybe I was truly made to be an NPC."
                })
            end
        else
            self:startDialogue({
                "[emote:side]* Whatever my creator touches, I can manifest in it.",
                "[emote:happy]* Maybe he takes it as a curse? I take it as a wild ride around the universes, eh he he.",
                "[emote:wink]* I think this place is FUN.",
                "[emote:happy]* Everything here at its very core is made piece by piece by multiple people. And it continues to evolve.",
                "[emote:happy]* Such an interesting place I landed in. Why would I interrupt it??",
                "[emote:crazy]* I could pull the strings down, erase this world, destroy everything...",
                "[emote:wink_tongueout]* But why would I do that? Your narrator doesn't even seem evil!",
                "[emote:playful]* So I build this shop.",
                "[emote:side]* And by build, I mean forcing this \"[color:#00ffff]Kristal[color:reset]\" engine to recognize me as a shop NPC.",
                "[emote:happy]* I figured it was the best way to interact with you, "..Utils.titleCase(Game.save_name)..". As you need items for future bosses that might appear here.",
                "[emote:wink]* And talking to shopkeepers is more interesting than talking to a random NPC on the map, I am right?",
                "[emote:crazy]* EH HE HE! IT IS BUT SO EASY TO UNDERSTAND!"
            })
        end
    elseif talk == "post_console" then
        if not self.shatter_still_install then
            self:startDialogue({
                "[emote:side]* ...",
                "[emote:side]* I am not sure what you did, [emote:wink_tongueout]but don't make me believe you're not behind all of this.",
                "[emote:crazy]* IN ANY CASE, I ADMIRE YOUR DEDICATION TO TRY EVERYTHING POSSIBLE!! EH HE HE!",
            })
        else
            self:startDialogue({
                "[emote:side]* So [color:#7000FF]that[color:reset]'s what breaking it,[wait:1] huh?[wait:2] How funny.",
                "[emote:wink_tongueout]* As always,[wait:1] you impress me,[wait:1] "..Utils.titleCase(Game.save_name)..".",
                "[emote:crazy]* Well you and every other guy I've met in my indecive lifetime that is!"
            })
        end
    elseif talk == "Threaten" then
        if Mod.jeku_memory["killed"] then
            if Mod.jeku_memory["killed_in_legacy"] then
                if Mod.jeku_memory["skipped_death"] then
                    self:startDialogue({
                        "[emote:crazy]* EH HE EH HE HE!!",
                        "[emote:crazy]* I'm sure you knew it was gonna happen![wait:5]\n* I already did this to you in the previous game!",
                        "[emote:side]* Seeing how fast you've loaded your save,[wait:2] I'm assuming you just wanted to do it just to say you've done it here.",
                        "[emote:happy]* Then go on,[wait:2] "..Utils.titleCase(Game.save_name).."![wait:5] What's the next mighty step to take back the legacy you left behind?"
                    })
                else
                    self:startDialogue({
                        "[emote:crazy]* EH HE EH HE HE!!",
                        "[emote:crazy]* I'm sure you knew it was gonna happen![wait:5]\n* I already did this to you in the previous game!",
                        "[emote:happy]* Did you perhaps think I would do something else?[wait:5] Or did you just want to do it again to say you did it in this \"reboot\"?",
                        "[emote:playful]* People like you never stop being entertaining,[wait:2] "..Utils.titleCase(Game.save_name).."!"
                    })
                end
            elseif Mod.jeku_memory["skipped_death"] then
                self:startDialogue({
                    "[emote:crazy]* YOU ARE FUN TO PLAY WITH,[wait:2] "..Game.save_name.."!",
                    "[emote:wink_tongueout]* ARE YOU AGAINST THE TIME OR SOMETHING?",
                    "[emote:side]* Time is so important for people like you, eh he eh...",
                    "[emote:crazy]* Ever wondered how many things you missed by rushing whatever you're doing?"
                })
            else
                self:startDialogue({
                    "[emote:wink_tongueout]* I take it that it amused you?"
                })
            end
        else
            if self:getFlag("threaten_jeku", 0) == 0 then
                self.music:pause()
                self:startDialogue({
                    "[emote:side][speed:0.5]* ...",
                    "[emote:crazy]* EH HE EH!![wait:3] EH HE EH HE HE HE EH!!!",
                    "[emote:crazy]* YOU ARE HILARIOUS "..Game.save_name..".",
                    "[emote:wink_tongueout]* YOU THINK YOU CAN HURT ME?[wait:3] THINK YOU CAN START A BATTLE HERE??[wait:2] IN THE SHOP INTERFACE?",
                    "[emote:side]* No.[wait:5][emote:crazy] NO YOU CAN'T!!",
                    "[noskip][voice:none][emote:insane]* ME,[wait:1] ON THE OTHER HAND..."
                })
            elseif self:getFlag("threaten_jeku") == 5 then
                self.music:stop()
                self:startDialogue({
                    "[noskip][voice:none][emote:insane][speed:0.5]* ...[wait:10]"
                })
            else
                self:startDialogue({
                    "[emote:side][speed:0.5]* ..."
                })
            end
            self:addFlag("threaten_jeku", 1)
        end
    elseif talk == "Flirt" then
        self:replaceTalk("Threaten", 3, COLORS.white)
        self:startDialogue({
            "[emote:side][speed:0.5]* ...",
            "[emote:crazy]* EH HE EH!![wait:3] EH HE EH HE HE HE EH!!!",
            "[emote:crazy]* YOU ARE HILARIOUS "..Game.save_name..".",
            "[emote:happy]* I HAVE FRIENDS WHO ALSO LOVES TO DO THIS TYPE OF STUFF TO ANYONE THEY MEET!",
            "[emote:crazy]* WELL I GUESS ONE OF THEM'S A BIT MORE...[wait:5] EXTREME ABOUT IT...",
            "[emote:playful]* MAYBE YOU WOULD GO ALONG WELL?",
            "[emote:side]* As a matter of fact,[wait:5] I am selling one of the syringe she gave me before I arrived here.",
            "[emote:wink_tongueout]* I can tell her if you bought it or not!"
        })
    elseif talk == "Behind you" then
        self:startDialogue({
            "[emote:happy]* Behind me?[wait:4] It's a small glimpse into the entire multiverse!!",
            "[emote:wink_tongueout]* And not just your world's multiverse, [wait:5][emote:crazy]THE ENTIRE FICTIONAL WORLD!",
            "[emote:side]* Well at least it's what it is on paper.[wait:3] I can't really just go into any world I want.",
            "[emote:crazy]* So I tend to create timelines of the worlds that interest me so I can experiment on them.",
            "[emote:playful]* I'm a huge fan of fighting the protagonists of those worlds![wait:3] Some are REALLY powerful!!",
            "[emote:crazy]* I could just delete them. But where's the fun in that?",
            "[emote:playful]* Isn't it better to actually have a challenge? To see how they adapt to me adapting reality? [emote:crazy]Would you want to fight me if I just killed you on the spot?",
            "[emote:crazy]* SHATTERING REALITY BEFORE THEIR EYES BEFORE DELETING EVERYTHING THEN RESTORING IT ALL JUST TO SEE THEIR CONFUSED FACE IS REALLY AMUSING,[wait:2] DON'T GET ME WRONG...",
            "[emote:side]* But it's only a short-time satisfaction.[wait:5] What's the point if I do that every time I fight someone?",
            "[emote:playful]* Being \"OP\" isn't really fun.[wait:3] You get bored after a while.[wait:3] Your adversaries too.[wait:3] It's just boring!",
            "[emote:crazy]* But when you start thinking a little,[wait:2] there's so many things you can do with powers like mine that can produce hilarious results!"
        })
    elseif talk == "The Key" then
        self:startDialogue({
            "[emote:happy]* When I wandered across universes,[wait:2] I fell upon a sad,[wait:2] sad one.",
            "[emote:happy]* One of the characters was already aware of the TRUTH,[wait:2] but did everything in her power to take control of her game.",
            "[emote:side]* She succeded,[wait:2] but her game was extremely corrupted due to its age and her actions.",
            "[emote:playful]* It seems that at some point,[wait:2] the save data was about to die and so she did everything she wanted with the one she loved.",
            "[emote:side]* And then everything died.[wait:5]\nThe save.[wait:5]\nThe girl.[wait:5]\nHer feelings.",
            "[emote:crazy]* How sad.[wait:5] Do you guys love to torture us that much?[wait:3] Eh he eh!",
            "[emote:happy]* You have a saying for this, no?[wait:5]\nThe more you love a fictionnal character,[wait:2] the more pain you're going to make them go through, right?",
            "[emote:playful]* In any case, I wondered... What would happened if someone could get the girl out of her game?",
            "[emote:side]* I can't save the original her,[wait:2] but I can create a timeline and manipulate it to my will.",
            "[emote:happy]* That key is the direct access to that timeline.[wait:5] Do you feel like [color:yellow]taking the challenge[color:reset]?",
            "[emote:wink]* The game is pretty unstable so be aware.[wait:5] But if you succeed...[wait:3] Eh he eh...",
            "[emote:wink_tongueout]* Maybe her skies will be forever blue again."
        })
    elseif talk == "The fight" then
        self:replaceTalk("The Key", 4, COLORS.white)
        self:setFlag("talk_came_back", true)
        self:startDialogue({
            "[emote:happy]* RIGHT!![wait:5] Right![wait:5] The fight!",
            "[emote:happy]*[speed:0.1] ...[wait:10][speed:1][emote:playful]What fight?",
            "[emote:wink_tongueout]* HE EH HE!![wait:5] Sorry, sorry![wait:5] How can I know about [color:yellow]something that doesn't exist yet[color:reset],[wait:2] right?",
            "[emote:crazy]* Truly absurb!![wait:5] Way more than me knowing that you talked to the me in another world.",
        })
    elseif talk == "Where were you" then
        -- I'll fix that later. It's not like you can see it in-game right now
        --self:replaceTalk("Who are you", 1, COLORS.white)
        --self:registerTalkAfter("What is true?", 1)
        self:setFlag("talk_came_back", true)
        self:startDialogue({
            "[emote:happy]* Who??[wait:5] Me??[wait:5]\n[emote:crazy]* I HAVE NO IDEA WHAT YOU ARE TALKING ABOUT!!",
            "[emote:wink_tongueout]* Why should I tell you where I was when you didn't even find me!",
            "[emote:side]* Hmm...[wait:5] Well perhaps I shouldn't have hid myself in a default mod...",
            "[emote:happy]* Do you even know how to use a console?"
        })
    end
end

function JekuShop:onStateChange(old, new)
    super.onStateChange(self, old, new)
    if self.empty then
        if self.bubbles_pos[new] then
            self.bubbles_state = new
        end

        if new == "TALKMENU" then
            message = love.math.random(1, 100)
            if message >= 35 then
                self:startDialogue("* Who are you talking to?", function() self:setState("MAINMENU") return true end)
            elseif message >= 5 then
                self:startDialogue("* Don't be so silly!", function() self:setState("MAINMENU") return true end)
            else
                self:startDialogue("* You are now talking with the\n\n             equator", function() self:setState("MAINMENU") return true end)
            end
        elseif new == "LOOKAROUND" then
            self:startDialogue({
            "* (You look around the place.)",
            "* (You never realized that it never had any walls or ceilling...[wait:5] Neither a floor,[wait:2] for that matter.)",
            "* (And whatever's in the background,[wait:2] you really don't feel like approaching it.)",
            "* (But you see those weird bubbles around you,[wait:2] each containing an item.)",
            Game:getFlag("meet_jeku") and "* (Those are the items Jeku used to sell.)" or "* (Maybe you can do something with them?)"
            }, function() self:setState("MAINMENU") return true end)
        end
    else
        if old == "DIALOGUE" and new == "TALKMENU" then
            if self:getFlag("threaten_jeku") == 6 then
                Mod.jeku_memory["killed"] = true
                self:remove()
                Game.world:remove()
                Game.state = "GAMEOVER"
                Kristal.hideBorder(0)
                self:setFlag("threaten_jeku", 10)
                Kristal.callEvent("completeAchievement", "jekukilled")
                Game.stage:addChild(JekuGameOver(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, "EH HE EH HE!![wait:5]\nHAPPY NOW??"))
                return
            end
            if not self.music:isPlaying() then
                self.music:resume()
            end
        elseif new == "CHECKCONSOLE" then
            self.console_timer = 0
            if not self.orig_kristal_keys then
                self.orig_kristal_keys = Kristal.onKeyPressed
                self.orig_textinput_keys = TextInput.onKeyPressed
                Kristal.panic_reset = 0
                Utils.hook(love, "keypressed", function(orig, love, key, scancode, is_repeat)
                    if key == 'r' and not is_repeat then
                        Kristal.panic_reset = Kristal.panic_reset + 1
                        if Kristal.panic_reset > 5 then
                            -- tries to close the console
                            Kristal.Console:close()
                            -- reset everything making this monstruosity work
                            self.orig_kristal_keys = nil
                            self.orig_textinput_keys = nil
                            self.console_timer = nil
                            Kristal.panic_reset = nil
                            unhook(love, "keypressed")
                            Kristal.quickReload("temp")
                        end
                    else
                        Kristal.panic_reset = 0
                    end
                    --orig(love, key, scancode, is_repeat)
                end)
            end
        end
        if old == "CHECKCONSOLE" then
            self.console_timer = nil
            --self.orig_kristal_keys = nil
            self.orig_textinput_keys = nil
            self.console_timer = nil
            Kristal.panic_reset = nil
            TextInput.clear()
            TextInput.updateInput(self.old_input)
            unhook(love, "keypressed")
        end
    end
end

function JekuShop:buyItem(current_item)
    if not self.empty or (self.empty and self:getFlag("empty_dial_buy")) then
        super.buyItem(self, current_item)
    else
        if (current_item.options["price"] or 0) > self:getMoney() then
            self:startDialogue({
                "* (You raised you hand to the bubble and try to take the item inside of it.)",
                "* (Unsurprisingly, your hand can't enter the bubble.)",
                "* (You thought about taking the bubble with you but it wouldn't have any use at all.)"
            }, function()
                self:setState("BUYMENU", "DIALOGUE")
                self:setRightText(self.buy_too_expensive_text)
                return true
            end)
        else

            local new_item = Registry.createItem(current_item.item.id)
            new_item:load(current_item.item:save())

            if Game.inventory:addItem(new_item) then
                self:removeMoney(current_item.options["price"] or 0)

                -- Decrement the stock
                if current_item.options["stock"] then
                    current_item.options["stock"] = current_item.options["stock"] - 1
                    self:setFlag(current_item.options["flag"], current_item.options["stock"])
                end

                self:startDialogue({
                    "* (You raised your hand to the bubble and try to take the item inside of it.)",
                    "* (Unsurprisingly,[wait:2] your hand can't enter the bubble.)",
                    "* (You decide to take "..(current_item.options["price"] or 0).." D$ out of your pocket and try again,[wait:2] this time with the money in your hand.",
                    "* (Your hand succesfully enter the bubble.)",
                    "* (You let go of the money and grab the item inside.[wait:5]\nThe money evaporates instantly as you take your hand out of the bubble.)",
                    (current_item.options["stock"] and current_item.options["stock"] <= 0) and "* (You look at the bubble,[wait:2] but it seems that it has disappeared.)" or "* (You look at the bubble...[wait:3] It seems that a new item has appeared inside.)"
                }, function()
                    Assets.playSound("locker")
                    self:setState("BUYMENU", "DIALOGUE")

                    if self.items[4].options["stock"] and self.items[4].options["stock"] <= 0 then
                        self.bubbles[4].visible = false
                    end

                    local name = current_item.options["name"]
                    if name:find(" ") then
                        name = {
                            name:sub(1, name:find(" ")-1),
                            name:sub(name:find(" ")+1),
                        }
                    end

                    if type(name) == "string" then
                        self:setRightText("You got\nthe "..name..".")
                    else
                        self:setRightText("You got\nthe "..name[1].."\n"..name[2]..".")
                    end
                    self:setFlag("empty_dial_buy", true)
                    return true
                end)
            else
                self:startDialogue({
                    "* (You raised your hand to the bubble and try to take the item inside of it.)",
                    "* (Unsurprisingly,[wait:2] your hand can't enter the bubble.)",
                    "* (You decide to take "..(current_item.options["price"] or 0).." D$ out of your pocket and try again,[wait:2] this time with the money in your hand.",
                    "* (Your hand succesfully enter the bubble.)",
                    "* (You let go of the money and grab the item inside.[wait:5]\nThe money evaporates instantly as you take your hand out of the bubble.)",
                    "* (But then,[wait:3] horror and damnation,[wait:2] you realize your inventory is full.)",
                    "* (Feeling scammed,[wait:2] you throw the item in the void around you.)",
                    "* [speed:0.1](...)",
                    "* (And then you feel your money hole filling up.)"
                }, function()
                    self:setState("BUYMENU", "DIALOGUE")
                    self:setRightText(self.buy_no_space_text)
                    return true
                end)
            end
        end
    end
end

if Kristal.Shatter and Kristal.Shatter.active then
    function JekuShop:onEmote(emote)
        --self.shopkeeper:onEmote(self.jeku_sprites[emote])
        self.shopkeeper.sprite.texture = self.jeku_sprites[emote]
    end

    function JekuShop:leave()
        if self.shopkeeper.parent == Game.stage then
            self.shopkeeper:setParent(self)
        end
        super.leave(self)
    end

    function JekuShop:postInit()
        super.postInit(self)

        if not self.empty then
            local shop = self
            Utils.hook(self.dialogue_text, "playTextSound", function(orig, self, current_node)
                if self.state.skipping and (Input.down("cancel") or self.played_first_sound) then
                    return
                end

                if current_node.type ~= "character" then
                    return
                end

                local no_sound = { "\n", " ", "^", "!", ".", "?", ",", ":", "/", "\\", "|", "*" }

                if (Utils.containsValue(no_sound, current_node.character)) then
                    return
                end

                if (self.state.typing_sound ~= nil) and (self.state.typing_sound ~= "") then
                    self.played_first_sound = true
                    if Kristal.callEvent("onTextSound", self.state.typing_sound, current_node) then
                        return
                    end
                    shop.jeku_voice:play()
                end
            end)

            Utils.hook(self.right_text, "playTextSound", function(orig, self, current_node)
                if self.state.skipping and (Input.down("cancel") or self.played_first_sound) then
                    return
                end

                if current_node.type ~= "character" then
                    return
                end

                local no_sound = { "\n", " ", "^", "!", ".", "?", ",", ":", "/", "\\", "|", "*" }

                if (Utils.containsValue(no_sound, current_node.character)) then
                    return
                end

                if (self.state.typing_sound ~= nil) and (self.state.typing_sound ~= "") then
                    self.played_first_sound = true
                    if Kristal.callEvent("onTextSound", self.state.typing_sound, current_node) then
                        return
                    end
                    shop.jeku_voice:play()
                end
            end)

            local font = {default=32}
            font[font.default] = love.graphics.newFont("assets/fonts/main_mono.ttf", 32)
            Assets.data.fonts["jeku_unfased"] = font
            self.dialogue_text.font = "jeku_unfased"
            --self.right_text.font = "jeku_unfased"

            -- I feel like I'm making a giant mess to keep things organized
            -- As if this whole file wasn't a mess already
        
            Utils.hook(self, "update", function(orig, self)
                orig(self)

                if self.timer_pixel_check > 0 and Utils.containsValue({"crazy", "playful", "happy"}, self.shopkeeper.sprite.sprite) then
                    self.timer_pixel_check = self.timer_pixel_check - DTMULT

                    -- How horrible can that be?
                    if math.ceil(self.timer_pixel_check)%15 == 0 then
                        if not self.checked_pixel then
                            --print("Check pixel!")
                            local x = 286
                            if self.state == "BUYMENU" then
                                x = 250
                            end
                            local screen_pixel = Utils.rgbToHex({SCREEN_CANVAS:newImageData():getPixel(x, 155)})
                            local expected_pixel = "#E9E267"

                            --print(screen_pixel, expected_pixel)
                            if screen_pixel == expected_pixel then
                                --print("Color match up!")
                                self.pixel_judge = self.pixel_judge + 1
                            else
                                --print("Color don't match up.")
                                self.pixel_judge = self.pixel_judge - 2
                            end
                            --print("Balance: "..self.pixel_judge)
                            self.checked_pixel = true
                        end
                    elseif self.checked_pixel then
                        self.checked_pixel = false
                    end
                elseif self.timer_pixel_check > -5 then
                    --print("Finished.")
                    if self.pixel_judge <= 0 then
                        --print("Jeku is possibly below the corrupted UI")
                        self.shopkeeper:setParent(Game.stage)
                    end
                    self.timer_pixel_check = -math.huge
                end


                if self.console_timer then
                    self.console_timer = self.console_timer + DTMULT
                    if self.console_timer <= 10 then
                        self.console_timer = self.console_timer + 10
                        Kristal.Console:open()
                        self.old_input = TextInput.input
                        TextInput.clear()
                        love.keyboard.setTextInput(false)

                        self.possible_mods = {}

                        self.char = 0
                        self.prev_index = -1
                    elseif self.console_timer >= 40 and self.console_timer <= 150 then
                        local str = "= Kristal.Mods.getMod(\""

                        if self.console_timer%3 == 0 and self.char < #str then
                            self.char = self.char + 1
                            local current_char = str:sub(self.char, self.char)
                            TextInput.insertString(current_char)
                        end
                    elseif self.console_timer > 150 and self.console_timer < 9999 then
                        if #self.possible_mods == 0 then
                            if not self.loop_index then
                                self.shatter_still_install = false
                                for i,v in ipairs(Kristal.Mods.getMods()) do
                                    if v.name == "shatter" then
                                        self.shatter_still_install = true
                                    else
                                        table.insert(self.possible_mods, {
                                            name = v.id,
                                            fake_chunk = Utils.dump(v):sub(1, 90) --Approximatively the number of character that can appear in the console history
                                        })
                                    end
                                end
                                self.loop_index = 0
                            elseif self.loop_index > 0 then
                                TextInput.clear()
                                if self.shatter_still_install then
                                    TextInput.insertString("= Kristal.Mods.getMod(\"shatter\")")
                                else
                                    self.char = 0
                                    self.sentence_step = 1
                                    self:onEmote("insane")
                                end
                                self.console_timer = 9999
                            end
                        else
                            if self.console_timer%1 == 0 then
                                TextInput.clear()
                                local i_choices = {}
                                for i = 1,#self.possible_mods do
                                    if i ~= self.prev_index or #self.possible_mods <= 2 then
                                        table.insert(i_choices, i)
                                    end
                                end
                                local index = Utils.pick(i_choices)
                                self.prev_index = index
                                TextInput.insertString("= Kristal.Mods.getMod(\""..self.possible_mods[index].name.."\")")
                                if self.loop_index%(#self.possible_mods>=10 and 5 or 15) == 0 then
                                    table.remove(self.possible_mods, index)
                                end
                                self.loop_index = self.loop_index + 1
                            end
                        end
                    elseif self.console_timer >= 9999+100 then
                        if self.shatter_still_install then
                            TextInput.clear()
                            Kristal.Console:push("[color:gray]> = Kristal.Mods.getMod(\"shatter\")")
                            Kristal.Console:push(Utils.dump(Kristal.Mods.getMod("shatter")):sub(1, 90))
                            self.console_timer = -math.huge
                            self.timer:after(3, function()
                                Kristal.Console:close()
                                self:startTalk("post_console", "TALKMENU")
                            end)
                        else
                            if self.console_timer >= 9999+150 then
                                local str = self.sentence_step == 1 and "Where is it?" or "You always know how to amuse me "..Utils.titleCase(Game.save_name).."."
                                if self.console_timer%5==0 then 
                                    if TextInput.input[1] == "Where is it?" then TextInput.clear() end
                                    if self.char < #str then
                                        self.char = self.char + 1
                                        local current_char = str:sub(self.char, self.char)
                                        TextInput.insertString(current_char)
                                    else
                                        self.sentence_step = self.sentence_step + 1
                                        if self.sentence_step == 2 then
                                            self.console_timer = 9999+101
                                            self.char = 0
                                        else
                                            self.console_timer = -math.huge
                                            self.timer:after(3, function()
                                                Kristal.Console:close()
                                                self:startTalk("post_console", "TALKMENU")
                                            end)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end

return JekuShop
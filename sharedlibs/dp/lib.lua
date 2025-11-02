local lib = {}

Registry.registerGlobal("DP", lib)
DP = lib

function lib:init()
    self:loadHooks()
    self:initTaunt()
    self:initBattleTaunt()
end

function lib:postInit(new_file)
    if not new_file then
        self:checkSaveStatus()
    end

    local date = os.date("*t")
    if date.month == 10 then
        Game.stage.timer:every(date.day == 31 and 30 or 60, self.tryForFunnySkeletonVideo)
    end
end

function lib:checkSaveStatus()
    local brenda = Game:getPartyMember("brenda")
    if not brenda:hasSpell("multiflare") then
        brenda:removeSpell("gammabeam")
        brenda:addSpell("multiflare")
        brenda:addSpell("powderkeg")
        print("[DP Lib] WARNING: Brenda does not have MultiFlare. Giving starting spells and removing GammaBeam. Save is likely from before her new spells were added.")
    end
end

function lib:onRegistered()
    ---@type table<string, CodeBlock>
    self.codeblocks = {}

    for _,path,block in Registry.iterScripts("codeblocks", true) do
        assert(block ~= nil, '"codeblocks/'..path..'.lua" does not return value')
        block.id = block.id or path
        self.codeblocks[block.id] = block
    end
end

---@generic T
---@param id CodeBlock.`T`
---@return T
function lib:createCodeblock(id, data)
    local block = self.codeblocks[id]()
    if data then
        block:load(data)
    end
    return block
end

function lib:onPause()
    if Game.tutorial then
        PauseLib.paused = false
        Assets.playSound("ui_cant_select",1.5)
    end
end

function lib:save(data)
    if not MagicalGlassLib then
        data.magical_glass = self.mg_data_preserve
    end
end

function lib:load(data)
    if not MagicalGlassLib then
        self.mg_data_preserve = data.magical_glass
    end
    
    if data and data.name and string.upper(data.name) == "EUROPE" and tonumber(os.date("%m")) == 11 then
        love.event.quit("restart")
    end
end

function lib:preDraw()
    Assets.getShader("palette"):send("debug",DEBUG_RENDER and ((RUNTIME/0.3)%1>.5))
end

function lib:getSoulColor()
    local date = os.date("*t")
    if date.month == 4 and date.day == 1 then
        return unpack(COLORS.green)
    end
end

function lib:postUpdate()
    self:updateTaunt()
    self:updateBattleTaunt()

    if Game.save_name == "MERG" then
        for _, party in ipairs(Game.party) do
            if party.health > 1 then
                party.health = 1
            end
            if party.stats.health ~= 1 then
                party.stats.health = 1
            end
        end
        if Game.battle then
            Game.battle:targetAll()
            for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
                enemy.current_target = "ALL"
            end
        end
    end

    for _, badge in ipairs(Game:getBadgeStorage()) do
        badge:update(badge.equipped)
    end

end

function lib:addEventTime(time_added)
    for k,_ in pairs(Game:getFlag("PROMISES", {})) do
        Game:getFlag("PROMISES")[k] = Game:getFlag("PROMISES")[k] - time_added
    end
    self:checkPromises()
end

function lib:addPromise(promise, event_time)
    Game:getFlag("PROMISES")[promise] = event_time
end

function lib:checkPromises()
    -- Step 1: Convert to sortable array of {key, value}
    local sorted = {}
    for k, v in pairs(Game:getFlag("PROMISES")) do
        table.insert(sorted, {key = k, value = v})
    end

    -- Step 2: Sort by value (ascending)
    table.sort(sorted, function(a, b)
        return a.value < b.value
    end)

    local promises_to_fulfill = {}
    -- Step 3: Loop through sorted array
    for i, pair in ipairs(sorted) do
        if pair.value <= 0 then
            table.insert(promises_to_fulfill, pair.key)
        end
    end
    
    local nextPromise
    function nextPromise()
        local cutscene_id = table.remove(promises_to_fulfill, 1)
        if not cutscene_id then return end
        Game:getFlag("PROMISES")[cutscene_id] = nil
        local cutscene = Game.world:startCutscene("promises." .. cutscene_id)
        cutscene:after(nextPromise)
    end
    
    nextPromise()
end

function lib:rollShiny(id, force)
    if (not Game:getFlag("SHINY") or Game:getFlag("SHINY")[id] == nil) or force then
        local roller = love.math.random(1, 100)
        -- Kristal.Console:log(id .. ": " .. roller)
        if not Game:getFlag("SHINY") then
            Game:setFlag("SHINY", {})
        end
        -- "󰌠 󰸭 󰺾  󰘦 󰫿 "- Gaster (translates to "CROSS MY PENUMBRA GRAND CHASM")
        if roller == 66 then
            Game:getFlag("SHINY")[id] = true
        else
            Game:getFlag("SHINY")[id] = false
        end
    else
        Kristal.Console:log("Tried to roll shiny for " .. id .. ", but they were already rolled.")
    end
end

function lib:forceShiny(id, what)
    Game:getFlag("SHINY")[id] = (what ~= false)
end

function lib:loadHooks()
    if MagicalGlassLib then
        Utils.hook(LightEnemyBattler, "init", function(orig, self, actor, use_overlay)
            orig(self)
            self.service_mercy = 20
        end)
        Utils.hook(LightEnemyBattler, "registerMarcyAct", function(orig, self, name, description, party, tp, highlight, icons)
            if Game:getFlag("marcy_joined") then
                self:registerShortActFor("jamm", name, description, party, tp, highlight, icons)
                self.acts[#self.acts].color = {0, 1, 1}
            end
        end)
        Utils.hook(LightEnemyBattler, "registerShortMarcyAct", function(orig, self, name, description, party, tp, highlight, icons)
            if Game:getFlag("marcy_joined") then
                self:registerActFor("jamm", name, description, party, tp, highlight, icons)
                self.acts[#self.acts].color = {0, 1, 1}
            end
        end)
        Utils.hook(LightEnemyBattler, "onService", function(orig, self, spell) end)
        Utils.hook(LightEnemyBattler, "canService", function(orig, self, spell) return true end)
        
        Utils.hook(LightEncounter, "addEnemy", function(orig, self, enemy, x, y, ...) 
            local enemy_obj
            if type(enemy) == "string" then
                enemy_obj = MagicalGlassLib:createLightEnemy(enemy, ...)
            else
                enemy_obj = enemy
            end
            
            if enemy_obj.milestone and enemy_obj.experience > 0 then
                self.milestone = true
            end
            
            return orig(self, enemy, x, y, ...)
        end)

        Utils.hook(LightStatMenu, "draw", function(orig, self)
            love.graphics.setFont(self.font)
            Draw.setColor(PALETTE["world_text"])
            
            local party = Game.party[self.party_selecting]
            
            if self.state == "PARTYSELECT" then
                local function party_box_area()
                    local party_box = self.party_select_bg
                    love.graphics.rectangle("fill", party_box.x - 24, party_box.y - 24, party_box.width + 48, party_box.height + 48)
                end
                love.graphics.stencil(party_box_area, "replace", 1)
                love.graphics.setStencilTest("equal", 0)
            end
            
            if Game:getFlag("SHINY", {})[party.actor:getShinyID()] and not (Game.world and Game.world.map.dont_load_shiny) then
                Draw.setColor({235/255, 235/255, 130/255})
            end
            
            love.graphics.print("\"" .. party:getName() .. "\"", 4, 8)
            
            Draw.setColor(PALETTE["world_text"])
            
            if party:getLightStatText() and not party:getLightPortrait() then
                love.graphics.print(party:getLightStatText(), 172, 8)
            end
            
            local ox, oy = party.actor:getPortraitOffset()
            if party:getLightPortrait() then
                Draw.draw(Assets.getTexture(party:getLightPortrait()), 179 + ox, 7 + oy, 0, 2, 2)
            end

            if #Game.party > 1 then
                if self.state == "STATS" or self.state == "SPELLS" then
                    Draw.setColor(Game:getSoulColor())
                    Draw.draw(self.heart_sprite, 212, 124, 0, 2, 2)
                end
                
                Draw.setColor(PALETTE["world_text"])
                love.graphics.print("<                >", 162, 116)
            end

            Draw.setColor(PALETTE["world_text"])
            
            love.graphics.print(Kristal.getLibConfig("magical-glass", "light_level_name_short").."  "..party:getLightLV(), 4, 68)
            love.graphics.print("HP  "..party:getHealth().." / "..party:getStat("health"), 4, 100)

            if self.state == "STATS" then
                local exp_needed = math.max(0, party:getLightEXPNeeded(party:getLightLV() + 1) - party:getLightEXP())
            
                local at = party:getBaseStats()["attack"]
                local df = party:getBaseStats()["defense"]
                local mg = party:getBaseStats()["magic"]
                
                if self.undertale_stat_display then
                    at = at - 10
                    df = df - 10
                end

                local offset = 0
                if self.show_magic then
                    offset = 16
                    love.graphics.print("MG  ", 4, 228 - offset)
                    love.graphics.print(mg  .. " ("..party:getEquipmentBonus("magic")   .. ")", 44, 228 - offset) -- alinging the numbers with the rest of the stats
                end
                love.graphics.print("AT  "  .. at  .. " ("..party:getEquipmentBonus("attack")  .. ")", 4, 164 - offset)
                love.graphics.print("DF  "  .. df  .. " ("..party:getEquipmentBonus("defense") .. ")", 4, 196 - offset)
                
                if party.id ~= "pauling" then
                    love.graphics.print("EXP: " .. party:getLightEXP(), 172, 164)
                    love.graphics.print("NEXT: ".. exp_needed, 172, 196)
                else
                    love.graphics.print("MILESTONE", 172, 164)
                end
            
                local weapon_name = "None"
                local armor_name = "None"

                if party:getWeapon() then
                    weapon_name = party:getWeapon():getEquipDisplayName()
                end

                if party:getArmor(1) then
                    armor_name = party:getArmor(1):getEquipDisplayName()
                end
                
                love.graphics.print("WEAPON: "..weapon_name, 4, 256)
                love.graphics.print("ARMOR: "..armor_name, 4, 288)
            
                love.graphics.print(Game:getConfig("lightCurrency"):upper()..": "..Game.lw_money, 4, 328)
                if MagicalGlassLib.kills > 20 then
                    love.graphics.print("KILLS: "..MagicalGlassLib.kills, 172, 328)
                end
                
                if self.show_magic then
                    love.graphics.setFont(self.font_small)
                    if Input.usingGamepad() then
                        Draw.printAlign("PRESS    TO VIEW SPELLS", 150, 368, "center")
                        Draw.draw(Input.getTexture("confirm"), 100, 366)
                    else
                        Draw.printAlign("PRESS " .. Input.getText("confirm") .. " TO VIEW SPELLS", 150, 368, "center")
                    end
                end
            else
                local spells = self:getSpells()
                local spell_limit = self:getSpellLimit()
                
                love.graphics.setFont(self.font_small)
                Draw.setColor(PALETTE["world_gray"])
                love.graphics.print(Kristal.getLibConfig("magical-glass", "light_battle_tp_name"), 21, 138)
                
                love.graphics.setFont(self.font)
                Draw.setColor(PALETTE["world_text"])
                for i = self.scroll_y, math.min(#spells, self.scroll_y + (spell_limit - 1)) do
                    local spell = spells[i]
                    local offset = i - self.scroll_y
                    
                    love.graphics.print(tostring(spell:getTPCost(party)).."%", 20, 148 + offset * 32)
                    love.graphics.print(spell:getName(), 90, 148 + offset * 32)
                end
                
                Draw.setColor(Game:getSoulColor())
                if self.state == "SELECTINGSPELL" then
                    Draw.draw(self.heart_sprite, -4, 156 + 32 * (self.spell_selecting - self.scroll_y), 0, 2, 2)
                elseif self.state == "USINGSPELL" then
                    if self.option_selecting == 1 then
                        Draw.draw(self.heart_sprite, -4 + 32, 348, 0, 2, 2)
                    elseif self.option_selecting == 2 then
                        Draw.draw(self.heart_sprite, 206 - 32, 348, 0, 2, 2)
                    end
                end
                
                -- Draw scroll arrows if needed
                if #spells > spell_limit then
                    Draw.setColor(1, 1, 1)

                    -- Move the arrows up and down only if we're in the spell selection state
                    local sine_off = 0
                    if self.state == "SELECTINGSPELL" then
                        sine_off = math.sin((Kristal.getTime()*30)/12) * 3
                    end

                    if self.scroll_y > 1 then
                        -- up arrow
                        Draw.draw(self.arrow_sprite, 294 - 4, (148 + 25 - 3) - sine_off, 0, 1, -1)
                    end
                    if self.scroll_y + spell_limit <= #spells then
                        -- down arrow
                        Draw.draw(self.arrow_sprite, 294 - 4, (148 + (32 * spell_limit) - 19) + sine_off)
                    end
                end
                
                -- Draw scrollbar if needed (unless the spell limit is 2, in which case the scrollbar is too small)
                if self.state == "SELECTINGSPELL" and spell_limit > 2 and #spells > spell_limit then
                    local scrollbar_height = (spell_limit - 2) * 32 + 7
                    Draw.setColor(0.25, 0.25, 0.25)
                    love.graphics.rectangle("fill", 294, 148 + 30, 6, scrollbar_height)
                    local percent = (self.scroll_y - 1) / (#spells - spell_limit)
                    Draw.setColor(1, 1, 1)
                    love.graphics.rectangle("fill", 294, 148 + 30 + math.floor(percent * (scrollbar_height-6)), 6, 6)
                end
                
                if self.state == "PARTYSELECT" then
                    love.graphics.setStencilTest()
                    Draw.setColor(PALETTE["world_text"])
                    
                    local z = Mod.libs["moreparty"] and Kristal.getLibConfig("moreparty", "classic_mode") and 3 or 4
                    
                    Draw.printAlign("Use " .. spells[self.spell_selecting]:getName() .. " on", 150, 231 + (#Game.party > z and 18 or 56), "center")

                    for i,party in ipairs(Game.party) do
                        if i <= z then
                            love.graphics.print(party:getShortName(), 63 - (math.min(#Game.party,z) - 2) * 70 + (i - 1) * 122, 269 + (#Game.party > z and 18 or 56))
                        else
                            love.graphics.print(party:getShortName(), 63 - (math.min(#Game.party - z,z) - 2) * 70 + (i - 1 - z) * 122, 269 + 38 + (#Game.party > z and 18 or 56))
                        end
                    end

                    Draw.setColor(Game:getSoulColor())
                    for i,party in ipairs(Game.party) do
                        if i == self.party_selecting_spell then
                            if i <= z then
                                Draw.draw(self.heart_sprite, 39 - (math.min(#Game.party,z) - 2) * 70 + (i - 1) * 122, 277 + (#Game.party > z and 18 or 56), 0, 2, 2)
                            else
                                Draw.draw(self.heart_sprite, 39 - (math.min(#Game.party - z,z) - 2) * 70 + (i - 1 - z) * 122, 277 + 38 + (#Game.party > z and 18 or 56), 0, 2, 2)
                            end
                        end
                    end
                else
                    Draw.setColor(PALETTE["world_text"])
                    if self.state ~= "SPELLS" and not self:canCast(spells[self.spell_selecting]) then
                        Draw.setColor(PALETTE["world_gray"])
                    end
                    love.graphics.print("USE" , 20 + 32 , 340)
                    Draw.setColor(PALETTE["world_text"])
                    love.graphics.print("INFO", 230 - 32, 340)
                end
            end
            love.graphics.setFont(self.font)			
            local party = Game.party[self.party_selecting]
            
            Draw.setColor(COLORS.white)
        end)
    end
end


function lib:isTauntingAvaliable()
    if self.let_me_taunt then return true end
    if Game:isSpecialMode("PEPPINO") then return true end

    for _,party in ipairs(Game.party) do
        if party:checkArmor("pizza_toque") then return true end
    end

    return false
end

--Overworld taunt
function lib:initTaunt()
    self.taunt_lock_movement = false
    --[[
    Utils.hook(Actor, "init", function(orig, self)
        orig(self)
        self.taunt_sprites = {}
    end)
    --]]
    Utils.hook(Player, "isMovementEnabled",
        ---@overload fun(orig:function, self:Player) : boolean
        function(orig, self)
            return not self.taunt_lock_movement and orig(self)
        end
    )

end

function lib:updateTaunt()
    if not (OVERLAY_OPEN or TextInput.active)
        and self:isTauntingAvaliable()
        and Input.pressed("taunt", false)
        and not self.taunt_lock_movement
        and (Game.state == "OVERWORLD" and Game.world.state == "GAMEPLAY"
            and not Game.world:hasCutscene() and not Game.lock_movement)
    then
        local any_taunted = false

        for _,chara in ipairs(Game.stage:getObjects(Character)) do
            if not chara.actor or not chara.visible then goto continue end

            -- workaround due to actors being loaded first by registry
            local sprites = chara.actor.getTauntSprites and chara.actor:getTauntSprites() or chara.actor.taunt_sprites
            if not sprites or #sprites <= 0 then goto continue end

            any_taunted = true

            local shine = Sprite("effects/taunt", chara:getRelativePos(chara.width/2, chara.height/2))
            shine:setOrigin(0.5, 0.5)
            shine:setScale(1)
            chara.layer = chara.layer + 0.1
            shine.layer = chara.layer - 0.1
            Game.world:addChild(shine)

            chara.sprite:set(Utils.pick(sprites))
            shine:play(1/30, false, function()
                shine:remove()
                chara:resetSprite()
                chara.layer = chara.layer - 0.1
            end)

            ::continue::
        end

        if any_taunted then
            -- awesome workaround for run_anims
            Game.world.player:setState("WALK")
            Game.world.player.running = false
            for _, follower in ipairs(Game.world.followers) do
                if follower:getTarget() == Game.world.player and follower.state == "RUN" then
                    follower.state_manager:setState("WALK")
                    follower.running = false
                end
            end
            Game.world.player:resetFollowerHistory()

            self.taunt_lock_movement = true
            Game.world.timer:after(1/3, function()
                self.taunt_lock_movement = false
            end)

            Assets.playSound("taunt", 0.5, Utils.random(0.9, 1.1))
        end
    end
end

--Battle taunt
function lib:initBattleTaunt()
    self.taunt_cooldown = 0
    self.state_blacklist = {
        "DEFENDINGBEGIN",
        "DEFENDING", -- handled by the soul itself, so this is ignored
        "DEFENDINGEND",
        "ENEMYDIALOGUE",
        "ATTACKING",
        "ACTIONS",
        "ACTIONSDONE",
        "INTRO",
        "TRANSITION",
        "TRANSITIONOUT"
    }
end

function lib:updateBattleTaunt()
    if
        Game:isTauntingAvaliable()
        and Input.pressed("taunt", false)
        and self.taunt_cooldown == 0
        and (Game.state == "BATTLE" and not Game.battle:hasCutscene())
        and not Utils.containsValue(Game.state_blacklist, Game.battle.state)
        and not (OVERLAY_OPEN or TextInput.active)
    then
        self.taunt_cooldown = 2.1

        Assets.playSound("taunt", 0.5, Utils.random(0.9, 1.1))

        for _,chara in ipairs(Game.battle.party) do
            if not chara.actor or chara.is_down then goto continue end

            -- workaround due of actors being loaded first by registry
            local sprites = chara.actor.getTauntSprites and chara.actor:getTauntSprites() or chara.actor.taunt_sprites
            if not sprites or #sprites <= 0 then goto continue end

            local shine = Sprite("effects/taunt", chara:getRelativePos(chara.width/2, chara.height/2))
            shine:setOrigin(0.5, 0.5)
            shine:setScale(1)
            shine.layer = chara.layer - 0.1
            Game.battle:addChild(shine)

            chara:toggleOverlay(true)
            chara.overlay_sprite:setSprite(Utils.pick(sprites))
            shine:play(1/30, false, function()
                shine:remove()
                chara:toggleOverlay(false)
            end)

            ::continue::
        end

    end

    self.taunt_cooldown = Utils.approach(self.taunt_cooldown, 0, DT)
end

---@param world World
---@param name string
---@param data table
function lib:loadObject(world, name, data)
    if name:lower() == "voidglass" then
        return VoidGlass(data.x, data.y, {data.width, data.height, data.polygon}, data.properties["broken"])
    elseif name:lower() == "warpbin" then
        return WarpBin(data)
    elseif name:lower() == "superstar" then
        return SuperStar(data.x, data.y, data.width, data.height, data.properties)
    elseif name:lower() == "sprite" then
        local sprite = Sprite(data.properties["texture"], data.x, data.y)
        sprite:play(data.properties["speed"], true)
        sprite:setScale(data.properties["scalex"] or 2, data.properties["scaley"] or 2)
        sprite:setOrigin(data.properties["originx"] or 0, data.properties["originy"] or 0)
        return sprite
    end
end

function lib:onKeyPressed(key)
    if Game.state == "MINIGAME" then
        Game.minigame:onKeyPressed(key)
        return true
    end
end

function lib:shouldWeIncreaseTheRateAtWhichYouGainNightmaresOrNot()
    for _, party in ipairs(Game.party or {}) do
        if party:checkArmor("the_mushroom_hat_that_increases_the_rate_at_which_you_gain_nightmares") then
            return true
        end
    end
    return false
end

function lib.tryForFunnySkeletonVideo()
    local self = DP
    if self.funnyskeletonvideo and not self.funnyskeletonvideo:isPlaying() then
        self.funnyskeletonvideo:remove()
        self.funnyskeletonvideo = nil
        return false
    elseif self.sawfunnyskeleton and self.funnyskeletonvideo == nil then
        return false
    end

    if self.sawfunnyskeleton then return end
    if MathUtils.randomInt(0, 100) >= 15 then return end

    self.sawfunnyskeleton = true

    self.funnyskeletonvideo = Video("whatwasthat", false, 0, 0, 640, 480)
    self.funnyskeletonvideo.parallax_x, self.funnyskeletonvideo.parallax_y = 0, 0
    self.funnyskeletonvideo:addFX(ShaderFX(Assets.getShader("chromakey"), {
        ["keyColor"] = { 0.0, 1.0, 0.0, 1.0 }, -- Pure green (R=0, G=1, B=0)
        ["threshold"] = 0.4,         -- Adjust the threshold for green color tolerance
    }), 66)
    self.funnyskeletonvideo:play()
    Game.stage:addChild(self.funnyskeletonvideo)
end

return lib

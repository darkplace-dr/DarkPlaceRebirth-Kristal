local Lib = {}
Registry.registerGlobal("MagicalGlassLib", Lib)

function Lib:cleanup()
    MG_PALETTE               = nil
    MG_EVENT                 = nil
    MG_GAMEOVERS             = nil
    LIGHT_BATTLE_LAYERS      = nil
    LIGHT_SHOP_LAYERS        = nil
    
    Textbox.REACTION_X_BATTLE = ORIG_REACTION_X_BATTLE
    Textbox.REACTION_Y_BATTLE = ORIG_REACTION_Y_BATTLE
    ORIG_REACTION_X_BATTLE = nil
    ORIG_REACTION_Y_BATTLE = nil
end

function Lib:save(data)
    data.magical_glass = {}
    data.magical_glass["kills"] = Lib.kills
    data.magical_glass["serious_mode"] = Lib.serious_mode
    data.magical_glass["spare_color"] = Lib.spare_color
    data.magical_glass["save_level"] = Game.party[1] and Game.party[1]:getLightLV() or 0
    data.magical_glass["in_light_shop"] = Lib.in_light_shop
    data.magical_glass["last_shop_world_type"] = Lib.last_shop_world_type
    data.magical_glass["current_battle_system"] = Lib.current_battle_system
    data.magical_glass["random_encounter"] = Lib.random_encounter
    data.magical_glass["light_battle_shake_text"] = Lib.light_battle_shake_text
    data.magical_glass["rearrange_cell_calls"] = Lib.rearrange_cell_calls
    data.magical_glass["game_overs"] = Lib.game_overs
    MG_GAMEOVERS = 0
    
    data.calls = Game.world.calls
end

function Lib:load(data, new_file)
    data.magical_glass = data.magical_glass or {}
    Lib.kills = data.magical_glass["kills"] or 0
    Lib.serious_mode = data.magical_glass["serious_mode"] or false
    Lib.spare_color = data.magical_glass["spare_color"] or {COLORS.yellow, "YELLOW"}
    Lib.in_light_shop = data.magical_glass["in_light_shop"] or false
    Lib.last_shop_world_type = data.magical_glass["last_shop_world_type"]
    Lib.current_battle_system = data.magical_glass["current_battle_system"] or nil
    Lib.random_encounter = data.magical_glass["random_encounter"] or nil
    Lib.light_battle_shake_text = data.magical_glass["light_battle_shake_text"] or 0
    Lib.rearrange_cell_calls = data.magical_glass["rearrange_cell_calls"] or false
    Lib.game_overs = MG_GAMEOVERS_TEMP and (MG_GAMEOVERS_TEMP + MG_GAMEOVERS) or data.magical_glass["game_overs"] and (data.magical_glass["game_overs"] + MG_GAMEOVERS) or MG_GAMEOVERS or 0
    
    Game.world.calls = {}
    if data.calls then
        Game.world.calls = data.calls
    end
    
    if new_file then
        Lib.initialize_armor_conversion = true
        if not Kristal.getLibConfig("magical-glass", "item_conversion") then
            Game:setFlag("has_cell_phone", Kristal.getModOption("cell") ~= false)
        end
    else
        for _, party in pairs(Game.party_data) do
            -- Fixes a crash with existing saves
            if not party.lw_stats["magic"] then
                party.lw_stats["magic"] = 0
            end
            
            -- Fixes an issue with equipment for party members which were created after loading a save
            if party.mg_initialized == false then
                if Kristal.getLibConfig("magical-glass", "equipment_conversion") then
                    for i = 1, 2 do
                        if party.equipped.armor[i] and party.equipped.armor[i]:convertToLightEquip(party) == party.lw_armor_default then
                            party:setFlag("converted_light_armor", "light/bandage")
                            break
                        end
                    end
                end
                if Game:isLight() then
                    local last_weapon = party:getWeapon() and party:getWeapon().id or false
                    local last_armors = {party:getArmor(1) and party:getArmor(1).id or false, party:getArmor(2) and party:getArmor(2).id or false}
                    
                    party:setFlag("dark_weapon", last_weapon)
                    party:setFlag("dark_armors", last_armors)
                    
                    party:setWeapon(party.lw_weapon_default)
                    party:setArmor(1, party.lw_armor_default)
                    party:setArmor(2, nil)
                end
            end
        end
    end
    
    if Kristal.getLibConfig("magical-glass", "debug") then
        for item, _ in pairs(Registry.items) do
            local item = Registry.createItem(item)
            if item.type == "item" and #item:getShortName() > 11 then
                Kristal.Console:warn("The item \"" .. item.id .. "\" has beyond 11 characters in its short name")
            end 
        end
    end
end

function Lib:preInit()
    MG_GAMEOVERS = 0
    ORIG_REACTION_X_BATTLE = Textbox.REACTION_X_BATTLE
    ORIG_REACTION_Y_BATTLE = Textbox.REACTION_Y_BATTLE
    
    MG_PALETTE = {
        ["tension_maxtext"] = PALETTE["tension_maxtext"],
        ["tension_back"] = PALETTE["tension_back"],
        ["tension_decrease"] = PALETTE["tension_decrease"],
        ["tension_fill"] = PALETTE["tension_fill"],
        ["tension_max"] = PALETTE["tension_max"],
        ["tension_desc"] = PALETTE["tension_desc"],

        ["tension_maxtext_reduced"] = PALETTE["tension_maxtext_reduced"],
        ["tension_back_reduced"] = PALETTE["tension_back_reduced"],
        ["tension_decrease_reduced"] = PALETTE["tension_decrease_reduced"],
        ["tension_fill_reduced"] = PALETTE["tension_fill_reduced"],
        ["tension_max_reduced"] = PALETTE["tension_max_reduced"],
        ["tension_desc_reduced"] = PALETTE["tension_desc_reduced"],
        
        ["action_health_bg"] = COLORS.red,
        ["action_health"] = COLORS.lime,
        ["action_health_text"] = PALETTE["action_health_text"],
        ["battle_mercy_bg"] = PALETTE["battle_mercy_bg"],
        ["battle_mercy_text"] = PALETTE["battle_mercy_text"],
        
        ["gauge_outline"] = COLORS.black,
        ["gauge_bg"] = {64 / 255, 64 / 255, 64 / 255, 1},
        ["gauge_health"] = COLORS.lime,
        ["gauge_mercy"] = COLORS.yellow,
        
        ["pink_spare"] = {255 / 255, 187 / 255, 212 / 255, 1},
        
        ["player_health_bg"] = COLORS.red,
        ["player_health"] = COLORS.yellow,
        ["player_karma_health_bg"] = {192 / 255, 0, 0, 1},
        ["player_karma_health"] = COLORS.fuchsia,
        
        ["player_karma_health_bg_dark"] = PALETTE["action_health_bg"],
        ["player_karma_health_dark"] = {213 / 255, 53 / 255, 217 / 255, 1},
        
        ["player_text"] = COLORS.white,
        ["player_defending_text"] = COLORS.aqua,
        ["player_action_text"] = COLORS.yellow,
        ["player_down_text"] = COLORS.red,
        ["player_sleeping_text"] = COLORS.blue,
        ["player_karma_text"] = COLORS.fuchsia,
        
        ["light_world_dark_battle_color"] = COLORS.white,
        ["light_world_dark_battle_color_attackbar"] = COLORS.lime,
        ["light_world_dark_battle_color_attackbox"] = COLORS.red,
        ["light_world_dark_battle_color_damage_single"] = {1, 0.3, 0.3, 1},
    }
    
    MG_EVENT = {
        onLightBattleActionBegin = "onLightBattleActionBegin",
        onLightBattleActionEnd = "onLightBattleActionEnd",
        onLightBattleActionCommit = "onLightBattleActionCommit",
        onLightBattleActionUndo = "onLightBattleActionUndo",
        onLightBattleMenuSelect = "onLightBattleMenuSelect",
        onLightBattleMenuCancel = "onLightBattleMenuCancel",
        onLightBattleEnemySelect = "onLightBattleEnemySelect",
        onLightBattleEnemyCancel = "onLightBattleEnemyCancel",
        onLightBattlePartySelect = "onLightBattlePartySelect",
        onLightBattlePartyCancel = "onLightBattlePartyCancel",
        onLightActionSelect = "onLightActionSelect",
        
        onRegisterRandomEncounters = "onRegisterRandomEncounters",
        onRegisterLightEncounters = "onRegisterLightEncounters",
        onRegisterLightEnemies = "onRegisterLightEnemies",
        onRegisterLightWaves = "onRegisterLightWaves",
        onRegisterLightBullets = "onRegisterLightBullets",
        onRegisterLightShops = "onRegisterLightShops",
        onRegisterLightWorldBullets = "onRegisterLightWorldBullets",
        
        getMonsterSoul = "getMonsterSoul",
    }
    
    LIGHT_BATTLE_LAYERS = {
        ["bottom"]             = -1000,
        ["background"]         = -950,
        ["below_battlers"]     = -900,
        ["battlers"]           = -850,
        ["above_battlers"]     = -800, --┰-- -800
        ["below_ui"]           = -800, --┙
        ["ui"]                 = -700,
        ["above_ui"]           = -600, --┰-- -600
        ["below_arena"]        = -600, --┙
        ["arena"]              = -500,
        ["above_arena"]        = -400, --┰-- -400
        ["below_bullets"]      = -400, --┙
        ["bullets"]            = -300,
        ["above_bullets"]      = -200, --┰-- -200
        ["below_soul"]         = -200, --┙
        ["soul"]               = -150,
        ["above_soul"]         = -100, --┰-- -100
        ["below_arena_border"] = -100, --┙
        ["arena_border"]       = -50,
        ["above_arena_border"] = 0,
        ["damage_numbers"]     = 150,
        ["top"]                = 1000
    }
    
    LIGHT_SHOP_LAYERS = TableUtils.copy(SHOP_LAYERS, true)
end

function Lib:onRegistered()
    self.random_encounters = {}
    for _,path,rnd_enc in Registry.iterScripts("battle/randomencounters") do
        assert(rnd_enc ~= nil, '"randomencounters/' .. path .. '.lua" does not return value')
        rnd_enc.id = rnd_enc.id or path
        self.random_encounters[rnd_enc.id] = rnd_enc
    end
    Kristal.callEvent(MG_EVENT.onRegisterRandomEncounters)

    self.light_encounters = {}
    for _,path,light_enc in Registry.iterScripts("battle/lightencounters") do
        assert(light_enc ~= nil, '"lightencounters/' .. path .. '.lua" does not return value')
        light_enc.id = light_enc.id or path
        self.light_encounters[light_enc.id] = light_enc
    end
    Kristal.callEvent(MG_EVENT.onRegisterLightEncounters)

    self.light_enemies = {}
    for _,path,light_enemy in Registry.iterScripts("battle/lightenemies") do
        assert(light_enemy ~= nil, '"lightenemies/' .. path .. '.lua" does not return value')
        light_enemy.id = light_enemy.id or path
        self.light_enemies[light_enemy.id] = light_enemy
    end
    Kristal.callEvent(MG_EVENT.onRegisterLightEnemies)
    
    self.light_waves = {}
    for _,path,light_wave in Registry.iterScripts("battle/lightwaves") do
        assert(light_wave ~= nil, '"lightwaves/' .. path .. '.lua" does not return value')
        light_wave.id = light_wave.id or path
        self.light_waves[light_wave.id] = light_wave
    end
    Kristal.callEvent(MG_EVENT.onRegisterLightWaves)
    
    self.light_bullets = {}
    for _,path,light_bullet in Registry.iterScripts("battle/lightbullets") do
        assert(light_bullet ~= nil, '"lightbullets/' .. path .. '.lua" does not return value')
        light_bullet.id = light_bullet.id or path
        self.light_bullets[light_bullet.id] = light_bullet
    end
    Kristal.callEvent(MG_EVENT.onRegisterLightBullets)

    self.light_shops = {}
    for _,path,light_shop in Registry.iterScripts("lightshops") do
        assert(light_shop ~= nil, '"lightshops/' .. path .. '.lua" does not return value')
        light_shop.id = light_shop.id or path
        self.light_shops[light_shop.id] = light_shop
    end
    Kristal.callEvent(MG_EVENT.onRegisterLightShops)
    
    self.light_world_bullets = {}
    for _,path,light_world_bullet in Registry.iterScripts("world/lightbullets") do
        assert(light_world_bullet ~= nil, '"lightworldbullets/' .. path .. '.lua" does not return value')
        light_world_bullet.id = light_world_bullet.id or path
        self.light_world_bullets[light_world_bullet.id] = light_world_bullet
    end
    Kristal.callEvent(MG_EVENT.onRegisterLightWorldBullets)
end

function Lib:init()

    -- print("Loaded Magical Glass: Redux " .. self.info.version .. "!")
    
    -- Undertale Borders
    self.active_keys = {}
    self.flower_positions = {
        {34, 679},
        {94, 939},
        {269, 489},
        {0, 319},
        {209, 34},
        {1734, 0},
        {1829, 359},
        {1789, 709},
        {1584, 1049}
    }
    self.idle_time = RUNTIME * 1000
    self.idle = false



    self.encounters_enabled = false
    self.steps_until_encounter = nil
end

function Lib:onGameOver(x, y)
    if Game.state == "OVERWORLD" then
        for _, party in ipairs(Game.party) do
            if party:getHealth() > 0 then
                party:setHealth(0)
            end
        end
        Game.world:shakeCamera(0)
    end
    if Game.battle and Game.battle.light or Game:isLight() and Game.state ~= "BATTLE" then
        love.draw()
    end
    
    if Game.battle and Game.battle.encounter.invincible then
        Kristal.hideBorder(0)

        Game.state = "GAMEOVER"

        for _, child in ipairs(Game.stage.children) do
            child:remove()
        end

        Game.gameover = GameNotOver(x, y)
        Game.stage:addChild(Game.gameover)
        
        return true
    else
        MG_GAMEOVERS = MG_GAMEOVERS + 1
        
        -- Shows the game over message even when the party member is the main character
        local soul_party = Game:getSoulPartyMember()
        if soul_party:getForceGameOverMessage() then
            local party_clone = TableUtils.copy(soul_party, true)
            party_clone.temp = true
            Game:addPartyMember(party_clone)
        end
    end
end

function Lib:getActionButtons(battler, buttons)
    if TableUtils.contains(buttons, "spare") then
        local index = TableUtils.getIndex(buttons, "spare")
        table.remove(buttons, index)
        table.insert(buttons, index, FleeButton(false))
    end
end

function Lib:registerRandomEncounter(id, class)
    self.random_encounters[id] = class
end

function Lib:getRandomEncounter(id)
    return self.random_encounters[id]
end

function Lib:createRandomEncounter(id, ...)
    if self.random_encounters[id] then
        return self.random_encounters[id](...)
    else
        error("Attempted to create non-existent random encounter \"" .. tostring(id) .. "\"")
    end
end

function Lib:registerLightEncounter(id, class)
    self.light_encounters[id] = class
end

function Lib:getLightEncounter(id)
    return self.light_encounters[id]
end

function Lib:createLightEncounter(id, ...)
    if self.light_encounters[id] then
        return self.light_encounters[id](...)
    else
        error("Attempted to create non-existent light encounter \"" .. tostring(id) .. "\"")
    end
end

function Lib:registerLightEnemy(id, class)
    self.light_enemies[id] = class
end

function Lib:getLightEnemy(id)
    return self.light_enemies[id]
end

function Lib:createLightEnemy(id, ...)
    if self.light_enemies[id] then
        return self.light_enemies[id](...)
    else
        error("Attempted to create non-existent light enemy \"" .. tostring(id) .. "\"")
    end
end

function Lib:registerLightWave(id, class)
    self.light_waves[id] = class
end

function Lib:getLightWave(id)
    return self.light_waves[id]
end

function Lib:createLightWave(id, ...)
    if self.light_waves[id] then
        return self.light_waves[id](...)
    else
        error("Attempted to create non-existent light wave \"" .. tostring(id) .. "\"")
    end
end

function Lib:registerLightBullet(id, class)
    self.light_bullets[id] = class
end

function Lib:getLightBullet(id)
    return self.light_bullets[id]
end

function Lib:createLightBullet(id, ...)
    if self.light_bullets[id] then
        return self.light_bullets[id](...)
    else
        error("Attempted to create non-existent light bullet \"" .. tostring(id) .. "\"")
    end
end

function Lib:registerLightShop(id, class)
    self.light_shops[id] = class
end

function Lib:getLightShop(id)
    return self.light_shops[id]
end

function Lib:createLightShop(id, ...)
    if self.light_shops[id] then
        return self.light_shops[id](...)
    else
        error("Attempted to create non-existent light shop \"" .. tostring(id) .. "\"")
    end
end

function Lib:registerLightWorldBullet(id, class)
    self.light_world_bullets[id] = class
end

function Lib:getLightWorldBullet(id)
    return self.light_world_bullets[id]
end

function Lib:createLightWorldBullet(id, ...)
    if self.light_world_bullets[id] then
        return self.light_world_bullets[id](...)
    else
        error("Attempted to create non-existent light world bullet \"" .. tostring(id) .. "\"")
    end
end

function Lib:registerDebugOptions(debug)
    local function isDebugWave(id)
        return TableUtils.contains({"_empty"}, id)
    end
    
    debug.exclusive_battle_menus = {}
    debug.exclusive_battle_menus["LIGHTBATTLE"] = {"light_wave_select", "light_wave_select_multiple"}
    debug.exclusive_battle_menus["DARKBATTLE"] = {"wave_select", "wave_select_multiple"}
    debug.exclusive_world_menus = {}
    debug.exclusive_world_menus["LIGHTWORLD"] = {}
    debug.exclusive_world_menus["DARKWORLD"] = {}

    debug:registerMenu("encounter_select", "Encounter Select")
    
    debug:registerOption("encounter_select", "Start Dark Encounter", "Start a dark encounter.", function()
        debug:enterMenu("dark_encounter_select", 0)
    end)
    debug:registerOption("encounter_select", "Start Light Encounter", "Start a light encounter.", function()
        debug:enterMenu("light_encounter_select", 0)
    end)

    debug:registerMenu("dark_encounter_select", "Select Dark Encounter", "search")
    for id,_ in pairs(Registry.encounters) do
        if id ~= "_empty" or Kristal.getLibConfig("magical-glass", "debug") then
            debug:registerOption("dark_encounter_select", id, "Start this encounter.", function()
                Game:encounter(id, true, nil, nil, false)
                debug:closeMenu()
            end)
        end
    end

    debug:registerMenu("light_encounter_select", "Select Light Encounter", "search")
    for id,_ in pairs(self.light_encounters) do
        if id ~= "_empty" or Kristal.getLibConfig("magical-glass", "debug") then
            debug:registerOption("light_encounter_select", id, "Start this encounter.", function()
                Game:encounter(id, true, nil, nil, true)
                debug:closeMenu()
            end)
        end
    end

    debug:registerMenu("light_wave_select", "Wave Select", "search")
    
    debug:registerOption("light_wave_select", "[Stop Current Wave]", "Stop the current playing wave.", function ()
        if Game.battle:getState() == "DEFENDING" then
            Game.battle.encounter:onWavesDone()
        end
        debug:closeMenu()
    end)

    local waves_list = {}
    for id,_ in pairs(self.light_waves) do
        if not isDebugWave(id) or Kristal.getLibConfig("magical-glass", "debug") then
            table.insert(waves_list, id)
        end
    end

    table.sort(waves_list, function(a, b)
        return a < b
    end)

    for _,id in ipairs(waves_list) do
        debug:registerOption("light_wave_select", id, "Start this wave.", function ()
            if Game.battle:getState() == "ACTIONSELECT" then
                Game.battle.debug_wave = true
                Game.battle:setState("ENEMYDIALOGUE", {id})
            end
            debug:closeMenu()
        end)
    end
    
    debug:registerMenu("light_wave_select_multiple", "Multiple Wave Select", "search")

    debug:registerOption(
        "light_wave_select_multiple",
        "[Start Waves]",
        "Start the selected waves.",
        function()
            if #debug.light_selected_waves > #Game.battle:getActiveEnemies() then
                return false
            end
            -- WARNING: Prepare eye bleach before reading function
            if Game.battle:getState() == "ACTIONSELECT" then
                -- Step 1: Creates a table of enemies that can (normally) use each wave
                local enemy_matches = {}
                for _, wave in ipairs(debug.light_selected_waves) do
                    enemy_matches[wave] = {}
                    for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
                        if TableUtils.contains(enemy.waves, wave) then
                            table.insert(enemy_matches[wave], enemy)
                        end
                    end
                end
                -- Step 2: Assign waves to enemies
                -- Table for waves that don't get a match at this stage
                local assign_randomly = {}
                for i = 0, #debug.light_selected_waves do
                    for wave, enemies in pairs(enemy_matches) do
                        -- Process the least matches first
                        if #enemies == i then
                            -- Skip over everything that didn't get a match
                            if i == 0 then
                                table.insert(assign_randomly, wave)
                                goto continue
                            end
                            local success
                            -- Find the first enemy that can use this wave and set it on them
                            for _, enemy in ipairs(enemies) do
                                if not enemy.selected_wave then
                                    enemy.selected_wave = wave
                                    success = true
                                    break
                                end
                            end

                            -- Oops! Accidentally assigned all of the enemies this fit on already
                            if not success then
                                table.insert(assign_randomly, wave)
                            end
                        end
                        ::continue::
                    end
                end
                -- Step 3: All the waves we couldn't assign before get chucked on enemies randomly
                for _, wave in ipairs(assign_randomly) do
                    for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
                        if not enemy.selected_wave then
                            enemy.selected_wave = wave
                            break
                        end
                    end
                end
                Game.battle.debug_wave = true
                Game.battle:setState("ENEMYDIALOGUE", debug.light_selected_waves)
                debug:closeMenu()
            end
        end,
        nil,
        function()
            return #debug.light_selected_waves > #Game.battle:getActiveEnemies() and COLORS.silver or COLORS.white
        end
    )
    
    debug:registerOption(
        "light_wave_select_multiple",
        "[Clear Selection]",
        "Clear the currently selected waves.",
        function()
            debug.light_selected_waves = {}
        end
    )
    
    table.sort(waves_list, function(a, b)
        return a < b
    end)

    local function getWaveSpaceString()
        return "(" .. #debug.light_selected_waves .. "/" .. #Game.battle:getActiveEnemies() .. ")"
    end

    for _, id in ipairs(waves_list) do
        if not isDebugWave(id) then
            debug:registerOption(
                "light_wave_select_multiple",
                id,
                function()
                    if TableUtils.contains(debug.light_selected_waves, id) then
                        return "Remove this wave from the selected group. " .. getWaveSpaceString()
                    end
                    
                    return "Add this wave to the selected group. " .. getWaveSpaceString()
                end,
                function()
                    if TableUtils.contains(debug.light_selected_waves, id) then
                        TableUtils.removeValue(debug.light_selected_waves, id)
                    elseif #debug.light_selected_waves < #Game.battle:getActiveEnemies() then
                        table.insert(debug.light_selected_waves, id)
                    else
                        return false
                    end
                end,
                nil,
                function()
                    return TableUtils.contains(debug.light_selected_waves, id) and COLORS.aqua or #debug.light_selected_waves >= #Game.battle:getActiveEnemies() and COLORS.silver or COLORS.white
                end
            )
        end
    end
    
    debug:registerMenu("select_shop", "Enter Shop")
    
    debug:registerOption("select_shop", "Enter Dark Shop", "Enter a dark shop.", function()
        debug:enterMenu("dark_select_shop", 0)
    end)
    debug:registerOption("select_shop", "Enter Light Shop", "Enter a light shop.", function()
        debug:enterMenu("light_select_shop", 0)
    end)
    
    debug:registerMenu("dark_select_shop", "Enter Dark Shop", "search")
    for id,_ in pairs(Registry.shops) do
        debug:registerOption("dark_select_shop", id, "Enter this shop.", function()
            Game:enterShop(id, nil, false)
            debug:closeMenu()
        end)
    end

    debug:registerMenu("light_select_shop", "Enter Light Shop", "search")
    for id,_ in pairs(self.light_shops) do
        debug:registerOption("light_select_shop", id, "Enter this shop.", function()
            Game:enterShop(id, nil, true)
            debug:closeMenu()
        end)
    end
    
    debug:registerMenu("give_item", "Give Item")
    
    debug:registerOption("give_item", "Give Dark Item", "Give a dark item.", function()
        debug:enterMenu("dark_give_item", 0)
    end)
    debug:registerOption("give_item", "Give Light Item", "Give a light item.", function()
        debug:enterMenu("light_give_item", 0)
    end)
    debug:registerOption("give_item", "Give Undertale Item", "Give an Undertale item.", function()
        debug:enterMenu("ut_give_item", 0)
    end)
    
    debug:registerMenu("dark_give_item", "Give Dark Item", "search")
    debug:registerMenu("light_give_item", "Give Light Item", "search")
    debug:registerMenu("ut_give_item", "Give Undertale Item", "search")
    for id, item_data in pairs(Registry.items) do
        local item = item_data()
        local menu
        if StringUtils.sub(item.id, 1, 10) == "undertale/" then
            menu = "ut_give_item"
        elseif item.light then
            menu = "light_give_item"
        else
            menu = "dark_give_item"
        end
        debug:registerOption(menu, item.id, "\"" .. item.name .. "\"\n" .. item.description, function ()
            Game.inventory:tryGiveItem(item_data())
        end)
    end
    
    local in_game = function () return Kristal.getState() == Game end
    local in_overworld = function () return in_game() and Game.state == "OVERWORLD" end
    local in_dark_battle = function () return in_game() and Game.state == "BATTLE" and not Game.battle.light end
    local in_light_battle = function () return in_game() and Game.state == "BATTLE" and Game.battle.light end
    local in_dark_world = function () return in_game() and not Game:isLight() end
    local in_light_world = function () return in_game() and Game:isLight() end
    
    for i = #debug.menus["main"].options, 1, -1 do
        local option = debug.menus["main"].options[i]
        if TableUtils.contains({"Start Wave", "Start Multiple Waves", "End Battle"}, option.name) then
            table.remove(debug.menus["main"].options, i)
        end
    end
    
    debug:registerOption("main", "Start Wave", "Start a wave.", function ()
        debug:enterMenu("wave_select", 0)
    end, in_dark_battle)
    
    debug:registerOption("main", "Start Multiple Waves", "Start multiple waves at once.", function ()
        debug:enterMenu("wave_select_multiple", 0)
    end, in_dark_battle)

    debug:registerOption("main", "End Battle", "Instantly complete a battle.", function ()
        Game.battle:setState("VICTORY")
        debug:closeMenu()
    end, in_dark_battle)
                        
    debug:registerOption("main", "Start Wave", "Start a wave.", function ()
        debug:enterMenu("light_wave_select", 0)
    end, in_light_battle)
    
    debug:registerOption("main", "Start Multiple Waves", "Start multiple waves at once.", function ()
        debug:enterMenu("light_wave_select_multiple", 0)
    end, in_light_battle)

    debug:registerOption("main", "End Battle", "Instantly complete a battle.", function ()
        Game.battle.forced_victory = true
        if TableUtils.contains({"DEFENDING", "DEFENDINGBEGIN", "ENEMYDIALOGUE"}, Game.battle.state) then
            Game.battle.encounter:onWavesDone()
        end
        Game.battle:setState("VICTORY")
        debug:closeMenu()
    end, in_light_battle)
    
    debug:addToExclusiveMenu("OVERWORLD", {"dark_encounter_select", "light_encounter_select", "dark_select_shop", "light_select_shop"})
    debug:addToExclusiveMenu("BATTLE", "light_wave_select", "light_wave_select_multiple")
end

function Lib:setupLightShop(shop)
    local check_shop
    if type(shop) == "string" then
        check_shop =  Lib:getLightShop(shop)
    else
        check_shop = shop
    end
    
    if check_shop:includes(Shop) then
        error("Attempted to use Shop in a LightShop. Convert the shop \"" .. check_shop.id .. "\" file to a LightShop")
    end
    
    if Game.shop then
        error("Attempt to enter light shop while already in shop")
    end

    if type(shop) == "string" then
        shop = Lib:createLightShop(shop)
    end

    if shop == nil then
        error("Attempt to enter light shop with nil shop")
    end

    Game.shop = shop
    Game.shop:postInit()
end

function Lib:enterLightShop(shop, options)
    -- Add the shop to the stage and enter it.
    if Game.shop then
        Game.shop:leaveImmediate()
    end

    Lib:setupLightShop(shop)

    if options then
        Game.shop.leave_options = options
    end

    if Game.world and Game.shop.shop_music then
        Game.world.music:stop()
    end

    Game.state = "SHOP"
    
    Lib.in_light_shop = true

    Game.stage:addChild(Game.shop)
    Game.shop:onEnter()
end

function Lib:setLightBattleShakingText(v)
    if v == true then
        Lib.light_battle_shake_text = 0.501
    elseif v == false then
        Lib.light_battle_shake_text = 0
    elseif type(v) == "number" then
        Lib.light_battle_shake_text = v
    end
end

function Lib:setLightBattleSpareColor(value, color_name)
    if value == "pink" then
        Lib.spare_color = {MG_PALETTE["pink_spare"], "PINK"}
    elseif type(value) == "table" then
        Lib.spare_color = {value, "SPAREABLE"}
    else
        for name, color in pairs(COLORS) do
            if value == name then
                Lib.spare_color = {color, name:upper()}
                break
            end
        end
    end
    if type(color_name) == "string" then
        Lib.spare_color[2] = color_name:upper()
    end
end

function Lib:setCellCallsRearrangement(v)
    Lib.rearrange_cell_calls = v
end

function Lib:setSeriousMode(v)
    Lib.serious_mode = v
end

function Lib:onFootstep(char, num)
    if self.encounters_enabled and self.in_encounter_zone and Game.world.player and char:includes(Player) then
        self.steps_until_encounter = self.steps_until_encounter - 1
    end
end

function Lib:setLightEXP(exp)
    for _, party in pairs(Game.party_data) do
        party:setLightEXP(exp)
    end
end

function Lib:setLightLV(level)
    for _, party in pairs(Game.party_data) do
        party:setLightLV(level)
    end
end

function Lib:getLightActionButtons(battler, buttons)
    if battler.has_save then
        local index = TableUtils.getIndex(buttons, "act")
        if index then
            table.remove(buttons, index)
            table.insert(buttons, index, SaveLightButton())
        end
    end
end

function Lib:assetsMonsterSoulCheckOverwrite(path)
    if StringUtils.sub(path, 1, 7) == "player/" and Game:getMonsterSoul() then
        path = StringUtils.sub(path, 1, 7) .. "monster" .. "/" .. StringUtils.sub(path, 8)
    elseif StringUtils.sub(path, 1, 8) == "!player/" then
        return StringUtils.sub(path, 2)
    end
    
    return path
end

-- Undertale Borders
function Lib:onKeyPressed(key, is_repeat)
    if not is_repeat then
        self.active_keys[key] = true
    end
end

-- Undertale Borders
function Lib:onKeyReleased(key)
    self.active_keys[key] = nil
end

function Lib:onBorderDraw(border_sprite)
    -- Undertale Border
    if border_sprite == "undertale/sepia" then
        local idle_min = 300000
        local idle_time = 0
        local current_time = RUNTIME * 1000
        if (self.idle and current_time >= (self.idle_time + idle_min)) then
            idle_time = (current_time - (self.idle_time + idle_min))
        end

        local idle_frame = (math.floor((idle_time / 100)) % 3)

        if idle_frame > 0 then
            for index, pos in pairs(self.flower_positions) do
                local x, y = (pos[1] * BORDER_SCALE), (pos[2] * BORDER_SCALE) - 1
                local round = MathUtils.round
                love.graphics.setBlendMode("replace")
                local flower = Assets.getTexture("borders_addons/undertale/sepia/" .. tostring(index) .. ((idle_frame == 1) and "a" or "b"))
                Draw.setColor(1, 1, 1, BORDER_ALPHA)
                Draw.draw(flower, round(x), round(y), 0, BORDER_SCALE, BORDER_SCALE)
                Draw.setColor(1, 1, 1, 1)
                love.graphics.setBlendMode("alpha")
            end
        end
    end
end

function Lib:postUpdate()
    Game.lw_xp = nil
    for _, party in pairs(Game.party_data) do -- Gets the party with the most Light EXP
        if not Game.lw_xp or (type(party:getLightEXP()) == "number" and party:getLightEXP() > Game.lw_xp) then
            Game.lw_xp = party:getLightEXP()
        end
    end
    if Game.lw_xp == nil then Game.lw_xp = 0 end
    if Kristal.getLibConfig("magical-glass", "shared_light_exp") then
        for _, party in pairs(Game.party_data) do
            if party:getLightEXP() ~= Game.lw_xp then
                party:setLightEXP(Game.lw_xp)
            end
        end
    end
    if not Game.battle then
        if Lib.random_encounter then
            Lib.random_encounter:resetSteps(false)
            Lib.random_encounter = nil
        end
    end
    
    -- Undertale Borders
    if Utils.equal(self.active_keys, {}, false) then
        self.idle_time = 0
        self.idle = false
    else
        if not self.idle then
            self.idle_time = RUNTIME * 1000
        end
        self.idle = true
    end
    
    for _, sprite in ipairs(Game.stage:getObjects(Sprite)) do
        local object = sprite.parent
        if object then
            local party = object.getPartyMember and object:getPartyMember() or object.chara
            if party and party:getDarknerShield() and Game:isLight() and object.darkner_shield == nil then
                object.darkner_shield = true
            end
            if object.darkner_shield and not object.darkner_shield_active then
                object.darkner_shield_background = DarknerProtectionEffect(0, 0, false)
                object.darkner_shield_foreground = DarknerProtectionEffect(0, 0, true)
                sprite.parent:addChild(object.darkner_shield_background)
                sprite.parent:addChild(object.darkner_shield_foreground)
                
                object.darkner_shield_active = true
            end
            if not object.darkner_shield and object.darkner_shield_active then
                object.darkner_shield_background:remove()
                object.darkner_shield_foreground:remove()
                object.darkner_shield_background = nil
                object.darkner_shield_foreground = nil
                object.darkner_shield_active = nil
            end
        end
    end
end

return Lib
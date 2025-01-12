MagicalGlass = {}
local lib = MagicalGlass

-- VARIABLES

local mg_palette_data = {
    ["pink_spare"]           = {1, 167/255, 212/255, 1},

    ["player_health_back"]   = COLORS.red,
    ["player_health"]        = COLORS.yellow,

    ["karma"]                = { 192/255, 0, 0, 1 },

    ["player_status_defend"] = COLORS.aqua,
    ["player_status_down"]   = COLORS.red,

    ["player_attack"]        = { 1, 105/255, 105/255, 1 },

    ["menu_health_back"]     = { 128 / 255, 0, 0, 1 },
    ["menu_health"]          = COLORS.lime,

    ["enemy_health_back"]    = { 128 / 255, 0, 0, 1 },
    ["enemy_health"]         = COLORS.lime,
    ["enemy_mercy"]          = COLORS.yellow,

    ["tension_back"]         = { 128 / 255, 0, 0, 1 },
    ["tension_decrease"]     = { 1, 0, 0, 1 },
    ["tension_fill"]         = { 255 / 255, 160 / 255, 64 / 255, 1 },
    ["tension_max"]          = { 255 / 255, 208 / 255, 32 / 255, 1 },
    ["tension_maxtext"]      = { 1, 1, 0, 1 },
    ["tension_desc"]         = { 255 / 255, 160 / 255, 64 / 255, 1 },

    ["en_back"]              = { 62/255, 283/255, 100/255, 1 },
    ["en"]                   = { 184/255, 213/255, 70/255, 1 }
}
MagicalGlass.PALETTE = {}
setmetatable(MagicalGlass.PALETTE, {
    __index = function (t, i) return Kristal.callEvent("getMGPaletteColor", i) or mg_palette_data[i] end,
    __newindex = function (t, k, v) mg_palette_data[k] = v end,
})

MagicalGlass.EVENT = {
    beforeLightBattleStateChange    = "beforeLightBattleStateChange",    -- old, new, reason, extra
    onLightBattleStateChange        = "onLightBattleStateChange",        -- old, new, reason, extra
    beforeLightBattleSubStateChange = "beforeLightBattleSubStateChange", -- old, new, reason, extra
    onLightBattleSubStateChange     = "onLightBattleSubStateChange",     -- old, new, reason, extra

    onLightBattleActionCommit       = "onLightBattleActionCommit",       -- action, action name, user, target
    onLightBattleActionUndo         = "onLightBattleActionUndo",         -- action, action name, user, target
    onLightBattleActionBegin        = "onLightBattleActionBegin",        -- action, action name, user, target
    onLightBattleAction             = "onLightBattleAction",             -- action, action name, user, target
    onLightBattleActionEnd          = "onLightBattleActionEnd",          -- action, action name, user, target, don't end

    getLightBattleActionOrder       = "getLightBattleActionOrder",       -- order, encounter

    onLightBattleActionButtonSelect = "onLightBattleActionButtonSelect", -- battler, button, selectable

    preLightBattleUIDraw            = "preLightBattleUIDraw",            -- LightBattleUI
    onLightBattleUIDraw             = "onLightBattleUIDraw",             -- LightBattleUI
}

MagicalGlass.__encounter_zones = {}

-- not a fan of looping through every object in existence
MagicalGlass.__dust_objects = 0
MagicalGlass.__DUST_OBJECT_LIMIT = 8000

MagicalGlass.GLOBAL_SAVE_PATH = "saves" .. "/mg_global.json"

-- REGISTRY

function lib:initRegistry()
    self.registry = {}

    self.registry.encounter_groups = {}
    
    self.registry.light_encounters = {}
    self.registry.light_enemies = {}
    self.registry.light_waves = {}
    self.registry.light_battle_cutscenes = {}

    self.registry.light_shops = {}

    for _,path,group in Registry.iterScripts("world/encountergroups") do
        assert(group ~= nil, '"encountergroups/'..path..'.lua" does not return value')
        group.id = group.id or path
        self.registry.encounter_groups[group.id] = group
    end

    for _,path,light_enc in Registry.iterScripts("battle/lightencounters") do
        assert(light_enc ~= nil, '"lightencounters/'..path..'.lua" does not return value')
        light_enc.id = light_enc.id or path
        self.registry.light_encounters[light_enc.id] = light_enc
    end

    for _,path,light_enemy in Registry.iterScripts("battle/lightenemies") do
        assert(light_enemy ~= nil, '"lightenemies/'..path..'.lua" does not return value')
        light_enemy.id = light_enemy.id or path
        self.registry.light_enemies[light_enemy.id] = light_enemy
    end

    for _,path,light_wave in Registry.iterScripts("battle/lightwaves") do
        assert(light_wave ~= nil, '"lightwaves/'..path..'.lua" does not return value')
        light_wave.id = light_wave.id or path
        self.registry.light_waves[light_wave.id] = light_wave
    end

    for _,path,cutscene in Registry.iterScripts("battle/lightbattlecutscenes") do
        assert(cutscene ~= nil, '"lightbattlecutscenes/'..path..'.lua" does not return value')
        cutscene.id = cutscene.id or path
        self.registry.light_battle_cutscenes[cutscene.id] = cutscene
    end

    for _,path,light_shop in Registry.iterScripts("lightshops") do
        assert(light_shop ~= nil, '"lightshops/'..path..'.lua" does not return value')
        light_shop.id = light_shop.id or path
        self.registry.light_shops[light_shop.id] = light_shop
    end
end

function lib:getEncounterGroup(id)
    return MagicalGlass.registry.encounter_groups[id]
end

function lib:createEncounterGroup(id, ...)
    if MagicalGlass.registry.encounter_groups[id] then
        return MagicalGlass.registry.encounter_groups[id](...)
    else
        error("Attempt to create non existent encounter group \"" .. tostring(id) .. "\"")
    end
end

function lib:getLightEncounter(id)
    return MagicalGlass.registry.light_encounters[id]
end

function lib:createLightEncounter(id, ...)
    if MagicalGlass.registry.light_encounters[id] then
        return MagicalGlass.registry.light_encounters[id](...)
    else
        error("Attempt to create non existent light encounter \"" .. tostring(id) .. "\"")
    end
end

function lib:getLightEnemy(id)
    return MagicalGlass.registry.light_enemies[id]
end

function lib:createLightEnemy(id, ...)
    if MagicalGlass.registry.light_enemies[id] then
        return MagicalGlass.registry.light_enemies[id](...)
    else
        error("Attempt to create non existent light enemy \"" .. tostring(id) .. "\"")
    end
end

function lib:getLightWave(id)
    return MagicalGlass.registry.light_waves[id]
end

function lib:createLightWave(id, ...)
    if MagicalGlass.registry.light_waves[id] then
        return MagicalGlass.registry.light_waves[id](...)
    else
        error("Attempt to create non existent light wave \"" .. tostring(id) .. "\"")
    end
end

function lib.getLightBattleCutscene(group, id)
    local cutscene = MagicalGlass.registry.light_battle_cutscenes[group]
    if type(cutscene) == "table" then
        return cutscene[id], true
    elseif type(cutscene) == "function" then
        return cutscene, false
    end
end

-- INIT

function lib:init()
    print("oh boy here we go again")
    print("Loaded Magical Glass 2!")
    
    self:initRegistry()

    for _,path in ipairs(Utils.getFilesRecursive(self.info.path.."/scripts/init")) do
        love.filesystem.load(self.info.path .. "/scripts/init/" .. path)()
    end
end

function lib:save(data)
    data.magical_glass_2 = {}
    data.magical_glass_2["default_battle_system"]       = self.default_battle_system
    data.magical_glass_2["party_members"]               = self.party_members
    data.magical_glass_2["advanced_save_menu"]          = self.advanced_save_menu

    data.magical_glass_2["light_battle_text_shake"]     = self.light_battle_text_shake
    data.magical_glass_2["light_battle_mercy_messages"] = self.light_battle_mercy_messages
    data.magical_glass_2["list_item_menu"]              = self.list_item_menu

    data.magical_glass_2["pink_spare"]                  = self.pink_spare
    data.magical_glass_2["always_flee"]                 = self.always_flee

    data.magical_glass_2["kills"]                       = self.kills

    data.magical_glass_2["__has_dim_box_a"]             = self.__has_dim_box_a
    data.magical_glass_2["__has_dim_box_b"]             = self.__has_dim_box_b

    data.magical_glass_2["__current_battle_system"]     = self.__current_battle_system
end

function lib:load(data, is_new_file)
    if not love.filesystem.getInfo(MagicalGlass.GLOBAL_SAVE_PATH) then
        love.filesystem.write(MagicalGlass.GLOBAL_SAVE_PATH, self:initGlobalSave())
    end

    if not data.magical_glass_2 then
        local function getConfigOption(config, default)
            local option = self:getConfig(config)
            if option ~= nil then return option else return default end
        end

        self.default_battle_system          = getConfigOption("defaultBattleSystem", "undertale")
        self.party_members                  = getConfigOption("allowPartyMembers", true)
        self.advanced_save_menu             = getConfigOption("advancedSaveMenu", true)

        self.light_battle_text_shake        = getConfigOption("lightBattleTextShake", true)
        self.light_battle_mercy_messages    = getConfigOption("lightBattleMercyMessages", false)
        self.list_item_menu                 = getConfigOption("lightBattleListItemMenu", false)

        self.pink_spare                     = false
        self.always_flee                    = false

        self.kills                          = 0

        self.__has_dim_box_a                = false
        self.__has_dim_box_b                = false

        self.__current_battle_system        = nil
        self.__game_overs                   = nil
        self:setGameOvers(0)
    else
        self.default_battle_system          = data.magical_glass_2["default_battle_system"]
        self.party_members                  = data.magical_glass_2["party_members"]
        self.advanced_save_menu             = data.magical_glass_2["advanced_save_menu"]

        self.light_battle_text_shake        = data.magical_glass_2["light_battle_text_shake"]
        self.light_battle_mercy_messages    = data.magical_glass_2["light_battle_mercy_messages"]

        self.list_item_menu                 = data.magical_glass_2["list_item_menu"]

        self.pink_spare                     = data.magical_glass_2["pink_spare"]
        self.always_flee                    = data.magical_glass_2["always_flee"]

        self.kills                          = data.magical_glass_2["kills"]

        self.__has_dim_box_a                = data.magical_glass_2["__has_dim_box_a"]
        self.__has_dim_box_b                = data.magical_glass_2["__has_dim_box_b"]

        self.__current_battle_system        = data.magical_glass_2["__current_battle_system"]
        self.__game_overs                   = self:getGameOvers()
    end
end

function lib:unload()
    MagicalGlass = nil
end

-- EVENTS

function lib:registerDebugOptions(debug)
    -- Items
    debug:registerMenu("give_item", "Give Item")

    debug:registerOption("give_item", "Give Dark World Item", "Give a dark world item.", function()
        debug:enterMenu("dark_give_item", 0)
    end)
    debug:registerOption("give_item", "Give Light World Item", "Give a light world item.", function()
        debug:enterMenu("light_give_item", 0)
    end)

    debug:registerMenu("dark_give_item", "Give Dark World Item", "search")
    for id, item_data in pairs(Registry.items) do
        local item = item_data()
        if not item.light then
            debug:registerOption("dark_give_item", item.name or "", item.description, function()
                Game.inventory:tryGiveItem(item_data())
            end)
        end
    end

    debug:registerMenu("light_give_item", "Give Light World Item", "search")
    for id, item_data in pairs(Registry.items) do
        local item = item_data()
        if item.light then
            debug:registerOption("light_give_item", item.name or "", item.description, function()
                Game.inventory:tryGiveItem(item_data())
            end)
        end
    end

    -- Encounters
    debug:registerMenu("encounter_select", "Encounter Select")

    debug:registerOption("encounter_select", "Start Dark Encounter", "Start a dark encounter.", function()
        debug:enterMenu("dark_encounter_select", 0)
    end)
    debug:registerOption("encounter_select", "Start Light Encounter", "Start a light encounter.", function()
        debug:enterMenu("light_encounter_select", 0)
    end)

    debug:registerMenu("dark_encounter_select", "Select Dark Encounter", "search")
    for id,_ in pairs(Registry.encounters) do
        debug:registerOption("dark_encounter_select", id, "Start this encounter.", function()
            Game:encounterDark(id, true, nil, nil, false)
            debug:closeMenu()
        end)
    end

    debug:registerMenu("light_encounter_select", "Select Light Encounter", "search")
    for id,_ in pairs(self.registry.light_encounters) do
        if id ~= "_nobody" then
            debug:registerOption("light_encounter_select", id, "Start this encounter.", function()
                Game:encounterLight(id, true, nil, nil, true)
                debug:closeMenu()
            end)
        end
    end
end

function lib:registerTextCommands(text)
    text:registerCommand("ut_shake", function(text, node, dry)
        text.state.ut_shake = tonumber(node.arguments[1]) or 1
        text.draw_every_frame = true
    end)
end

function lib:onDrawText(text, node, state, x, y, scale, font, use_color)
    if state.ut_shake and state.ut_shake > 0 then
        state.offset_x = Utils.random(state.ut_shake) - state.ut_shake / 2
        state.offset_y = Utils.random(state.ut_shake) - state.ut_shake / 2
    end
end

function lib:onFootstep(chara, num)
    if chara == Game.world.player then
        if #self.__encounter_zones > 0 then
            for _,enc_zone in ipairs(self.__encounter_zones) do
                enc_zone:onFootstep(num)
            end
        end
    end
end

-- GLOBAL SAVE

local read = love.filesystem.read
local write = love.filesystem.write

function lib:initGlobalSave()
    local data = {}

    data["global"] = {}

    data["files"] = {}
    for i = 1, 4 do
        data["files"][i] = {}
    end

    return JSON.encode(data)
end

function lib:writeToGlobalSaveFile(key, data, file)
    file = file or Game.save_id
    if love.filesystem.getInfo(MagicalGlass.GLOBAL_SAVE_PATH) then
        local global_data = JSON.decode(read(MagicalGlass.GLOBAL_SAVE_PATH))
        global_data.files[file][key] = data
        write(MagicalGlass.GLOBAL_SAVE_PATH, JSON.encode(global_data))
    end
end

function lib:writeToGlobalSave(key, data)
    if love.filesystem.getInfo(MagicalGlass.GLOBAL_SAVE_PATH) then
        local global_data = JSON.decode(read(MagicalGlass.GLOBAL_SAVE_PATH))
        global_data.global[key] = data
        write(MagicalGlass.GLOBAL_SAVE_PATH, JSON.encode(global_data))
    end
end

function lib:readFromGlobalSaveFile(key, file)
    file = file or Game.save_id
    if love.filesystem.getInfo(MagicalGlass.GLOBAL_SAVE_PATH) then
        local global_data = JSON.decode(read(MagicalGlass.GLOBAL_SAVE_PATH))
        return global_data.files[file][key]
    end
end

function lib:readFromGlobalSave(key)
    if love.filesystem.getInfo(MagicalGlass.GLOBAL_SAVE_PATH) then
        local global_data = JSON.decode(read(MagicalGlass.GLOBAL_SAVE_PATH))
        return global_data.global[key]
    end
end

-- FUNCTIONS

function lib:getConfig(config)
    return Kristal.getLibConfig(self.info.id, config)
end

function lib:toggleDimensionalBoxA(active)
    if active == nil then
        self.__has_dim_box_a = not self.__has_dim_box_a
    else
        self.__has_dim_box_a = active
    end

    if self.__has_dim_box_a then
        Game.world:registerCall("Dimensional Box A", function()
            Assets.playSound("dimbox")
            Game.lock_movement = true
    
            Game.world.timer:after(7/30, function()
                if Game.world.encountering_enemy then return end

                Game.world:openMenu(LightStorageMenu("items", "box_a"))
                Game.lock_movement = false
            end)
        end)
    else
        local index
        for i, call in ipairs(Game.world.calls) do
            if call[1] == "Dimensional Box A" then index = i end
            break
        end
        table.remove(Game.world.calls, index)
    end
end

function lib:toggleDimensionalBoxB(active)
    if active == nil then
        self.__has_dim_box_b = not self.__has_dim_box_b
    else
        self.__has_dim_box_b = active
    end

    if self.__has_dim_box_b then
        Game.world:registerCall("Dimensional Box B", function()
            Assets.playSound("dimbox")
            Game.lock_movement = true
    
            Game.world.timer:after(7/30, function()
                if Game.world.encountering_enemy then return end

                Game.world:openMenu(LightStorageMenu("items", "box_b"))
                Game.lock_movement = false
            end)
        end)
    else
        local index
        for i, call in ipairs(Game.world.calls) do
            if call[1] == "Dimensional Box B" then index = i end
            break
        end
        table.remove(Game.world.calls, index)
    end
end

function lib:setGameOvers(amount)
    self.__game_overs = amount
    self:writeToGlobalSaveFile("game_overs", self.__game_overs)
end

function lib:getGameOvers()
    return self:readFromGlobalSaveFile("game_overs")
end

function lib:getCurrentBattleSystem()
    return self.__current_battle_system
end

function lib:clearGlobalSave()
    if love.filesystem.getInfo(MagicalGlass.GLOBAL_SAVE_PATH) then
        love.filesystem.write(MagicalGlass.GLOBAL_SAVE_PATH, self:initGlobalSave())
    end
end

return lib
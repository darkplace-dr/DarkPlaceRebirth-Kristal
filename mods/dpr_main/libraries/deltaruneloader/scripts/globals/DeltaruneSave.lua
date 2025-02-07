---@class DeltaruneSave : Class
local DeltaruneSave = Class()

function DeltaruneSave:init(chapter, slot, completed)
    self.chapter = chapter or 2
    self.slot = slot or 1
    self.completed = completed or false

    self.data = {}

    self.name = ""
    self.money = 0

    self.plot = 0
    self.room_id = 0
    self.room_name = ""
    self.playtime = 0

    self.inventory = {
        ["items"]     = {},
        ["key_items"] = {},
        ["weapons"]   = {},
        ["armors"]    = {},
        ["storage"]   = {}
    }

    self.equipment = {
        ["kris"]   = {weapon = nil, armor = {}},
        ["susie"]  = {weapon = nil, armor = {}},
        ["ralsei"] = {weapon = nil, armor = {}},
        ["noelle"] = {weapon = nil, armor = {}},
    }

    self.title_ids = {
        ["kris"]   =   0,
        ["susie"]  = 100,
        ["ralsei"] = 200,
        ["noelle"] = 300
    }
    self.title_lv = 1

    self.lw_items = {}
    self.lw_weapon = nil
    self.lw_armor = nil

    self.vessel_name = ""

    self.team_name_id = 0
    self.team_name = DeltaruneConsts.TEAM_NAMES[0]

    self.shadow_crystals = 0
    self.beat_jevil = false
    self.beat_spamton = false

    self.starwalker = false

    self.snowgrave = false
    self.failed_snowgrave = false

    self.eggs = {[1] = false, [2] = false}

    if self.chapter == 1 then
        self.flag_start = 317
        self.flag_count = 9999
    elseif self.chapter >= 2 then
        self.flag_start = 553
        self.flag_count = 2500
    end
end

function DeltaruneSave:getData(index, as)
    local value = self.data[index]

    if value == nil then
        return nil
    end

    if as == "number" then
        return tonumber(value) or 0
    elseif as == "boolean" then
        return value ~= "0" and value ~= ""
    elseif as == "string" then
        return value
    else
        return tonumber(value) or value
    end
end

function DeltaruneSave:checkData(...)
    local index, compare = ...
    if arg.n == 1 then
        compare = true
    end
    return self:getData(index, type(compare)) == compare
end

function DeltaruneSave:getFlag(id, as)
    return self:getData(self.flag_start + id, as)
end

function DeltaruneSave:checkFlag(...)
    local id, compare = ...
    if arg.n == 1 then
        compare = true
    end
    return self:getData(self.flag_start + id, type(compare)) == compare
end

function DeltaruneSave:getRoomName()
    return DeltaruneConsts.ROOM_IDS[self.room_id] or (self.chapter >= 2 and "Dark World?" or " ")
end

function DeltaruneSave:getTeamName()
    return DeltaruneConsts.TEAM_NAMES[self.team_name_id] or "Guys"
end

function DeltaruneSave:getTitleName(character)
    return DeltaruneConsts.TITLE_NAMES[self.title_ids[character]]
end

function DeltaruneSave:getTitleDescription(character)
    return DeltaruneConsts.TITLE_DESCRIPTIONS[self.title_ids[character]]
end

function DeltaruneSave:getTitle(character)
    return DeltaruneConsts.TITLE_NAMES[self.title_ids[character]] .. "\n" .. DeltaruneConsts.TITLE_DESCRIPTIONS[self.title_ids[character]]
end

function DeltaruneSave:parseData(data)
    self.data = data

    self.name = data[1]
    self.money = tonumber(data[11])

    if self.chapter == 1 then
        self.plot         = tonumber(data[10316])
        self.room_id      = tonumber(data[10317])
        self.playtime     = tonumber(data[10318])
        if self.room_id < 280 then
            self.room_id = self.room_id + 280
        end
    elseif self.chapter >= 2 then
        self.plot         = tonumber(data[3053])
        self.room_id      = tonumber(data[3054])
        self.playtime     = tonumber(data[3055])
    end

    self.room_name = DeltaruneConsts.ROOM_IDS[self.room_id] or (self.chapter >= 2 and "Dark World?" or " ")
    self.playtime = self.playtime / 30

    local function parseEquipment(chara, index)
        self.equipment[chara].weapon = DeltaruneConsts.WEAPON_IDS[tonumber(data[index])]
        self.equipment[chara].armor[1] = DeltaruneConsts.ARMOR_IDS[tonumber(data[index + 1])]
        self.equipment[chara].armor[2] = DeltaruneConsts.ARMOR_IDS[tonumber(data[index + 2])]
    end

    if self.chapter == 1 then
        parseEquipment("kris", 77)
        parseEquipment("susie", 131)
        parseEquipment("ralsei", 185)
        self.lw_weapon = DeltaruneConsts.WEAPON_IDS[tonumber(data[290])]
        self.lw_armor  = DeltaruneConsts.ARMOR_IDS[tonumber(data[291])]
    elseif self.chapter >= 2 then
        parseEquipment("kris", 85)
        parseEquipment("susie", 147)
        parseEquipment("ralsei", 209)
        parseEquipment("noelle", 271)
        self.lw_weapon = DeltaruneConsts.WEAPON_IDS[tonumber(data[526])]
        self.lw_armor  = DeltaruneConsts.ARMOR_IDS[tonumber(data[527])]
    end

    local function parseItems(start, num, inc, tbl, lookup)
        for i = 1, num do
            local item_id = data[start + (i - 1) * inc]

            tbl[i] = lookup[tonumber(item_id)]
        end
    end

    if self.chapter == 1 then
        parseItems(236, 12, 4, self.inventory.items,     DeltaruneConsts.ITEM_IDS)
        parseItems(237, 12, 4, self.inventory.key_items, DeltaruneConsts.KEY_ITEM_IDS)
        parseItems(238, 12, 4, self.inventory.weapons,   DeltaruneConsts.WEAPON_IDS)
        parseItems(239, 12, 4, self.inventory.armors,    DeltaruneConsts.ARMOR_IDS)
        parseItems(301, 8,  2, self.lw_items,            DeltaruneConsts.LIGHT_ITEM_IDS)
    elseif self.chapter >= 2 then
        parseItems(330, 12, 2, self.inventory.items,     DeltaruneConsts.ITEM_IDS)
        parseItems(331, 12, 2, self.inventory.key_items, DeltaruneConsts.KEY_ITEM_IDS)
        parseItems(356, 48, 2, self.inventory.weapons,   DeltaruneConsts.WEAPON_IDS)
        parseItems(357, 48, 2, self.inventory.armors,    DeltaruneConsts.ARMOR_IDS)
        parseItems(452, 72, 1, self.inventory.storage,   DeltaruneConsts.ITEM_IDS)
        parseItems(537, 8,  2, self.lw_items,            DeltaruneConsts.LIGHT_ITEM_IDS)
    end

    if self.chapter == 1 then

        if self:getFlag(252, "boolean") then
            self.title_ids["kris"] = 2 -- Bed Inspector
        elseif self.plot >= 30 then
            self.title_ids["kris"] = 1 -- Leader
        else
            self.title_ids["kris"] = 0 -- Human
        end

        if self.plot >= 154 then
            self.title_ids["susie"] = 101 -- Dark Knight
        else
            self.title_ids["susie"] = 100 -- Mean Girl
        end

        self.title_ids["ralsei"] = 200 -- Lonely Prince

    elseif self.chapter >= 2 then
        local snowgrave_active = not self:getFlag(916, "boolean") and self:getFlag(915, "number") > 0

        if snowgrave_active then
            self.title_ids["kris"] = 5 -- Leader (Snowgrave)
        elseif self:getFlag(920, "boolean") then
            self.title_ids["kris"] = 4 -- Moss Finder
        elseif self:getFlag(252, "boolean") then
            self.title_ids["kris"] = 2 -- Bed Inspector
        elseif self.plot >= 60 then
            self.title_ids["kris"] = 3 -- Tactician
        else
            self.title_ids["kris"] = 1 -- Leader
        end

        if self:getFlag(922, "boolean") then
            self.title_ids["susie"] = 103 -- Moss Enjoyer
        elseif self.plot >= 95 then
            self.title_ids["susie"] = 102 -- Healing Master
        else
            self.title_ids["susie"] = 101 -- Dark Knight
        end

        local photo_gesture = self:getFlag(325, "number")
        if photo_gesture == 1 then
            self.title_ids["ralsei"] = 204 -- Hug Prince
        elseif photo_gesture == 2 then
            self.title_ids["ralsei"] = 205 -- Pose Prince
        elseif photo_gesture == 3 then
            self.title_ids["ralsei"] = 206 -- Rude Prince
        elseif photo_gesture == 4 then
            self.title_ids["ralsei"] = 207 -- Blank Prince
        else
            self.title_ids["ralsei"] = 203 -- Dark Prince
        end

        if self:getFlag(921, "boolean") and not snowgrave_active then
            self.title_ids["noelle"] = 303 -- Moss Neutral
        elseif self:getFlag(925, "number") > 0 then
            self.title_ids["noelle"] = 301 -- Frostmancer
        else
            self.title_ids["noelle"] = 300 -- Snowcaster
        end
    end

    self.title_lv = self.chapter
    if self.chapter == 2 and self.plot >= 200 then
        self.title_lv = 3
    end

    -- Extra variables

    self.vessel_name = data[2]

    self.team_name_id = self:getFlag(214, "number")
    self.team_name = DeltaruneConsts.TEAM_NAMES[self.team_name_id] or self.team_name

    self.eggs[1] = self:getFlag(263, "number") >= 2
    self.eggs[2] = self:getFlag(439, "boolean")

    if self:getFlag(241, "number") >= 6 then
        self.beat_jevil = true
        self.shadow_crystals = self.shadow_crystals + 1
    end
    if self:getFlag(309, "number") >= 9 then
        self.beat_spamton = true
        self.shadow_crystals = self.shadow_crystals + 1
    end

    self.starwalker = self:getFlag(254, "boolean")

    self.snowgrave = self:getFlag(915, "number") >= 6
    self.failed_snowgrave = self:getFlag(916, "boolean")
end

function DeltaruneSave:load()
    Game.save_name = self.name
    Game.money = self.money

    local function safeGetItem(id)
        if not id then
            return nil
        end

        if not Registry.getItem(id) then
            print("[DeltaruneLoader] Loaded invalid item: "..id)
            return nil
        end

        return id
    end

    local function clearStorages(inventory, storages)
        for _,storage_id in ipairs(storages) do
            local storage = inventory:getStorage(storage_id)
            for i = 1, storage.max do
                if inventory.stored_items[storage[i]] then
                    inventory.stored_items[storage[i]] = nil
                end
                storage[i] = nil
            end
        end
    end

    local function loadStorage(inventory, storage_id, data)
        local storage = inventory:getStorage(storage_id)
        for i = 1, storage.max do
            local item = safeGetItem(data[i])
            if storage.sorted then
                if item then
                    inventory:addItemTo(storage, item)
                end
            else
                inventory:setItem(storage, i, item)
            end
        end
    end

    local loaded_party = {"kris", "susie", "ralsei"}
    if self.chapter >= 2 then
        table.insert(loaded_party, "noelle")
    end

    local inventory = Game.inventory
    if Game:isLight() then
        clearStorages(inventory, {"items"})
        loadStorage(inventory, "items", self.lw_items)

        local kris = Game:getPartyMember("kris")
        kris:setWeapon(safeGetItem(self.lw_weapon))
        kris:setArmor(1, safeGetItem(self.lw_armor))

        for _,party_id in ipairs(loaded_party) do
            local chara = Game:getPartyMember(party_id)

            local weapon = chara:getWeapon()
            if weapon then
                weapon.dark_item = safeGetItem(self.equipment[party_id].weapon)
            end
            local armor = chara:getArmor(1)
            if armor then
                if armor:includes(LightEquipItem) then
                    armor:setArmor(1, safeGetItem(self.equipment[party_id].armor[1]))
                    armor:setArmor(2, safeGetItem(self.equipment[party_id].armor[2]))
                else
                    armor.dark_item = safeGetItem(self.equipment[party_id].armor[1])
                end
            end
        end

        inventory = Game.inventory:getDarkInventory()
    else
        for _,party_id in ipairs(loaded_party) do
            local chara = Game:getPartyMember(party_id)

            chara:setWeapon(safeGetItem(self.equipment[party_id].weapon))
            chara:setArmor(1, safeGetItem(self.equipment[party_id].armor[1]))
            chara:setArmor(2, safeGetItem(self.equipment[party_id].armor[2]))
        end
    end

    for _,party_id in ipairs(loaded_party) do
        local chara = Game:getPartyMember(party_id)

        chara.title = self:getTitle(party_id)
    end

    if self.chapter == 1 then
        clearStorages(inventory, {"items", "weapons", "armors"})
    elseif self.chapter >= 2 then
        clearStorages(inventory, {"items", "weapons", "armors", "storage"})
    end

    loadStorage(inventory, "items",     self.inventory.items)
    loadStorage(inventory, "weapons",   self.inventory.weapons)
    loadStorage(inventory, "armors",    self.inventory.armors)
    if self.chapter >= 2 then
        loadStorage(inventory, "storage", self.inventory.storage)
    end

    if self.shadow_crystals > 0 and not inventory:hasItem("shadowcrystal") then
        inventory:addItem("shadowcrystal")
    end
    Game:setFlag("shadow_crystals", self.shadow_crystals)

    if self.chapter >= 2 then
        local noelle = Game:getPartyMember("noelle")
        noelle:setFlag("iceshocks_used", self:getFlag(925, "number"))
        noelle:setFlag("boldness", math.min(-12 + (self.plot - 70) * 30, 100))

        if self.snowgrave then
            local has_snowgrave = false
            for _,spell in ipairs(noelle:getSpells()) do
                if spell.id == "snowgrave" then
                    has_snowgrave = true
                    break
                end
            end
            if not has_snowgrave then
                noelle:addSpell("snowgrave")
            end
        end
    end
end

return DeltaruneSave
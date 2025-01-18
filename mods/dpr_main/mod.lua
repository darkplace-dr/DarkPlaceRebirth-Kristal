--modRequire("scripts/main/warp_bin")
--modRequire("scripts/main/utils_general")

function Mod:init()
    print("Loaded "..self.info.name.."!")
    self.border_shaders = {}

    self:setMusicPitches()
end

function Mod:postInit(new_file)
    local items_list = {
        {
            result = "soulmantle",
            item1 = "flarewings",
            item2 = "discarded_robe"
        },
    }
    Kristal.callEvent("setItemsList", items_list)

    if new_file then
        Game:setFlag("library_love", 1)
        Game:setFlag("library_experience", 0)
        Game:setFlag("library_kills", 0)
		
        if Game.save_name == "SUPER" then
            Game.inventory:addItem("chaos_emeralds")
        end
        local baseParty = {}
        if Game.save_name == "DESS" then
            Game:setFlag("Dess_Mode", true)

            table.insert(baseParty, "dess") -- :heckyeah:
            Game:setFlag("_unlockedPartyMembers", baseParty)
            Game:addPartyMember("dess")
            Game:removePartyMember("hero")
        else
            table.insert(baseParty, "hero") -- should be just Hero for now
            Game:setFlag("_unlockedPartyMembers", baseParty)
        end

        Game.world:startCutscene("_main.introcutscene")
    end
    
    if not Game:getFlag("FUN") then
        local random = math.random(1,100)
        Game:setFlag("FUN", random)
    end

    self:initializeImportantFlags(new_file)
end

function Mod:initializeImportantFlags(new_file)
    self.pc_gifts_data = {
        UNDERTALE = {
            file = "undertale.ini",
            item_id = "heart_locket",
            prefix_os = {Windows = "Local/UNDERTALE", Linux = "%XDG_CONFIG_HOME%/UNDERTALE", OS_X = "com.tobyfox.undertale"},
            wine_steam_appid = 391540
        },
        DELTARUNE = {
            file = "dr.ini",
            item_id = "egg",
            prefix_os = {Windows = "Local/DELTARUNE", Linux = "%XDG_CONFIG_HOME%/DELTARUNE", OS_X = "com.tobyfox.deltarune"},
            wine_steam_appid = 1690940
        },
        UTY = {
            name = "UNDERTALE YELLOW",
            file = {"Save.sav", "Save02.sav", "Controls.sav", "tempsave.sav"},
            item_id = "wildrevolver",
            prefix_os = {Windows = "Local/Undertale_Yellow", Linux = "%XDG_CONFIG_HOME%/Undertale_Yellow"}
        },
        PT = {
            name = "PIZZA TOWER",
            file = {"saves/saveData1.ini", "saves/saveData2.ini", "saves/saveData3.ini"},
            item_id = "pizza_toque",
            -- Not sure what the Mac OS_X or Linux directories for PT are.
            -- If anyone else knows tho, feel free to add them in here lol.
            prefix_os = {Windows = "Roaming/PizzaTower_GM2"},
            wine_steam_appid = 2231450
        },

        -- Use "KR_" as a prefix to check for a Kristal Mod instead
        KR_frozen_heart = {item_id = "angelring"},
        KR_wii_bios = {item_id = "wiimote"},
        ["KR_acj_deoxynn/act1"] = {name = "Deoxynn Act 1", item_id = "victory_bell"}
    }
    local function generateStatusTable(data)
        local status = {}
        for game, info in pairs(data) do
            status[game] = info.received or false
        end
        return status
    end
    if Game:getFlag("pc_gifts_data") then
        assert(not new_file)
        Game:setFlag("pc_gifts_status", generateStatusTable(Game:getFlag("pc_gifts_data")))
        Game:setFlag("pc_gifts_data", nil)
    end
    if not Game:getFlag("pc_gifts_status") then
        Game:setFlag("pc_gifts_status", generateStatusTable(self.pc_gifts_data))
    else
        Game:setFlag("pc_gifts_status", Utils.merge(generateStatusTable(self.pc_gifts_data), Game:getFlag("pc_gifts_status")))
    end
end

function Mod:addGlobalEXP(exp)
    Game:setFlag("library_experience", Utils.clamp(Game:getFlag("library_experience", 0) + exp, 0, 99999))

    local max_love = #Kristal.getLibConfig("library_main", "global_xp_requirements")
    local leveled_up = false
    while
        Game:getFlag("library_experience") >= Kristal.callEvent("getGlobalNextLvRequiredEXP")
        and Game:getFlag("library_love", 1) < max_love
    do
        leveled_up = true
        Game:addFlag("library_love", 1)
        for _,party in ipairs(Game.party) do
            party:onLevelUpLVLib(Game:getFlag("library_love"))
        end
    end

    return leveled_up
end

function Mod:setMusicPitches()

    MUSIC_PITCHES["deltarune/THE_HOLY"] = 0.9
    MUSIC_PITCHES["deltarune/cybercity"] = 0.97
    MUSIC_PITCHES["deltarune/cybercity_alt"] = 1.2
end

function Mod:getGlobalNextLvRequiredEXP()
    return Kristal.getLibConfig("library_main", "global_xp_requirements")[Game:getFlag("library_love") + 1] or 0
end

function Mod:getGlobalNextLv()
    return Utils.clamp(Kristal.callEvent("getGlobalNextLvRequiredEXP") - Game:getFlag("library_experience"), 0, 99999)
end

function Mod:unlockQuest(quest, silent)
    if not silent and Game.stage then
        Game.stage:addChild(QuestCreatedPopup(quest))
    end
end

function Mod:registerDebugOptions(debug)
    debug:registerOption("main", "Party Menu", "Enter the  Party  Menu.", 
        function () 
            Game.world:openMenu(DarkCharacterMenu()) 
            debug:closeMenu()
        end
    )
end

function Mod:onMapMusic(map, music)
    -- Diner music
    local cur_song = Game:getFlag("curJukeBoxSong")

    if music == "dev" then
        if cur_song then
            return cur_song
        elseif Game:isDessMode() then
            return "gimmieyourwalletmiss"
        else
            return "greenroom"
        end
    end

    -- Cyber City music	
	local can_kill = Game:getFlag("can_kill", false)
    if music == "deltarune/cybercity" and can_kill == true then
        return "deltarune/cybercity_alt"
    end
end

--modRequire("scripts/main/warp_bin")
--modRequire("scripts/main/utils_general")

function Mod:init()
    print("Loaded "..self.info.name.."!")
	
    self.voice_timer = 0
    
    self.border_shaders = {}

    self:setMusicPitches()

    if DELTARUNE_SAVE_ID then
        DeltaruneLoader.load({chapter = 2, completed = true, slot = DELTARUNE_SAVE_ID})
    end
end

function Mod:postInit(new_file)
    if DELTARUNE_SAVE_ID then
        local save = DeltaruneLoader.getCompletion(2,DELTARUNE_SAVE_ID)
        self:loadDeltaruneFile(save)
        Game.save_id = DELTARUNE_SAVE_ID
        DELTARUNE_SAVE_ID = nil
    end
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
            result = "peanut",
            item1 = "nut",
            item2 = "nut"
        },
        {
            result = "quadnut",
            item1 = "peanut",
            item2 = "peanut"
        },
    }
    Kristal.callEvent("setItemsList", items_list)

    if new_file then
        Game:setFlag("library_love", 1)
        Game:setFlag("library_experience", 0)
        Game:setFlag("library_kills", 0)
		
        if Game:isSpecialMode "SUPER" then
            Game.inventory:addItem("chaos_emeralds")
        end
        local baseParty = {}
        if Game:isSpecialMode "DESS" then
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
        local random = love.math.random(1,100)
        Game:setFlag("FUN", random)
    end
	
	Game:setFlag("devDinerBorderState", nil)
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
        BOB = {
            name = "Born of Bread",
            file = {"Saved/SaveGames/Settings.sav"},
            item_id = "soupladle",
            -- Not sure what the Mac OS_X or Linux directories for BOB are.
            -- If anyone else knows tho, feel free to add them in here lol.
            prefix_os = {Windows = "Local/BornOfBread"},
            wine_steam_appid = 1555140
        },
        YATC = {
            name = "You Are The Code",
            file = {"logs/godot.log"},
            item_id = "binariband",
            -- Not sure what the Mac OS_X or Linux directories for YATC are.
            -- If anyone else knows tho, feel free to add them in here lol.
            prefix_os = {Windows = "Roaming/thinkwithgames/YouAreTheCode"},
            wine_steam_appid = 3333330
        },
        PROJECTCAT = {
            name = "Project Cat",
            file = {"Frost-Garb_ProjectCat/player.json"},
            item_id = "marketkey",
            prefix_os = {Windows = "Roaming/LOVE"},
        },
        OVERTIME = {
            file = {"Mercenaries.sav", "Progress.sav", "Story.sav", "undertale_save", "Universal.sav"},
            party_id = "pauling",
            -- Not sure what the Mac OS_X or Linux directories for Overtime are.
            -- If anyone else knows tho, feel free to add them in here lol.
            prefix_os = {Windows = "Local/Overtime"}
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

function Mod:postLoad()
    -- Switch to the very cool debug mode!...?

    if not Game:getFlag("FUN") then
        local random = love.math.random(1,100)
        Game:setFlag("FUN", random)
    end

    if (Game:getFlag("FUN") >= 90 or Game.save_name == "JOEY") and love.math.random() < 0.1 then
        if Game.world and Game.world:hasCutscene() then
            Game.world:stopCutscene()
        end
        Game:setFlag("FUN", love.math.random(1,100))
        local save_data = Utils.copy(Game:save(Game.world.player:getPosition()), true)
        Kristal.clearModState()
        Kristal.DebugSystem:refresh()
        Kristal.setState("Debug", save_data)
    end
	
	Game:rollShiny("hero")
	self.mic_controller = MicController()
	Game.stage:addChild(self.mic_controller)
	if Game:getFlag("microphone_id") then
		self.mic_controller.mic_id = Game:getFlag("microphone_id", 1)
	end
	if Game:getFlag("microphone_right_click") then
		self.mic_controller.right_click_mic = Game:getFlag("microphone_right_click", 0)
	end
	if Game:getFlag("microphone_sensitivity") then
		self.mic_controller.mic_sensitivity = Game:getFlag("microphone_sensitivity", 0.5)
	end
	if Game:getFlag("mic_active", false) then
		Mod:enableMicAccess(self.mic_controller.mic_id)
	end
end

function Mod:enableMicAccess(id)
	Game:setFlag("mic_active", true)
	self.mic_controller:startRecordMic(id or 1)
end

function Mod:disableMicAccess()
	Game:setFlag("mic_active", false)
	self.mic_controller:startRecordMic()
end

function Mod:openMicMenu()
	if not Game:getFlag("mic_active", false) then
		Mod:enableMicAccess(1)
	end
	Game.world:openMenu(MicMenu())
end

function Mod:preUpdate()
    self.voice_timer = Utils.approach(self.voice_timer, 0, DTMULT)
end

function Mod:unload()
	if self.mic_controller then
		-- I have no idea if this will even fix the potential memory leak but it's worth a shot
		self.mic_controller.cleaning_up = true
		self.mic_controller.mic_recording = false
		if self.mic_controller.mic_data then
			self.mic_controller.mic_data:release()
			self.mic_controller.mic_data = nil
		end
		if self.mic_controller.mic_inputs then
			for _, inputs in ipairs(self.mic_controller.mic_inputs) do
				inputs:release()
			end
		end
		self.mic_controller:remove()
		collectgarbage()
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
    MUSIC_PITCHES["deltarune/tv_results_screen"] = 0.4
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

function Mod:onMapMusic(map, music)
    -- Diner music
    local cur_song = Game:getFlag("curJukeBoxSong")

    if music == "dev" then
        if cur_song then
            return cur_song
        elseif Game:isDessMode() then
            return "gimmieyourwalletmiss"
        else
            return "deltarune/greenroom_detune"
        end
    end

    -- Cyber City music	
	local can_kill = Game:getFlag("can_kill", false)
    if music == "deltarune/cybercity" and can_kill == true then
        return "deltarune/cybercity_alt"
    end
    --TV World music
    if map.id:find("floortv/") and can_kill == true then
        return "deltarune/tv_results_screen"
    end
end

function Mod:onMapBorder(map, border)
	if border == "green_room" and map.id:find("floortv/") and Game:getFlag("can_kill", false) then
		return "green_room_blue"
	end
end

---@param file DeltaruneSave
function Mod:loadDeltaruneFile(file)
    -- TODO: Load items into custom storages, and
    -- give the player access to that stuff much later in the game.
    file:load()
    if file.failed_snowgrave then
    elseif file.snowgrave then
        Game:setFlag("POST_SNOWGRAVE", true)
    end
end

-- Necessery for Jeku and Noel's interaction in the former's shop
-- as the function in Noel's actor is not called in that case
function Mod:onTextSound(voice, node, text)
    if voice == "noel" and Game.shop then
        Assets.playSound("voice/noel/"..string.lower(node.character), 1, 1)
        return true
    end
    if voice == "rx1" then
        if self.voice_timer == 0 then
            local snd = Assets.playSound(Utils.pick{"voice/rx1", "voice/rx2", "voice/rx3"})
            self.voice_timer = 2
        end
        return true
    end
end

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
            Game.world:openMenu(CharacterMenu()) 
            debug:closeMenu()
        end
    )
end

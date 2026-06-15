local character, super = Class("noelle", true)

function character:init()
    super.init(self)
    
    self:setDarkTransitionActor("noelle_dark_transition")

    -- Light world portrait in the menu (saved to the save file)
    self.lw_portrait = "face/noelle/smile"

    self.lw_health = 20
    -- Light world base stats (saved to the save file)
    self.lw_stats = {
        health = 20,
        attack = 10,
        defense = 10,
        magic = 2
    }
    
    -- The color of this character's soul (optional, defaults to red)
    self.soul_color = {1, 1, 1}
    -- Whether the soul will be upside-down or not (optional)
    self.monster_soul = true

    -- Default light world equipment item IDs (saves current equipment)
    self.lw_weapon_default = "mg/ring"
    self.lw_armor_default = "light/wristwatch"
    
    -- Increased Base stats & Current health (saved to the save file)
    if Game.chapter == 1 then
        self.health = 60
        self.stats = {
            health = 60,
            attack = 3,
            defense = 1,
            magic = 9
        }
    elseif Game.chapter == 3 then
        self.health = 120
        self.stats = {
            health = 120,
            attack = 4,
            defense = 1,
            magic = 13
        }
    elseif Game.chapter >= 4 then
        self.health = 150
        self.stats = {
            health = 150,
            attack = 5,
            defense = 1,
            magic = 16
        }
    end
end

function character:getLightStatText()
    if self:checkWeapon("mg/thorn") then
        return "Trance"
    end
    
    return super.getLightStatText(self)
end

function character:lightLVStats()
    return {
        health = self:getLightLV() == 20 and 99 or 16 + self:getLightLV() * 4,
        attack = 9 + self:getLightLV() + math.floor(self:getLightLV() / 3),
        defense = 9 + math.ceil(self:getLightLV() / 4),
        magic = 1 + self:getLightLV()
    }
end

function character:getGameOverMessage(main)
    return {
        main:getName() .. ",[wait:5] are you\nokay?!",
        "Please,[wait:5]\nwake up...!"
    }
end

return character
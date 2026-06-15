local character, super = Class("susie", true)

function character:init()
    super.init(self)
    
    -- Light world portrait in the menu (saved to the save file)
    self.lw_portrait = Game:getConfig("susieStyle") == 1 and "face/susie/bangs_smile" or "face/susie/smile"

    self.lw_health = 30
    -- Light world base stats (saved to the save file)
    self.lw_stats = {
        health = 30,
        attack = 12,
        defense = 10,
        magic = 1
    }
    
    -- The color of this character's soul (optional, defaults to red)
    self.soul_color = {1, 1, 1}
    -- Whether the soul will be upside-down or not (optional)
    self.monster_soul = true

    -- Default light world equipment item IDs (saves current equipment)
    if Game.chapter <= 2 then
        self.lw_weapon_default = "mg/hairbrush"
    elseif Game.chapter == 3 then
        self.lw_weapon_default = "mg/electric_toothbrush"
    elseif Game.chapter >= 4 then
        self.lw_weapon_default = "mg/dirty_toothbrush"
    end
    self.lw_armor_default = "light/bandage"
end

function character:lightLVStats()
    return {
        health = self:getLightLV() <= 20 and math.min(25 + self:getLightLV() * 5, 99) or 25 + self:getLightLV() * 5,
        attack = 10 + self:getLightLV() * 2 + math.floor(self:getLightLV() / 4),
        defense = 9 + math.ceil(self:getLightLV() / 4),
        magic = math.ceil(self:getLightLV() / 4)
    }
end

function character:onLightTurnStart(battler)
    super.onLightTurnStart(self, battler)
    
    if self:getFlag("auto_attack", false) then
        Game.battle:pushForcedAction(battler, "AUTOATTACK", Game.battle:getActiveEnemies()[1], nil, {points = 150})
    end
end

function character:onLightAttackHit(enemy, damage)
    super.onLightAttackHit(self, enemy, damage)
    
    if not Game:isLight() then
        if damage > 0 then
            Assets.playSound("impact", 0.8)
            Game.battle:shake(true)
        end
    end
end

return character
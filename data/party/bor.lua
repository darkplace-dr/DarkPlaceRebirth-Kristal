local character, super = Class(PartyMember, "bor")

function character:init()
    super.init(self)

    -- Display name
    self.name = "Bor"

    -- Actor (handles overworld/battle sprites)
    self:setActor("bor")
    self:setLightActor("bor")

    -- Display level (saved to the save file)
    self.level = 2
    -- Default title / class (saved to the save file)
    self.title = "Ball\nIs this... a\nkirby reference?"

    -- Determines which character the soul comes from (higher number = higher priority)
    self.soul_priority = 1
    -- The color of this character's soul (optional, defaults to red)
    self.soul_color = {0.459, 0.667, 0.8}

    -- Whether the party member can act / use spells
    self.has_act = false
    self.has_spells = true

    -- Whether the party member can use their X-Action
    self.has_xact = true
    -- X-Action name (displayed in this character's spell menu)
    self.xact_name = "B-Action"
    
    -- Spells
    self:addSpell("ice_beam")
    self:addSpell("dual_heal")
    self:addSpell("peace")
    self:addSpell("sleep_mist")

    self.love = 20
    self.exp = 99999
    self.kills = 120

    self.lw_stats = {
        health = 24,
        attack = 18,
        defense = 6
    }

    -- Current health (saved to the save file)
    self.lw_health = 24
    self.health = 160

    -- Base stats (saved to the save file)
    self.stats = {
        health = 160,
        attack = 6,
        defense = 4,
        magic = 12
    }
    -- Max stats from level-ups
    self.max_stats = {
        health = 320,
        attack = 20,
        defense = 20,
        magic = 40
    }

    -- Weapon icon in equip menu
    self.weapon_icon = "ui/menu/equip/shard"

    -- Equipment (saved to the save file)
    self:setWeapon("neutral_shard")
    self:setArmor(1, "steel_coating")
    self:setArmor(2, "tealstartophat")

    -- Default light world equipment item IDs (saves current equipment)
    self.lw_weapon_default = "light/pencil"
    self.lw_armor_default = "light/bandage"

    -- Character color (for action box outline and hp bar)
    self.color = {117/255, 170/255, 204/255}
    -- Damage color (for the number when attacking enemies) (defaults to the main color)
    self.dmg_color = {117/255, 170/255, 204/255}
    -- Attack bar color (for the target bar used in attack mode) (defaults to the main color)
    self.attack_bar_color = {117/255, 170/255, 204/255}
    -- Attack box color (for the attack area in attack mode) (defaults to darkened main color)
    self.attack_box_color = {68/255, 131/255, 172/255}
    -- X-Action color (for the color of X-Action menu items) (defaults to the main color)
    self.xact_color = {117/255, 170/255, 204/255}

    -- Head icon in the equip / power menu
    self.menu_icon = "party/bor/head"
    -- Path to head icons used in battle
    self.head_icons = "party/bor/icon"
    -- Name sprite
    self.name_sprite = "party/bor/name"

    -- Effect shown above enemy after attacking it
    self.attack_sprite = "effects/attack/slap_n"
    -- Sound played when this character attacks
    self.attack_sound = "laz_c"
    -- Pitch of the attack sound
    self.attack_pitch = 1.5

    -- Battle position offset (optional)
    self.battle_offset = {2, 1}
    -- Head icon position offset (optional)
    self.head_icon_offset = nil
    -- Menu icon position offset (optional)
    self.menu_icon_offset = nil

end

function character:onLevelUp(level)
    self:increaseStat("health", 2)
    if level % 2 == 0 then
        self:increaseStat("health", 1)
    end
    if level % 10 == 0 then
        self:increaseStat("attack", 1)
        self:increaseStat("magic", 1)
    end
end

function character:drawPowerStat(index, x, y, menu)
    if index == 1 then
        
        local icon = Assets.getTexture("ui/menu/icon/magic")
        love.graphics.draw(icon, x-26, y+6, 0, 2, 2)

        love.graphics.print("Sphere", x, y, 0, 0.8, 1)
        love.graphics.print("Yeah", x+130, y)

        return true

    elseif index == 3 then
        local icon = Assets.getTexture("ui/menu/icon/fire")
        love.graphics.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Guts:", x, y)

        love.graphics.draw(icon, x+90, y+6, 0, 2, 2)
        love.graphics.draw(icon, x+110, y+6, 0, 2, 2)
        return true
    end
end

return character
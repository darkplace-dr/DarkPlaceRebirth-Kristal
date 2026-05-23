local character, super = Class(PartyMember, "zenore")

function character:init()
    super.init(self)

    -- Display name
    self.name = "Zenore"

    -- Actor (handles overworld/battle sprites)
    self:setActor("zenore")
    self:setLightActor("zenore_lw")
    self:setDarkTransitionActor("zenore_dark_transition")

    -- Display level (saved to the save file)
    self.level = Game.chapter
    -- Default title / class (saved to the save file)
    if Game.chapter == 1 then
        self.title = "Dragon\nHelps the party with\nvarious ACTs & MAGIC."
    elseif Game.chapter == 2 then
        self.title = "Planer\nHelps the party\nby ACTs & MAGIC."
    elseif Game.chapter == 3 then
        self.title = "Planer\nHelps the party\nby ACTs & MAGIC."
    elseif Game.chapter == 4 then
        self.title = "Dark Hero\nCarries out fate\nwith a blade."
    else
        self.title = "Dark Mage\nCarries out fights\nwith MAGIK."
    end

    -- Determines which character the soul comes from (higher number = higher priority)
    self.soul_priority = 4
    -- The color of this character's soul (optional, defaults to red)
    self.soul_color = {1, 1, 1}
    self.heart_sprite = "player/heart_zenore"
    self.soul_facing = "zenore"

    -- Whether the party member can act / use spells
    self.has_act = true
    self.has_spells = true

    -- Whether the party member can use their X-Action
    self.has_xact = false
    -- X-Action name (displayed in this character's spell menu)
    self.xact_name = "Z-Action"

    -- Spells
    self:addSpell("flame_burst")
    self:addSpell("ice_shock")
    self:addSpell("heal_prayer")
    self:addSpell("flame_buster")
    if Game.chapter >= 5 then
        self:addMagik("magikbuff")
    end

    -- Current health (saved to the save file)
    if Game.chapter == 1 then
        self.health = 90
    elseif Game.chapter == 2 then
        self.health = 120
    elseif Game.chapter == 3 then
        self.health = 160
    else
        self.health = 200
    end

    -- Base stats (saved to the save file)
    if Game.chapter == 1 then
        self.stats = {
            health = 90,
            attack = 10,
            defense = 2,
            magic = 5,
        }
    elseif Game.chapter == 2 then
        self.stats = {
            health = 120,
            attack = 12,
            defense = 2,
            magic = 7
        }
    elseif Game.chapter == 3 then
        self.stats = {
            health = 160,
            attack = 14,
            defense = 2,
            magic = 9
        }
    else
        self.stats = {
            health = 200,
            attack = 17,
            defense = 2,
            magic = 12
        }

    end
    -- Max stats from level-ups
    if Game.chapter == 1 then
        self.max_stats = {
            health = 120
        }
    elseif Game.chapter == 2 then
        self.max_stats = {
            health = 160
        }
    elseif Game.chapter == 3 then
        self.max_stats = {
            health = 200
        }
    else
        self.max_stats = {
            health = 260
        }
    end
    
    -- Party members which will also get stronger when this character gets stronger, even if they're not in the party
    self.stronger_absent = {"kris","susie","ralsei","zenore","aj","lex"}

    -- Weapon icon in equip menu
    self.weapon_icon = "ui/menu/equip/knife"

    -- Equipment (saved to the save file)
    if Game.chapter <= 2 then
        self:setWeapon("flame_knife")
        if Game.chapter == 2 then
            self:setArmor(1, "amber_card")
            self:setArmor(2, "amber_card")
        end
    elseif Game.chapter == 3 then
        self:setWeapon("flame_knife")
        self:setArmor(1, "amber_card")
        self:setArmor(2, "glowwrist")
    elseif Game.chapter >= 4 then
        self:setWeapon("flame_knife")
        self:setArmor(1, "gingerguard")
        self:setArmor(2, "glowwrist")
    end

    -- Default light world equipment item IDs (saves current equipment)
    if Game.chapter <= 2 then
        self.lw_weapon_default = "light/pencil"
    elseif Game.chapter == 3 then
        self.lw_weapon_default = "light/mech_pencil"
    elseif Game.chapter >= 4 then
        self.lw_weapon_default = "light/cactusneedle"
    end
    self.lw_armor_default = "light/bandage"

    -- Character color (for action box outline and hp bar)
    self.color = {1, 0, 0}
    -- Damage color (for the number when attacking enemies) (defaults to the main color)
    self.dmg_color = {0.5, 0, 0}
    -- Attack bar color (for the target bar used in attack mode) (defaults to the main color)
    self.attack_bar_color = {1, 0, 0}
    -- Attack box color (for the attack area in attack mode) (defaults to darkened main color)
    self.attack_box_color = {1, 0, 0}
    -- X-Action color (for the color of X-Action menu items) (defaults to the main color)
    self.xact_color = {0.5, 1, 1}

    -- Head icon in the equip / power menu
    self.menu_icon = "party/zenore/head"
    -- Path to head icons used in battle
    self.head_icons = "party/zenore/icon"
    -- Name sprite
    self.name_sprite = "party/zenore/name"

    -- Effect shown above enemy after attacking it
    self.attack_sprite = "effects/attack/cut"
    -- Sound played when this character attacks
    self.attack_sound = "laz_c"
    -- Pitch of the attack sound
    self.attack_pitch = 1

    -- Battle position offset (optional)
    self.battle_offset = {2, 1}
    -- Head icon position offset (optional)
    self.head_icon_offset = nil
    -- Menu icon position offset (optional)
    self.menu_icon_offset = nil

    -- Message shown on gameover (optional)
    self.gameover_message = nil
end

function character:onLevelUp(level)
    self:increaseStat("health", 2)
    if level % 10 == 0 then
        self:increaseStat("attack", 1)
    end
end

function character:onPowerSelect(menu)
    if MathUtils.random() < ((Game.chapter == 1) and 0.02 or 0.04) then
        menu.kris_dog = true
    else
        menu.kris_dog = false
    end
end

function character:drawPowerStat(index, x, y, menu)
    if index == 1 and menu.kris_dog then
        local frames = Assets.getFrames("misc/dog_sleep")
        local frame = math.floor(Kristal.getTime()) % #frames + 1
        love.graphics.print("Dog:", x, y)
        Draw.draw(frames[frame], x+120, y+5, 0, 2, 2)
        return true
    elseif index == 3 then
        local icon = Assets.getTexture("ui/menu/icon/fire")
        Draw.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Guts:", x, y)

        Draw.draw(icon, x+90, y+6, 0, 2, 2)
        if Game.chapter >= 2 then
            Draw.draw(icon, x+110, y+6, 0, 2, 2)
        end
        if Game.chapter >= 4 then
            Draw.draw(icon, x+130, y+6, 0, 2, 2)
        end
        return true
    end
end

return character

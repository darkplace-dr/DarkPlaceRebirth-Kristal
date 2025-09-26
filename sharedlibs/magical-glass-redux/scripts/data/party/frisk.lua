local character, super = Class(PartyMember, "frisk")

function character:init()
    super.init(self)

    -- Display name
    self.name = "Frisk"

    -- Actor (handles overworld/battle sprites)
    self:setActor("frisk")
    self:setLightActor("frisk_lw")

    -- Display level (saved to the save file)
    self.level = 1
    -- Default title / class (saved to the save file)
    self.title = "Human\nBody contains a\nhuman SOUL."

    -- Determines which character the soul comes from (higher number = higher priority)
    self.soul_priority = 2
    -- The color of this character's soul (optional, defaults to red)
    self.soul_color = {1, 0, 0}

    -- Whether the party member can act / use spells
    self.has_act = true
    self.has_spells = false
    
    -- Use Undertale Movement
    self.undertale_movement = true

    -- Whether the party member can use their X-Action
    self.has_xact = true
    -- X-Action name (displayed in this character's spell menu)
    self.xact_name = "F-Action"

    -- Current health (saved to the save file)
    self.health = 90

    -- Base stats (saved to the save file)
    self.stats = {
        health = 90,
        attack = 10,
        defense = 2,
        magic = 0
    }
    -- Max stats from level-ups
    self.max_stats = {
        health = 120
    }

    -- Weapon icon in equip menu
    self.weapon_icon = "ui/menu/equip/rapier"

    self:setWeapon("wood_rapier")

    -- Default light world equipment item IDs (saves current equipment)
    self.lw_weapon_default = "undertale/stick"
    self.lw_armor_default = "undertale/bandage"

    -- Character color (for action box outline and hp bar)
    self.color = {170/255, 1, 0}
    -- Damage color (for the number when attacking enemies) (defaults to the main color)
    self.dmg_color = {170/255, 1, 0}
    -- Attack bar color (for the target bar used in attack mode) (defaults to the main color)
    self.attack_bar_color = {170/255, 1, 0}
    -- Attack box color (for the attack area in attack mode) (defaults to darkened main color)
    self.attack_box_color = {85/255, 1, 0}
    -- X-Action color (for the color of X-Action menu items) (defaults to the main color)
    self.xact_color = {170/255, 1, 0}
    
    -- Light Battle Colors
    self.light_color = COLORS.white
    self.light_dmg_color = COLORS.red
    self.light_miss_color = COLORS.silver
    self.light_attack_color = {1, 105/255, 105/255}
    self.light_multibolt_attack_color = COLORS.white
    self.light_attack_bar_color = COLORS.white
    self.light_xact_color = COLORS.white
    
    -- Dark Battle Colors in the light world
    self.dmg_color_lw = COLORS.white
    self.attack_bar_color_lw = COLORS.white
    self.attack_box_color_lw = COLORS.silver
    self.xact_color_lw = COLORS.white
    
    
    -- Head icon in the equip / power menu
    self.menu_icon = "party/frisk/head"
    -- Path to head icons used in battle
    self.head_icons = "party/frisk/dark/icon"
    -- Name sprite
    self.name_sprite = "party/frisk/name"

    -- Effect shown above enemy after attacking it
    self.attack_sprite = "effects/attack/cut"
    -- Sound played when this character attacks
    self.attack_sound = "laz_c"
    -- Pitch of the attack sound
    self.attack_pitch = 1

    -- Battle position offset (optional)
    self.battle_offset = {-4, 7}
    -- Head icon position offset (optional)
    self.head_icon_offset = nil
    -- Menu icon position offset (optional)
    self.menu_icon_offset = nil
    -- Battle soul position offset (optional)
    self.soul_offset = {9, 2}

    -- Message shown on gameover (optional)
    self.gameover_message = nil
    self.force_gameover_message = true
end

function character:getName()
    if Kristal.getLibConfig("magical-glass", "frisk_use_player_name") then
        return Game.save_name
    else
        return super.getName(self)
    end
end

function character:getNameSprite()
    if Kristal.getLibConfig("magical-glass", "frisk_use_player_name") then
        return nil
    else
        return super.getNameSprite(self)
    end
end


function character:getHeadIcons()
    if Game:isLight() then
        return "party/frisk/light/icon"
    else
        return super.getHeadIcons(self)
    end
end

function character:getGameOverMessage(main)
    local determined = main:getName().."![wait:10]\nStay determined..."
    return Utils.pick({{"You cannot give\nup just yet...", determined}, {"You're going to\nbe alright!", determined}, {"It cannot end\nnow!", determined}, {"Don't lose hope!", determined}, {"Our fate rests\nupon you...", determined}})
end

function character:getBattleOffset()
    if Game:isLight() then
        return 3, 4
    else
        return super.getBattleOffset(self)
    end
end

function character:getSoulOffset()
    if Game:isLight() then
        return 2, 5
    else
        return super.getSoulOffset(self)
    end
end

function character:onLevelUp(level)
    self:increaseStat("health", 2)
    if level % 10 == 0 then
        self:increaseStat("attack", 1)
    end
end

function character:drawPowerStat(index, x, y, menu)
    if index == 3 then
        local icon = Assets.getTexture("ui/menu/icon/fire")
        love.graphics.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Guts:", x, y)

        love.graphics.draw(icon, x+90, y+6, 0, 2, 2)
        love.graphics.draw(icon, x+110, y+6, 0, 2, 2)
        return true
    end
end

return character
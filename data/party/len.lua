local character, super = Class(PartyMember, "len")

function character:init()
    super.init(self)

    -- Display name
    self.name = "Len"

    -- Actor (handles overworld/battle sprites)
    self:setActor("len")
    self:setLightActor("len_lw")
    self:setDarkTransitionActor("len_dark_transition")

    -- Display level (saved to the save file)
    self.love = -1
    self.level = 1
    
    -- Default title / class (saved to the save file)
    -- self.title = "Dark-King\nAssists the party\nas best as possible."
    -- self.title = "King\nAssists the party\nwith might. rarely."
    -- self.title = "Wild card\nAssists the party\nby ACTs."
    self.title = "Resigned Hero\nThe prophecied\ndark embraced."

    -- Determines which character the soul comes from (higher number = higher priority)
    self.soul_priority = 1

    -- The color of this character's soul (optional, defaults to red)
    self.soul_color = {1, 0, 0}

    -- In which direction will this character's soul face (optional, defaults to facing up)
    self.soul_facing = "down"

    -- Whether the party member can act / use spells
    self.has_act = true
    self.has_spells = true

    -- Whether the party member can use their X-Action
    self.has_xact = true

    -- X-Action name (displayed in this character's spell menu)
    self.xact_name = "L-Action"

    -- Spells
    self:addSpell("dark_prayer")
    self:addSpell("dark_steal")
    self:addSpell("dark_tomb")

    -- Current health (saved to the save file)
    self.health = 200

    -- Base stats (saved to the save file)
    self.stats = {
        health = 200,
        attack = 17,
        defense = 4,
        magic = 8
    }

    -- Max stats from level-ups
    self.max_stats = {
        health = 320
    }

    -- Party members which will also get stronger when this character gets stronger, even if they're not in the party
    self.stronger_absent = {}

    -- Weapon icon in equip menu
    self.weapon_icon = "ui/menu/equip/sword"

    -- Equipment (saved to the save file)
    self:setWeapon("wood_blade")
    self:setArmor(1, "bowl_hat")
    -- self:setArmor(2, "amber_card")

    -- Default light world equipment item IDs (saves current equipment)
    self.lw_weapon_default = "light/pencil"
    self.lw_armor_default = "light/bandage"

    -- Character color (for action box outline and hp bar)
    self.color = {208/255, 1, 1}
    -- Damage color (for the number when attacking enemies) (defaults to the main color)
    self.dmg_color = {120/255, 146/255, 146/255}
    -- Attack bar color (for the target bar used in attack mode) (defaults to the main color)
    -- self.attack_bar_color = {75/255, 5/255, 75/255}
    -- Attack box color (for the attack area in attack mode) (defaults to darkened main color)
    self.attack_box_color = ColorUtils.hexToRGB("#a1c5c5")
    -- X-Action color (for the color of X-Action menu items) (defaults to the main color)
    self.xact_color = {208/255/2, 1, 1}

    self.icon_color = {208/255, 1, 1}
	-- highlight color A
    self.highlight_color = ColorUtils.hexToRGB("#D0FFFFFF")
	-- highlight color B
    self.highlight_color_alt = ColorUtils.hexToRGB("#ACD3D3FF")

    -- Head icon in the equip / power menu
    self.menu_icon = "party/len/head"
    -- Path to head icons used in battle
    self.head_icons = "party/len/icon"
    -- Name sprite
    self.name_sprite = "party/len/name"

    -- Effect shown above enemy after attacking it
    self.attack_sprite = "effects/attack/cut"
    -- Sound played when this character attacks
    self.attack_sound = "laz_c_len"
    -- Pitch of the attack sound
    self.attack_pitch = 0.9

    -- Battle position offset (optional)
    self.battle_offset = {2, 1}
    -- Head icon position offset (optional)
    self.head_icon_offset = nil
    -- Menu icon position offset (optional)
    self.menu_icon_offset = nil

    -- Message shown on gameover (optional)
    self.gameover_message = nil -- "The tank ran out of bullets\ngive up!"
end

function character:isLast()
    for _, battler in ipairs(Game.battle.party) do
        if not battler.is_down and battler.chara.id ~= self.id then
            return false
        end
    end
    return true
end

function character:onPreHurt(amount, swoon)
    -- print("onPreHurt: " .. self.name .. " was hurt by " .. tostring(amount) .. " points of damage, and was " .. (swoon and "swooned" or "not swooned") .. ".")
    if self:isLast() then
        -- If last alive battler, then uh ow
        if not swoon then
            -- multiply damage taken by 10 and apply swoon damage
            return amount * 10, true
        else
            -- if the damage is already swoon damage, take less damage
            return amount * 6, true
        end
    end
end

function character:getHeadIcons()
    local party = Game:getPartyMember("len")
    if party then
        if party:getFlag("hoodless") or (Game.battle and Game.battle.encounter.is_jackenstein) then
            return "party/len/icon/hoodless"
        end
    end
    
    return super.getHeadIcons(self)
end

-- function character:onHurt(amount)
--     print("onHurt: " .. self.name .. " was hurt by " .. tostring(amount) .. " points of damage.")
-- end

-- function character:onPostHurt(amount, swoon)
--     print("onPostHurt: " .. self.name .. " was hurt by " .. tostring(amount) .. " points of damage, and was " .. (swoon and "swooned" or "not swooned") .. ".")
-- end

return character
local character, super = Class(PartyMember, "berdly")

function character:init()
    super.init(self)

    -- Display name
    self.name = "Berdly"

    -- Actor (handles overworld/battle sprites)
    self:setActor("berdly")
    self:setLightActor("berdly_lw")

    self.lw_portrait = "face/berdly_lw/smirk"

    -- Display level (saved to the save file)
    self.level = Game.chapter
    -- Default title / class (saved to the save file)
    self.title = "Gamer\nUses powerful\nfighting skills."

    -- Determines which character the soul comes from (higher number = higher priority)
    self.soul_priority = 1
    -- The color of this character's soul (optional, defaults to red)
    self.soul_color = {1, 1, 1}
    -- In which direction will this character's soul face (optional, defaults to facing up)
    self.soul_facing = "down"

    -- Whether the party member can act / use spells
    self.has_act = false
    self.has_spells = true

    -- Whether the party member can use their X-Action
    self.has_xact = true
    -- X-Action name (displayed in this character's spell menu)
    self.xact_name = "B-Action"
    
    -- Spells
    self:addSpell("wavedash")
    self:addSpell("pacify")

    -- Current health (saved to the save file)
    self.health = 200

    -- Base stats (saved to the save file)
    -- DO NOT CHANGE THESE PLEASE I BEG OF YOU
    self.stats = {
        health = 200,
        attack = 8,
        defense = 4,
        magic = 2
    }

    -- Weapon icon in equip menu
    self.weapon_icon = "ui/menu/equip/halberd"

    -- Equipment (saved to the save file)
    self:setWeapon("gilded_halberd")
    self:setArmor(1, "smart_scouter")
    if Game.chapter >= 2 then
        self:setArmor(2, "royalpin")
    end

    self.lw_health = 20

    self.lw_stats = {
        health = 20,
        attack = 10,
        defense = 10,
        magic = 1
    }

    -- Default light world equipment item IDs (saves current equipment)
    self.lw_weapon_default = "light/pencil"
    self.lw_armor_default = "light/bandage"

    -- Character color (for action box outline and hp bar)
    self.color = {15/255, 150/255, 78/255}
    -- Damage color (for the number when attacking enemies) (defaults to the main color)
    self.dmg_color = {18/255, 181/255, 94/255}
    -- Attack bar color (for the target bar used in attack mode) (defaults to the main color)
    self.attack_bar_color = {43/255, 165/255, 100/255}
    -- Attack box color (for the attack area in attack mode) (defaults to darkened main color)
    self.attack_box_color = {0, 114/255, 53/255}
    -- X-Action color (for the color of X-Action menu items) (defaults to the main color)
    self.xact_color = {18/255, 181/255, 94/255}

    -- Head icon in the equip / power menu
    self.menu_icon = "party/berdly/head"
    -- Path to head icons used in battle
    self.head_icons = "party/berdly/icon"
    -- Name sprite
    self.name_sprite = "party/berdly/name"

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
	
	self.tv_name = "BRD"
end

function character:getGameOverMessage(main)
    return {
        "Oh, no! ".. main.name ..", are you all right?",
        "Do not die on me, ".. main.name .."! Do not!!!"
    }
end

function character:onAttackHit(enemy, damage)
    if damage > 0 then
        Assets.playSound("impact", 0.8)
        Game.battle:shakeCamera()
    end
end

function character:onLevelUp(level)
    self:increaseStat("health", 2)
    if level % 10 == 0 then
        self:increaseStat("attack", 1)
		self:increaseStat("magic", 1)
    end
end

function character:onLevelUpLVLib(level)
    self:increaseStat("health", 5)
    self:increaseStat("defense", 1)
    if level % 2 == 0 then
        self:increaseStat("health", 5)
        self:increaseStat("attack", 1)
	    self:increaseStat("magic", 1)
    end
end

function character:drawPowerStat(index, x, y, menu)
    if index == 1 then
        
        local icon = Assets.getTexture("ui/menu/icon/gamer")
        love.graphics.draw(icon, x-26, y+6, 0, 2, 2)

        love.graphics.print("Gamer", x, y, 0, 1, 1)
        love.graphics.print("Yes", x+130, y)

        return true
		
    elseif index == 2 then
        
        local icon = Assets.getTexture("ui/menu/icon/bird")
        love.graphics.draw(icon, x-26, y+6, 0, 2, 2)

        love.graphics.print("Bird", x, y, 0, 1, 1)
        love.graphics.print("Yes", x+130, y)

        return true

    elseif index == 3 then
        local icon = Assets.getTexture("ui/menu/icon/fire")
        love.graphics.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Guts:", x, y)

        love.graphics.draw(icon, x+90, y+6, 0, 2, 2)
        return true
    end
end

function character:lightLVStats()
    return {
        health = self:getLightLV() == 20 and 99 or 16 + self:getLightLV() * 4,
        attack = 8 + self:getLightLV() * 2,
        defense = 9 + math.ceil(self:getLightLV() / 4),
        magic = math.ceil(self:getLightLV() / 4)
    }
end

return character
local character, super = Class(PartyMember, "apm")

function character:init()
    super.init(self)

    -- Display name
    self.name = "A.P.M."

    -- Actor (handles overworld/battle sprites)
    self:setActor("apm")

    -- Display level (saved to the save file)
    self.love = 1
    self.level = self.love
    -- Default title / class (saved to the save file)
    self.title = "Robot\nFollows its\nprogramming."

    -- Determines which character the soul comes from (higher number = higher priority)
    self.soul_priority = -99999
    -- The color of this character's soul (optional, defaults to red)
    self.soul_color = {175/255, 175/255, 175/255}
    -- In which direction will this character's soul face (optional, defaults to facing up)
    self.soul_facing = "up"

    -- Whether the party member can act / use spells
    self.has_act = true
    self.has_spells = true

    -- Whether the party member can use their X-Action
    self.has_xact = true
    -- X-Action name (displayed in this character's spell menu)
    self.xact_name = "A-Action"

    -- Current health (saved to the save file)
    self.health = 160

    self.stats = {
        health = 160,
        attack = 14,
        defense = 2,
        magic = 0
    }
    -- Max stats from level-ups
    self.max_stats = {}

    -- Weapon icon in equip menu
    self.weapon_icon = "ui/menu/equip/sword"

    -- Equipment (saved to the save file)
    self:setWeapon("wood_blade")
    if Game.chapter >= 2 then
        self:setArmor(1, "amber_card")
        self:setArmor(2, "amber_card")
    end

    -- Default light world equipment item IDs (saves current equipment)
    self.lw_weapon_default = "light/pencil"
    self.lw_armor_default = "light/bandage"

    -- Character color (for action box outline and hp bar)
    self.color = {175/255, 175/255, 175/255}
    -- Damage color (for the number when attacking enemies) (defaults to the main color)
    self.dmg_color = {175/255, 175/255, 175/255}
    -- Attack bar color (for the target bar used in attack mode) (defaults to the main color)
    self.attack_bar_color = {175/255, 175/255, 175/255}
    -- Attack box color (for the attack area in attack mode) (defaults to darkened main color)
    self.attack_box_color = {175/255, 175/255, 175/255}
    -- X-Action color (for the color of X-Action menu items) (defaults to the main color)
    self.xact_color = {175/255, 175/255, 175/255}

    self.icon_color = {175/255, 175/255, 175/255}

    -- Head icon in the equip / power menu
    self.menu_icon = "party/apm/head"
    -- Path to head icons used in battle
    self.head_icons = "party/apm/icon"
    -- Name sprite
    self.name_sprite = "party/apm/name"

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
	
	self.tv_name = "APM"
	
	self.can_lead = false
end

function character:onLevelUp(level)
    self:increaseStat("health", 2)
    if level % 10 == 0 then
        self:increaseStat("attack", 1)
    end
end

function character:hasProgramming()
	return false
end

function character:onTurnStart(battler)
	if self:hasProgramming() then
		
	else
		Game.battle:pushForcedAction(battler, "SKIP")
	end
end

return character
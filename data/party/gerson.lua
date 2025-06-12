local character, super = Class(PartyMember, "gerson")

function character:init()
    super.init(self)

    -- Display name
    self.name = "Gerson"

    -- Actor (handles sprites)
    self:setActor("gerson")

    -- Display level (saved to the save file)
    self.love = 1
    self.level = self.love
    -- Default title / class (saved to the save file)
    self.title = "Lord of the\nHammer, huh. Hell\nif im reading that."

	self.icon_color = {101/255, 170/255, 38/255}
	
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
    self.xact_name = "G-Action"

    -- Spells
    self:addSpell("rude_buster")

    -- Current health (saved to the save file)
    if Game.chapter == 1 then
        self.health = 110
    else
        self.health = 140
    end

    -- Base stats (saved to the save file)
    if Game.chapter == 1 then
        self.stats = {
            health = 110,
            attack = 14,
            defense = 2,
            magic = 1
        }
    else
        self.stats = {
            health = 220,
            attack = 14,
            defense = 6,
            magic = 8
        }
    end
    -- Max stats from level-ups
    self.max_stats = {}

    -- Weapon icon in equip menu
    self.weapon_icon = "ui/menu/equip/hammer"

    -- Equipment (saved to the save file)
    self:setWeapon("titan_hammer")
    self:setArmor(1, "amber_card")
    self:setArmor(2, "amber_card")

    -- Character color (for action box outline and hp bar)
    self.color = {101/255, 170/255, 38/255}
    -- Damage color (for the number when attacking enemies) (defaults to the main color)
    self.dmg_color = {101/255, 170/255, 38/255}
    -- Attack bar color (for the target bar used in attack mode) (defaults to the main color)
    self.attack_bar_color = {101/255, 170/255, 38/255}
    -- Attack box color (for the attack area in attack mode) (defaults to darkened main color)
    self.attack_box_color = {101/255, 170/255, 38/255}
    -- X-Action color (for the color of X-Action menu items) (defaults to the main color)
    self.xact_color = {101/255, 170/255, 38/255}

    -- Head icon in the equip / power menu
    self.menu_icon = "party/gerson/head"
    -- Path to head icons used in battle
    self.head_icons = "party/gerson/icon"
    -- Name sprite (optional)
    self.name_sprite = "party/gerson/name"

    -- Effect shown above enemy after attacking it
    self.attack_sprite = "effects/attack/mash"
    -- Sound played when this character attacks
    self.attack_sound = "laz_c"
    -- Pitch of the attack sound
    self.attack_pitch = 0.9

    -- Battle position offset (optional)
    self.battle_offset = {3, 1}
    -- Head icon position offset (optional)
    self.head_icon_offset = {-1, -2}
    -- Menu icon position offset (optional)
    self.menu_icon_offset = nil

    -- Message shown on gameover (optional)
    self.gameover_message = nil
end

function character:down()
	self.rage = false
	self.rage_counter = 0
    self.is_down = true
    self.sleeping = false
    self.hurting = false
    self:toggleOverlay(true)
    self.overlay_sprite:setAnimation("battle/defeat")
    if self.action then
        Game.battle:removeAction(Game.battle:getPartyIndex(self.chara.id))
    end
    Game.battle:checkGameOver()
end

function character:onAttackHit(enemy, damage)
    if damage > 0 then
        Assets.playSound("impact", 0.8)
        Game.battle:shakeCamera(4)
    end
end

function character:getGameOverMessage(main)
    return {
        "Come on,[wait:5]\nthat all you got!?",
        main:getName()..",[wait:5]\nget up...!"
    }
end

function character:canEquip(item, slot_type, slot_index)
    if item then
        return super.canEquip(self, item, slot_type, slot_index)
    else
        local item
        if slot_type == "weapon" then
            item = self:getWeapon()
        elseif slot_type == "armor" then
            item = self:getArmor(slot_index)
        else
            return true
        end
        return false
    end
end

function character:drawPowerStat(index, x, y, menu)
if index == 3 then
        local frames = Assets.getFramesOrTexture("misc/firescroll")
        local frame_id = math.floor(Utils.clampWrap(RUNTIME * 4, 1, #frames))
        local texture = frames[frame_id]
        Draw.draw(texture, x+90, y+6)
        love.graphics.print("Guts:", x, y)
        Draw.draw(texture, x+110, y+6)
        Draw.draw(texture, x+130, y+6)
        return true
    end
end

return character

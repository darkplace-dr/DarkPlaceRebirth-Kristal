local character, super = Class(PartyMember, "susie")

function character:init()
    super.init(self)

    -- Display name
    self.name = "Susie"

    -- Actor (handles sprites)
    self:setActor("susie")
    self:setLightActor("susie_lw")
    self:setDarkTransitionActor("susie_dark_transition")

    self.lw_portrait = "face/susie/smile"

    -- Display level (saved to the save file)
    self.love = 1
    self.level = self.love
    -- Default title / class (saved to the save file)
    if Game.chapter <= 3 then
        self.title = "Dark Knight\nDoes damage using\ndark energy."
    else
        self.title = "Dark Hero\nCarries out fate\nwith the blade."
    end

	self.icon_color = {234/255, 121/255, 200/255}
	
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
    self.xact_name = "S-Action"

    -- Spells
    self:addSpell("rude_buster")
    self:addSpell("sick_heal")
    self:addSpell("pacibuster")

    -- Current health (saved to the save file)
    if Game.chapter == 1 then
        self.health = 110
    elseif Game.chapter == 2 then
        self.health = 140
    elseif Game.chapter == 3 then
        self.health = 190
    else
        self.health = 230
    end

    -- Base stats (saved to the save file)
    if Game.chapter == 1 then
        self.stats = {
            health = 110,
            attack = 14,
            defense = 2,
            magic = 1
        }
    elseif Game.chapter == 2 then
        self.stats = {
            health = 140,
            attack = 16,
            defense = 2,
            magic = 1
        }
    elseif Game.chapter == 3 then
        self.stats = {
            health = 190,
            attack = 18,
            defense = 2,
            magic = 2
        }
    else
        self.stats = {
            health = 230,
            attack = 22,
            defense = 2,
            magic = 3
        }
    end
    -- Max stats from level-ups
    if Game.chapter == 1 then
        self.max_stats = {
            health = 140
        }
    elseif Game.chapter == 2 then
        self.max_stats = {
            health = 190
        }
    elseif Game.chapter == 3 then
        self.max_stats = {
            health = 240
        }
    else
        self.max_stats = {
            health = 290
        }
    end
    
    -- Party members which will also get stronger when this character gets stronger, even if they're not in the party
    self.stronger_absent = {"kris","susie","ralsei"}
    -- For some reason, we emptied the max_stats table. This preserves that old behavior.
    self.max_stats = {}

    -- Weapon icon in equip menu
    self.weapon_icon = "ui/menu/equip/axe"

    -- Equipment (saved to the save file)
    if Game.chapter <= 2 then
        self:setWeapon("mane_ax")
        if Game.chapter == 2 then
            self:setArmor(1, "amber_card")
            self:setArmor(2, "amber_card")
        end
    elseif Game.chapter == 3 then
        self:setWeapon("autoaxe")
        self:setArmor(1, "amber_card")
        self:setArmor(2, "glowwrist")
    elseif Game.chapter >= 4 then
        self:setWeapon("toxicaxe")
        self:setArmor(1, "gingerguard")
        self:setArmor(2, "glowwrist")
    end

    -- Default light world equipment item IDs (saves current equipment)
    self.lw_weapon_default = "light/pencil"
    self.lw_armor_default = "light/bandage"

    self.lw_health = 30

    self.lw_stats = {
        health = 30,
        attack = 12,
        defense = 10,
        magic = 1
    }

    -- Character color (for action box outline and hp bar)
    self.color = {1, 0, 1}
    -- Damage color (for the number when attacking enemies) (defaults to the main color)
    self.dmg_color = {0.8, 0.6, 0.8}
    -- Attack bar color (for the target bar used in attack mode) (defaults to the main color)
    self.attack_bar_color = {234/255, 121/255, 200/255}
    -- Attack box color (for the attack area in attack mode) (defaults to darkened main color)
    self.attack_box_color = {0.5, 0, 0.5}
    -- X-Action color (for the color of X-Action menu items) (defaults to the main color)
    self.xact_color = {1, 0.5, 1}

    -- Head icon in the equip / power menu
    self.menu_icon = "party/susie/head"
    -- Path to head icons used in battle
    self.head_icons = "party/susie/icon"
    -- Name sprite (optional)
    self.name_sprite = "party/susie/name"

    -- Effect shown above enemy after attacking it
    self.attack_sprite = "effects/attack/mash"
    -- Sound played when this character attacks
    self.attack_sound = "laz_c"
    -- Pitch of the attack sound
    self.attack_pitch = 0.9

    -- Battle position offset (optional)
    self.battle_offset = {3, 1}
    -- Head icon position offset (optional)
    self.head_icon_offset = nil
    -- Menu icon position offset (optional)
    self.menu_icon_offset = nil

    -- Message shown on gameover (optional)
    self.gameover_message = nil -- Handled by getGameOverMessage for Susie

    -- Character flags (saved to the save file)
    self.flags = {
        ["auto_attack"] = false,
        ["serious"] = false,
        ["eyes"] = true,
        ["kindness_heal"] = false,
        ["susie_heal"] = 0,
    }

	self.rage = false
	self.rage_counter = 0

	self.tv_name = "ASS"
end

function character:onTurnStart(battler)
	if self:checkWeapon("harvester") and not Game:getFlag("IDLEHEALDOESNTWORK") then
        self:heal(11)
    end
	if self.rage_counter > 0 then
		self.rage_counter = self.rage_counter - 1
		if self.rage_counter == 0 then
			self.rage = false
			battler:setAnimation("battle/idle")
		end
	end
	if self.rage then	-- TODO: 5% chance to attack a party member instead
		Game.battle:pushForcedAction(battler, "AUTOATTACK", Game.battle:getActiveEnemies()[love.math.random(#Game.battle:getActiveEnemies())], nil, {points = 450})
    elseif self:getFlag("auto_attack", false) then
        Game.battle:pushForcedAction(battler, "AUTOATTACK", Game.battle:getActiveEnemies()[1], nil, {points = 150})
    end
end

function character:getMenuIcon()
    if self:getFlag("eyes", false) then
        return "party/susie/head_eyes"
    end
    return self.menu_icon
end

function character:getHeadIcon()
    if self.is_down then
        return "head_down"
    elseif self.sleeping then
        return "sleep"
    elseif self.defending then
        return "defend"
    elseif self.action and self.action.icon then
        return self.action.icon
    elseif self.hurting then
        return "head_hurt"
    elseif self.rage then
        return "rage"
	elseif (self.chara:getHealth() <= (self.chara:getStat("health") / 4)) then
		return "head_low"
    else
        return "head"
    end
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
	
    if not self.getWeapon then return end
    local weapon = self:getWeapon()
    if not weapon then return end
    local id = weapon.id
    if not id then return end
    if id == "decayaxe" then
		self:addStatBuff("attack", -2)
	end
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

function character:getReaction(item, user)
    if item or user.id ~= self.id then
        return super.getReaction(self, item, user)
    else
        return "Hey, hands off!"
    end
end

function character:drawPowerStat(index, x, y, menu)
    if index == 1 then
        local icon = Assets.getTexture("ui/menu/icon/demon")
        Draw.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Rudeness", x, y)
        if Game.chapter == 1 then
            love.graphics.print("99", x+130, y)
        else
            love.graphics.print("89", x+130, y)
        end
        return true
    elseif index == 2 then
        if Game.chapter >= 3 then
            return
        end
        local icon = Assets.getTexture("ui/menu/icon/demon")
        Draw.draw(icon, x-26, y+6, 0, 2, 2)
        if Game.chapter == 1 then
            love.graphics.print("Crudeness", x, y, 0, 0.8, 1)
            love.graphics.print("100", x+130, y)
        elseif Game.chapter == 2 then
            love.graphics.print("Purple", x, y, 0, 0.8, 1)
            love.graphics.print("Yes", x+130, y)
        end
        return true
    elseif index == 3 then
        local icon = Assets.getTexture("ui/menu/icon/fire")
        Draw.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Guts:", x, y)

        Draw.draw(icon, x+90, y+6, 0, 2, 2)
        Draw.draw(icon, x+110, y+6, 0, 2, 2)
        if Game.chapter >= 3 then
            Draw.draw(icon, x+130, y+6, 0, 2, 2)
        end
        if Game.chapter >= 4 then
            Draw.draw(icon, x+150, y+6, 0, 2, 2)
        end
        return true
    end
end

function character:lightLVStats()
    return {
        health = self:getLightLV() <= 20 and math.min(25 + self:getLightLV() * 5,99) or 25 + self:getLightLV() * 5,
        attack = 10 + self:getLightLV() * 2 + math.floor(self:getLightLV() / 4),
        defense = 9 + math.ceil(self:getLightLV() / 4),
        magic = math.ceil(self:getLightLV() / 4)
    }
end

function character:onLevelUpLVLib(level)
    self:increaseStat("health", 5)
    self:increaseStat("attack", 1)
    if level % 2 == 0 then
        self:increaseStat("health", 5)
        self:increaseStat("magic", 1)
        self:increaseStat("defense", 1)
    end
end

return character

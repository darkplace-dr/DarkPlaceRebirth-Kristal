local character, super = Class(PartyMember, "pink")

function character:init()
    super.init(self)

    self.name = "Pink"
--Game.battle.tension_bar
    self:setActor("pink")
    self:setDarkTransitionActor("susie_dark_transition") -- Placeholder

    self.love = 1
    self.level = self.love
    self.title = "Magical Girl\nFights off evil\nwith anime powers."

    self.soul_priority = 2
    self.soul_color = {1, 0.5, 0.5}
    self.soul_facing = "down"

    self.has_act = false
    self.has_spells = true
    self.has_xact = true
    self.xact_name = "P-Action"

    self.health = 140

    self.stats = {
        health = 140,
        attack = 6,
        defense = 0,
        magic = 6
    }

    self.doki = 20

    self.max_stats = {}

    self.weapon_icon = "ui/menu/equip/staff"

    self:setWeapon("mew_staff")

    self.lw_weapon_default = "light/pencil"
    self.lw_armor_default = "light/bandage"
    self.lw_portrait = "face/hero/neutral_closed"

    self.color = {230/255, 36/255, 123/255}
    self.dmg_color = {1, 0.5, 0.25}
    self.attack_bar_color = {230/255, 30/255, 130/255}
    self.attack_box_color = {127/255, 58/255, 59/255}
    self.xact_color = {1, 0.5, 0.5}
	-- highlight color A
    self.highlight_color = ColorUtils.hexToRGB("#FF7F27FF")
		-- highlight color B
    self.highlight_color_alt = COLORS.pink

    self.icon_color = {252/255, 98/255, 166/255}

    self.menu_icon = "party/pink/head"
    self.head_icons = "party/pink/icon"
    self.name_sprite = "party/pink/name"

    self.attack_sprite = "effects/attack/cut_h"
    self.attack_sound = "laz_c"
    self.attack_pitch = 1

    self.battle_offset = {2, 1}
    self.head_icon_offset = {0, 0}
    self.menu_icon_offset = {0, 0}

    self.gameover_message = nil

    self.flags = {
    }

    self.tv_name = "PNK"

    self.can_lead = true

    self.element = {
        "CAT"
    }
end

function character:onLevelUp(level)
    self:increaseStat("health", 2)
    if level % 10 == 0 then
        self:increaseStat("attack", 1)
    end
end

function character:onLevelUpLVLib(level)
    self:increaseStat("health", 5)
    self:increaseStat("defense", 1)
    if level % 2 == 0 then
        self:increaseStat("attack", 1)
    end
end

function character:save()
    local data = {
        id = self.id,
        title = self.title,
        level = self.level,
        health = self.health,
        stats = self.stats,
        lw_lv = self.lw_lv,
        lw_exp = self.lw_exp,
        lw_health = self.lw_health,
        lw_stats = self.lw_stats,
        spells = self:saveSpells(),
        equipped = self:saveEquipment(),
        flags = self.flags,
        kills = self.kills,
        doki = self.doki
    }
    self:onSave(data)
    return data
end

function character:load(data)
    self.title = data.title or self.title
    self.level = data.level or self.level
    self.stats = data.stats or self.stats
    self.lw_lv = data.lw_lv or self.lw_lv
    self.lw_exp = data.lw_exp or self.lw_exp
    self.lw_stats = data.lw_stats or self.lw_stats
    if data.spells then
        self:loadSpells(data.spells)
    end
    if data.equipped then
        self:loadEquipment(data.equipped)
    end
    self.flags = data.flags or self.flags
    self.health = data.health or self:getStat("health", 0, false)
    self.lw_health = data.lw_health or self:getStat("health", 0, true)
    self.kills = data.kills or self.kills

    self.doki = data.doki or self.doki

    self:onLoad(data)
end

function character:drawPowerStat(index, x, y, menu)
    if index == 1 then
        local icon = Assets.getTexture("ui/menu/icon/exclamation")
        Draw.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Chosen One:", x, y, 0, 0.8, 1)
        love.graphics.print("Yes", x+130, y)
        return true
    elseif index == 2 then
        local icon = Assets.getTexture("ui/menu/icon/demon")
        Draw.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Doki:", x, y)
        love.graphics.print(self.doki, x+130, y)
        return true
    elseif index == 3 then
        local icon = Assets.getTexture("ui/menu/icon/fire")
        Draw.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Guts:", x, y)

        Draw.draw(icon, x+90, y+6, 0, 2, 2)
        Draw.draw(icon, x+110, y+6, 0, 2, 2)
        Draw.draw(icon, x+130, y+6, 0, 2, 2)
        return true
    end
end

return character

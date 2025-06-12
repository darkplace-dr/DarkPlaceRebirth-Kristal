local character, super = Class(PartyMember, "ddelta")

function character:init()
    super.init(self)

    self.name = "D. Delta"

    self:setActor("ddelta")
    self:setLightActor("ddelta_lw")
    self:setDarkTransitionActor("kris_dark_transition") -- Placeholder

    self.love = 1
    self.level = self.love
    self.title = "Walking Jewel\nKnows a variety\nof random moves."

    self.soul_priority = 1
    self.soul_color = {0.6, 1, 1}
    self.soul_facing = "down"

    self.has_act = false
    self.has_spells = true

    self.has_xact = true
    self.xact_name = "DD-Action"

    self.lw_portrait = "face/ddelta_lw/aha"
	
    self.health = 100

    self.stats = {
        health = 100,
        attack = 13,
        defense = 2,
        magic = 2
    }
    self.max_stats = {}

    self.lw_health = 25

    self.lw_stats = {
        health = 25,
        attack = 13,
        defense = 11,
        magic = 2
    }

    self.weapon_icon = "ui/menu/equip/crystal"

    self:setWeapon("beginners_crystal")

    self.lw_weapon_default = "light/magic_ball"
    self.lw_armor_default = "light/bandage"

    self.color = {0.5, 1, 1}
    self.dmg_color = {0.75, 1, 1}
    self.attack_bar_color = {153/255, 217/255, 234/255}
    self.attack_box_color = {153/255, 217/255, 234/255}
    self.xact_color = {0.5, 1, 1}

    self.icon_color = {153/255, 217/255, 234/255}

    self.menu_icon = "party/ddelta/head"
    self.head_icons = "party/ddelta/icon"
    self.name_sprite = "party/ddelta/name"

    self.attack_sprite = "effects/attack/cast_ddelta"
    self.attack_sound = "laz_c"
    self.attack_pitch = 0.9

    self.battle_offset = {2, 1}
    self.head_icon_offset = nil
    self.menu_icon_offset = {3, 0}

    self.gameover_message = {
        "don't give up\nalready man...",
        "we can't lose again,[wait:5]\nright?"
    }
end

function character:onLevelUp(level)
    self:increaseStat("health", 2)
    if level % 10 == 0 then
        self:increaseStat("attack", 1)
        self:increaseStat("magic", 1)
    end
end

function character:drawPowerStat(index, x, y, menu)
    if index == 1 then
        local icon = Assets.getTexture("ui/menu/icon/diamond")
        Draw.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Diamondized", x, y, 0, 0.8, 1)
        love.graphics.print("Yes", x+130, y)
        return true
    elseif index == 2 then
        local icon = Assets.getTexture("ui/menu/icon/quirkyrpgwiththemesof")
        Draw.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Quirky", x, y)
        love.graphics.print("Uh...", x+130, y, 0, 0.9, 1)
        return true
    elseif index == 3 then
        local icon = Assets.getTexture("ui/menu/icon/fire")
        Draw.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Guts:", x, y)

        Draw.draw(icon, x+90, y+6, 0, 2, 2)
        Draw.draw(icon, x+110, y+6, 0, 2, 2)
        return true
    end
end

return character
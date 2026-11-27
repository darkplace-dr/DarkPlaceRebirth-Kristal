local character, super = Class(PartyMember, "calypso")

function character:init()
    super.init(self)

    self.name = "Calypso"

    self:setActor("calypso")
    self:setLightActor("kris_lw")   -- temporary
    self:setDarkTransitionActor("kris_dark_transition")   -- temporary

    self.level = 1
    self.title = "Captain\nSwings cutlass\nstrategically"

    self.soul_priority = 1
    self.soul_color = {0.8, 0, 1}
    self.soul_facing = "down"

    self.has_act = false
    self.has_spells = true

    self.has_xact = true
    self.xact_name = "C-Action"

    self.lw_portrait = "face/kris/neutral"   -- temporary

    self:addSpell("tide_break")
    self:addSpell("heal_wave")
    self:addSpell("headwind")

    self.health = 140

    self.stats = {
        health = 140,
        attack = 10,
        defense = 0,
        magic = 3
    }

    self.weapon_icon = "ui/menu/equip/cutlass"

    self:setWeapon("basic_cutlass")

    -- self.lw_weapon_default = "light/rope_sling"
    -- self.lw_armor_default = "light/bandage"

    self.color = {0.8, 0, 1}
    self.dmg_color = nil
    self.attack_bar_color = {0.8, 0, 1}
    self.attack_box_color = {255/255, 0, 182/255}
    self.xact_color = nil
	-- highlight color A
    self.highlight_color = ColorUtils.hexToRGB("#620089FF")
		-- highlight color B
    self.highlight_color_alt = ColorUtils.hexToRGB("#620089FF")

    self.menu_icon = "party/calypso/head"
    self.head_icons = "party/calypso/icon"
    self.name_sprite = "party/calypso/name"

    self.attack_sprite = "effects/attack/cut"
    self.attack_sound = "laz_c"
    self.attack_pitch = 1

    self.battle_offset = {2, 1}
    self.head_icon_offset = {0, -3}
    self.menu_icon_offset = nil
    self.icon_color = {255/255, 0, 182/255}

	self.graduate = false
    
    self.tv_name = "CSO"

    self.element = {
        "WATER",
        "WIND"
    }
    
    self.flags = {
        ["gold"] = 11240
    }
end

function character:getStarmanTheme() return "jamm" end  -- intended

function character:onLevelUp(level)
    self:increaseStat("health", 2)
    if level % 10 == 0 then
        self:increaseStat("attack", 1)
    end
end

function character:onLevelUpLVLib(level)
    self:increaseStat("health", 5)
    self:increaseStat("attack", 1)
    if level % 2 == 0 then
        self:increaseStat("defense", 1)
        self:increaseStat("magic", 1)
    end
end

function character:drawPowerStat(index, x, y, menu)
    if index == 1  then
        local icon = Assets.getTexture("ui/menu/icon/coin")
        love.graphics.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Gold", x, y, 0, 0.7, 1)
        love.graphics.print(self.flags["gold"], x+100, y)
        return true
    elseif index == 2 then
        local icon = Assets.getTexture("ui/menu/icon/magic")
        love.graphics.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Wind", x, y)
        love.graphics.print("28MPH", x+100, y, 0)
        return true
    elseif index == 3 then
        local icon = Assets.getTexture("ui/menu/icon/fire")
        love.graphics.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Guts:", x, y)

        love.graphics.draw(icon, x+90, y+6, 0, 2, 2)
        love.graphics.draw(icon, x+110, y+6, 0, 2, 2)
        love.graphics.draw(icon, x+130, y+6, 0, 2, 2)

        return true
    end
end

function character:getGameOverMessage(main)
    return {
        "Argh, we'll be alright...",
        main:getName()..",[wait:5]\nget back up!"
    }
end

return character

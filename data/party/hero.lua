local character, super = Class(PartyMember, "hero")

function character:init()
    super.init(self)

    self.name = "Hero"

    self:setActor("hero")
    self:setLightActor("hero_lw")
    self:setDarkTransitionActor("kris_dark_transition") -- Placeholder

    self.love = 1
    self.level = self.love
    self.title = "Protagonist\nLeads in battle\nusing many ACTs."

    self.soul_priority = 2
    self.soul_color = {1, 0, 0}
    self.soul_facing = "up"

    self.has_act = true
    self.has_spells = true
    self.has_xact = false
    self.xact_name = "H-Action"
    self:addSpell("half-cify")
    self:addSpell("echo")	-- Nobody else should have this spell or it could break

    self.health = 90

    self.stats = {
        health = 90,
        attack = 14,
        defense = 3,
        magic = 0
    }
    self.max_stats = {}

    self.weapon_icon = "ui/menu/equip/sword"

    self:setWeapon("chosen_blade")

    self.lw_weapon_default = "light/pencil"
    self.lw_armor_default = "light/bandage"
    self.lw_portrait = "face/hero/neutral_closed"

    self.color = {1, 0.5, 0}
    self.dmg_color = {1, 0.5, 0.25}
    self.attack_bar_color = {1, 0.75, 0}
    self.attack_box_color = {1, 0.5, 0}
    self.xact_color = {1, 0.5, 0}

    self.icon_color = {1, 127/255, 39/255}

    self.menu_icon = "party/hero/head"
    self.head_icons = "party/hero/icon"
    self.name_sprite = "party/hero/name"

    self.attack_sprite = "effects/attack/cut"
    self.attack_sound = "laz_c"
    self.attack_pitch = 1

    self.battle_offset = {2, 1}
    self.head_icon_offset = {0, -3}
    self.menu_icon_offset = {3, 0}

    self.gameover_message = nil

    self.flags = {
        ["karma"] = 0
    }

    self.tv_name = "HRO"

    self.can_lead = true
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
        love.graphics.print("Karma:", x, y)
        love.graphics.print(self:getFlag("karma"), x+130, y)
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

function character:getTitle()
    local karma = self:getFlag("karma")
    if karma <= -100 then
        return "LV"..self.level.." Protagonist\nGets stronger\nat all costs."
    elseif karma >= 100 then
        return "LV"..self.level.." Protagonist\nSpares their foes\nusing many ACTs."
    else
        return "LV"..self.level.." Protagonist\nLeads in battle\nusing many ACTs."
    end
end

function character:getActor(light)
    if not Game.world or not Game.world.map then return super.getActor(self, light) end
    if light == nil then
        light = Game.light
    end
    local map = Game.world.map
    if map.data and map.data.properties.blue_skies then
        return "hero_sfb"
    end

    if light then
        return self.lw_actor or self.actor
    else
        return self.actor
    end
end

function character:addKarma(ammount)
    local newkarma = self:getFlag("karma") + ammount
    if newkarma > 100 then newkarma = 100 end
    if newkarma < -100 then newkarma = -100 end
    self:setFlag("karma", newkarma)
end

function character:onTurnStart(battler)
    if self:checkWeapon("harvester") and not Game:getFlag("IDLEHEALDOESNTWORK") then
        self:heal(9)
    end
    if Game:getFlag("LastTurnJJ") then
        Game:setFlag("LastTurnJJ", false)
    else
        Game:setFlag("JJS1", false)
        Game:setFlag("JJS2", false)
        Game:setFlag("JJS3", false)
        Game:setFlag("JJS4", false)
    end
end

return character

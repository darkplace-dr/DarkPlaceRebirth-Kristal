local character, super = Class(PartyMember, "suzy")

function character:init()
    super.init(self)

    self.name = "Suzy"

    self:setActor("suzy")
    self:setLightActor("suzy_lw")
    self:setDarkTransitionActor("suzy_lw") --"suzy_dark_transition"

    self.lw_portrait = nil
    self.love = 1
    self.level = 1

    self.title = "Man, I should really put text here."

    self.soul_priority = 1

    self.soul_color = {1, 1, 1}

    self.soul_facing = "down"

    self.has_act = false
    self.has_spells = true

    self.has_xact = true

    self.xact_name = "S-Action"

    self.health = 110

    self.stats = {
        health = 110,
        attack = 10,
        defense = 2,
        magic = 4
    }
    self.max_stats = {}

    self.weapon_icon = "ui/menu/equip/axe"

    self.lw_weapon_default = "light/pencil"
    self.lw_armor_default = "light/bandage"

    self:setWeapon("the_angles_bane")

    self.lw_health = 30

    self.lw_stats = {
        health = 25,
        attack = 11,
        defense = 12,
        magic = 5
    }

    self.color = {0.7, 0.3, 0.8}

    self.dmg_color = {0.8, 0.6, 0.8}

    self.attack_bar_color = self.color

    self.attack_box_color = {0.6, 0.2, 0.6}

    self.xact_color = {0.7, 0.3, 0.8}

    self.menu_icon = "party/susie/head"
    self.head_icons = "party/susie/icon"
    self.name_sprite = "party/suzy/name"

    self.attack_sprite = "effects/attack/mash"
    self.attack_sound = "laz_c"
    self.attack_pitch = 0.9

    self.battle_offset = {3, 1}

    self.head_icon_offset = nil

    self.menu_icon_offset = nil

    self.gameover_message = nil

    self:addSpell("tattle")
    self:addSpell("half-cify")
    self:addSpell("mend")
end

-- add later:

--[[function character:onTurnStart(battler)
    if not self:getFlag("trust_hero") then
        local enemy = Game.battle:getActiveEnemies()[1]
        if enemy.mercy == 100 then
            Game.battle:pushForcedAction(battler, "SPARE", Game.battle:getActiveEnemies()[1])
        elseif not enemy.tattled then
            local tattle = Registry.createSpell("tattle")
            Game.battle:pushForcedAction(battler, "SPELL", Game.battle:getActiveEnemies()[1], {data = tattle})
            enemy.tattled = true
        else
            Game.battle:pushForcedAction(battler, "XACT", Game.battle:getActiveEnemies()[1], {["name"] = "Standard"})
        end
    end
end]]

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
        "Now's not the\ntime for that!",
        main.name..",[wait:5]\nget up...!"
    }
end

function character:setArmor(i, item)

    local item = item

    if type(item) == "string" then
        item = Registry.createItem(item)
    end

    if item and item.id == "leadmaker" then
        item = Registry.createItem("broken_leadmaker")
    end

    self.equipped.armor[i] = item
end

function character:canEquip(item, slot_type, slot_index)
    if item then
        return super.canEquip(self, item, slot_type, slot_index)
    else
        local item
        if slot_type == "weapon" then
            item = self:getWeapon()
            return false
        elseif slot_type == "armor" then
            item = self:getArmor(slot_index)
            if not self:getArmor(slot_index) then
                return false
            end
        else
            return true
        end
        if Game.world.menu.suzy_complain and Game.world.menu.suzy_complain == 3 then
            return true
        end
        return false
    end
end

function character:getReaction(item, user)
    local menu = Game.world.menu

    if not menu then return "" end

    local selected = menu.box.selected_slot

    if item or user.id ~= self.id then
        return super.getReaction(self, item, user)
    elseif selected == 1 then
        return "I need that!"
    else
        if menu.suzy_complain then
            local comp = menu.suzy_complain
            if comp == 2 then
                menu.suzy_complain = 3
                return "... fine..."
            elseif comp == 3 then
                menu.suzy_complain = 1
                return "AGAIN!?"
            end
            menu.suzy_complain = 2
            return "Are you SURE...!?"
        else
            menu.suzy_complain = 1
            return "Do I HAVE to...?"
        end
    end
end

function character:drawPowerStat(index, x, y, menu)
    if index == 1 then
        local icon = Assets.getTexture("ui/menu/icon/demon")
        Draw.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Rudeness", x, y)
        love.graphics.print("99", x+130, y)
        return true
    elseif index == 2 then
        local icon = Assets.getTexture("ui/menu/icon/demon")
        Draw.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Crudeness", x, y, 0, 0.8, 1)
        love.graphics.print("100", x+130, y)
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

function character:lightLVStats()
    return {
        health = self:getLightLV() <= 20 and math.min(25 + self:getLightLV() * 5,99) or 25 + self:getLightLV() * 5,
        attack = 10 + self:getLightLV() * 2 + math.floor(self:getLightLV() / 4),
        defense = 9 + math.ceil(self:getLightLV() / 4),
        magic = math.ceil(self:getLightLV() / 4)
    }
end

function character:onLevelUpLVLib()
    self:increaseStat("health", 15)
    self:increaseStat("attack", 2)
    self:increaseStat("magic", 1)
    self:increaseStat("defense", 1)
end

function character:onTurnStart(battler)
    if self:checkWeapon("harvester") and not Game:getFlag("IDLEHEALDOESNTWORK") then
        self:heal(11)
    end
end

return character
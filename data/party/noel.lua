local character, super = Class(PartyMember, "noel")

function character:init()
    super.init(self)
    self.lw_portrait = "face/noel/neutral"
    self.lw_armor_default = nil

    self.set_buttons = {"magic", "item", "spare", "tension"}
    -- Display name
    self.name = "Noel"

    self.cm_draw = true --for the character select draw function

    -- Actor (handles sprites)
    self:setActor("noel")
    self:setDarkTransitionActor("noel")

    local lever = "-1"
    -- Display level (saved to the save file)
    self.level = lever
    -- Default title / class (saved to the save file)
    self.title = "Preist\nDoesn't understand\nhow his class works."

    -- Determines which character the soul comes from (higher number = higher priority)
    self.soul_priority = 0.1
    -- The color of this character's soul (optional, defaults to red)
    self.soul_color = {1, 1, 1}

    -- Whether the party member can act / use spells
    self.has_act = false
    self.has_spells = true

    -- Whether the party member can use their X-Action
    self.has_xact = true
    -- X-Action name (displayed in this character's spell menu)
    self.xact_name = "Noel-Act"

    -- Spells
    self:addSpell("spare_smack")
    self:addSpell("soul_send")
    self:addSpell("quick_heal")
    self:addSpell("life_steal")

    --self:addSpell("sirens_serenade")

    -- Current health (saved to the save file)
    self.health = 890
    self.lw_health = 890

    -- Base stats (saved to the save file)
    self.stats = {
        health = 900,
        attack = 1,
        defense = -100,
        magic = 1
    }

    -- Max stats from level-ups
    self.max_stats = {
        health = 900,
        attack = 1,
        defense = -100,
        magic = 1
    }

    self.lw_stats = {
        health = 900,
        attack = 11,
        defense = -90,
        magic = 1
    }

    self.lw_max_stats = {
        health = 900,
        attack = 11,
        defense = -90,
        magic = 1
    }

    -- Weapon icon in equip menu
    self.weapon_icon = "ui/menu/equip/old_umbrella"

    self.lw_weapon_default = "light/old_umbrella"
    self.weapon_default = "old_umbrella"

    -- Character color (for action box outline and hp bar)
    self.color = {1, 1, 1}
    -- Damage color (for the number when attacking enemies) (defaults to the main color)
    self.dmg_color = {1, 1, 1}
    -- Attack bar color (for the target bar used in attack mode) (defaults to the main color)
    self.attack_bar_color = {1, 1, 1}
    -- Attack box color (for the attack area in attack mode) (defaults to darkened main color)
    self.attack_box_color = {1, 1, 1}
    self.xact_color = {1, 1, 1}

    self.icon_color = {150/255, 150/255, 150/255}

    -- Head icon in the equip / power menu
    self.menu_icon = "party/noel/head"
    -- Path to head icons used in battle
    self.head_icons = "party/noel/icon"
    -- Name sprite (optional)
    --self.name_sprite = "party/noel/name"

    -- Effect shown above enemy after attacking it
    --self.attack_sprite = "effects/attack/slap_n"
    -- Sound played when this character attacks
    self.attack_sound = "laz_c"
    -- Pitch of the attack sound
    self.attack_pitch = 0.8
    -- Battle position offset (optional)
    self.battle_offset = {0, 0}
    -- Head icon position offset (optional)
    self.head_icon_offset = nil
    -- Menu icon position offset (optional)
    self.menu_icon_offset = nil

    -- Message shown on gameover (optional)
    self.gameover_message = nil

    local save = Noel:loadNoel()
    if save and not Kristal.temp_save == true then
            self:loadEquipment(save.Equipped)
        self.health = save.Health
        self.lw_health = save.Health
    else
        self:setWeapon("old_umbrella")
        self:setArmor(1, "ironshackle")
    end

    self.kills = 0

    self.opinions = {}
    self.default_opinion = 0

    self.pain_img = Assets.getTexture("ui/menu/icon/pain")

    self.tv_name = "NUL"

    self.can_lead = false
end

function character:getTitle()
    local save = Noel:loadNoel()
    local prefix = "LV"..self:getLevel().." "
    if Noel:isDess() then
        local meth = math.random(1, 15)
        if meth == 1 then
            return prefix.."Preist\nDoesn't understand\nhow his class works."
        else
            return prefix.."Preist\nDoesn't understand\nhow her class works."
        end
    else
        return prefix..""..self.title
    end
end

function character:getName()
    local save = Noel:loadNoel()
    if Noel:isDess() then
        local meth = math.random(1, 15)
        if meth == 9 then
            return "dess"
        else
            return "Noel"
        end
    else
        return "Noel"
    end
end

function character:onLightLevelUp(level) end --do not remove this or noel will not work in light battles 

function character:getLevel()
    return -1
end

function character:getLOVE()
    return -1
end

function character:PainStat(y)
    local i = y

    Draw.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 18,145, 190,30)

    if math.random(1, 10) == 1 then
        love.graphics.rectangle("fill", -9,145, 30,30)
        Draw.setColor(1, 1, 1, 1)
        Draw.draw(self.pain_img, -8, i + 6, 0, 2, 2)
    end

    Draw.setColor(1, 1, 1, 1)

    love.graphics.print("Pain:", 18, i)

    love.graphics.print("x", 134, i)

    local n = 2

    local x, y = math.random(n, -n), math.random(n, -n)
    love.graphics.print("1", 148 + x, i + y)

    local x, y = math.random(n, -n), math.random(n, -n)
    love.graphics.print("0", 162 + x, i + y)
end

function character:drawPowerStat(index, x, y, menu)
    self:PainStat(143)
end

function character:drawEquipStat(menu)
    self:PainStat(145)
end


function character:getGameOverMessage(main)
    --local save = Noel:loadNoel()
    ---assert(save)
    return {
        "oh...[wait:5]\nYou died...",
        Game.save_name.."...\n[wait:10]It's your call.",
        "Will you load your last save?"
    }
end

--function character:n()

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
    }

    local save = Noel:loadNoel()

    if Kristal.temp_save == true then
    elseif save and Game:hasPartyMember("noel") then
        local num = love.math.random(1, 999999)
        Game:setFlag("noel_SaveID", num)
        local newData = {
            Attack = self.stats.attack,
            Magic = self.stats.magic,
            MaxHealth = self.stats.health,
            Health = self.health,
            Defense = self.stats.defense,
            Equipped = self:saveEquipment(),
            Spells = self:saveSpells(),
            Level = self.level,
            Kills = self.kills,
            flags = save.flags or {}
        }    

        Noel:saveNoel(newData)

        local left_behind = Game:getFlag("noel_at")

            local maptable ={
                SaveID = num,
                Map = Game.world.map.id,
                Mod = Mod.info.id
            }

            Noel:saveNoel(maptable)

    end


    self:onSave(data)
    return data
end



function character:getReaction(item, user)
    local menu = Game.world.menu
    if not menu then return "" end
    local selected = menu.box.selected_slot
    if item or user.id ~= self.id then
        return super.getReaction(self, item, user)
    elseif selected == 1 then
        return "Outstanding move."
    elseif not self:getArmor(selected - 1) then
        return "You want me to swap nothing with nothing?"
    end
end
function character:load(data)

    local save = Noel:loadNoel()
    local save_stat = {}
    local lw_save_stat = {}
    if save then
        save_stat = {
            health = save.MaxHealth,
            attack = save.Attack,
            defense = save.Defense,
            magic = save.Magic
        }
        lw_save_stat = {
            health = save.MaxHealth,
            attack = save.Attack + 10,
            defense = save.Defense + 10,
            magic = save.Magic
        }
    end

    self.title = data.title or self.title

    if save then
        self.stats = save_stat or data.stats or self.stats
        self.health = save.Health or data.health or self:getStat("health", 0, false)
        if data.spells then
            self:loadSpells(save.Spells)
        end

        self.kills = save.Kills or self.kills

        self:loadEquipment(save.Equipped)

        self.level = save.Level or data.level or self.level
        self.lw_lv = save.Level or data.lw_lv or self.lw_lv
        self.lw_exp = data.lw_exp or self.lw_exp
        self.lw_stats = lw_save_stat or data.lw_stats or self.lw_stats
        self.flags = data.flags or self.flags
        self.lw_health = save.Health or data.lw_health or self:getStat("health", 0, true)
        if not Noel:getFlag("FUN") then
            Noel:setFlag("FUN", Game:getFlag("FUN", 11))
        end
    else
        self.stats = data.stats or self.stats
        self.health = data.health or self:getStat("health", 0, false)
        if data.spells then
            self:loadSpells(data.spells)
        end
        if data.equipped then
            self:loadEquipment(data.equipped)
        end
        self.level = data.level or self.level
        self.lw_lv = data.lw_lv or self.lw_lv
        self.lw_exp = data.lw_exp or self.lw_exp
        self.lw_stats = data.lw_stats or self.lw_stats
        self.flags = data.flags or self.flags
        self.lw_health = data.lw_health or self:getStat("health", 0, true)
    end

    self:onLoad(data)

    if Kristal.temp_save == true then
        Kristal.temp_save = nil
    end

    if self:hasSpell("sirens_serenade") then
        self:removeSpell("sirens_serenade")
    end
end

function character:CharacterMenuDraw()

    local party = self
	local x = 330
	love.graphics.print("ATK "..party.stats["attack"], x, 310)
	love.graphics.print("PAIN x10", x, 342)
	love.graphics.print("MAG "..party.stats["magic"], x, 374)

	x = 420

	love.graphics.print("HP "..party.health.."/"..party.stats["health"], x, 310)
	love.graphics.print("   LOVE -1", x, 342)
	love.graphics.print("KILLS "..party.kills, x, 374)
end

return character
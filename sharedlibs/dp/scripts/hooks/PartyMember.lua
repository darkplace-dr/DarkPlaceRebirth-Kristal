---@class PartyMember : PartyMember
local PartyMember, super = HookSystem.hookScript(PartyMember)

function PartyMember:init()
    super.init(self)
    self.flee_text = {}

    self.has_command = false

    -- Combos
    self.combos = {}

    self.love = 1
    self.exp = 0
    self.max_exp = 99999
    self.kills = 0

    -- Party member specific EXP requirements
    -- The size of this table is the max LV
    self.exp_needed = {
        [ 1] = 0,
        [ 2] = 10,
        [ 3] = 30,
        [ 4] = 70,
        [ 5] = 120,
        [ 6] = 200,
        [ 7] = 300,
        [ 8] = 500,
        [ 9] = 800,
        [10] = 1200,
        [11] = 1700,
        [12] = 2500,
        [13] = 3500,
        [14] = 5000,
        [15] = 7000,
        [16] = 10000,
        [17] = 15000,
        [18] = 25000,
        [19] = 50000,
        [20] = 99999
    }

    self.future_heals = {}

    self.opinions = {}
    self.default_opinion = 50

    -- whether or not the next attack should be reflected
    self.reflectNext = false

    -- did this character graduate high school?
    self.graduate = false

    -- their TV name
    self.tv_name = nil

    -- Whether or not this party member can be the leader.
    self.can_lead = true
end

function PartyMember:getStarmanTheme() return "default" end

function PartyMember:getTVName()
    if self.tv_name then return self.tv_name end
    local first_three = string.sub(self.name, 1, 3)
    return string.upper(first_three)
end

function PartyMember:onTurnStart(battler)
    if not self.equipped.weapon then
        return
    end
    -- Turn start healing
    local turnHealing = 0
    turnHealing = turnHealing + self.equipped.weapon.turn_heal
    for i, v in ipairs(self.equipped.armor) do
        turnHealing = turnHealing + v.turn_heal
    end
    if turnHealing > 0 and Game.battle.turn_count > 1 then
        battler:heal(turnHealing)
    end
end

--- *(Override)* Called upon completion of this character's arc
function PartyMember:onArc() end

function PartyMember:convertToLight()
    local last_weapon = self:getWeapon() and self:getWeapon().id or false
    local last_armors = {self:getArmor(1) and self:getArmor(1).id or false, self:getArmor(2) and self:getArmor(2).id or false}

    self.equipped = {weapon = nil, armor = {}}

    if self:getFlag("light_weapon") then
        self.equipped.weapon = Registry.createItem(self:getFlag("light_weapon"))
    end
    if self:getFlag("light_armor") then
        self.equipped.armor[1] = Registry.createItem(self:getFlag("light_armor"))
    end

    if self:getFlag("light_weapon") == nil then
        self.equipped.weapon = self.lw_weapon_default and Registry.createItem(self.lw_weapon_default) or nil
    end
    if self:getFlag("light_armor") == nil then
        self.equipped.armor[1] = self.lw_armor_default and Registry.createItem(self.lw_armor_default) or nil
    end

    --if Kristal.getLibConfig("magical-glass", "equipment_conversion") then
        if last_weapon then
            local result = Registry.createItem(last_weapon):convertToLightEquip(self)
            if result then
                if type(result) == "string" then
                    result = Registry.createItem(result)
                end
                if isClass(result) and self:canEquip(result, "weapon", 1) and self.equipped.weapon and self.equipped.weapon.dark_item and self.equipped.weapon.equip_can_convert ~= false then
                    self.equipped.weapon = result
                end
            end
        end
        local converted = false
        for i = 1, 2 do
            if last_armors[i] then
                local result = Registry.createItem(last_armors[i]):convertToLightEquip(self)
                if result then
                    if type(result) == "string" then
                        result = Registry.createItem(result)
                    end
                    if isClass(result) and self:canEquip(result, "armor", 1) and (self.equipped.armor[1] and (self.equipped.armor[1].equip_can_convert or self.equipped.armor[1].id == result.id) or not self.equipped.armor[1]) then
                        if self:getFlag("converted_light_armor") == nil then
                            if self.equipped.armor[1] and self.equipped.armor[1].id == result.id then
                                self:setFlag("converted_light_armor", "light/bandage")
                            else
                                self:setFlag("converted_light_armor", self.equipped.armor[1] and self.equipped.armor[1].id or "light/bandage")
                            end
                        end
                        converted = true
                        self.equipped.armor[1] = result
                        break
                    end
                end
            end
        end
        if not converted and self:getFlag("converted_light_armor") ~= nil then
            self.equipped.armor[1] = self:getFlag("converted_light_armor") and Registry.createItem(self:getFlag("converted_light_armor")) or nil
            self:setFlag("converted_light_armor", nil)
        end
    --end

    self:setFlag("dark_weapon", last_weapon)
    self:setFlag("dark_armors", last_armors)

    if Game:getConfig("healthConversion") then
        self.lw_health = math.ceil((self.health / self:getStat("health", 1, false)) * self:getStat("health", 1, true))
    else
        -- The formula is broken in chapters 1 & 3.
        self.lw_health = math.ceil(self.health / self:getStat("health", 1, false)) * self:getStat("health", 1, true)
    end

    if self.lw_health <= 0 then
        self.lw_health = 1
    end
end

function PartyMember:convertToDark()
    local last_weapon = self:getWeapon() and self:getWeapon().id or false
    local last_armor = self:getArmor(1) and self:getArmor(1).id or false

    self.equipped = {weapon = nil, armor = {}}

    if self:getFlag("dark_weapon") then
        self.equipped.weapon = Registry.createItem(self:getFlag("dark_weapon"))
    end
    for i = 1, 2 do
        if self:getFlag("dark_armors") and self:getFlag("dark_armors")[i] then
            self.equipped.armor[i] = Registry.createItem(self:getFlag("dark_armors")[i])
        end
    end

    --if Kristal.getLibConfig("magical-glass", "equipment_conversion") then
        if last_weapon then
            local result = Registry.createItem(last_weapon).dark_item
            if result then
                if type(result) == "string" then
                    result = Registry.createItem(result)
                end
                if isClass(result) and self:canEquip(result, "weapon", 1) and self.equipped.weapon and self.equipped.weapon:convertToLightEquip(self) and self.equipped.weapon.equip_can_convert ~= false then
                    self.equipped.weapon = result
                end
            end
        end
        if last_armor then
            local result = Registry.createItem(last_armor).dark_item
            if result then
                if type(result) == "string" then
                    result = Registry.createItem(result)
                end
                if isClass(result) then
                    local slot
                    for i = 1, 2 do
                        if self:canEquip(result, "armor", i) then
                            slot = i
                            break
                        end
                    end
                    if slot then
                        if self:getFlag("converted_light_armor") == nil then
                            self:setFlag("converted_light_armor", "light/bandage")
                        end
                        local already_equipped = false
                        for i = 1, 2 do
                            if self.equipped.armor[i] and (self.equipped.armor[i].id == result.id or self.equipped.armor[i].equip_can_convert == false) then
                                already_equipped = true
                            end
                        end
                        if not already_equipped then
                            for i = 1, 2 do
                                if self.equipped.armor[i] then
                                    Game.inventory:addItem(self.equipped.armor[i].id)
                                end
                                self.equipped.armor[i] = nil
                            end
                            self.equipped.armor[slot] = result
                        end
                    end
                end
            else
                for i = 1, 2 do
                    if self:getFlag("converted_light_armor") ~= nil and self.equipped.armor[i] and self.equipped.armor[i]:convertToLightEquip(self) then
                        self.equipped.armor[i] = nil
                        self:setFlag("converted_light_armor", nil)
                        break
                    end
                end
            end
        end
    --end

    self:setFlag("light_weapon", last_weapon)
    self:setFlag("light_armor", last_armor)

    if Game:getConfig("healthConversion") then
        self.health = math.ceil((self.lw_health / self:getStat("health", 1, true)) * self:getStat("health", 1, false))
    else
        -- The formula is broken in chapters 1 & 3.
        self.health = math.ceil(self.lw_health / self:getStat("health", 1, true)) * self:getStat("health", 1, false)
    end

    if self.health <= 0 then
        self.health = 1
    end
end

function PartyMember:getSoulFacing() return self.soul_facing or "down" end

function PartyMember:drawEquipStat(menu) end

function PartyMember:onSave(data)
    data.opinions = self.opinions

    data.exp = self.exp
    data.love = self.love
       
    data.combos = self:saveCombos()
end

function PartyMember:onLoad(data)
    self.opinions = data.opinions or self.opinions

    self.exp = data.exp or self.exp
    self.love = data.love or self.love
       
    self:loadCombos(data.combos or {})
end

function PartyMember:getStarmanTheme() return "default" end

---@return number x
---@return number y
function PartyMember:getNameOffset() return unpack(self.name_offset or {0, 0}) end
function PartyMember:getFleeText() return self.flee_text end

--- Returns the min
---@return string?
function PartyMember:getAssistID()
    return nil
end

function PartyMember:getAssistColor()
    return self:getColor()
end

function PartyMember:getReaction(item, user)
    if item then
        return item:getReaction(user.id, self.id, self:getAssistID())
    end
end

function PartyMember:getCombos()
    return self.combos
end

function PartyMember:addCombo(combo)
    if type(combo) == "string" then
        combo = Registry.createCombo(combo)
    end
    table.insert(self.combos, combo)
end

function PartyMember:removeCombo(combo)
    for i,v in ipairs(self.combos) do
        if v == combo or (type(combo) == "string" and v.id == combo) then
            table.remove(self.combos, i)
            return
        end
    end
end

function PartyMember:hasCombo(combo)
    for i,v in ipairs(self.combos) do
        if v == combo or (type(combo) == "string" and v.id == combo) then
            return true
        end
    end
    return false
end

function PartyMember:replaceCombo(combo, replacement)
    local tempcombos = {}
    for _,v in ipairs(self.combos) do
        if v == combo or (type(combo) == "string" and v.id == combo) then
            table.insert(tempcombos, Mod:createCombo(replacement))
        else
            table.insert(tempcombos, v)
        end
    end
    self.combos = tempcombos
end

function PartyMember:saveCombos()
    local result = {}
    for _,v in pairs(self.combos) do
        table.insert(result, v.id)
    end
    return result
end

function PartyMember:loadCombos(data)
    self.combos = {}
    for _,v in ipairs(data) do
        self:addCombo(v)
    end
end

function PartyMember:getMaxShield()
    return self:getStat("health") / 2
end

function PartyMember:hasSkills()
	local has_stuff = 0
	if self:hasAct() then
		has_stuff = has_stuff + 1
	end
	if self:hasSpells() then
		has_stuff = has_stuff + 1
	end
	if #self.combos > 0 then
		has_stuff = has_stuff + 1
	end
    return (has_stuff > 1)
end

function PartyMember:getSkills()
    local color = {1, 1, 1, 1}
    for _,spell in ipairs(self:getSpells()) do
        if spell:hasTag("spare_tired") and spell:isUsable(spell) and spell:getTPCost(spell) <= Game:getTension() then
            local has_tired = false
            for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
                if enemy.tired then
                    has_tired = true
                    break
                end
            end
            if has_tired then
                color = {0, 178/255, 1, 1}
				if Game:getConfig("pacifyGlow") then
					color = function ()
                        return Utils.mergeColor({0, 0.7, 1, 1}, COLORS.white, 0.5 + math.sin(Game.battle.pacify_glow_timer / 4) * 0.5)
                    end
                end
            end
        end
    end
	local skills = {}
	if self:hasAct() then
		table.insert(skills, {"ACT", "Do all\nsorts of\nthings", nil, function() Game.battle:setState("ENEMYSELECT", "ACT") end})
	end
	if self:hasSpells() then
		table.insert(skills, {"Magic", "Cast\nSpells", color, function()
            Game.battle:clearMenuItems()

            -- First, register X-Actions as menu items.

            if Game.battle.encounter.default_xactions and self:hasXAct() then
                local spell = {
                    ["name"] = Game.battle.enemies[1]:getXAction(self.battler),
                    ["target"] = "xact",
                    ["id"] = 0,
                    ["default"] = true,
                    ["party"] = {},
                    ["tp"] = 0
                }

                Game.battle:addMenuItem({
                    ["name"] = self:getXActName() or "X-Action",
                    ["tp"] = 0,
                    ["color"] = {self:getXActColor()},
                    ["data"] = spell,
                    ["callback"] = function(menu_item)
                        Game.battle.selected_xaction = spell
                        Game.battle:setState("ENEMYSELECT", "XACT")
                    end
                })
            end

            for id, action in ipairs(Game.battle.xactions) do
                if action.party == self.id then
                    local spell = {
                        ["name"] = action.name,
                        ["target"] = "xact",
                        ["id"] = id,
                        ["default"] = false,
                        ["party"] = {},
                        ["tp"] = action.tp or 0
                    }

                    Game.battle:addMenuItem({
                        ["name"] = action.name,
                        ["tp"] = action.tp or 0,
                        ["description"] = action.description,
                        ["color"] = action.color or {1, 1, 1, 1},
                        ["data"] = spell,
                        ["callback"] = function(menu_item)
                            Game.battle.selected_xaction = spell
                            Game.battle:setState("ENEMYSELECT", "XACT")
                        end
                    })
                end
            end

            -- Now, register SPELLs as menu items.
            for _,spell in ipairs(self:getSpells()) do
                local color = spell.color or {1, 1, 1, 1}
                if spell:hasTag("spare_tired") then
                    local has_tired = false
                    for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
                        if enemy.tired then
                            has_tired = true
                            break
                        end
                    end
                    if has_tired then
                        color = {0, 178/255, 1, 1}
						if Game:getConfig("pacifyGlow") then
							color = function ()
								return Utils.mergeColor({0, 0.7, 1, 1}, COLORS.white, 0.5 + math.sin(Game.battle.pacify_glow_timer / 4) * 0.5)
							end
						end
                    end
                end
                Game.battle:addMenuItem({
                    ["name"] = spell:getName(),
                    ["tp"] = spell:getTPCost(self),
                    ["unusable"] = not spell:isUsable(self),
                    ["description"] = spell:getBattleDescription(),
                    ["party"] = spell.party,
                    ["color"] = color,
                    ["data"] = spell,
                    ["callback"] = function(menu_item)
                        Game.battle.selected_spell = menu_item

                        if not spell:getTarget() or spell:getTarget() == "none" then
                            Game.battle:pushAction("SPELL", nil, menu_item)
                        elseif spell:getTarget() == "ally" then
                            Game.battle:setState("PARTYSELECT", "SPELL")
                        elseif spell:getTarget() == "enemy" then
                            Game.battle:setState("ENEMYSELECT", "SPELL")
                        elseif spell:getTarget() == "party" then
                            Game.battle:pushAction("SPELL", Game.battle.party, menu_item)
                        elseif spell:getTarget() == "enemies" then
                            Game.battle:pushAction("SPELL", Game.battle:getActiveEnemies(), menu_item)
                        end
                    end
                })
            end

            Game.battle:setState("MENUSELECT", "SPELL")
        end})
	end
	if #self.combos > 0 then
		table.insert(skills, {"Combos", "Multi\nParty\nAction", nil, function()
            Game.battle:clearMenuItems()

            -- Now, register SPELLs as menu items.
            for _,combo in ipairs(self:getCombos()) do
                Game.battle:addMenuItem({
                    ["name"] = combo:getName(),
                    ["tp"] = combo:getTPCost(self),
                    ["unusable"] = not combo:isUsable(self),
                    ["description"] = combo:getBattleDescription(),
                    ["party"] = combo.party,
                    ["color"] = {1, 1, 1, 1},
                    ["data"] = combo,
                    ["callback"] = function(menu_item)
						Game.battle.selected_combo = menu_item

                        if not combo:getTarget() or combo:getTarget() == "none" then
                            Game.battle:pushAction("COMBO", nil, menu_item)
                        elseif combo:getTarget() == "ally" then
                            Game.battle:setState("PARTYSELECT", "COMBO")
                        elseif combo:getTarget() == "enemy" then
                            Game.battle:setState("ENEMYSELECT", "COMBO")
                        elseif combo:getTarget() == "party" then
                            Game.battle:pushAction("COMBO", Game.battle.party, menu_item)
                        elseif combo:getTarget() == "enemies" then
                            Game.battle:pushAction("COMBO", Game.battle:getActiveEnemies(), menu_item)
                        end
                    end
                })
            end

            Game.battle:setState("MENUSELECT", "COMBO")
        end})
	end
    return skills
end

function PartyMember:hasLightSkills()
    return (self:hasAct() and self:hasSpells())
end

function PartyMember:getLightSkills()
    local color = {1, 1, 1, 1}
    for _,spell in ipairs(self:getSpells()) do
        if spell:hasTag("spare_tired") and spell:isUsable(spell) and spell:getTPCost(spell) <= Game:getTension() then
            local has_tired = false
            for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
                if enemy.tired then
                    has_tired = true
                    break
                end
            end
            if has_tired then
                color = {0, 178/255, 1, 1}
				if Game:getConfig("pacifyGlow") then
					color = function ()
                        return Utils.mergeColor({0, 0.7, 1, 1}, COLORS.white, 0.5 + math.sin(Game.battle.pacify_glow_timer / 4) * 0.5)
                    end
                end
            end
        end
    end
    return {
        {"ACT", "Do all\nsorts of\nthings", nil, function() Game.battle:setState("ENEMYSELECT", "ACT") end},
        {"Spell", Kristal.getLibConfig("library_main", "magic_description") or "Cast\nSpells", color, function()
            Game.battle:clearMenuItems()
			Game.battle.current_menu_columns = 2
			Game.battle.current_menu_rows = 3

			if Game.battle.encounter.default_xactions and Game.battle.party[1].chara:hasXAct() then
				local spell = {
					["name"] = Game.battle.enemies[1]:getXAction(Game.battle.party[1]),
					["target"] = "xact",
					["id"] = 0,
					["default"] = true,
					["party"] = {},
					["tp"] = 0
				}

				Game.battle:addMenuItem({
					["name"] = Game.battle.party[1].chara:getXActName() or "X-Action",
					["tp"] = 0,
					["color"] = { Game.battle.party[1].chara:getXActColor() },
					["data"] = spell,
					["callback"] = function(menu_item)
						Game.battle.selected_xaction = spell
						Game.battle:setState("ENEMYSELECT", "XACT")
					end
				})
			end

			for id, action in ipairs(Game.battle.xactions) do
				if action.party == Game.battle.party[1].chara.id then
					local spell = {
						["name"] = action.name,
						["target"] = "xact",
						["id"] = id,
						["default"] = false,
						["party"] = {},
						["tp"] = action.tp or 0
					}

					Game.battle:addMenuItem({
						["name"] = action.name,
						["tp"] = action.tp or 0,
						["description"] = action.description,
						["color"] = action.color or { 1, 1, 1, 1 },
						["data"] = spell,
						["callback"] = function(menu_item)
							Game.battle.selected_xaction = spell
							Game.battle:setState("ENEMYSELECT", "XACT")
						end
					})
				end
			end

			-- Now, register SPELLs as menu items.
			for _, spell in ipairs(Game.battle.party[1].chara:getSpells()) do
				local color = spell.color or { 1, 1, 1, 1 }
				if spell:hasTag("spare_tired") then
					local has_tired = false
					for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
						if enemy.tired then
							has_tired = true
							break
						end
					end
					if has_tired then
						color = { 0, 178 / 255, 1, 1 }
						if Game:getConfig("pacifyGlow") then
							color = function ()
								return Utils.mergeColor({0, 0.7, 1, 1}, COLORS.white, 0.5 + math.sin(Game.battle.pacify_glow_timer / 4) * 0.5)
							end
						end
					end
				end
				Game.battle:addMenuItem({
					["name"] = spell:getName(),
					["tp"] = spell:getTPCost(Game.battle.party[1].chara),
					["unusable"] = not spell:isUsable(Game.battle.party[1].chara),
					["description"] = spell:getBattleDescription(),
					["party"] = spell.party,
					["color"] = color,
					["data"] = spell,
					["callback"] = function(menu_item)
						Game.battle.selected_spell = menu_item

						if not spell:getTarget() or spell:getTarget() == "none" then
							Game.battle:pushAction("SPELL", nil, menu_item)
						elseif spell:getTarget() == "ally" and #Game.battle.party == 1 then
							Game.battle:pushAction("SPELL", Game.battle.party[1], menu_item)
						elseif spell:getTarget() == "ally" then
							Game.battle:setState("PARTYSELECT", "SPELL")
						elseif spell:getTarget() == "enemy" then
							Game.battle:setState("ENEMYSELECT", "SPELL")
						elseif spell:getTarget() == "party" then
							Game.battle:pushAction("SPELL", Game.battle.party, menu_item)
						elseif spell:getTarget() == "enemies" then
							Game.battle:pushAction("SPELL", Game.battle:getActiveEnemies(), menu_item)
						end
					end
				})
			end

			Game.battle:setState("MENUSELECT", "SPELL")
        end}
    }
end

function PartyMember:getStat(name, default, light)
    local stat = super.getStat(self, name, default, light)
    if name == "attack" then
        local success, amount = self:checkArmor("master_medallion")
        stat = stat * (2^amount)
    end
    return stat
end

function PartyMember:getLevel()
    return self.level
end

function PartyMember:getLOVE()
    return self.love
end

function PartyMember:addExp(amount)
    self.exp = Utils.clamp(self.exp + amount, 0, self.max_exp)

    local leveled_up = false
    while self.exp >= self:getNextLvRequiredEXP() and self.love < #self.exp_needed do
        leveled_up = true
        self.love = self.love + 1
        self:onLevelUpLVLib(self.love)
    end

    return leveled_up
end

function PartyMember:onLevelUpLVLib(level)
    self:increaseStat("health", 10)
    self:increaseStat("attack", 2)
    self:increaseStat("defense", 2)
end

function PartyMember:getExp()
    return self.exp
end

function PartyMember:getNextLvRequiredEXP()
    return self.exp_needed[self.love + 1] or 0
end

function PartyMember:getNextLv()
    return Utils.clamp(self:getNextLvRequiredEXP() - self.exp, 0, self.max_exp)
end

function PartyMember:getCommandOptions()
    return {"FIGHT", "ACT", "MAGIC"}, {"ITEM", "SPARE", "DEFEND"}
end

--- Called whenever a HealItem is used. \
--- Calculates the amount of healing an item should apply based on the character's healing bonuses.
---@param amount integer The amount of base healing for the item.
---@param item any The HealItem that is being used.
function PartyMember:applyHealBonus(amount, item)
    -- Check to see whether this item allows heal bonuses, return original amount if it does not.
    if item.block_heal_bonus then
        return amount
    end
    
    -- Doesn't apply bonuses if the original heal amount is 0 or less, unless the config overrides this behaviour.
    if amount <= 0 and not Kristal.getLibConfig("pie", "alwaysApplyHealBonus", true) then
        return amount
    end
    
    local equipment = self:getEquipment()
    local final_amount = amount
    local multiplier = 1
    local bonus = 0

    -- Gathers all the heal bonuses from the character's equipment.
    for _,equipitem in ipairs(equipment) do
        if equipitem:includes(Item) then
            multiplier = multiplier * equipitem:getHealMultiplier(self, item)
            bonus = bonus + equipitem:getHealBonus(self, item)
        end
    end

    -- Applies the heal bonus, based on the order set in the config.
    if Kristal.getLibConfig("pie", "healMultiplierTakesPriority", true) then
        final_amount = (final_amount * multiplier) + bonus
    else
        final_amount = (final_amount + bonus) * multiplier
    end

    return math.floor(final_amount)
end

--- Registers a future heal for this party member.
---@param amount integer Amount of HP to restore.
---@param turns integer Amount of turns this heal happens in.
function PartyMember:addFutureHeal(amount, turns)
    table.insert(self.future_heals, {amount = amount, turns = turns})
end

--- Callback for when a future heal activates. \
--- If this function returns `true`, the future heal will be cancelled.
---@param amount integer The amount of HP restored by this heal.
---@param battler PartyBattler The PartyBattler associated with this character.
function PartyMember:onFutureHeal(amount, battler) end

---@param other_party string|PartyMember
function PartyMember:getOpinion(other_party)
    if type(other_party) == "table" and other_party:includes(PartyMember) then
        other_party = other_party.id
    end
    if self.opinions[other_party] ~= nil then return self.opinions[other_party] end
    return self.default_opinion
end

---@param other_party string|PartyMember
function PartyMember:setOpinion(other_party, amount)
    if type(other_party) == "table" and other_party:includes(PartyMember) then
        other_party = other_party.id
    end
    self.opinions[other_party] = amount
    return amount
end

---@param other_party string|PartyMember
function PartyMember:addOpinion(other_party, amount)
    if type(other_party) == "table" and other_party:includes(PartyMember) then
        other_party = other_party.id
    end
    self.opinions[other_party] = self:getOpinion(other_party) + amount
    return self.opinions[other_party]
end

-- Completes a character's Arc
-- this is kind of lazy tbh but like sue me
--   -char
function PartyMember:completeArc()
    self:setFlag("arc", true)
    for i,v in pairs(self.stats) do
        if self.arcBonusStats and self.arcBonusStats[i] then
            self:increaseStat(i, self.arcBonusStats[i])
        end
    end
    self:onArc()
end

function PartyMember:canLead()
    return self.can_lead
end

function PartyMember:doBattleDescision(battler)
    return true
end

function PartyMember:canAutohealSwoon()
    return false
end

-- Should definitely return a small number. Should be single digit, if anything.
-- Or it can be negative if you wanna be sadistic. Not judging.
function PartyMember:autoHealSwoonAmount()
    return 0
end

return PartyMember

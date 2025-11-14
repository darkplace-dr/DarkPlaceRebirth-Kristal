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

    self.ribbit = false

    self.opinions = {}
    self.default_opinion = 50

    -- protection points for soul shield mechanic
    self.pp = 0

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

                        if not spell.target or spell.target == "none" then
                            Game.battle:pushAction("SPELL", nil, menu_item)
                        elseif spell.target == "ally" then
                            Game.battle:setState("PARTYSELECT", "SPELL")
                        elseif spell.target == "enemy" then
                            Game.battle:setState("ENEMYSELECT", "SPELL")
                        elseif spell.target == "party" then
                            Game.battle:pushAction("SPELL", Game.battle.party, menu_item)
                        elseif spell.target == "enemies" then
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

                        if not combo.target or combo.target == "none" then
                            Game.battle:pushAction("COMBO", nil, menu_item)
                        elseif combo.target == "ally" then
                            Game.battle:setState("PARTYSELECT", "COMBO")
                        elseif combo.target == "enemy" then
                            Game.battle:setState("ENEMYSELECT", "COMBO")
                        elseif combo.target == "party" then
                            Game.battle:pushAction("COMBO", Game.battle.party, menu_item)
                        elseif combo.target == "enemies" then
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

						if not spell.target or spell.target == "none" then
							Game.battle:pushAction("SPELL", nil, menu_item)
						elseif spell.target == "ally" and #Game.battle.party == 1 then
							Game.battle:pushAction("SPELL", Game.battle.party[1], menu_item)
						elseif spell.target == "ally" then
							Game.battle:setState("PARTYSELECT", "SPELL")
						elseif spell.target == "enemy" then
							Game.battle:setState("ENEMYSELECT", "SPELL")
						elseif spell.target == "party" then
							Game.battle:pushAction("SPELL", Game.battle.party, menu_item)
						elseif spell.target == "enemies" then
							Game.battle:pushAction("SPELL", Game.battle:getActiveEnemies(), menu_item)
						end
					end
				})
			end

			Game.battle:setState("MENUSELECT", "SPELL")
        end}
    }
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

return PartyMember

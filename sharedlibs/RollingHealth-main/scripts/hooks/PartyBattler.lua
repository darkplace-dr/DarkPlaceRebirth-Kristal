local PartyBattler, super = HookSystem.hookScript(PartyBattler)

local function map(tbl, func)
    local result = {}
    for index, value in ipairs(tbl) do
        result[index] = func(value, index)
    end
    return result
end

local function getConfig(name)
    return Kristal.getLibConfig("rolling-health", name)
end

function PartyBattler:init(chara,x,y)
    super.init(self,chara,x,y)

    self.health_rolling_to = self.chara:getHealth()
    self.health_rolling_last = self.health_rolling_to
    self.health_rolling_timer = 0
	self.health_rolling_swooned = false
end

function PartyBattler:removeHealth(amount, swoon, pierce)
	if self:canHealthRoll() then
		if Game.battle.superpower then return end
		if not pierce then
			if self.shield < amount then
				amount = amount - self.shield
				self.shield = 0
			else
				self.shield = self.shield - amount
				amount = 0
			end
		end
		if swoon then
			self.health_rolling_swooned = true
		end
		local health_roll_previous = self.health_rolling_to
		if (self.chara:getHealth() <= 0) then
			amount = MathUtils.round(amount / 4)
			self.health_rolling_to = self.health_rolling_to - amount
		else
			self.health_rolling_to = self.health_rolling_to - amount
		end
		self.health_rolling_to = math.max(self.health_rolling_to, 0)
		-- if self.health_rolling_to > self.chara:getHealth() and health_roll_previous < self.chara:getHealth() then
		--     self.health_rolling_timer = -getConfig("roll_delay")
		-- end
	else
		super.removeHealth(self, amount, swoon, pierce)
	end	
end

function PartyBattler:removeHealthBroken(amount, swoon)
	if self:canHealthRoll() then
		if Game.battle.superpower then return end
		self:removeHealth(amount, swoon)
	else
		super.removeHealthBroken(self, amount, swoon)
	end
end

function PartyBattler:canHealthRoll()
	return self.chara:checkArmor("life_odometer") and self.chara.id ~= "noel"
end

-- There are so many checks to do aeughghhghghghhgg
function PartyBattler:isHealthRolling()
    -- local current_action = Game.battle.current_actions[Game.battle.current_action_index]
    local current_action = Game.battle.current_processing_action

           -- Check if the health to roll to is different from the current health
    return MathUtils.round(self.health_rolling_to) ~= MathUtils.round(self.chara:getHealth()) and
           -- Check if the party member is not down
           not self.is_down and
           -- Check if the battle is not finished
           not Game.battle.victory and
           -- Check if the party member is not doing an action while their health is 1
           -- (So the party member's health will keep rolling but stops at 1 during an action)
           not
            (
                self.chara:getHealth() <= 1 and
                (
                    (
                        -- ACT/ITEM/SPARE/SPELL/SKILL
                        TableUtils.contains({"ACT", "ITEM", "SPARE", "SPELL", "SKILL"}, Game.battle.substate) and current_action and
                        (
                            -- Is the party member doing an action (ACT/ITEM/SPARE/SPELL)?
                            current_action.character_id == Game.battle:getPartyIndex(self.chara.id) or
                            -- Multi-ACT?
                            TableUtils.contains(current_action.party or {}, self.chara.id) or
                            -- Short ACT?
                            (
                                TableUtils.contains(Game.battle.short_actions, current_action) and
                                TableUtils.contains(map(Game.battle.short_actions, function (value)
                                    return value.character_id
                                end), self.chara.id)
                            )
                        )
                    ) or
                    (
                        -- Attacking
                        TableUtils.contains(Game.battle.attackers, self)
                    )
                )
            )
           and
           -- Check if halt_during_party_turn config is turned on and it is not the enemy's turn
           not (getConfig("halt_during_party_turn") and not Utils.containsValue({"DEFENDING", "DEFENDINGBEGIN", "DEFENDINGEND"}, Game.battle.state))
end

function PartyBattler:canTarget()
    -- Check if all party members received mortal damage
	if self:canHealthRoll() then
		local all_mortal_damage = true
		for _, battler in ipairs(Game.battle.party) do
			if battler.health_rolling_to > 0 then
				all_mortal_damage = false
				break
			end
		end
		return not self.is_down and
			   not (self.health_rolling_to <= 0 and not all_mortal_damage)
	else
		return super.canTarget(self)
	end
end

function PartyBattler:getRollSpeed()
    local speed_up = getConfig("speed_up")
    local current_health = self.chara:getHealth()
    local max_health = self.chara:getStat("health")
    local roll_speed = getConfig("roll_speed") *
                       math.pow(1 - speed_up, math.abs(self.health_rolling_to - current_health) / max_health)
    return roll_speed
end

function PartyBattler:update()
    super.update(self)

	if self:canHealthRoll() then
		self.health_rolling_timer = self.health_rolling_timer + DT
		local roll_speed = self:getRollSpeed()
		if self.health_rolling_swooned then
			roll_speed = 1/15
		end
		if self.health_rolling_timer > roll_speed then
			self.health_rolling_timer = self.health_rolling_timer - roll_speed
			local current_health = self.chara:getHealth()
			self.health_rolling_last = self.chara:getHealth()
			if self:isHealthRolling() then
				self.chara:setHealth(current_health + MathUtils.sign(self.health_rolling_to - current_health) * (self.health_rolling_swooned and 2 or 1))
				if self.chara:getHealth() <= 0 then
					local party_index = Game.battle:getPartyIndex(self.chara.id)
					local do_remove_table = Game.battle.current_selecting == party_index
					Game.battle:pushForcedAction(self, "SKIP")
					if do_remove_table then
						TableUtils.removeValue(Game.battle.selected_character_stack, party_index)
						table.remove(Game.battle.selected_action_stack, party_index)
					end
					if self.health_rolling_swooned then
						self.chara:setHealth(-999)
						self.health_rolling_to = self.chara:getHealth()
						self:statusMessage("msg", "swoon", nil, true)
						Assets.playSound("impact", 0.7)
						Assets.playSound("glassbreak", 0.7, 0.4)
						Assets.playSound("bageldefeat", 0.8, 0.8)
						Game.battle:shakeCamera(8)
					else
						self.chara:setHealth(MathUtils.round(((-self.chara:getStat("health")) / 2)))
						self.health_rolling_to = self.chara:getHealth()
						self:statusMessage("msg", "down", nil, true)
						Assets.playSound("bageldefeat")
						Game.battle:shakeCamera(4)
					end
				end
				self:checkHealth(self.health_rolling_swooned)
			end
		end
	end
end

function PartyBattler:heal(amount, sparkle_color, show_up)
	if self:canHealthRoll() then
		Assets.stopAndPlaySound("power")

		amount = math.floor(amount)

		local health_roll_previous = self.health_rolling_to
		self.health_rolling_to = self.health_rolling_to + amount

		local was_down = self.is_down
		self:flash()

		if self.health_rolling_to >= self.chara:getStat("health") then
			self.health_rolling_to = self.chara:getStat("health")
			self:statusMessage("msg", "max")
		else
			if show_up then
				if was_down ~= self.is_down then
					self:statusMessage("msg", "up")
				end
			else
				self:statusMessage("heal", amount, {0, 1, 0})
			end
		end

		if getConfig("instant_roll_up") then
			self.chara:setHealth(self.health_rolling_to)
		elseif self.is_down then
			if self.health_rolling_to <= 0 or
			   (self.health_rolling_to > 0 and getConfig("instant_roll_revive")) then
				self.chara:setHealth(self.health_rolling_to)
			else
				self.chara:setHealth(1)
			end
		end
		self.health_rolling_swooned = false

		-- Kristal.Console:log(tostring(self.health_rolling_to > self.chara:getHealth() and health_roll_previous < self.chara:getHealth()))
		-- if self.health_rolling_to > self.chara:getHealth() and health_roll_previous < self.chara:getHealth() then
		--     self.health_rolling_timer = -getConfig("roll_delay")
		-- end
		
		self:checkHealth()
		self:sparkle(unpack(sparkle_color or {}))
	else
		super.heal(self, amount, sparkle_color, show_up)
	end
end

return PartyBattler
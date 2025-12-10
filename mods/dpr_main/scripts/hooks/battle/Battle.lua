---@class Battle : Battle
local Battle, super = Utils.hookScript(Battle)

function Battle:postInit(state, encounter)
    super.postInit(self, state, encounter)

	self.mike_mode = self.encounter.mike_battle or false
end

function Battle:handleAttackingInput(key)
	if Kristal.Config["altAttack"] then
		local key_to_party_index = {
			isConfirm = 1,
			isCancel  = 2,
			isMenu    = 3
		}

		for key_check, party_index in pairs(key_to_party_index) do
			if Input[key_check](key) and not self.attack_done and not self.cancel_attack and #self.battle_ui.attack_boxes > 0 then
				for _, attack in ipairs(self.battle_ui.attack_boxes) do
					if attack.battler == Game.battle.party[party_index] then
						local closeness = attack:getClose()
						if closeness and closeness < 14.2 and closeness > -2 then
							local points = attack:hit()
							if self.encounter.is_jackenstein then
								points = 0
							end
							local action = self:getActionBy(attack.battler, true)
							action.points = points
							if self:processAction(action) then
								self:finishAction(action)
							end
						end
						break
					end
				end
			end
		end
        return false
	end

    if Input.isConfirm(key) then
        if not self.attack_done and not self.cancel_attack and #self.battle_ui.attack_boxes > 0 then
            local closest
            local closest_attacks = {}

            for _,attack in ipairs(self.battle_ui.attack_boxes) do
                if not attack.attacked then
                    local close = attack:getClose()
                    if not closest then
                        closest = close
                        table.insert(closest_attacks, attack)
                    elseif close == closest then
                        table.insert(closest_attacks, attack)
                    elseif close < closest then
                        closest = close
                        closest_attacks = {attack}
                    end
                end
            end

            if closest and closest < 14.2 and closest > -2 then
                for _,attack in ipairs(closest_attacks) do
                    local points = attack:hit()
					if self.encounter.is_jackenstein then
						points = 0
					end

                    local action = self:getActionBy(attack.battler, true)
                    action.points = points

                    if self:processAction(action) then
                        self:finishAction(action)
                    end
                end
            end
        end
    end
end

return Battle
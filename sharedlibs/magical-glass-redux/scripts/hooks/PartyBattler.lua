local PartyBattler, super = HookSystem.hookScript(PartyBattler)

function PartyBattler:init(chara, x, y)
    super.init(self, chara, x, y)

    self.already_has_flee_button = false
    self.flee_button = nil

    -- Karma (KR) calculations
    self.karma = 0
    self.karma_timer = 0
    self.karma_bonus = 0
    self.prev_health = 0
    self.inv_bonus = 0
end

function PartyBattler:canTarget()
    if Game.battle.heal_target == "force" then
        return true
    elseif Game.battle.heal_target then
        return self.chara:getHealth() < self.chara:getStat("health")
    else
        return super.canTarget(self)
    end
end

function PartyBattler:addKarma(amount)
    self.karma = self.karma + amount
end

function PartyBattler:updateKarma()
    -- Karma (KR) calculations
    self.karma = MathUtils.clamp(self.karma, 0, 40)
    if self.karma >= self.chara:getHealth() and self.chara:getHealth() > 0 then
        self.karma = self.chara:getHealth() - 1
    end
    if self.karma > 0 and self.chara:getHealth() > 1 then
        self.karma_timer = self.karma_timer + DTMULT
        if self.prev_health == self.chara:getHealth() then
            self.karma_bonus = 0
            self.inv_bonus = 0
            for _, equip in ipairs(self.chara:getEquipment()) do
                if equip.getInvBonus then
                    self.inv_bonus = self.inv_bonus + equip:getInvBonus()
                end
            end
            if self.inv_bonus >= 15 / 30 then
                self.karma_bonus = TableUtils.pick({0, 1})
            end
            if self.inv_bonus >= 30 / 30 then
                self.karma_bonus = TableUtils.pick({0, 1, 1})
            end
            if self.inv_bonus >= 45 / 30 then
                self.karma_bonus = 1
            end

            local function hurtKarma()
                self.karma_timer = 0
                self.chara:setHealth(self.chara:getHealth() - 1)
                self.karma = self.karma - 1
            end

            if self.karma_timer >= (1 + self.karma_bonus * 1) and self.karma >= 40 then
                hurtKarma()
            end
            if self.karma_timer >= (2 + self.karma_bonus * 2) and self.karma >= 30 then
                hurtKarma()
            end
            if self.karma_timer >= (5 + self.karma_bonus * 3) and self.karma >= 20 then
                hurtKarma()
            end
            if self.karma_timer >= (15 + self.karma_bonus * 5) and self.karma >= 10 then
                hurtKarma()
            end
            if self.karma_timer >= (30 + self.karma_bonus * 10) then
                hurtKarma()
            end
            if self.chara:getHealth() <= 0 then
                self.chara:setHealth(1)
            end
        end
        self.prev_health = self.chara:getHealth()
    end
end

function PartyBattler:update()
    super.update(self)

    self:updateKarma()
end

function PartyBattler:calculateDamage(amount)
    if Game:isLight() then
        local def = self.chara:getStat("defense")
        local hp = self.chara:getHealth()

        local bonus = hp > 20 and math.min(1 + math.floor((hp - 20) / 10), 8) or 0
        amount = MathUtils.round(amount + bonus - def / 5)

        return math.max(amount, 1)
    else
        return super.calculateDamage(self, amount)
    end
end

function PartyBattler:calculateDamageSimple(amount)
    if Game:isLight() then
        return math.ceil(amount - (self.chara:getStat("defense") / 5))
    else
        return super.calculateDamageSimple(self, amount)
    end
end

return PartyBattler
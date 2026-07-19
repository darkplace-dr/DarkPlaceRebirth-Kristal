local character, super = HookSystem.hookScript("susie")

function character:init()
    super.init(self)

    self.title = "Betrayed Hero\nBetrayed and sealed\nby the blade."

    self.health = 110

    self.stats = {
        health = 110,
        attack = 14,
        defense = 2,
        magic = 1
    }

    self:removeSpell("better_heal") -- remove ch5 starting spells
    self:removeSpell("scythemare")

    self:addSpell("sick_heal") -- add dp spells
    self:addSpell("pacibuster")

    self:setWeapon("old_ax")
    self:setArmor(1, nil)
    self:setArmor(2, nil)
end

function character:onTurnStart(battler)
    super.super.onTurnStart(self, battler)
	if self:checkWeapon("harvester") and not Game:getFlag("IDLEHEALDOESNTWORK") then
        Game.battle:getPartyBattler(self.id):heal(11)
    end
	if self.rage_counter > 0 then
		self.rage_counter = self.rage_counter - 1
		if self.rage_counter == 0 then
			self.rage = false
			battler:setAnimation("battle/idle")
		end
	end
	if self.rage then	-- TODO: 5% chance to attack a party member instead
        local _, yellowhat_count = self:checkArmor("yellowhat") -- technically this is part of the spell(?), so the 20% bonus applies
        local p = 450 + 450 * (0.2 * yellowhat_count)
        if Game.battle.encounter.is_jackenstein then p = 0 end
		Game.battle:pushForcedAction(battler, "AUTOATTACK", Game.battle:getActiveEnemies()[love.math.random(#Game.battle:getActiveEnemies())], nil, {points = p})
    elseif self:getFlag("auto_attack", false) then
        Game.battle:pushForcedAction(battler, "AUTOATTACK", Game.battle:getActiveEnemies()[1], nil, {points = 150})
    end
end

return character
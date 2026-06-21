local Battle, super = HookSystem.hookScript(Battle)

function Battle:init()
    super.init(self)

    self.victory = false
end

function Battle:onVictory()
    self.victory = true
    for _,battler in ipairs(self.party) do
        if battler.health_rolling_to <= 0 or battler.chara:getHealth() <= 0 then
            battler:revive()
            battler.health_rolling_to = battler.chara:autoHealAmount()
        end
        battler.chara:setHealth(battler.health_rolling_to)
    end
	return super.onVictory(self)
end

return Battle
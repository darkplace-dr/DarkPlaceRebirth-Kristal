---@class StatusCondition.atkboost : StatusCondition
local ATKBoost, super = Class(StatusCondition)

function ATKBoost:init(amplifier)
    super.init(self)

    self.name = "AttackUp"

    self.amplifier = amplifier or 2

    self.desc = ("Increases effective ATK by %s."):format(self.amplifier)

    self.default_turns = 3

    self.icon = "ui/status/atkboost"
end

function ATKBoost:applyStatModifier(stat, value)
    if stat == "attack" then
        value = value + self.amplifier
    end
    return value
end

return ATKBoost

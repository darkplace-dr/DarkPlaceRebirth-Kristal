local item, super = Class("light/ball_of_junk", true)

function item:init()
    super.init(self)

    self.short_name = "JunkBall"
    self.serious_name = "Junk"

    self.can_sell = false
end

function item:onBattleSelect(user, target)
    return false
end

return item
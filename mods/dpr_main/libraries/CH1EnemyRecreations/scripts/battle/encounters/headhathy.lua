local Hathy, super = Class(Encounter)

function Hathy:init()
    super.init(self)

    self.text = "* Head Hathy blocked the way \nquietly! (x3)"

    self.music = "battle"
    self.background = true

    self:addEnemy("headhathy", 533, 116)
    self:addEnemy("headhathy", 553, 216)
    self:addEnemy("headhathy", 513, 316)
end

return Hathy
local Hathy, super = Class(Encounter)

function Hathy:init()
    super.init(self)

    self.text = "* Hathy blocked the way!"

    self.music = "battle"
    self.background = true

    self:addEnemy("hathy")
    self:addEnemy("hathy")
end

return Hathy
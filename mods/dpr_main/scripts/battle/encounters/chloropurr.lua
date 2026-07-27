local Pebblin, super = Class(Encounter)

function Pebblin:init()
    super.init(self)

    self.text = "* Chloropurr challenges you!!"

    self.music = "battle"
    self.background = true

    self:addEnemy("chloropurr")
end

return Pebblin
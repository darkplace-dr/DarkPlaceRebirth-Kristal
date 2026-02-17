local Rabbick, super = Class(Encounter)

function Rabbick:init()
    super.init(self)

    self.text = "* Rabbick slithered in the way!"

    self.music = "battle"
    self.background = true

    self:addEnemy("rabbick")
    self:addEnemy("rabbick")
    self:addEnemy("rabbick")
end

return Rabbick
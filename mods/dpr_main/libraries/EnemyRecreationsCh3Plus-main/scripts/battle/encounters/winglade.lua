local Winglade, super = Class(Encounter)

function Winglade:init()
    super.init(self)

    self.text = "* Winglade cuts in!"

    self.music = "ch4_battle"
    self.background = true

    self:addEnemy("winglade", 520, 140)
    self:addEnemy("winglade", 520, 300)
end

return Winglade
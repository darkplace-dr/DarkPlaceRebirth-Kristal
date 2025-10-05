local Shuttah, super = Class(Encounter)

function Shuttah:init()
    super.init(self)

    self.text = "* Shuttah struttah-ed into view!"

    self.music = "battle"
    self.background = true

    self:addEnemy("shuttah")
end

return Shuttah
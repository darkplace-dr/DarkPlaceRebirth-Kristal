local Voidspawn, super = Class(Encounter)

function Voidspawn:init()
    super.init(self)

    self.text = "* Placeholder."

    self.music = "titan_spawn"
    self.background = true

    self:addEnemy("voidspawn")
end

return Voidspawn
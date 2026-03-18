local Apotheosis, super = Class(Encounter)

function Apotheosis:init()
    super.init(self)

    self.text = "* Placeholder."

    self.music = "apotheosis"
    self.background = false

    self:addEnemy("apotheosis")
end

return Apotheosis
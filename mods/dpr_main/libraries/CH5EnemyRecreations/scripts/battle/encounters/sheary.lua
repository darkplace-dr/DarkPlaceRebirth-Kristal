local Sheary, super = Class(Encounter)

function Sheary:init()
    super.init(self)

    self.text = "* Sheary cuts in!"

    self.music = "rakuichi_buster_wip"
    self.background = true

    self:addEnemy("sheary", 484, 162)
    self:addEnemy("sheary", 526, 285)
end

return Sheary
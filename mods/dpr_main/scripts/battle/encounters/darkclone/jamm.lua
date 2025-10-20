local DarkCloneBrenda, super = Class(Encounter)

function DarkCloneBrenda:init()
    super.init(self)

    self.text = "* It stood in your way."

    self.music = "deltarune/battle_vapor" -- Placeholder
    self.background = true

    self:addEnemy("darkclone/jamm", 550, 242)
end

return DarkCloneBrenda

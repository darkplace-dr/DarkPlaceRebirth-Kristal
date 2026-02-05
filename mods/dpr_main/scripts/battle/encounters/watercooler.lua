local Watercooler, super = Class(Encounter)

function Watercooler:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* A strong aura emanates from the Watercooler."

    -- Battle music ("battle" is rude buster)
    self.music = "deltarune/battle_vapor"
    -- Enables the purple grid battle background
    self.background = true

    -- Add the dummy enemy to the encounter
    self:addEnemy("watercooler", 507, 196)
end

return Watercooler
local Rabbick, super = Class(Encounter)

function Rabbick:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* Pippins rolls in your way!"

    -- Battle music ("battle" is rude buster)
    self.music = "battle"
    -- Enables the purple grid battle background
    self.background = true

    -- Add enemies to the battle
    self:addEnemy("pippins")
    self:addEnemy("pippins")
    self:addEnemy("pippins")
end

return Rabbick
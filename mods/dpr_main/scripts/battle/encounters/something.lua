local something, super = Class(Encounter)

function something:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* There is a Jukebox nearby that turns on."

    self.music = "Same Old Story"
    -- Enables the purple grid battle background
    self.background = true

    self.flee = false

    -- Add the something enemy to the encounter
    self:addEnemy("something")


end

return something
local Dummy, super = Class(Encounter)

function Dummy:init()
    super.init(self)

    self.music = "dreamed death"

    self.text = "* Your SOUL is [color:pink]pink[color:reset] now. It's locked to 9 positions."
    -- Enables the purple grid battle background
    self.background = true
    self.flee = false

    -- Add the dummy enemy to the encounter
    self:addEnemy("annabelle")

    --- Uncomment this line to add another!
    --self:addEnemy("dummy")
end

function Dummy:createSoul(x, y)
    return PurpleSoul(x, y)
end

return Dummy
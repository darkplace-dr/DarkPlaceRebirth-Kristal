local Dummy, super = Class(Encounter)

function Dummy:init()
    super.init(self)

    self.text = "* It's TV TIME!"

    self.music = "deltarune/tenna_battle"
    self.background = false

    self:addEnemy("tenna", 526, 260)

end

return Dummy
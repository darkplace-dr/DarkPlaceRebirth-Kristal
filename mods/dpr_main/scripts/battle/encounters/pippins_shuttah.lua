local PippinsShuttah, super = Class(Encounter)

function PippinsShuttah:init()
    super.init(self)

    self.text = "* Pippins and Shuttah ambushed you!"

    self.music = "battle"
    self.background = true

    self:addEnemy("shuttah")
    self:addEnemy("pippins")

	self.flee = false
end

function PippinsShuttah:onReturnToWorld(events)
    Game:setFlag("pippins_shuttah_violence", Game.battle.used_violence)
end

return PippinsShuttah

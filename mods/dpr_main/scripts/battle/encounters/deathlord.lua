local DeathLord, super = Class(Encounter)

function DeathLord:init()
    super.init(self)
    self.music = "strongerer_monsters"
    self.background = true
    self:addEnemy("deathlord")
    self.text = "* your gonna die lol"
	
	self.flee = false
end

return DeathLord

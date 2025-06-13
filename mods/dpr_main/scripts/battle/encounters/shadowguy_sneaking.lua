local ShadowguySneaking, super = Class(Encounter)

function ShadowguySneaking:init()
    super.init(self)

    self.text = "* Shadowguys emerge from the shadows!"

    self.music = "battle"
    self.background = true

    self.shadows = {
        self:addEnemy("shadowguy"),
        self:addEnemy("shadowguy")
    }
	
	self.flee = false
end

function ShadowguySneaking:onReturnToWorld(events)
    Game:setFlag("sneaking_shadowmen_violence", Game.battle.used_violence)
end

return ShadowguySneaking

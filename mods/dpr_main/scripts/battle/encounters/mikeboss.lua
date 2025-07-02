local MikeBoss, super = Class(Encounter)

function MikeBoss:init()
    super.init(self)

    self.music = "mike"
    self.text = "* It's Mike!"

	self.uses_mic = true

    -- Add the dummy enemy to the encounter
    self.mimic = self:addEnemy("mimic")
    self.death_cine_played = false
	
	self.flee = false

    self.boss_rush = false
	
    if Game:getFlag("mike_defeated") == true then
        self.boss_rush = true
    end

    self.font = Assets.getFont("main")
end

return MikeBoss

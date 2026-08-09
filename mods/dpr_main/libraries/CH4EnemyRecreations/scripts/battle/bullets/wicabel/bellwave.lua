local BellWave, super = Class(Bullet)

function BellWave:init(x, y, dir, speed)
    super.init(self, x, y, "battle/bullets/wicabel/bellwave")
	
	self.sprite:play(1/30)
	self.physics.speed = speed or 2
	self.physics.direction = dir or 0
	self.remove_offscreen = true
	
    self.damage = 45
    if #Game.party > 1 then -- In DR, this originally just checked if obj_herosusie was present, but I made it like this to account for if the party consists of more than just one member.
        self.damage = 65
    end

	self.tp = 0.6
    self.time_bonus = 1     -- have to account for some of the stuff in scr_bullet_init() too lol.
end

return BellWave
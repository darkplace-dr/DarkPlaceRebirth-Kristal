local CarrotThrower, super = Class(Wave)

function CarrotThrower:init()
	super.init(self)
	
	self.time = 170/30

    self.skiprab = 0
    self.made = false
end

function CarrotThrower:onStart()
    if self.made == false and self.skiprab == 0 then
        self.made = true
        self:spawnBullet("rabbick/rabbit_thrower", Game.battle.arena.x, Game.battle.arena.y)
    end
end

return CarrotThrower
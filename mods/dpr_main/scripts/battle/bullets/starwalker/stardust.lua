local Bullet, super = Class(Bullet)

function Bullet:init(x, y)
    -- Last argument = sprite path
    super.init(self, x, y, "world/events/lightfairy")
	
    self.sprite:play(0.1, true)

    self.physics.speed_x = love.math.random(-1, 1)
    self.physics.speed_y = -2
    self.physics.gravity = 0.25
	
    self.destroy_on_hit = false
end

function Bullet:update()
    -- For more complicated bullet behaviours, code here gets called every update
	
	if self.y > Game.battle.arena.bottom then
        self:fadeOutAndRemove(0.1)
    end

    super.update(self)
end

return Bullet
local HorseApple5, super = Class(Bullet)

function HorseApple5:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/horse/apple6")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    self.physics.speed = speed
    self.physics.friction = 1.5 / 15
    self.scale = self:getScale()
    self.destroy_on_hit = false
    self.reserve = reverse
    self.speede = speed
    self.bspeed = bspeed

    
end

function HorseApple5:update()
    -- For more complicated bullet behaviours, code here gets called every update
    if self.reserve == true then
        if self.physics.speed <= 1 then
            self.physics.friction = 0
            self.physics.gravity = self.physics.gravity + 1
        end  
end
    super.update(self)
end

return HorseApple5
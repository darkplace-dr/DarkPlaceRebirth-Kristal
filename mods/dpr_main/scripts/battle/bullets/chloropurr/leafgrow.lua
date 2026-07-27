local SmallBullet, super = Class(Bullet)

function SmallBullet:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/chloropurr/leafgrow")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    self.timer = 0
end

function SmallBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update
    self.timer = self.timer + 1
if self.timer == 30 then
    self.wave:spawnBullet("chloropurr/leaf", self.x, self.y, math.rad(90), 0)
    self:remove()
end 
    super.update(self)
end

return SmallBullet
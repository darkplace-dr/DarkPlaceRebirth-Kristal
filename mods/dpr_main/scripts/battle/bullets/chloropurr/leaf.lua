local SmallBullet, super = Class(Bullet)

function SmallBullet:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/chloropurr/leaffall")
    self.damage = 27
    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    self.siner = 0
end

function SmallBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update
    self.siner = self.siner + 1
    self.y = self.y + (math.sin(self.siner/3)+0.95)*2
    self.x = self.x + math.sin((self.siner+1)/4)*1.5
    super.update(self)
end

return SmallBullet
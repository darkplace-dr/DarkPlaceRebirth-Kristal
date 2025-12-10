local SmallBullet, super = Class(Bullet)

function SmallBullet:init(x, y, dir, speed, rot)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/guei/diamond")
    self.rotation = rot
    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    self.physics.friction = -1
    self:setScale(1)
    self:setOrigin(0.5, 0.5)
    self:setHitbox(8, 6, 24-8, 18-12)
    self.g = 0
end

function SmallBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update
    super.update(self)
end

return SmallBullet 
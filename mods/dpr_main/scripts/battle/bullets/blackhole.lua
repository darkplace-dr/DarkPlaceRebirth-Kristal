local SmallBullet, super = Class(Bullet)

function SmallBullet:init(x, y, dir, speed, dx)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/blackhole")
    self.sprite:play(0.2, true)

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    self.dx = dx
    self.collider = nil
    self.color = {0.5,0.5,0.5}
end

function SmallBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)
end

return SmallBullet
local SmallBullet, super = Class(Bullet)

function SmallBullet:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/annabelle/annaspider")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    --self.collider = nil
    --self.color = {0.5,0.5,0.5}
    self.destroy_on_hit = false
end

function SmallBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update
    if self.y > 420 then
        self.physics.direction = math.rad(270)
    end
    if self.y < 20 then
        self.physics.direction = math.rad(90)
    end

    super.update(self)
end

return SmallBullet
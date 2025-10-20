local Bullet, super = Class(Bullet)

function Bullet:init(x, y, dir, speed)
    super.init(self, x, y, "battle/bullets/darkclone/brenda/bullet")

    self.physics.direction = dir
    self.physics.speed = speed

    self.rotation = dir
end

function Bullet:update()

    super.update(self)
end

return Bullet
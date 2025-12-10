local StarBullet, super = Class(Bullet, "SW_StarBullet")

function StarBullet:init(x, y)
    super.init(self, x, y, "battle/bullets/star")

    self.grazed = true
    self.graphics.spin = math.rad(45 / 4)

    self.inv_timer = 1 / 30
    self.destroy_on_hit = false
end

function StarBullet:shouldSwoon(damage, target, soul)
    return true
end

function StarBullet:update()
    super.update(self)
end

return StarBullet
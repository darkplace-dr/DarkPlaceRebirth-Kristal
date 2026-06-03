local RingBullet, super = Class(Bullet)

function RingBullet:init(x, y, dir, speed)
    super.init(self, x, y, "battle/bullets/winglade/ring")

    self:setScale(1, 1)
    self.tp = 2.5
    self.physics.direction = dir
    self.physics.speed = speed
    self.collider = CircleCollider(self, self.width / 2, self.height / 2, 13)
    self.afterimages = {}
end

function RingBullet:onWaveSpawn()
    self.wave.timer:script(function(wait)
        wait(2/30 + DT) -- Idk man I have to do this otherwise the spacing will be off
        if self:isRemoved() then return end
        local bullet = self.wave:spawnBullet("winglade/ring_afterimage", self.init_x, self.init_y, self.physics.direction, self.physics.speed, 0.7)
        bullet:setLayer(self.layer - 0.01)
        table.insert(self.afterimages, bullet)
        wait(2/30)
        if self:isRemoved() then return end
        local bullet = self.wave:spawnBullet("winglade/ring_afterimage", self.init_x, self.init_y, self.physics.direction, self.physics.speed, 0.4)
        bullet:setLayer(self.layer - 0.01)
        table.insert(self.afterimages, bullet)
    end)
end

function RingBullet:onCollide(soul)
    super.onCollide(self, soul)
    for _, afterimage in ipairs(self.afterimages) do
        afterimage:remove()
    end
end

function RingBullet:update()
    super.update(self)
end

return RingBullet
local bullet, super = Class(Bullet)

function bullet:init(x, y)
    super.init(self, x, y)
    self:setSprite("bullets/bulletmd", 1, true)

    self:setScale(1, 1)
    self:setOrigin(0.5, 0.5)
    self:setHitbox(5, 5, 4, 4)

    self.timelimit = 20 + math.random(0, 20)
    self.timer = 0

    self.physics.speed = 2.5
    self.physics.direction = math.rad(90)
end

function bullet:update()
    super.update(self)

    self.timer = self.timer + 1*DTMULT
    if self.timer >= self.timelimit then
        for i = 1, 10 do
            local newbullet = self.wave:spawnBullet("splinter", self.x, self.y)
            newbullet.physics.direction = math.rad(i*40)
        end
        self:remove()
    end
end

return bullet
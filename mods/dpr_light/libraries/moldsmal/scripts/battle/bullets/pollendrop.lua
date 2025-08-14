local bullet, super = Class(Bullet)

function bullet:init(x, y)
    super.init(self, x, y, "bullets/bulletmd")

    self:setScale(1, 1)
    self:setOrigin(0.5, 0.5)
    self:setHitbox(5, 5, 4, 4)

    self.timer = 0
    self.timelimit = 10

    self.hspeed = 1.5
    self.vspeed = 1.2
    self.physics.gravity = 0.02
    self.physics.gravity_direction = math.rad(90)
end

function bullet:update()
    super.update(self)

    self.timer = self.timer + 1*DTMULT
    self:move(self.hspeed * DTMULT, self.vspeed * DTMULT)

    if self.timer >= self.timelimit then
        self.timer = 0
        self.timelimit = 20
        self.hspeed = -self.hspeed
    end

    if self.y > Game.battle.arena.bottom then
        self:remove()
    end
end

return bullet
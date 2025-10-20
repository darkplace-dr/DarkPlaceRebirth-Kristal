local SmallBullet, super = Class(Bullet)

function SmallBullet:init(x, y, dir, speed)
    super.init(self, x, y, "battle/bullets/pebble")

    self.physics.direction = dir
    self.physics.speed = speed
    self.alpha = 0
    self.state = "SPAWNING" -- SPAWNING, FALLING, GROUNDED
end

function SmallBullet:update()
    if self.state == "SPAWNING" then
        self.alpha = self.alpha + DT*2
        if self.alpha >= 1 then
            self.state = "FALLING"
        end
    elseif self.state == "FALLING" then
        self.physics.speed_y = self.physics.speed_y + 1*DTMULT
        if self.y > Game.battle.arena.bottom - 6 and (self.x > Game.battle.arena.left and self.x < Game.battle.arena.right) then
            self.state = "GROUNDED"
            self.physics.speed_y = 0
            self:shake()
            Assets.stopAndPlaySound("wing", 1, 1)
            self.y = 238
        end
    end

    super.update(self)
end

return SmallBullet
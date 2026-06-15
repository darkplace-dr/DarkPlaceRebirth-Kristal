local SmallBullet, super = Class(Bullet)

function SmallBullet:init(x, y, dir, speed)
    super.init(self, x, y, "battle/bullets/club")

    self.physics.direction = dir
    self.physics.speed = speed
    self.alpha = 0
    self.state = "SPAWNING" -- SPAWNING, SWINGING, SWUNG
    self.timer = 0
    self.swing_delay = 20
end

function SmallBullet:update()
    if self.state == "SPAWNING" then
        self.alpha = self.alpha + DT*2
        if self.alpha >= 1 then
            self.state = "SWINGING"
        end
    elseif self.state == "SWINGING" then
        self.timer = self.timer + 1*DTMULT
        if self.timer >= self.swing_delay then
            self.timer = 0
            if self.swing_delay > 5 then
                self.swing_delay = self.swing_delay - 2/#Game.battle:getActiveEnemies()
            else
                self.swing_delay = 5
            end
            Assets.stopAndPlaySound("leaf_dodge")
        end
        if self.swing_delay == 5 then
            self.state = "SWUNG"
            local angle = Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
            self.physics.direction = angle
            self.physics.speed = -4
            Assets.stopAndPlaySound("wing")
        end
    elseif self.state == "SWUNG" then
        self.physics.speed = self.physics.speed + 0.3*DTMULT
    end

    if self.state == "SWINGING" or self.state == "SWUNG" then
        self.rotation = self.rotation - (3/self.swing_delay)*DTMULT
    end

    super.update(self)
end

return SmallBullet
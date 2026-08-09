local Saw, super = Class(Bullet)

function Saw:init(x, y, dir, speed)
    super.init(self, x, y, "battle/bullets/wicabel/saw")

    self:setScale(1)
    self:setOrigin(0, 0)
	
	self.sprite:play(1/30)
	self.physics.speed = speed or -5 + MathUtils.random(2)
	self.physics.direction = -math.rad(dir) or -math.rad(0)
	
    self.tp = 0.4
    self.time_bonus = 1
    self.damage = 10

    self.delay = 5
    self.destroy_on_hit = false

    --fuckin' stupid way of handling this, but it's just so the `if` statement in `update()` can be accurate.
    self.alarm_0 = -1
    self.alarm_0_start = true
end

function Saw:getDebugInfo()
    local info = super.getDebugInfo(self)
    table.insert(info, "Delay: " .. self.delay)
    table.insert(info, "Spark Timer: " .. self.alarm_0)

    table.insert(info, "Scale X: " .. self.scale_x)
    table.insert(info, "Scale Y: " .. self.scale_y)
    table.insert(info, "Speed: " .. self.physics.speed)
    table.insert(info, "Direction: " .. self.physics.direction)

    return info
end

function Saw:update()
    super.update(self)

    if self.alarm_0 > 0 and self.alarm_0_start then
        self.alarm_0 = self.alarm_0 - DTMULT
        if self.alarm_0 <= 0 then
            self.alarm_0_start = false
            self:fireSparks()
        end
    end

    if math.abs((self.x + ((self.sprite.width / 2) * MathUtils.sign(self.physics.speed_x))) - Game.battle.arena.x) <= 75 and self.alarm_0 > -1 then
        self:setSpeed(MathUtils.approach(self.physics.speed, 5, 1))
    end
end

function Saw:fireSparks()
    if (math.abs((self.x + ((self.sprite.width / 2) * MathUtils.sign(self.physics.speed_x))) - (Game.battle.arena.x + 10)) <= 85) then
        self.wave:spawnBullet("wicabel/saw_spark", self.x + ((self.sprite.width / 2) * MathUtils.sign(self.physics.speed_x)), self.y, 100 + MathUtils.random(30), 1.25 + MathUtils.random(1.25))
        self.wave:spawnBullet("wicabel/saw_spark", self.x + ((self.sprite.width / 2) * MathUtils.sign(self.physics.speed_x)), self.y, 260 - MathUtils.random(30), 1.25 + MathUtils.random(1.25))

        self.alarm_0 = self.delay + (MathUtils.randomInt(3) + 1)
        self.alarm_0_start = true
    else
        self.alarm_0 = 1
        self.alarm_0_start = true
    end
end

return Saw
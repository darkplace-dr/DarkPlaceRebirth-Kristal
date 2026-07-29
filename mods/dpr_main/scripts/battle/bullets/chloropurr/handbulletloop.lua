local SmallBullet, super = Class(Bullet)

function SmallBullet:init(x, y, dir, speed, target_x, target_y)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/chloropurr/spr_hand_crawl")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    self.target_x = target_x
    self.target_y = target_y
    self.track = true
    self.speed = speed
    self.timer = 8
end

function SmallBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update
    self.physics.speed = self.physics.speed - (0.9+MathUtils.random(-0.2, 0.2))
    self.timer = self.timer - 1
    if self.timer <= 0 then
        Assets.stopAndPlaySound("wing")
        self.timer = 8
        self.speed = self.speed + 2
        self.physics.speed = self.speed
    end
    if MathUtils.dist(self.x,self.y,Game.battle.soul.x, Game.battle.soul.y) < 100 then
        self.speed = self.speed - 0.1
        local dir = Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
        self.rotation = self.rotation - (MathUtils.angleDiff(dir, self.rotation) / 50) * DTMULT
        self.physics.speed = self.physics.speed - 0.15
    end
    local dir = Utils.angle(self.x, self.y, self.target_x, self.target_y)
    if MathUtils.dist(self.x,self.y,self.target_x,self.target_y) < 100 then
        self.track = false
    end
    if self.track == true then
    self.rotation = self.rotation + (MathUtils.angleDiff(dir, self.rotation) / 4) * DTMULT
    end
    self.physics.direction = self.rotation
    if self.x <= 0 then
    self.x = SCREEN_WIDTH + 20
    if self.y < 0-40 then
        self.y = SCREEN_HEIGHT+20
    end
    if self.y > SCREEN_HEIGHT+40 then
        self.y = 0-20
    end
    end
    super.update(self)
end

return SmallBullet
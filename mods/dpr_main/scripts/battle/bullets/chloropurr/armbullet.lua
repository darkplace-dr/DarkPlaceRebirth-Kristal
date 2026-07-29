local SmallBullet, super = Class(Bullet)

function SmallBullet:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/chloropurr/spr_hand")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    if MathUtils.dist(self.x,self.y,Game.battle.soul.x, Game.battle.soul.y) <= 120 then
        self.x = Game.battle.soul.x + 100
    end
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    self.physics.direction = MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
    self.speed = self.physics.speed
    self.timer = 30
    self.movement = 8
    self:setHitbox(12, 8, self.width-24, self.height-16)
end

function SmallBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update
    self.timer = self.timer - 1
    if self.timer <= 0 and self.movement > 0 then
        Assets.stopAndPlaySound("wing")
        self.physics.direction = MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
        self.physics.speed = self.speed
        self.timer = 30
        self.movement = self.movement - 1
    end
    if MathUtils.dist(self.x,self.y,Game.battle.soul.x, Game.battle.soul.y) <= 90 then
        self.physics.speed = self.physics.speed - 0.06
    end
    self.rotation = self.physics.direction
    self.physics.speed = self.physics.speed - 8/60
    super.update(self)
end
function SmallBullet:onGraze()
    self.physics.speed = self.physics.speed - 0.1
end

return SmallBullet
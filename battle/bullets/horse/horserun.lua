local HorseRun, super = Class(Bullet)

function HorseRun:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/horse/horserun")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = math.random(-20,10)
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    self.siner = 1
    self.timerthing = 0

    
end

function HorseRun:update()
    -- For more complicated bullet behaviours, code here gets called every update
    self.siner = self.siner + DT
    self.timerthing = self.timerthing + 1
    if self.timerthing <= 40 then
        self.physics.direction = MathUtils.approachAngle(self.physics.direction, MathUtils.angle(self.x,self.y,Game.battle.soul.x,Game.battle.soul.y), 0.09)
    else
        self.physics.direction = self.physics.direction
    end
self.physics.speed = math.sin(self.siner*1.2)+7*DT*25
    super.update(self)
end

return HorseRun
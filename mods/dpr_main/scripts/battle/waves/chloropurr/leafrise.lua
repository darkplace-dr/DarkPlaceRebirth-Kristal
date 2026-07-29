local MovingArena, super = Class(Wave)

function MovingArena:init()
    super.init(self)

    -- Initialize timer
    self.timerl = 0
    self.timerr = 0
    self.time = 10
end

function MovingArena:onStart()
    -- Get the arena object
    local arena = Game.battle.arena

        -- Spawn spikes on top of arena

    -- Store starting arena position
end

function MovingArena:update()
    -- Increment timer for arena movement
    self.timerl = self.timerl - 1
    self.timerr = self.timerr - 1
    if self.timerl <= 0 then
        self:spawnBullet("chloropurr/leafrise", Game.battle.arena.left-250, Game.battle.arena.y+MathUtils.random(-60, 60)+50, 0, MathUtils.random(15, 16.5))
        self.timerl = MathUtils.random(1,3)
    end
    if self.timerr <= 0 then
        self:spawnBullet("chloropurr/leafrise", Game.battle.arena.right+250, Game.battle.arena.y+MathUtils.random(-60, 60)+50, 0, MathUtils.random(-15, -16.5))
        self.timerr = MathUtils.random(1,3)
    end
    -- Calculate the arena offset

    super.update(self)
end

return MovingArena
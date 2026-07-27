local MovingArena, super = Class(Wave)

function MovingArena:init()
    super.init(self)

    -- Initialize timer
    self.siner = 0
    self.time = 10
end

function MovingArena:onStart()
    -- Get the arena object
    local arena = Game.battle.arena

        -- Spawn spikes on top of arena
        self:spawnBulletTo(Game.battle.arena, "chloropurr/vines", arena.width/2, 0, math.rad(0),10)

    -- Store starting arena position
end

function MovingArena:update()
    -- Increment timer for arena movement

    -- Calculate the arena offset

    super.update(self)
end

return MovingArena
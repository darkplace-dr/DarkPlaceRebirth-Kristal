local MovingArena, super = Class(Wave)

function MovingArena:init()
    super.init(self)

    -- Initialize timer
    self.siner = 0
end

function MovingArena:onStart()
    -- Get the arena object
    local arena = Game.battle.arena

	if Game.save_name == "BLUE" then
        -- Spawn spikes on left of arena (rotated -90 degrees)
        self:spawnBulletTo(Game.battle.arena, "arenahazard", 0, arena.height/2, math.rad(-90))
    else
        -- Spawn spikes on top of arena
        self:spawnBulletTo(Game.battle.arena, "arenahazard", arena.width/2, 0, math.rad(0))
    end

	if Game.save_name == "BLUE" then
        -- Spawn spikes on right of arena (rotated 90 degrees)
        self:spawnBulletTo(Game.battle.arena, "arenahazard", arena.width, arena.height/2, math.rad(90))
    else
        -- Spawn spikes on bottom of arena (rotated 180 degrees)
        self:spawnBulletTo(Game.battle.arena, "arenahazard", arena.width/2, arena.height, math.rad(180))
    end

    -- Store starting arena position
    self.arena_start_x = arena.x
    self.arena_start_y = arena.y
end

function MovingArena:update()
    -- Increment timer for arena movement
    self.siner = self.siner + DT

    -- Calculate the arena offset
    local offset = math.sin(self.siner * 1.5) * 60

	if Game.save_name == "BLUE" then
        -- Move the arena left and right
        Game.battle.arena:setPosition(self.arena_start_x + offset, self.arena_start_y)
    else
        -- Move the arena up and down
        Game.battle.arena:setPosition(self.arena_start_x, self.arena_start_y + offset)
    end

    super.update(self)
end

return MovingArena
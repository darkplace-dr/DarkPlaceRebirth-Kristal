local MovingArena, super = Class(Wave)

function MovingArena:init()
    super.init(self)

    -- Initialize timer
    self.siner = 0
    self.luck = 0
    self:setArenaSize(24, 24)
end

function MovingArena:onStart()
    local arena = Game.battle.arena
    self.arena_start_x = arena.x
    self.arena_start_y = arena.y
	self.timer:every(1/4, function()
        local x = SCREEN_WIDTH + 20
        if self.luck == 0 then
            self.luck = 1
            self:spawnBullet("smallddd", x, Game.battle.arena.top, math.rad(180), 20)
        else
            self:spawnBullet("smallddd", x, Game.battle.arena.bottom, math.rad(180), 20)
            self.luck = 0
        end
        --self:spawnBullet("smallddd", x, y, math.rad(180), 20)
    end)
end

function MovingArena:update()
    -- Increment timer for arena movement
    self.siner = self.siner + DT

    -- Calculate the arena Y offset
    local offset = math.sin(self.siner * 4) * 40

    -- Move the arena
    Game.battle.arena:setPosition(self.arena_start_x + offset, self.arena_start_y)

    super.update(self)
end

return MovingArena
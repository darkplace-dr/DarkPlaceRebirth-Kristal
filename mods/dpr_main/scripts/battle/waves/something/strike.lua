local Basic, super = Class(Wave)

function Basic:init()
	super.init(self)
	self:setArenaSize(284, 213)
	--self.time = 7
end

function Basic:onStart()
    -- Our X position is offscreen, to the right
    local x = Utils.random(Game.battle.arena.left, Game.battle.arena.right)
    -- Get a random Y position between the top and the bottom of the arena
    local y = -20

    -- Spawn smallbullet going left with speed 8 (see scripts/battle/bullets/smallbullet.lua)
    self:spawnBullet("foleystrikeas", x, y, math.rad(90), 10)
    --self:spawnBullet("smallbullet", x, y, math.rad(180), 4)
    self.timer:every(1/2, function()
        -- Our X position is offscreen, to the right
        local x = Utils.random(Game.battle.arena.left, Game.battle.arena.right)
        -- Get a random Y position between the top and the bottom of the arena
        local y = -20

        -- Spawn smallbullet going left with speed 8 (see scripts/battle/bullets/smallbullet.lua)
        self:spawnBullet("foleystrikeas", x, y, math.rad(90), 10)
        --self:spawnBullet("smallbullet", x, y, math.rad(180), 4)
    end)
end

function Basic:update()
    super.update(self)
end

return Basic
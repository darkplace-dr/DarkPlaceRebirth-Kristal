local Stomp, super = Class(Wave)

function Stomp:init()
    super.init(self)
    --self.time = 7
	self:setArenaSize(192, 24)
	--self:setSoulOffset(x, 63)
end

function Stomp:onStart()
    -- Every 0.33 seconds...
	--Game.battle:swapSoul(BlueSoul())

	-- Spawn smallddd going left with speed 8 (see scripts/battle/bullets/smallddd.lua)
	local bullet = self:spawnBullet("dddjump", Game.battle.soul.x, Game.battle.soul.y - 200, math.rad(90), 1)
	bullet.physics.friction = -1.5
	self.timer:every(1/2, function()
        local x = SCREEN_WIDTH + 20
        if Utils.random(0,1) <= 0.5 then
            --local y = Game.battle.arena.top
            self:spawnBullet("smallddd", x, Game.battle.arena.top, math.rad(180), 16)
        else
            self:spawnBullet("smallddd", x, Game.battle.arena.bottom, math.rad(180), 16)
            --local y = Game.battle.arena.bottom
        end
        --self:spawnBullet("smallddd", x, y, math.rad(180), 20)
    end)
end

function Stomp:update()
    -- Code here gets called every frame

    super.update(self)
end

return Stomp

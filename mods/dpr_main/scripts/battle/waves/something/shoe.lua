local Basic, super = Class(Wave)

function Basic:onStart()
    -- Every 0.33 seconds...
    -- Our X position is offscreen, to the right
    local x = (Game.battle.arena.left + Game.battle.arena.right)/2
    -- Get a random Y position between the top and the bottom of the arena
    local y = - 20

    -- Spawn smallbullet going left with speed 8 (see scripts/battle/bullets/smallbullet.lua)
    local bullet = self:spawnBullet("shoe", x, y, math.rad(60), 8)
    local bullet3 = self:spawnBullet("shoe", x, y, math.rad(80), 8)
    local bullet2 = self:spawnBullet("shoe", x, y, math.rad(100), 8)
    local bullet2 = self:spawnBullet("shoe", x, y, math.rad(120), 8)
    local bullet2 = self:spawnBullet("shoe", x, y, math.rad(160), 8)
    local bullet2 = self:spawnBullet("shoe", x, y, math.rad(40), 8)
    local bullet2 = self:spawnBullet("shoe", x, y, math.rad(180), 8)
    self.timer:every(1/2, function()
        -- Our X position is offscreen, to the right
        local x = Utils.random(Game.battle.arena.left - 20, Game.battle.arena.right + 20)
        -- Get a random Y position between the top and the bottom of the arena
        local y = - 20

        -- Spawn smallbullet going left with speed 8 (see scripts/battle/bullets/smallbullet.lua)
        local bullet = self:spawnBullet("shoe", x, y, math.rad(60), 8)
        local bullet3 = self:spawnBullet("shoe", x, y, math.rad(80), 8)
        local bullet2 = self:spawnBullet("shoe", x, y, math.rad(100), 8)
        local bullet2 = self:spawnBullet("shoe", x, y, math.rad(120), 8)
        local bullet2 = self:spawnBullet("shoe", x, y, math.rad(160), 8)
        local bullet2 = self:spawnBullet("shoe", x, y, math.rad(40), 8)
        local bullet2 = self:spawnBullet("shoe", x, y, math.rad(180), 8)

        -- Dont remove the bullet offscreen, because we spawn it offscreen
        bullet.remove_offscreen = false
    end)
end

function Basic:update()
    -- Code here gets called every frame

    super.update(self)
end

return Basic
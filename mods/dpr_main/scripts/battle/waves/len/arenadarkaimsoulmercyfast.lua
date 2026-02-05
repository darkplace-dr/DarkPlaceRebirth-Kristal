local ArenaDark, super = Class(Wave)

function ArenaDark:onStart()
    -- Every 0.5 seconds...
    local arena = Game.battle.arena
    local soul = Game.battle.soul
    self.timer:every(1/4, function()
        local x = love.math.random(arena:getLeft(), arena:getRight())
        local y = arena:getTop()
        local darkbullet = self:spawnBullet("len/mercy", x, y, 8)
        darkbullet:setScale(2)
        Assets.playSound("alert")
    end)
    self.timer:every(1/3, function()
        local x = soul.x + love.math.random(-10, 10)
        local y = soul.y - 40 + love.math.random(-10, 10)
        local darkbullet = self:spawnBullet("len/dark", x, y, 8)
        darkbullet:setScale(4)
        Assets.playSound("laz_c_len")
    end)
end

function ArenaDark:update()
    -- Code here gets called every frame

    super.update(self)
end

return ArenaDark
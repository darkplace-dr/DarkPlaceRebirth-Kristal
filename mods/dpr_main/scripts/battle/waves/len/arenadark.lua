local ArenaDark, super = Class(Wave)

function ArenaDark:onStart()
    -- Every 0.5 seconds...
    self.timer:every(1/2, function()
        local arena = Game.battle.arena
        local x = love.math.random(arena:getLeft(), arena:getRight())
        local y = love.math.random(arena:getTop(), arena:getBottom())
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
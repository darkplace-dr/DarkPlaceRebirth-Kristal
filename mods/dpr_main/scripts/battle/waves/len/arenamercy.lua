local ArenaDark, super = Class(Wave)

function ArenaDark:onStart()
    -- Every 0.5 seconds...
    self.timer:every(1/4, function()
        local arena = Game.battle.arena
        local x = love.math.random(arena:getLeft(), arena:getRight())
        local y = arena:getTop()
        local darkbullet = self:spawnBullet("len/mercy", x, y, 8)
        darkbullet:setScale(2)
        Assets.playSound("alert")
    end)
end

function ArenaDark:update()
    -- Code here gets called every frame

    super.update(self)
end

return ArenaDark
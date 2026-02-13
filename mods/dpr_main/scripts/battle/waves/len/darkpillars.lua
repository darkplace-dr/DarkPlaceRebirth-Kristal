local ArenaDark, super = Class(Wave)

function ArenaDark:onStart()
    -- Every 0.5 seconds...
    local arena = Game.battle.arena
    self.y = arena:getTop()
    self.timer:every(1/2, function()
        local x = love.math.random(arena:getLeft(), arena:getRight())
        local y = self.y
        local positions = {-100, 0, 100}
        for i = 1,3 do
            local changeX = positions[i]
            local darkbullet = self:spawnBullet("len/dark", x + changeX + love.math.random(-20,20), y, 8)
            darkbullet:setScale(4)
            Assets.playSound("laz_c_len")
        end
        self.y = self.y + 25
        if self.y > arena:getBottom() then
            self.y = arena:getTop() - 30
        end
    end)
end

function ArenaDark:update()
    -- Code here gets called every frame

    super.update(self)
end

return ArenaDark
local froggit_1, super = Class(Wave)

function froggit_1:onStart()
    -- Every 0.5 seconds...
    self.timer:every(1/2, function()
        -- Our X position is offscreen, to the right
        local x = SCREEN_WIDTH + 20
        -- Get a random Y position between the top and the bottom of the arena
        local y = 220
        self:spawnBullet("dddstar_puff", x, y, math.rad(180), 8)
        self:spawnBullet("dddstar_puff", x, y, math.rad(135), 8)
    end)
end

function froggit_1:update()
    -- Code here gets called every frame

    super.update(self)
end

return froggit_1
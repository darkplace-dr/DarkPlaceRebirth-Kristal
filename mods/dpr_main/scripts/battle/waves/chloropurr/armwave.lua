local Basic, super = Class(Wave)

function Basic:onStart()
    -- Every 0.33 seconds...
    self.timer:every(2/3, function()
        -- Our X position is offscreen, to the right
        local x = MathUtils.random(50, SCREEN_WIDTH-50)
        local y = MathUtils.random(50, SCREEN_HEIGHT-50)
        if y <= Game.battle.arena.top and y >= Game.battle.arena.bottom then
            y = SCREEN_HEIGHT-(Utils.random(-3,3)*SCREEN_HEIGHT/4)
        end
        if x <= Game.battle.arena.right and x >= Game.battle.arena.left then
            x = SCREEN_WIDTH-(Utils.random(-3,3)*SCREEN_WIDTH/4)
        end
        --if y <= Game.battle.arena.top and y >= Game.battle.arena.bottom then
           -- y = SCREEN_HEIGHT-(tils.random(-3,3)*SCREEN_HEIGHT/4)
      --  end
      --  if x <= Game.battle.arena.right and x >= Game.battle.arena.left then
      --      x = SCREEN_WIDTH-(Utils.random(-3,3)*SCREEN_WIDTH/4)
    --    end
        -- Get a random Y position between the top and the bottom of the arena

        -- Spawn smallbullet going left with speed 8 (see scripts/battle/bullets/smallbullet.lua)
        local bullet = self:spawnBullet("chloropurr/armbullet", x, y, 0, 4)
        bullet.tp = 3
        -- Dont remove the bullet offscreen, because we spawn it offscreen
        bullet.remove_offscreen = true
    end)
end

function Basic:update()
    -- Code here gets called every frame

    super.update(self)
end

return Basic
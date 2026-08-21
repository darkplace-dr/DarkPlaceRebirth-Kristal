local Basic, super = Class(Wave)

function Basic:onStart()
    -- Every 0.33 seconds...
    self.time = 10
    self.timer:every(4/3, function()
        -- Our X position is offscreen, to the right
        local y = MathUtils.random(50, SCREEN_HEIGHT-100)
        local x = 0
        if Utils.random(0,1) == 1 then
        x = Game.battle.arena.x + Utils.random(80,150)
        else
        x = Game.battle.arena.x + Utils.random(-80,-150)
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
        bullet.tp = 4
        -- Dont remove the bullet offscreen, because we spawn it offscreen
        bullet.remove_offscreen = true
    end)
end

function Basic:update()
    -- Code here gets called every frame

    super.update(self)
end

return Basic
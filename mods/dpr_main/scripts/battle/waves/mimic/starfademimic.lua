local Basic, super = Class(Wave)

function Basic:onStart()
    ---@type EnemyBattler.Mimic
    local mimic = Game.battle:getEnemyBattler("mimic")
    mimic:morph("ufoofdoom")

	self.time = 10
	
    -- Every 1/5 seconds...
    self.timer:every(1/5, function()
        -- Spawn smallbullet going left with speed 8 (see scripts/battle/bullets/smallbullet.lua)
		for i=0,2 do
			-- Get a random side
			local x = Utils.random(Game.battle.arena.left, Game.battle.arena.right)
			local y = Utils.random(Game.battle.arena.top, Game.battle.arena.bottom)

			local bullet = self:spawnBullet("ufos/starbulletfade", x, y)
		end

        -- Dont remove the bullet offscreen, because we spawn it offscreen
        --bullet.remove_offscreen = true
    end)
end

function Basic:update()
    -- Code here gets called every frame

    super.update(self)
end

return Basic
local Basic, super = Class(Wave)

function Basic:onStart()
    local enemy = Game.battle:getEnemyBattler("chloropurr")
        enemy:setAnimation("hit")
        self.time = 8
    -- Every 0.33 seconds...
    self.timer:every(1/3, function()
        -- Get all enemies that selected this wave as their attack
        local attackers = self:getAttackers()

        -- Loop through all attackers
        for _, attacker in ipairs(attackers) do

            -- Get the attacker's center position
            local x, y = attacker:getRelativePos(attacker.width/2, attacker.height/2)

            -- Get the angle between the bullet position and the soul's position
            local angle = Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)

            -- Spawn smallbullet angled towards the player with speed 8 (see scripts/battle/bullets/smallbullet.lua)
            self:spawnBullet("chloropurr/handbulletloop", x-60, y, angle+(MathUtils.random(-30, 30)), 12, Game.battle.soul.x, Game.battle.soul.y)
            self:spawnBullet("chloropurr/handbulletloop", x-60, y, -angle+(MathUtils.random(-60, 60)), 8, Game.battle.soul.x, Game.battle.soul.y)
            
        end
    end)
end

function Basic:update()
    -- Code here gets called every frame

    super.update(self)
end

function Basic:onEnd()
    local enemy = Game.battle:getEnemyBattler("chloropurr")
    if enemy.mercy >= 100 then
        enemy:setAnimation("spared")
    else
    enemy:setAnimation("idle")
    end
end

return Basic
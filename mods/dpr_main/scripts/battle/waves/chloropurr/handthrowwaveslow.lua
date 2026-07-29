local Basic, super = Class(Wave)

function Basic:onStart()
    self.timerthing = 6
    -- Every 0.33 seconds...
    self.timer:every(1/1.25, function()
        -- Get all enemies that selected this wave as their attack
        local attackers = self:getAttackers()

        -- Loop through all attackers
        for _, attacker in ipairs(attackers) do

            -- Get the attacker's center position
            local x, y = attacker:getRelativePos(attacker.width/2, attacker.height/2)

            -- Get the angle between the bullet position and the soul's position
            local angle = Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)

            -- Spawn smallbullet angled towards the player with speed 8 (see scripts/battle/bullets/smallbullet.lua)
            self:spawnBullet("chloropurr/handbullet", x-60, y, angle+(MathUtils.random(-30, 30)), 12, Game.battle.soul.x, Game.battle.soul.y)
        end
    end)
end

function Basic:update()
    self.timerthing = self.timerthing - 1
    if self.timerthing == 0 then
    local enemy = Game.battle:getEnemyBattler("chloropurr")
        enemy:setAnimation("hitslow")
    end
    -- Code here gets called every frame

    super.update(self)
end

function Basic:onEnd()
    local enemy = Game.battle:getEnemyBattler("chloropurr")
    enemy:setAnimation("idle")
end

return Basic
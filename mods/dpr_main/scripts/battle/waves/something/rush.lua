local froggit_1, super = Class(Wave)

function froggit_1:onStart()
    -- Every 0.5 seconds...
    local attackers = self:getAttackers()

        -- Loop through all attackers
    for _, attacker in ipairs(attackers) do
            -- Get the attacker's center position
        local x, y = attacker:getRelativePos(attacker.width/2, attacker.height/2)
        -- Get the angle between the bullet position and the soul's position
        local angle = Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)
        self:spawnBullet("rush_ddd", x, y, angle, 12)
    end
end

function froggit_1:update()
    -- Code here gets called every frame

    super.update(self)
end

return froggit_1
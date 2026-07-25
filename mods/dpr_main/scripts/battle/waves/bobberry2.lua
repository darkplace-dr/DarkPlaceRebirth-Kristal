local Bobberry2, super = Class(Wave)

function Bobberry2:onStart()
    self.timer:every(0.5, function()
        local attackers = self:getAttackers()

        for _, attacker in ipairs(attackers) do
            local x, y = attacker:getRelativePos(attacker.width / 2, attacker.height / 2)

            local angle = MathUtils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)

            self:spawnBullet("wilybullet", x, y, angle, 8)
        end
    end)
end

function Bobberry2:update()

    super.update(self)
end

return Bobberry2
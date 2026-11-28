local EasyAttack, super = Class(Wave, "shi/easy_attack")

function EasyAttack:init()
	super.init(self)

    self.time = 250/30
end

function EasyAttack:onStart()
    local attackers = self:getAttackers()
    for i, attacker in ipairs(attackers) do
        local _y = 1

        if i ~= 1 then
            _y = _y * -1
        end

        local scarecrow = self:spawnBullet("shi/scarecrow_wobbler", (Game.battle.arena.x - 10) + MathUtils.random(20), (Game.battle.arena.y + 1) + (68 * _y))
        scarecrow.scale_y = _y * 1.5
    end
end

return EasyAttack
---@class EnemyBattler : EnemyBattler
local EnemyBattler, super = Utils.hookScript(EnemyBattler)


function EnemyBattler:getAttackTension(points)
    local tp = super.getAttackTension(self, points)
    if Game.battle.encounter.reduced_tp then
        tp = tp / 3
    end
    return tp
end

return EnemyBattler
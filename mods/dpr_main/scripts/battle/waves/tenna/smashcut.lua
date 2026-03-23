local SmashCut, super = Class(Wave)

function SmashCut:init()
    super.init(self)

    self.time = 260/30
end

function SmashCut:onStart()
    local arena = Game.battle.arena
    
    local smashcut_attack = self:spawnBullet("tenna/smashcut_attack", arena.x, arena.y)
    smashcut_attack.damage = 65
end

function SmashCut:onEnd()
    local smash_cutter = Game.stage:getObjects(TennaSmashCutter)[1]

    if smash_cutter then
        smash_cutter:remove()
    end
end

return SmashCut
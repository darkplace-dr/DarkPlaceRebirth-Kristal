local SmashCut, super = Class(Wave)

function SmashCut:init()
    super.init(self)

    self.time = 260/30

    self.type = 153
    self.made = false
    self.sameattack = 0
end

local function mean(...) --Port of GameMaker's `mean` function to Kristal. Special thanks to Dobby233Liu for porting this lol.
    local vals = { ... }
    local count = #vals
    if count == 0 then return 0 end

    local sum = 0
    for i = 1, count do
        sum = sum + vals[i]
    end
    return sum / count
end

function SmashCut:update()
    local arena = Game.battle.arena
    
    if not self.made and #Game.stage:getObjects(Registry.getBullet("sheary/smashcut_attack")) == 0 and #Game.stage:getObjects(ShearySmashCutter) == 0 then
        local _smashcut = self:spawnObject(ShearySmashCutter(-20, mean(arena.y, 0)))
        _smashcut:setLayer(BATTLE_LAYERS["above_bullets"])
        _smashcut.type = self.type - 150
        _smashcut.do_flip = false
        -- _smashcut.difficulty = self.sameattack - 1
        self.made = true
    end

    super.update(self)
end

function SmashCut:onEnd()
    local smash_cutter = Game.stage:getObjects(ShearySmashCutter)[1]
    if smash_cutter then
        smash_cutter:remove()
    end
end

return SmashCut
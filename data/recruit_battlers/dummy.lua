local Dummy, super = Class(RecruitBattler)

function Dummy:init()
    super.init(self)
    
    self.name = "Dummy"
    
    self.actor_id = "dummy"
    
    self.flip = true
end

function Dummy:onTurnStart()
    for _,battler in ipairs(Game.battle.party) do
        battler:heal(battler.chara:getStat("health") / 10)
    end
end

return Dummy

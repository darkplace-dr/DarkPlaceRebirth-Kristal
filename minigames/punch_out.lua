---@class PunchOutMinigame : PunchOut
local PunchOutMinigame, super = Class(PunchOut)

function PunchOutMinigame:init()
    super.init(self)

    self.name = self.name

    self.req_score = 5000

    self.flag = "acj_game_win"
    self.hs_flag = "ball_jump_1_hs"
    
    self:setupAttackA()
end

function PunchOutMinigame:setupAttackA()
    self.attack_phase = 0
    self:resetQueen()
    self:addQueenAttack("PUNCH", 0, 4, 30)
    self:addQueenAttack("PUNCH", 0, 4, 30)
    self:addQueenAttack("PUNCH", 0, 4, 30)
    self:addQueenAttack("PUNCH", 0, 4, 30)
end

function PunchOutMinigame:setupAttackB()
    self.attack_phase = 1
    self:resetQueen()
    self:addQueenAttack("KICK", 0, 2, 30)
    self:addQueenAttack("PUNCH", 0, 4, 0)
    self:addQueenAttack("KICK", 0, 2, 30)
    self:addQueenAttack("PUNCH", 0, 4, 0)
end

function PunchOutMinigame:setupAttackC()
    self.attack_phase = 2
    self:resetQueen()
    self:addQueenAttack("PUNCH", 0, 4, 30)
    self:addQueenAttack("KICK", 0, 2, 0)
    self:addQueenAttack("WHEEL", 1, 2, 72)
    self:addQueenAttack("WHEEL", 1, 2, 72)
end

function PunchOutMinigame:setupAttackD()
    self.attack_phase = 3
    self:resetQueen()
    self:addQueenAttack("PUNCH", 0, 4, 30)
end

function PunchOutMinigame:changeAttack(hp, hp_max)
    if self.attack_phase == 0 and hp <= hp_max * 0.75 then
        self:setupAttackB()
        return true
    elseif self.attack_phase == 1 and hp <= hp_max * 0.5 then
        self:setupAttackC()
        return true
    elseif self.attack_phase == 2 and hp <= hp_max * 0.25 then
        self:setupAttackD()
        return true
    end
    return false
end

return PunchOutMinigame
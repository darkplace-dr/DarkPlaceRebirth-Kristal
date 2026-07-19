local LenHoodRedSpear, super = Class(Encounter)

function LenHoodRedSpear:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* You feel a sense of [color:yellow]JUSTICE[color:reset]."

    -- Battle music ("battle" is rude buster)
    self.music = "deltarune/ch4_extra_boss"
    -- Enables the purple grid battle background
    self.background = false

    self.len_hood = self:addEnemy("len_hood")

    self.len = Game:getPartyMember("len")
end

function LenHoodRedSpear:onTurnStart()
    local len_hood = self.len_hood
    if len_hood.final_attack_wave_triggered then
        len_hood:setTired(true)
    end

    for _,battler in pairs(Game.battle:getBattlers()) do
        if battler.actor.id == "len" and self.len:getFlag("hoodless") then
            if #Game.party > 1 then
                local chara = battler.chara
                if not chara:isLast() then
                    Game.battle:pushForcedAction(battler, "ACT", self.len_hood, {name = "Refuse"})
                else
                    battler:alert()
                    battler:setAnimation("battle/idle")
                end
            else
                battler:setAnimation("battle/idle")
            end
        end
    end
end

function LenHoodRedSpear:createSoul(x, y, color)
    return GreenSoul(x, y)
end

function LenHoodRedSpear:onActionsEnd()
    local mercy = self.len_hood.mercy
    if mercy >= 100 or self.len_hood.health <= 200 then
        self.len_hood.final_attack = true
    end
end

return LenHoodRedSpear
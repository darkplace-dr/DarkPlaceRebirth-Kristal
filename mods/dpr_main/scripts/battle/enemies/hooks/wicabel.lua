local Wicabel, super = HookSystem.hookScript("wicabel")

function Wicabel:init()
    super.init(self)
	
    self:registerAct("J-Tuningx2", "Tuning\ntwice", {"jamm"})
end

function Wicabel:onAct(battler, name)
    if name == "Tuning" or name == "Tuningx2" then
        local isdouble = false
        if name == "Tuningx2" then isdouble = true end
        local tuning = WicabelTuning(self, battler, isdouble, Game.battle:getPartyBattler('susie'))
        Game.battle:addChild(tuning)
        return
    elseif name =="J-Tuningx2" then
        local tuning = WicabelTuning(self, battler, true, Game.battle:getPartyBattler('jamm'))
        Game.battle:addChild(tuning)
        return
    elseif name == "Standard" then
        if battler.chara.id == "jamm" then
            self:addMercy(40)
            return  "* Jamm shoots a bell!"
		end
    end

    return super.onAct(self, battler, name)
end

function Wicabel:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "jamm" then
            self:addMercy(40)
            return  "* Jamm shoots a bell!"
		end
    end

    return super.onShortAct(self, battler, name)
end

return Wicabel
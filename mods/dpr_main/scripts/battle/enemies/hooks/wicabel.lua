local Wicabel, super = HookSystem.hookScript("wicabel")

function Wicabel:init()
    super.init(self)

    self.killable = true

    self:registerAct("J-Tuningx2", "Tuning\ntwice", { "jamm" })
end

function Wicabel:onAct(battler, name)
    if name == "J-Tuningx2" then
        Game.battle:addChild(WicabelTuning(self, battler, true, Game.battle:getPartyBattler("jamm")))
        return
    end

    return super.onAct(self, battler, name)
end

function Wicabel:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "jamm" then
            self:addMercy(40)
            return "* Jamm shoots a bell!"
        end
    end

    return super.onShortAct(self, battler, name)
end

return Wicabel

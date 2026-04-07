local Guei, super = HookSystem.hookScript("guei")

function Guei:init()
    super.init(self)

    self:registerAct("Xercism", "60% &\nDelayed\nTIRED", {"jamm"})
end

function Guei:onAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "jamm" then
            self:addMercy(40)
            return  "* Jamm told a story about a\nlonely ghost!"
        end
    end

    return super.onAct(self, battler, name)
end

function Guei:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "jamm" then
            self:addMercy(40)
            return  "* Jamm told a ghost story!"
        end
    end

    return super.onShortAct(self, battler, name)
end

return Guei
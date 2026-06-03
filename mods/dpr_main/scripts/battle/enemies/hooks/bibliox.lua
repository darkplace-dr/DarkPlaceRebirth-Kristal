local Bibliox, super = HookSystem.hookScript("bibliox")

function Bibliox:init()
    super.init(self)

    self:registerAct("EasyProof", "More\ntime to\nfix", {"jamm"})
end

function Bibliox:onAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "jamm" then
            self:addMercy(15)
            return  "* Jamm made a quote from memory!"
        end
    end

    return super.onAct(self, battler, name)
end

function Bibliox:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "jamm" then
            self:addMercy(15)
            return  "* Jamm made a quote from memory!"
        end
    end

    return super.onShortAct(self, battler, name)
end

return Bibliox
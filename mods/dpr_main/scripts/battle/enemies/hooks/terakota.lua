local Terakota, super = HookSystem.hookScript("terakota")

function Terakota:init()
    super.init(self)

    self.killable = true
end

function Terakota:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "jamm" then
            self:addMercy(18)
            local text = {
                "* Jamm replaces soil!",
                "* Jamm ate fruit!",
                "* Jamm cares for the soil!"
            }
            return TableUtils.pick(text)
        end
    end
    return super.onShortAct(self, battler, name)
end

return Terakota

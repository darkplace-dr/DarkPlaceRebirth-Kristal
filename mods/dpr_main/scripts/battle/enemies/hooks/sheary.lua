local Sheary, super = HookSystem.hookScript("sheary")

function Sheary:init()
    super.init(self)

    self.killable = true
end

function Sheary:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "jamm" then
            self:addMercy(40)
            return "* Jamm received a haircut!"
        end
    end
    return super.onShortAct(self, battler, name)
end

return Sheary

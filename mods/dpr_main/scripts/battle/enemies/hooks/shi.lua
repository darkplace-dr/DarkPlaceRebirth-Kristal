local Shi, super = HookSystem.hookScript("shi")

function Shi:init()
    super.init(self)

    self.killable = true
end

function Shi:onAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "jamm" then
            self:addMercy(30)
            return  "* Jamm shot a bell!"
        end
    end

    return super.onAct(self, battler, name)
end

return Shi

local Shi, super = HookSystem.hookScript("shi")

function Shi:init()
    super.init(self)

    self.killable = true
end

function Shi:onAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "jamm" then
            if #Game.battle:getActiveParty() == 1 then
                self:addMercy(50)
            else
                self:addMercy(30)
            end
            local text = {
                "* Jamm sews a hole!",
                "* Jamm picks up some straw!",
                "* Jamm reluctantly eats hay..."
            }
            return TableUtils.pick(text)
        end
    end

    return super.onAct(self, battler, name)
end

return Shi

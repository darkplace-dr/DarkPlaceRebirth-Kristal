local Shinobeetle, super = HookSystem.hookScript("shinobeetle")

function Shinobeetle:init()
    super.init(self)

    self.killable = true
end

function Shinobeetle:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "jamm" then
            if #Game.battle:getActiveParty() == 1 then
                self:addMercy(50)
            else
                self:addMercy(20)
            end
            local text = {
                "* Jamm calms the enemy down!",
                "* Jamm makes a brave pose!",
                "* Jamm offers a break!"
            }
            return TableUtils.pick(text)
        end
    end
    return super.onShortAct(self, battler, name)
end

return Shinobeetle

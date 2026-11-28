local Shi, super = HookSystem.hookScript("shi")

function Shi:init()
    super.init(self)

    self.killable = true
end

function Shi:onShortAct(battler, name)
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
        elseif battler.chara.id == "ceroba" then
            if #Game.battle:getActiveParty() == 1 then
                self:addMercy(50)
            else
                self:addMercy(30)
            end
            local text = {
                "* Ceroba makes a cowboy hat!",
                "* Ceroba acts tough!",
                "* Ceroba pretends to eat hay."
            }
            return TableUtils.pick(text)
        end
    end

    return super.onShortAct(self, battler, name)
end

return Shi

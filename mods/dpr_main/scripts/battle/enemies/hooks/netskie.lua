local Netskie, super = HookSystem.hookScript("netskie")

function Netskie:init()
    super.init(self)

    self.killable = true
end

function Netskie:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "jamm" then
            if #Game.battle:getActiveParty() == 1 then
                self:addMercy(29)
            else
                self:addMercy(9)
            end
            local rand = TableUtils.pick({ 0, 1 })
            if rand == 0 then
                battler:setActSprite("party/jamm/dark/dess", -5, 0)
                return "* Jamm's Dess impression!"
            elseif rand == 1 then
                battler:setActSprite("party/jamm/dark/susie", -5, 0, 0.2, true)
                return "* Jamm's Susie impression!"
            --[[elseif rand == 2 then
                battler:setActSprite("party/susie/dark/ralsei_pose", -3, -1)
                return "* Jamm's Ralsei impression!"]]
            end
        end
    end

    return super.onShortAct(self, battler, name)
end

return Netskie

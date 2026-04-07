local Balthizard, super = HookSystem.hookScript("balthizard")

function Balthizard:init()
    super.init(self)

    self:registerAct("ArmUp", "50% &\nHURT\nothers", {"jamm"})
end

function Balthizard:onAct(battler, name)
    if name == "ArmUp" then
        Game.battle:startActCutscene(function(cutscene)
            cutscene:text("* Jamm armed up!")	-- feel free to come up with some kind of effect
            self:addMercy(50)
            local line1 = "* The room got smokey!"
            local line2 = "* Other enemies became HURT!"
            for _,enemy in ipairs(Game.battle.enemies) do
                if enemy ~= self then
                    enemy:hurt(100, Game.battle:getPartyBattler('jamm'))
					Assets.playSound("damage")
                end
            end
            cutscene:text(line1.."\n"..line2)
            self.dialogue_override = "Ah! That\nwakes\nme up!!!"
        end)
        return
    end

    return super.onAct(self, battler, name)
end

return Balthizard
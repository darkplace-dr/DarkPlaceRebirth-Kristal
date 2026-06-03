local enemy, super = Class("rabbick", true)

function enemy:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "jamm" then
            self:addMercy(25)
            self:setTired(true)
            local msg = TableUtils.pick({
                "* Jamm does his part in cleaning!",
                "* Jamm uses a vacuum cleaner!",
                "* Jamm organizes his stuff!"
            })
            return msg
        end
    end
    
    return super.onShortAct(self, battler, name)
end

function enemy:onAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "jamm" then
            self:addMercy(25)
            self:setTired(true)
            Game.battle:startActCutscene(function(cutscene)
                cutscene:text("* Jamm tried to clean the \nenemy! It became TIRED...")
            end)
            return
        end
    end
    
    return super.onAct(self, battler, name)
end

return enemy

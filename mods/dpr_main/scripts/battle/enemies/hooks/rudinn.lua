local enemy, super = Class("rudinn", true)

function enemy:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "jamm" then
            self:addMercy(100)
            return "* Jamm logic'd the enemies!"
        end
    end
    
    return super.onShortAct(self, battler, name)
end

function enemy:onAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "jamm" then
            self:addMercy(50)
            self.text_override = "I'll try\nmy best!"
            Game.battle:startActCutscene(function(cutscene)
                cutscene:text("* Jamm tried to give encouragement!")
                cutscene:text("* You should strive to be the best you can be!", "smile", "jamm")
            end)
            return
        end
    end
    
    return super.onAct(self, battler, name)
end

return enemy

local enemy, super = Class("virovirokun", true)

function enemy:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "jamm" then
            self:addMercy(100)
            return "* Jamm offered an ice pack!"
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
                cutscene:text("* Jamm offered some advice!")
                cutscene:text("* Sometimes,[wait:5] it's best to watch stuff happen.", "look_left", "jamm")
                cutscene:text("* You don't want to get in trouble,[wait:5] after all.", "worried", "jamm")
            end)
            return
        end
    end
    
    return super.onAct(self, battler, name)
end

return enemy

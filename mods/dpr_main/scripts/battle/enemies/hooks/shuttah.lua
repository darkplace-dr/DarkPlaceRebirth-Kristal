local enemy, super = Class("shuttah", true)

function enemy:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "jamm" then
            local flavor_text = {
                "* Jamm waves at the camera!",
                "* Jamm poses at the camera!",
                "* Jamm shows his best smile!"
            }
            self:addMercy(30)
            return TableUtils.pick(flavor_text)
        end
    end
    
    return super.onShortAct(self, battler, name)
end

return enemy

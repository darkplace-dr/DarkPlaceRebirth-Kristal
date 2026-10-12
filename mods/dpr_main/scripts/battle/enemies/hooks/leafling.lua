local Leafling, super = HookSystem.hookScript("leafling")

function Leafling:init()
    super.init(self)

    self.killable = true
end

function Leafling:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "jamm" then
            self:addMercy(35)
            local text = {
                "* Jamm fans the air!",
                "* Jamm raises a makeshift sail!",
                "* Jamm walks against the wind!"
            }
            return TableUtils.pick(text)
        end
    end
    return super.onShortAct(self, battler, name)
end

return Leafling

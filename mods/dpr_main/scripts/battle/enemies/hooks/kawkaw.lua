local Kawkaw, super = HookSystem.hookScript("kawkaw")

function Kawkaw:init()
    super.init(self)

    self.killable = true
end

function Kawkaw:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "jamm" then
            self:addMercy(40)
            local text = {
                "* Jamm slings some crumbs!",
                "* Jamm scratches under the beak!",
                "* Jamm offers trash for a nest!"
            }
            return TableUtils.pick(text)
        end
    end
    return super.onShortAct(self, battler, name)
end

return Kawkaw

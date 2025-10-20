---@class Interactable : Interactable
local Interactable, super = Utils.hookScript(Interactable)

function Interactable:init(x, y, shape, properties)
    properties = properties or {}
    super.init(self, x, y, shape, properties)
    if properties["texture"] then
        Kristal.Console:warn("Deprecated Interactable \"texture\" property used, please use usetile instead.")
        self:setSprite(properties["texture"])
    end
end

return Interactable
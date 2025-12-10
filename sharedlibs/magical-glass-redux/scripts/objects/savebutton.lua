local SaveButton, super = Class(ActionButton)

function SaveButton:init()
    super.init(self, "save")
end

function SaveButton:update()
    self:setColor(Utils.hslToRgb(Kristal.getTime() / 0.75 % 1, 1, 0.69))

    super.update(self)
end

return SaveButton
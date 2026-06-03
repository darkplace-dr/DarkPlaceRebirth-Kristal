local FleeButton, super = Class(LightActionButton)

function FleeButton:init()
    super.init(self, "save")
end

function FleeButton:update()
    super.update(self)
    
    if not self.disabled then
        self:setColor(ColorUtils.HSLToRGB(Kristal.getTime() / 0.75 % 1, 1, 0.69))
    end
end

return FleeButton
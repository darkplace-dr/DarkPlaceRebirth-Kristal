---@class DamageNumber : DamageNumber
local DamageNumber, super = HookSystem.hookScript(DamageNumber)

function DamageNumber:setDisplay(type, arg, color)
    if type ~= "tired" then
        super.setDisplay(self, type, arg, color)
        return
    end

    self.amount = nil
    self.message = nil
    self.texture = nil
    self.text = nil
    self.darken = false

    self.color = color or self.color

    self.type = type or "msg"
    self.amount = arg or 0
    if self.type == "tired" then
        self.font = Assets.getFont("bluenumbers")
        if self.amount == 100 then
            self.type = "msg"
            self.message = "tiredness"
        elseif self.amount < 0 then
            self.text = self.amount .. "%"
            self.darken = true
        else
            self.text = "+" .. self.amount .. "%"
        end
    end

    if self.message then
        self.texture = Assets.getTexture("ui/battle/msg/" .. self.message)
        self.width = self.texture:getWidth()
        self.height = self.texture:getHeight()
    elseif self.text then
        self.width = self.font:getWidth(self.text)
        self.height = self.font:getHeight()
    end
end

return DamageNumber
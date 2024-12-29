---@class ButtonPrompt : Object
---@overload fun(...) : ButtonPrompt
local ButtonPrompt, super = Class(Object)

function ButtonPrompt:init(x, y, key, callback_or_pitch)
    super.init(self, x, y)
	
	self.font = Assets.getFont("main")
    self.key = key
    if type(callback_or_pitch) == "function" then
        self.on_pressed = callback_or_pitch
    elseif type(callback_or_pitch) == "number" then
        self.sound_pitch = callback_or_pitch
    end
    self.pressed = false
end

function ButtonPrompt:update()
    super.update(self)
    if Input.pressed(self.key) and not self.pressed then
        self.pressed = true
        self.alpha = 0.5
        if self.on_pressed then
            self:on_pressed()
        elseif self.sound_pitch then
            Assets.playSound("mercyadd", 0.5, self.sound_pitch)
        end
    end
end

function ButtonPrompt:draw()
    if Input.usingGamepad() then
        love.graphics.draw(Input.getTexture(self.key),0,0,0,2,2)
    else
        love.graphics.setFont(self.font)
        love.graphics.print(Input.getText(self.key), 0, 0)
    end
end

return ButtonPrompt

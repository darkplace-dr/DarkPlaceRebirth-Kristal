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
    self.pressed_count = 0
    self.pressed_max = 1
    self:setOrigin(0.5)
    self.shake_rng = love.math.newRandomGenerator()
end

function ButtonPrompt:update()
    self.scale_x = Utils.approach(self.scale_x, 1, DT*10)
    self.scale_y = Utils.approach(self.scale_y, 1, DT*10)
    super.update(self)
    if Input.pressed(self.key) and self.pressed_max > self.pressed_count then
        self.pressed_count = self.pressed_count + 1
        if self.pressed_count >= self.pressed_max then
            self.pressed = true
            self.alpha = 0.5
            if self.on_pressed then
                self:on_pressed()
            end
        end
        self:setScale(2,2)
        if self.sound_pitch then
            Assets.playSound("mercyadd", 0.5, Utils.clampMap(self.pressed_count, 0, self.pressed_max, self.sound_pitch/1.5, self.sound_pitch))
        end
    end
end

function ButtonPrompt:draw()
    if self.pressed_max > 1 then
        love.graphics.translate(
            self.shake_rng:random(-2,2),
            self.shake_rng:random(-2,2)
        )
    end
    if Input.usingGamepad() then
        local key = Input.getTexture(self.key)
        love.graphics.draw(key,-key:getWidth(),-key:getHeight(),0,2,2)
    else
        love.graphics.setFont(self.font)
        love.graphics.print(Input.getText(self.key), -self.font:getWidth(Input.getText(self.key))/2, -self.font:getHeight()/2)
    end
end

return ButtonPrompt

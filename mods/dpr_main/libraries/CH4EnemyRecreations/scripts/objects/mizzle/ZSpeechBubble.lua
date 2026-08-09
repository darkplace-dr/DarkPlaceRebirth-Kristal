local ZSpeechBubble, super = Class(Sprite)

function ZSpeechBubble:init(x, y)
    super.init(self, "bubbles/z", x, y)

    self:setScale(1)
    self:setOrigin(0, 0)

    self.done = false

    self.wait_timer = 15/30
end

function ZSpeechBubble:advance()
    if self.wait_timer == 0 then
        self.done = true
        self:remove()
    end
end

function ZSpeechBubble:isTyping()
    return false
end

function ZSpeechBubble:isDone()
    return self.done
end

function ZSpeechBubble:onAddToStage(stage)
    super.onAddToStage(self, stage)
end

function ZSpeechBubble:update()
    self.wait_timer = MathUtils.approach(self.wait_timer, 0, DT)

    if Input.pressed("confirm") or Input.down("menu") then
        self:advance()
    end
end

function ZSpeechBubble:draw()
    super.draw(self)
end

return ZSpeechBubble
local WingladeSpeechBubble, super = Class(Object)

function WingladeSpeechBubble:init(text, speaker)
    super.init(self, speaker.x, speaker.y)

    self.speaker = speaker
    self.rotation = math.rad(Utils.random(0, math.rad(360)))
    self.physics.spin = math.rad(1)
    self.physics.match_rotation = true
    self.text = text
    self.text_time = 90
    self.timer = 0
    self.advanced = false
end

function WingladeSpeechBubble:setStyle(style) end

function WingladeSpeechBubble:onRemoveFromStage(stage)
    super.onRemoveFromStage(self, stage)
    if self.speaker and self.speaker.bubble == self then
        self.speaker:onBubbleRemove(self)
        self.speaker.bubble = nil
    end
    self:remove()
    self.advanced = true
end

function WingladeSpeechBubble:advance()
    self.advanced = true
end

function WingladeSpeechBubble:setText(text, callback, line_callback) end

function WingladeSpeechBubble:setAuto(auto) end

function WingladeSpeechBubble:setAdvance(advance) end

function WingladeSpeechBubble:setSkippable(skippable) end

function WingladeSpeechBubble:setCallback(callback) end

function WingladeSpeechBubble:setLineCallback(callback) end

function WingladeSpeechBubble:setRight(right) end

function WingladeSpeechBubble:isTyping()
    return not self:isDone()
end

function WingladeSpeechBubble:isDone()
    return (self.timer > self.text_time or self.advanced) and self.timer > 30
end

function WingladeSpeechBubble:update()
    super.update(self)
    self.y = self.speaker.sprite.y + self.speaker.y
    if self.timer > 30 and Input.pressed("confirm") then self.advanced = true end
    self.timer = self.timer + DTMULT
    if self:isDone() then
        self:onRemoveFromStage()
    end
end

function WingladeSpeechBubble:getBorder() end

function WingladeSpeechBubble:getDebugRectangle()
    return super.getDebugRectangle(self)
end

function WingladeSpeechBubble:getSprite(name) end

function WingladeSpeechBubble:getSpriteSize(name) end

function WingladeSpeechBubble:getTailWidth() end

function WingladeSpeechBubble:updateSize() end

function WingladeSpeechBubble:drawText(rotation)
    local radius = 80
    for i = 1, #self.text do
        local rotation = math.rad(i * 8) + rotation
        local x, y = math.cos(rotation) * radius, math.sin(rotation) * radius
        love.graphics.print(self.text[i], x, y, rotation + math.rad(90), 1, 1)
    end
end

function WingladeSpeechBubble:draw()
    Draw.setColor(COLORS.white)
    love.graphics.setFont(Assets.getFont('plain'))
    self:drawText(0)
end

return WingladeSpeechBubble
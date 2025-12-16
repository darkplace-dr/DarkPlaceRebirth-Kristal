local WingladeSpeechBubble, super = Class(Object)

function WingladeSpeechBubble:init(text, speaker)
    super.init(self, speaker.x, speaker.y)

    self.done = false
    self.speaker = speaker
    self.rotation = math.rad(MathUtils.random(0, math.rad(360)))
    self.physics.spin = math.rad(1)
    self.physics.match_rotation = true
    self.text = text
    self.wait_timer = 15/30
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
    if self.wait_timer == 0 then
        self.done = true
        self:remove()
    end
end

function WingladeSpeechBubble:isTyping()
    return false
end

function WingladeSpeechBubble:isDone()
    return self.done
end

function WingladeSpeechBubble:update()
    super.update(self)
    local height = self.speaker:getScaledHeight()
    local _, y = self.speaker.sprite:getRelativePosFor(self.parent)
    self.y = y + height * 0.5
    self.wait_timer = MathUtils.approach(self.wait_timer, 0, DT)

    if Input.pressed("confirm") or Input.down("menu") then
        self:advance()
    end
end

function WingladeSpeechBubble:drawText(rotation)
    local radius = 80
    for i = 1, #self.text do
        local char_rotation = math.rad(i * 8) + rotation
        local x, y = math.cos(char_rotation) * radius, math.sin(char_rotation) * radius
        love.graphics.print(self.text[i], x, y, char_rotation + math.rad(90), 1, 1)
    end
end

function WingladeSpeechBubble:draw()
    Draw.setColor(COLORS.white)
    love.graphics.setFont(Assets.getFont('plain'))
    self:drawText(0)
end

return WingladeSpeechBubble
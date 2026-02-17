local HathySpeechBubble, super = Class(Sprite)

function HathySpeechBubble:init(x, y, type)
    super.init(self, "bubbles/battleblcon", x, y)

    self.type = type or "heartchomp"

    self:setScale(1)
    self:setOrigin(1, 0)

    self.done = false

    self.wait_timer = 15/30

    self.siner = 0
    self.letter_siner = 0
end

function HathySpeechBubble:advance()
    if self.wait_timer == 0 then
        self.done = true
        self:remove()
    end
end

function HathySpeechBubble:isTyping()
    return false
end

function HathySpeechBubble:isDone()
    return self.done
end

function HathySpeechBubble:onAddToStage(stage)
    super.onAddToStage(self, stage)
end

function HathySpeechBubble:update()
    self.wait_timer = MathUtils.approach(self.wait_timer, 0, DT)

    if Input.pressed("confirm") or Input.down("menu") then
        self:advance()
    end

    self.siner = self.siner + (1 * DTMULT)
    self.letter_siner = self.letter_siner + (0.2 * DTMULT)
end

function HathySpeechBubble:draw()
    super.draw(self)

    local r,g,b,a = self:getDrawColor()

    Draw.setColor(1, 1, 1, a)
    local frames = Assets.getFramesOrTexture("bubbles/hathy/"..self.type)
    local texture = frames[(math.floor(self.letter_siner) % #frames) + 1]

    local letter_x = 15 + MathUtils.round(math.sin(self.siner / 8))
    local letter_y = 15 + MathUtils.round(math.cos(self.siner / 8))

    Draw.draw(texture, letter_x, letter_y)
end

return HathySpeechBubble
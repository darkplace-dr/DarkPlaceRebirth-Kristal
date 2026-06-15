local GueiTextbox, super = Class(Sprite)

function GueiTextbox:init(x, y, frame)
    super.init(self, "bubbles/guei/small", x, y)
	
    self:setFrame(frame)

    self:setScale(1)
    self:setOrigin(1, 0)

    self.done = false

    self.wait_timer = 15/30
end

function GueiTextbox:advance()
    if self.wait_timer == 0 then
        self.done = true
        self:remove()
    end
end

function GueiTextbox:isTyping()
    return false
end

function GueiTextbox:isDone()
    return self.done
end

function GueiTextbox:onAddToStage(stage)
    super.onAddToStage(self, stage)
end

function GueiTextbox:update()
    self.wait_timer = Utils.approach(self.wait_timer, 0, DT)

    if Input.pressed("confirm") or Input.down("menu") then
        self:advance()
    end
end

function GueiTextbox:draw()
    super.draw(self)
end

return GueiTextbox
---@class Textbox : Textbox
local Textbox, super = Utils.hookScript(Textbox)

function Textbox:setActor(actor)
    self.noel = false
    super.setActor(self, actor)
    if self.actor and self.actor.name == "Noel" and self.actor.b_tog == 9 then
        self.noel = true

        self.next_time = self.actor.next_time or (os.date("%S") + self.actor:pickRandomDigit())


        function self:draw()
            super.draw(self)
        end
    end
end

function Textbox:draw()
    super.draw(self)
    if self.noel then
        local second = self.actor.second or (Kristal.getTime() + 0)

        if self.next_time <= second then
            self.next_time = self.actor.next_time or (self.actor:pickRandomDigit() + os.date("%S"))
            if self.next_time > (59) then
                self.next_time = self.actor.next_time or (self.next_time - 59)
            end
            self.blink = self.actor.blink or 0
        end

        if self.blink then
            Draw.setColor(1, 1, 1, 1)
            love.graphics.rectangle("fill", 30, 30, 34, 32) -- make this white
            Draw.setColor(0, 0, 0, 1)
            love.graphics.rectangle("fill", 32, 50, 10, 2) -- make this black
            love.graphics.rectangle("fill", 46, 52, 18, 2)

            if self.blink >= 1 then
                self.blink = self.actor.blink or nil
            else
                self.blink = self.actor.blink or (self.blink + DTMULT)
            end
        end
    end
end

return Textbox
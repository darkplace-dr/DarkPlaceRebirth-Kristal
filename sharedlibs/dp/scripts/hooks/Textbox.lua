---@class Textbox : Textbox
local Textbox, super = Utils.hookScript(Textbox)

function Textbox:setText(text, callback)
    super.setText(self, text, callback)
    if self.actor and self.actor.id == "noel" and (math.random(99) == 64) then

        for i, b in ipairs(self.text.nodes) do
            if b.character then
                b.character = Noel:crow_launguage(b.character)
            end
        end
        self.text.draw_every_frame = true
    end
end

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

    self.marcy = false
    
    if self.actor and self.actor.id == "marcy" and Game:getFlag("marcy_has_eyepatch", false) then
        self.marcy = Assets.getTexture("face/marcy/patch")
    end

    self.jamm = false
    
    if self.actor and self.actor.id == "jamm" and Game:getFlag("jamm_has_glasses", false) then
        self.jamm = Assets.getTexture("face/jamm/glasses_overlay")
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
    if self.marcy then
        Draw.draw(self.marcy, 18, 10, 0, 2, 2)
    end
    if self.jamm then
        Draw.draw(self.jamm, -1, 3, 0, 2, 2)
    end
end

return Textbox

---@class Textbox : Textbox
local Textbox, super = HookSystem.hookScript(Textbox)

function Textbox:init(x, y, width, height, default_font, default_font_size, battle_box)
    super.init(self, x, y, width, height, default_font, default_font_size, battle_box)

    self.do_ceroba_eye_twitch = false
    self.ceroba_eye_twitched = false
    self.ceroba_eye_twitch_timer = 0
end

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

function Textbox:update()
    super.update(self)

    if self.do_ceroba_eye_twitch then
        if MathUtils.randomInt(30 + 1) == 1 and not self.ceroba_eye_twitched then
            self.face:setSprite("lostit_twitch")
            self.ceroba_eye_twitch_timer = 1
            self.ceroba_eye_twitched = true
        else
            self.ceroba_eye_twitch_timer = MathUtils.approach(self.ceroba_eye_twitch_timer, 0, 0.2 * DTMULT)
            if self.ceroba_eye_twitch_timer == 0 then
                self.face:setSprite("lostit")
                self.ceroba_eye_twitched = false
            end
        end
    end
end

function Textbox:setFace(face, ox, oy)
    super.setFace(self, face, ox, oy)
    if self.actor and self.actor.id == "ceroba" and face == "lostit" then
        self.do_ceroba_eye_twitch = true
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

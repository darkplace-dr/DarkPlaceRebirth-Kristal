local ActorSprite, super = HookSystem.hookScript(ActorSprite)

function ActorSprite:init(actor)
    super.init(self, actor)

    self.run_away_light = false
    self.run_away_party = false
end

function ActorSprite:update()
    super.update(self)

    if self.run_away_light then
        self.run_away_timer = self.run_away_timer + DTMULT
    end
    if self.run_away_party then
        self.run_away_timer = self.run_away_timer + DTMULT
    end
end

function ActorSprite:draw()
    if self.actor:preSpriteDraw(self) then
        return
    end

    if self.texture and self.run_away_light then
        local r, g, b, a = self:getDrawColor()
        for i = 0, 80 do
            local alph = a * 0.4
            Draw.setColor(r, g, b, ((alph - (self.run_away_timer / 8)) + (i / 200)))
            Draw.draw(self.texture, i * 4, 0)
        end

        return
    end

    if self.texture and self.run_away_party then
        local r, g, b, a = self:getDrawColor()
        for i = 0, 80 do
            local alph = a * 0.4
            Draw.setColor(r, g, b, ((alph - (self.run_away_timer / 8)) + (i / 200)))
            Draw.draw(self.texture, i * (-2), 0)
        end

        return
    end

    super.draw(self)
end

return ActorSprite
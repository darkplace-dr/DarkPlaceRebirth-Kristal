local CutText, super = Class(Object)

function CutText:init(x, y)
    super.init(self, x, y)

    self.con = 1
    self.timer = 30

    self.font = Assets.getFont("main")
end

function CutText:draw()
    local cutstring = "CUT!!!"
    if self.con == 1 then
        self.timer = self.timer - DTMULT
        local shakedir = -1
        if (self.timer % 2) == 0 then
            shakedir = 1
        end
        Draw.setColor(ColorUtils.unpackColor(COLORS.white))
        love.graphics.setFont(self.font)
        love.graphics.print(cutstring, -self.font:getWidth(cutstring) * 1.5 / 2 + (shakedir * self.timer * 0.2), 0, 0, 1.5, 1.5)
        if self.timer <= 0 then
            self.con = 2
            self.timer = 0
        end
    elseif self.con == 2 then
        self.timer = self.timer + DTMULT
        local r, g, b = ColorUtils.unpackColor(COLORS.white)
        Draw.setColor(r, g, b, MathUtils.lerp(1, 0, self.timer / 30))
        love.graphics.setFont(self.font)
        love.graphics.print(cutstring, -self.font:getWidth(cutstring) * 1.5 / 2, 0, 0, 1.5, 1.5)
        if self.timer >= 30 then
            self:remove()
        end
    end

    super.draw(self)
end

return CutText

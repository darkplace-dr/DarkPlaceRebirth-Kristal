local TVSnow, super = Class(Object)

function TVSnow:init(x, y)
    super.init(self, x, y)
	
    self.snowfall = Assets.getTexture("effects/icespell/snowfall")
    self.timer = 0
    self.xpos = 0
    self.batcon = 0

    self.overlay = false
    self.parallax_x = 0.75
end

function TVSnow:draw()
    super.draw(self)

    self.xpos = self.x * self.parallax_x
    self.timer = self.timer + DTMULT

    love.graphics.setColor(1, 1, 1, 0.1)
    Draw.drawWrapped(self.snowfall, true, true, self.xpos + math.ceil((self.timer / 12) + (math.sin(self.timer / 48) * 18)), self.timer / 6, 0, 1, 1)
    Draw.drawWrapped(self.snowfall, true, true, self.xpos + math.ceil((self.timer / 13) + (math.sin(self.timer / 57) * 18)), self.timer / 7, 0, 1, 1)
    Draw.drawWrapped(self.snowfall, true, true, self.xpos + math.ceil((self.timer / 14) + (math.sin(self.timer / 64) * 18)), self.timer / 8, 0, 0.5, 0.5)
	
    if self.overlay == true then
        self.layer = WORLD_LAYERS["below_ui"]
        local color = Utils.mergeColor(COLORS.black, COLORS.navy, 0.8)
        love.graphics.setColor(color[1], color[2], color[3], 0.4)
        Draw.rectangle("fill", 0, 0, 9999, 9999)
    end
end

return TVSnow
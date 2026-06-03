local TennaSmashCutManager, super = Class(Object)

function TennaSmashCutManager:init(x, y)
    super.init(self, x, y)

    self.canvas = -4
    self.fadetype = 0
    self.intensity = 0
    self.bar_v = 96
    self.timer = 1.5707963267948966
    self.timer2 = 0
end

function TennaSmashCutManager:update()
    super.update(self)

    self.timer = self.timer + 0.025 * DTMULT

    if self.fadetype == 0 then
        self.intensity = MathUtils.approach(self.intensity, 1, (math.abs(1 - self.intensity) * 0.5)*DTMULT)
    end

    if self.fadetype == 1 then
        self.intensity = MathUtils.approach(intensity, 0, 0.1*DTMULT)
    
        if self.intensity == 0 then
            self:remove()
        end
    end
end

function TennaSmashCutManager:draw()
    super.draw(self)

    local remaining_time = Game.battle.wave_length - Game.battle.wave_timer
    if remaining_time < (1/30) then
        self:remove()
    end

	local canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
	love.graphics.clear(0,0,0,1)
	Draw.setColor(1,1,1,1)
	Draw.drawCanvas(SCREEN_CANVAS)
    Draw.popCanvas()

	love.graphics.push()
	love.graphics.origin()
    local cut = 0
    if Game.battle.arena then
        cut = Game.battle.arena.y
    end
    local cut2 = SCREEN_HEIGHT - cut

    local old_t2 = self.timer2
    self.timer2 = self.timer2 + DTMULT

    local xoffset = 0

    if old_t2 < 1 and self.timer2 >= 1 then
        xoffset = 10
    end
    if old_t2 < 2 and self.timer2 >= 2 then
        xoffset = -9
    end
    if old_t2 < 3 and self.timer2 >= 3 then
        xoffset = 8
    end
    if old_t2 < 4 and self.timer2 >= 4 then
        xoffset = -7
    end
    if old_t2 < 5 and self.timer2 >= 5 then
        xoffset = 6
    end
    if old_t2 < 6 and self.timer2 >= 6 then
        xoffset = -5
    end
    if old_t2 < 7 and self.timer2 >= 7 then
        xoffset = 4
    end
    if old_t2 < 8 and self.timer2 >= 8 then
        xoffset = -3
    end
    if old_t2 < 9 and self.timer2 >= 9 then
        xoffset = 2
    end
    if old_t2 < 10 and self.timer2 >= 10 then
        xoffset = -1
    end
    if old_t2 < 11 and self.timer2 >= 11 then
        xoffset = 0
    end

	Draw.setColor(0,0,0,1)
    Draw.rectangle("fill", 0, 0, SCREEN_WIDTH - 0 + 1, SCREEN_HEIGHT - 0 + 1)
	Draw.setColor(1,1,1,1)
    Draw.drawPart(canvas, (0 + xoffset + (math.sin(self.timer) * 24 * self.intensity)),                0,       0, 0,   SCREEN_WIDTH, cut,  0, 1, 1)
    Draw.drawPart(canvas, (0 + xoffset + (math.sin(self.timer) * 24 * self.intensity)) - SCREEN_WIDTH, 0,       0, 0,   SCREEN_WIDTH, cut,  0, 1, 1)
    Draw.drawPart(canvas, (0 + xoffset + (math.sin(self.timer) * 24 * self.intensity)) + SCREEN_WIDTH, 0,       0, 0,   SCREEN_WIDTH, cut,  0, 1, 1)
    Draw.drawPart(canvas, (0 + xoffset + (math.cos(self.timer) * 24 * self.intensity)),                0 + cut, 0, cut, SCREEN_WIDTH, cut2, 0, 1, 1)
    Draw.drawPart(canvas, (0 + xoffset + (math.cos(self.timer) * 24 * self.intensity)) - SCREEN_WIDTH, 0 + cut, 0, cut, SCREEN_WIDTH, cut2, 0, 1, 1)
    Draw.drawPart(canvas, (0 + xoffset + (math.cos(self.timer) * 24 * self.intensity)) + SCREEN_WIDTH, 0 + cut, 0, cut, SCREEN_WIDTH, cut2, 0, 1, 1)

    self.bar_v = MathUtils.approach(self.bar_v, 0, (self.bar_v * 0.5)*DTMULT)

    if self.bar_v < 0.1 then
        self.bar_v = 0
    end

    local bar_height = self.bar_v * 0.5
    local bar_width = SCREEN_WIDTH * 0.5
    
    if self.bar_v > 0 and Game.battle.arena then
        local x, y = Game.battle.arena.x - bar_width, Game.battle.arena.y - bar_height
        local w, h = Game.battle.arena.x + bar_width, Game.battle.arena.y + bar_height
        Draw.setColor(1,1,1,1)
        Draw.rectangle("fill", x, y, w - x + 1, h - y + 1)
    end

    love.graphics.pop()
end

function TennaSmashCutManager:onRemove(parent)
    super.onRemove(self, parent)
end

return TennaSmashCutManager
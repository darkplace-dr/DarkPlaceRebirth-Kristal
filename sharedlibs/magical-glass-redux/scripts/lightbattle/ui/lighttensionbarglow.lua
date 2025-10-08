local LightTensionBarGlow, super = Class(Object)

function LightTensionBarGlow:init(x, y)
    super.init(self, x, y)

    self.apparent = Game.tension
    self.current_alpha = 1
end

function LightTensionBarGlow:update()
    super.update(self)

    -- Copied from tension bars...
    if (math.abs((self.apparent - self.parent:getTension250())) < 20) then
        self.apparent = self.parent:getTension250()
    end

    if (self.apparent < self.parent:getTension250()) then
        self.apparent = self.apparent + (20 * DTMULT)
    end

    if (self.apparent > self.parent:getTension250()) then
        self.apparent = self.apparent - (20 * DTMULT)
    end

    -- Slowly fade out
    self.current_alpha = Utils.approach(self.current_alpha, 0, 0.15 * DTMULT)

    -- If we're fully faded out, remove
    if self.current_alpha <= 0 then
        self:remove()
    end
end

function LightTensionBarGlow:draw()
    -- Simplified draw code. DELTARUNE's is very verbose for no real reason
    -- The largest change is the lack of for loop, because DELTARUNE had a for loop
    -- that only did a single iteration... so that was completely removed

    Draw.setColor(1, 1, 1, 1)

    love.graphics.setBlendMode("add")

    -- Can be simplified to `0.75 * self.current_alpha`, but the `1` is the
    -- current iteration of the for loop... the one that only ran a single time
    local alpha = (1 - (1 * 0.25)) * self.current_alpha

    -- Do our draw code in all 8 directions
    local offsets = { -1, 0, 1 }
    for _, dx in ipairs(offsets) do
        for _, dy in ipairs(offsets) do
            if not (dx == 0 and dy == 0) then
                love.graphics.setFont(self.parent.tp_font)
                Draw.setColor(1, 1, 1, alpha)
                for i = 1, #Kristal.getLibConfig("magical-glass", "light_battle_tp_name") do
                    local char = Utils.sub(Kristal.getLibConfig("magical-glass", "light_battle_tp_name"), i, i)
                    love.graphics.print(char, -20 + dx, (i-1) * 21 + dy)
                end

                love.graphics.setFont(self.parent.font)
                if Game.tension < 100 then
                    Draw.printAlign(tostring(math.floor(Game.tension)) .. "%", 15 + dx, self.parent.height - 5 + dy, "center")
                else
                    love.graphics.print("MAX", 29 - 37 + dx, self.parent.height - 5 + dy)
                end
            end
        end
    end

    love.graphics.setBlendMode("alpha")

    Draw.setColor(1, 1, 1, 0.75 * self.current_alpha)
    Draw.draw(self.parent.tp_bar_fill, 0, 0, 0, 1, 1)

    super.draw(self)
end

return LightTensionBarGlow

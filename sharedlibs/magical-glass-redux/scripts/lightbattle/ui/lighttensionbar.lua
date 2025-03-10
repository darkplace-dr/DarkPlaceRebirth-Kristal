local LightTensionBar, super = Class(Object)

function LightTensionBar:init(x, y, dont_animate)
    if Game.world and (not x) then
        local x2 = Game.world.camera:getRect()
        x = x2 - 25
    end

    super.init(self, x or 25, y or 55)

    self.layer = LIGHT_BATTLE_LAYERS["ui"] - 2

    self.tp_bar_fill = Assets.getTexture("ui/lightbattle/tp_bar_fill")
    self.tp_bar_outline = Assets.getTexture("ui/lightbattle/tp_bar_outline")

    self.width = self.tp_bar_outline:getWidth()
    self.height = self.tp_bar_outline:getHeight()

    self.apparent = 0
    self.current = 0

    self.change = 0
    self.changetimer = 15
    self.tp_font = Assets.getFont("namelv", 24)
    self.font = Assets.getFont("main")

    self.parallax_y = 0

    if dont_animate ~= false then
        self.animating_in = false
    else
        self.animating_in = true
    end

    self.animation_timer = 0

    self.tsiner = 0

    self.tension_preview = 0
end

function LightTensionBar:show()
    self.visible = true
end

function LightTensionBar:hide()
    self.visible = false
end

function LightTensionBar:getDebugInfo()
    local info = super.getDebugInfo(self)
    table.insert(info, "Tension: "  .. Utils.round(self:getPercentageFor(Game:getTension()) * 100) .. "%")
    table.insert(info, "Apparent: " .. Utils.round(self.apparent / 2.5))
    table.insert(info, "Current: "  .. Utils.round(self.current / 2.5))
    return info
end

function LightTensionBar:getTension250()
    return self:getPercentageFor(Game:getTension()) * 250
end

function LightTensionBar:setTensionPreview(amount)
    self.tension_preview = amount
end

function LightTensionBar:getPercentageFor(variable)
    return variable / Game:getMaxTension()
end

function LightTensionBar:getPercentageFor250(variable)
    return variable / 250
end

function LightTensionBar:processTension()
    if (math.abs((self.apparent - self:getTension250())) < 20) then
        self.apparent = self:getTension250()
    elseif (self.apparent < self:getTension250()) then
        self.apparent = self.apparent + (20 * DTMULT)
    elseif (self.apparent > self:getTension250()) then
        self.apparent = self.apparent - (20 * DTMULT)
    end
    if (self.apparent ~= self.current) then
        self.changetimer = self.changetimer + (1 * DTMULT)
        if (self.changetimer > 15) then
            if ((self.apparent - self.current) > 0) then
                self.current = self.current + (2 * DTMULT)
            end
            if ((self.apparent - self.current) > 10) then
                self.current = self.current + (2 * DTMULT)
            end
            if ((self.apparent - self.current) > 25) then
                self.current = self.current + (3 * DTMULT)
            end
            if ((self.apparent - self.current) > 50) then
                self.current = self.current + (4 * DTMULT)
            end
            if ((self.apparent - self.current) > 100) then
                self.current = self.current + (5 * DTMULT)
            end
            if ((self.apparent - self.current) < 0) then
                self.current = self.current - (2 * DTMULT)
            end
            if ((self.apparent - self.current) < -10) then
                self.current = self.current - (2 * DTMULT)
            end
            if ((self.apparent - self.current) < -25) then
                self.current = self.current - (3 * DTMULT)
            end
            if ((self.apparent - self.current) < -50) then
                self.current = self.current - (4 * DTMULT)
            end
            if ((self.apparent - self.current) < -100) then
                self.current = self.current - (5 * DTMULT)
            end
            if (math.abs((self.apparent - self.current)) < 3) then
                self.current = self.apparent
            end
        end
    end

    if (self.tension_preview > 0) then
        self.tsiner = self.tsiner + DTMULT
    end
end

function LightTensionBar:update()
    self:processTension()

    super.update(self)
end

function LightTensionBar:drawText()
    love.graphics.setFont(self.tp_font)
    for i = 1, #Kristal.getLibConfig("magical-glass", "light_battle_tp_name") do
        local char = Utils.sub(Kristal.getLibConfig("magical-glass", "light_battle_tp_name"), i, i)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print(char, -20 + 1, 1 + (i-1) * 21)

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(char, -20, (i-1) * 21)
    end

    local tamt = math.floor(self:getPercentageFor250(self.apparent) * 100)
    self.maxed = false
    love.graphics.setFont(self.font)
    if (tamt < 100) then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf(tostring(math.floor(self:getPercentageFor250(self.apparent) * 100)) .. "%", 29 - 38, self.height - 4, 50, "center")
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(tostring(math.floor(self:getPercentageFor250(self.apparent) * 100)) .. "%", 29 - 39, self.height - 5, 50, "center")
    end
    if (tamt >= 100) then
        self.maxed = true

        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print("MAX", 29 - 36, self.height - 4)
        Draw.setColor(MG_PALETTE["tension_maxtext"])
        love.graphics.print("MAX", 29 - 37, self.height - 5)
    end
end

function LightTensionBar:drawBack()
    Draw.setColor(MG_PALETTE["tension_back"])
    Draw.pushScissor()
    Draw.scissorPoints(0, 0, 25, 156 - (self:getPercentageFor250(self.current) * 156) + 1)
    Draw.draw(self.tp_bar_fill, 0, 0)
    Draw.popScissor()
end
--todo: make apparent tension current tension
function LightTensionBar:drawFill()
    if (self.apparent < self.current) then
        Draw.setColor(MG_PALETTE["tension_decrease"])
        Draw.pushScissor()
        Draw.scissorPoints(0, 156 - (self:getPercentageFor250(self.current) * 156) + 1, 25, 156)
        Draw.draw(self.tp_bar_fill, 0, 0)
        Draw.popScissor()

        Draw.setColor(MG_PALETTE["tension_fill"])
        Draw.pushScissor()
        Draw.scissorPoints(0, 156 - (self:getPercentageFor250(self.apparent) * 156) + 1 + (self:getPercentageFor(self.tension_preview) * 156), 25, 156)
        Draw.draw(self.tp_bar_fill, 0, 0)
        Draw.popScissor()
    elseif (self.apparent > self.current) then
        Draw.setColor(1, 1, 1, 1)
        Draw.pushScissor()
        Draw.scissorPoints(0, 156 - (self:getPercentageFor250(self.apparent) * 156) + 1, 25, 156)
        Draw.draw(self.tp_bar_fill, 0, 0)
        Draw.popScissor()

        Draw.setColor(MG_PALETTE["tension_fill"])
        if (self.maxed) then
            Draw.setColor(MG_PALETTE["tension_max"])
        end
        Draw.pushScissor()
        Draw.scissorPoints(0, 156 - (self:getPercentageFor250(self.current) * 156) + 1 + (self:getPercentageFor(self.tension_preview) * 156), 25, 156)
        Draw.draw(self.tp_bar_fill, 0, 0)
        Draw.popScissor()
    elseif (self.apparent == self.current) then
        Draw.setColor(MG_PALETTE["tension_fill"])
        if (self.maxed) then
            Draw.setColor(MG_PALETTE["tension_max"])
        end
        Draw.pushScissor()
        Draw.scissorPoints(0, 156 - (self:getPercentageFor250(self.current) * 156) + 1 + (self:getPercentageFor(self.tension_preview) * 156), 25, 156)
        Draw.draw(self.tp_bar_fill, 0, 0)
        Draw.popScissor()
    end

    if (self.tension_preview > 0) then
        local alpha = (math.abs((math.sin((self.tsiner / 8)) * 0.5)) + 0.2)
        local color_to_set = {1, 1, 1, alpha}

        local theight = 156 - (self:getPercentageFor250(self.current) * 156)
        local theight2 = theight + (self:getPercentageFor(self.tension_preview) * 156)
        -- Note: causes a visual bug.
        if (theight2 > ((0 + 156) - 1)) then
            theight2 = ((0 + 156) - 1)
            color_to_set = {COLORS.dkgray[1], COLORS.dkgray[2], COLORS.dkgray[3], 0.7}
        end

        Draw.pushScissor()
        Draw.scissorPoints(0, theight2 + 1, 25, theight + 1)

        -- No idea how Deltarune draws this, cause this code was added in Kristal:
        local r,g,b,_ = love.graphics.getColor()
        Draw.setColor(r, g, b, 0.7)
        Draw.draw(self.tp_bar_fill, 0, 0)
        -- And back to the translated code:
        Draw.setColor(color_to_set)
        Draw.draw(self.tp_bar_fill, 0, 0)
        Draw.popScissor()

        Draw.setColor(1, 1, 1, 1)
    end


    if ((self.apparent > 20) and (self.apparent < 250)) then
        Draw.setColor(1, 1, 1, 1)
        Draw.pushScissor()
        Draw.scissorPoints(0, 156 - (self:getPercentageFor250(self.current) * 156) + 1, 25, 156 - (self:getPercentageFor250(self.current) * 156) + 3)
        Draw.draw(self.tp_bar_fill, 0, 0)
        Draw.popScissor()
    end
end

function LightTensionBar:draw()
    Draw.setColor(1, 1, 1, 1)
    Draw.draw(self.tp_bar_outline, 0, 0)

    self:drawBack()
    self:drawFill()

    self:drawText()

    super.draw(self)
end

return LightTensionBar
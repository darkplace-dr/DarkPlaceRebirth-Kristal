local DynamicGradientText, super = Class(Text, "DynamicGradientText")

-- maybe only have the shader render on the actual text and not the shadow when using the
-- dark style?

function DynamicGradientText:init(text, x, y, w, h, colors, options)
    if type(w) == "table" then
        options = w
        colors = h
        w, h = SCREEN_WIDTH, SCREEN_HEIGHT
    end
    options = options or {}

    options["font"] = options["font"] or "main_mono"
    options["style"] = options["style"] or (Game:isLight() and "none" or "dark")

    super.init(self, text, x or 0, y or 0, w or SCREEN_WIDTH, h or SCREEN_HEIGHT, options)

    self.gradient_colors = colors or {}
    self.draw_gradient = true
end

function DynamicGradientText:setColor(r, g, b, a)
    self.gradient_colors = {}
    super.setColor(self, r, g, b, a)
end

function DynamicGradientText:setGradientColors(colors)
    if #colors == 1 then
        self:setColor(Utils.unpackColor(colors))
        return
    end

    self:setColor(COLORS.white)
    self.gradient_colors = colors
end

function DynamicGradientText:draw()
    -- i hate this
    if self.draw_gradient and #self.gradient_colors > 1 then
        local new_canvas = Draw.pushCanvas(self:getTextWidth(), self:getTextHeight())
        Draw.setColor(1, 1, 1, 1)
        if self.draw_every_frame then
            for _,node in ipairs(self.nodes_to_draw) do
                self:drawChar(node[1], node[2], true)
            end
        else
            Draw.draw(self.canvas)
        end
        Draw.popCanvas()

        local color_canvas = Draw.pushCanvas(#self.gradient_colors, 1)
        for i = 1, #self.gradient_colors do
            Draw.setColor(self.gradient_colors[i])
            Draw.rectangle("fill", i - 1, 0, 1, 1)
        end
        Draw.popCanvas()

        local shader = Kristal.Shaders["DynGradient"]
        love.graphics.setShader(shader)
        shader:send("colors", color_canvas)
        shader:send("colorSize", {#self.gradient_colors, 1})
        Draw.setColor(1, 1, 1, 1)
        Draw.drawCanvas(new_canvas)
        love.graphics.setShader()

        if DEBUG_RENDER then
            Draw.setColor(0, 1, 0.5, 0.5)
            love.graphics.setLineWidth(2)
            love.graphics.rectangle("line", 0, 0, self.width, self.height)
    
            Draw.setColor(0, 1, 0.5, 1)
            love.graphics.rectangle("line", 0, 0, self:getTextWidth(), self:getTextHeight())
        end

        Object.draw(self)
    else
        super.draw(self)
    end
end

return DynamicGradientText
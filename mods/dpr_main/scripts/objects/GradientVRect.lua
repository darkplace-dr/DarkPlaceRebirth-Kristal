---@class Rectangle : Object
---@overload fun(...) : Rectangle
local GradientVRect, super = Class(Object)

function GradientVRect:init(x, y, width, height)
    super.init(self, x, y)
    self.width = width
    self.height = height
    self.color_top = {1, 1, 1}
    self.color_bottom = {1, 1, 1}

    self.line = false
    self.line_width = 1
end

function GradientVRect:draw()
	Draw.setColor(1, 1, 1, self.alpha)
    local shader = Kristal.Shaders["GradientV"]
    local last_shader = love.graphics.getShader()
	love.graphics.setShader(shader)
    shader:sendColor("from", self.color_top)
    shader:sendColor("to", self.color_bottom)
	Draw.draw(Assets.getTexture("bubbles/fill"), 0, 0, 0, self.width, self.height)
	love.graphics.setShader(last_shader)
	Draw.setColor(1, 1, 1, 1)
    super.draw(self)
end

return GradientVRect
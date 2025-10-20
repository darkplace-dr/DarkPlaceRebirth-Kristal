---@class HometownNightOverlay : Object
---@overload fun(...) : HometownNightOverlay
local HometownNightOverlay, super = Class(Object)

function HometownNightOverlay:init(x, y, width, height)
    super.init(self, x, y)
    self.width = width
    self.height = height
    self.color = {1, 1, 1}

    self.line = false
    self.line_width = 1
end

function HometownNightOverlay:draw()
    local mask = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
	local transformed = false
	for index, value in ipairs(Game.world.stage:getObjects(Object)) do
		if value.night_mode == 2 then
			if not transformed then
				love.graphics.applyTransform(value.parent:getFullTransform())
				transformed = true
			end
			value:fullDraw(not self.draw_children)
		end
    end
    Draw.popCanvas()
    Draw.setColor(1, 1, 1, 1)
    love.graphics.stencil(function()
        local last_shader = love.graphics.getShader()
        love.graphics.setShader(Kristal.Shaders["Mask"])
        Draw.draw(mask)
        love.graphics.setShader(last_shader)
    end, "replace", 1)
	
    Draw.setColor(self.color[1], self.color[2], self.color[3], self.alpha)
    love.graphics.setLineWidth(self.line_width)
    love.graphics.setStencilTest('less', 1)
    love.graphics.rectangle(self.line and "line" or "fill", 0, 0, self.width, self.height)
    love.graphics.setStencilTest()

    Draw.setColor(1, 1, 1, 1)
    super.draw(self)
end

return HometownNightOverlay
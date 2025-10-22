---@class ChurchHighlightFX : FXBase
---@overload fun(...) : HighlightFX
local ChurchHighlightFX, super = Class(FXBase)

function ChurchHighlightFX:init(alpha, color, settings, priority)
    super.init(self, priority)

    self.alpha = alpha or 0
    self.color = color or {1, 1, 1, 1}
    self.dark_color = settings["darkcol"] or ColorUtils.hexToRGB("#404040FF")
    self.darkness = settings["darkness"] or 1
    self.scale = settings["scale"] or 1
    self.thickness = settings["thickness"] or 1
    self.cutout = settings["cutout"]

    self.cutout_shader = Kristal.Shaders["Mask"]
end

function ChurchHighlightFX:getAlpha()
    return self.alpha
end

function ChurchHighlightFX:getScale()
    return self.scale
end

function ChurchHighlightFX:setColor(r, g, b, a)
    self.color = {r, g, b, a}
end

function ChurchHighlightFX:getColor()
    return self.color[1], self.color[2], self.color[3]
end

function ChurchHighlightFX:setDarkColor(r, g, b, a)
    self.dark_color = {r, g, b, a}
end

function ChurchHighlightFX:getDarkColor()
    return self.dark_color[1], self.dark_color[2], self.dark_color[3]
end
	
function ChurchHighlightFX:isActive()
    return super.isActive(self) and self:getAlpha() > 0
end

function ChurchHighlightFX:draw(texture)
    local alpha = self:getAlpha()

    local object = self.parent

    local mult_x, mult_y = object:getFullScale()
    mult_x = mult_x * self.thickness
    mult_y = mult_y * self.thickness

    local highlight = Draw.pushCanvas(texture:getWidth(), texture:getHeight())

    local shader = Kristal.Shaders["AddColor"]

    Draw.drawCanvas(texture)
	
	local dr,dg,db   = unpack(ColorUtils.mergeColor({1,1,1}, {self:getDarkColor()}, self.alpha))
    shader:send("inputcolor", {dr,dg,db})
    shader:send("amount", 1)
    love.graphics.setShader(shader)
	love.graphics.setBlendMode("multiply", "premultiplied")
    Draw.drawCanvas(texture)
	love.graphics.setBlendMode("alpha", "alphamultiply")

    love.graphics.stencil((function()
        love.graphics.setShader(self.cutout_shader)
		love.graphics.translate(0, 1 * mult_y)
        Draw.drawCanvas(texture)
        love.graphics.setShader()
    end), "replace", 1)
    love.graphics.setStencilTest("less", 1)

    love.graphics.setShader(shader)
    shader:send("inputcolor", {self:getColor()})
    shader:send("amount", self.alpha)
	
    love.graphics.translate(0, 0)
    Draw.drawCanvas(texture)
    love.graphics.setStencilTest()
	
    Draw.popCanvas()

    if not self.cutout then
        love.graphics.setShader(last_shader)
        Draw.drawCanvas(texture)
    end
    Draw.setColor(1, 1, 1, 1)
    Draw.drawCanvas(highlight)
    Draw.setColor(1, 1, 1, 1)
    love.graphics.setShader()
end

return ChurchHighlightFX
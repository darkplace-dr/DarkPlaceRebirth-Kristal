local PaletteFX, super = Class(FXBase)

function PaletteFX:init(palette_tex, palette_index, transformed, priority)
    super.init(self, priority or 0)

    self.shader = Assets.getShader("palette")
	self.palette_tex = palette_tex and Assets.getTexture(palette_tex) or nil
	self.palette_index = palette_index or 1
end

function PaletteFX:setPaletteIndex(index)
	self.palette_index = index or nil
end

function PaletteFX:setPaletteTexture(tex)
	self.palette_tex = Assets.getTexture(tex) or nil
end

function PaletteFX:isActive()
    return super.isActive(self) and self.palette_tex and self.palette_index
end

function PaletteFX:draw(texture)
    local last_shader = love.graphics.getShader()
    love.graphics.setShader(self.shader)
	self.shader:send("palette_tex", self.palette_tex)
	self.shader:send("palette_dim", {self.palette_tex:getWidth(), self.palette_tex:getHeight()})
	self.shader:send("palette_id", self.palette_index)
    Draw.drawCanvas(texture)
    love.graphics.setShader(last_shader)
end

return PaletteFX

local PaletteFX, super = Class(FXBase)

function PaletteFX:init(palette_tex, palette_index, fake_alpha, transformed, priority)
    super.init(self, priority or 0)

	self.fake_alpha = fake_alpha or nil
	self.shader = self.fake_alpha ~= nil and Assets.getShader("palette_fakealpha") or Assets.getShader("palette")
	self.palette_tex = palette_tex and Assets.getTexture(palette_tex) or nil
	self.palette_index = palette_index or 0
end

function PaletteFX:setPaletteIndex(index)
	self.palette_index = index or nil
end

function PaletteFX:setPaletteTexture(tex)
	self.palette_tex = Assets.getTexture(tex) or nil
end

function PaletteFX:setFakeAlpha(alpha)
	self.fake_alpha = alpha or nil
	self.shader = self.fake_alpha ~= nil and Assets.getShader("palette_fakealpha") or Assets.getShader("palette")
end

function PaletteFX:isActive()
    return super.isActive(self) and self.palette_tex and self.palette_index
end

function PaletteFX:draw(texture)
    local last_shader = love.graphics.getShader()
    love.graphics.setShader(self.shader)
	self.shader:send("palette_tex", self.palette_tex)
	local palw, palh = self.palette_tex:getWidth(), self.palette_tex:getHeight()
	self.shader:send("palette_uvs", {(1.0 / palw) * 0.5, (1.0 / palh) * 0.5, 1, 1})
	self.shader:send("pixel_size", {1.0 / palw, 1.0 / palh})
	self.shader:send("palette_id", type(self.palette_index) == "function" and self.palette_index() or self.palette_index)
	if self.fake_alpha ~= nil then
		self.shader:send("final_alpha", type(self.fake_alpha) == "function" and self.fake_alpha() or self.fake_alpha)
	end
    Draw.drawCanvas(texture)
    love.graphics.setShader(last_shader)
end

return PaletteFX

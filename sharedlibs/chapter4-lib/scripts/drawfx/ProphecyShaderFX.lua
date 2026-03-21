---@class ProphecyScrollFX: FXBase
local ProphecyShaderFX, super = Class(ShaderFX)

function ProphecyShaderFX:init(opacity, color, priority)
    super.init(self, "prophecy", {}, nil, priority)

    self.texture_1 = Assets.getTexture("backgrounds/IMAGE_DEPTH_EXTEND_MONO_SEAMLESS_POW2")
    self.texture_2 = Assets.getTexture("backgrounds/perlin_noise_looping")
    self.shader:send("sampler_1", self.texture_1)
    self.shader:send("sampler_2", self.texture_2)
	self.opacity = opacity or 1
	self.col = color or {0.2588, 0.8157, 1}
    self.transformed = false
end

function ProphecyShaderFX:draw(texture)
    local last_shader = love.graphics.getShader()
    love.graphics.setShader(self.shader)
    self.shader:send("time", Kristal.getTime() * 15)
    self.shader:send("opacity", self.opacity)
	if self.parent.parallax_x or self.parent.parallax_y then
		self.shader:send("camx", -Game.world.camera.x*self.parent.parallax_x/2)
		self.shader:send("camy", -Game.world.camera.y*self.parent.parallax_y/2)
	else
		self.shader:send("camx", -Game.world.camera.x/2)
		self.shader:send("camy", -Game.world.camera.y/2)
	end		
    self.shader:sendColor("col", self.col)
    Draw.drawCanvas(texture)
    love.graphics.setShader(last_shader)
end

return ProphecyShaderFX
local SelfShadowFX, super = Class(FXBase)

function SelfShadowFX:init(...)
    super.init(self, ...)
end

function SelfShadowFX:draw(texture)
    Draw.drawCanvas(texture)
    local last_shader = love.graphics.getShader()
    local shader = Assets.newShader("shadowblend")
	local sunshadows = Game.stage:getObjects(SunShadows)[1]
	if sunshadows then
		local shadow_col = sunshadows.colour_shadowblend
		shadow_col[4] = sunshadows.alpha_shadowblend
		shader:sendColor("shadowCol", shadow_col)
	end
    love.graphics.setShader(shader)
    Draw.drawCanvas(texture)
    love.graphics.setShader(last_shader)
end

return SelfShadowFX
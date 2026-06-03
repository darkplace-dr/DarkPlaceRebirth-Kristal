local ProphecySprite, super = Class(Object)

function ProphecySprite:init(texture, xoff, yoff)
    super.init(self, 0, 0, 320, 240)
	
	self.texture = Assets.getTexture(texture) or nil

    self.debug_select = false
	
	self.canvas = love.graphics.newCanvas(320, 240)
	self.xoff = xoff or 0
	self.yoff = yoff or 0
end

function ProphecySprite:onAddToStage(stage)
    self:drawToCanvas(function()
		if self.texture then
			local last_shader = love.graphics.getShader()
			if not Ch4Lib.accurate_blending then
				local shader = Kristal.Shaders["AddColor"]
				love.graphics.setShader(shader)
				shader:send("inputcolor", {1, 1, 1})
				shader:send("amount", 1)
			end
			Draw.draw(self.texture, 99.5, 122, 0, 1, 1, self.xoff, self.yoff)
			love.graphics.setShader(last_shader)
		end
    end, true)
end

function ProphecySprite:drawToCanvas(func, clear)
	local last_shader = love.graphics.getShader()
    Draw.pushCanvas(self.canvas, { stencil = false })
    Draw.pushScissor()
    love.graphics.push()
    love.graphics.origin()
    if clear then
        love.graphics.clear()
    end
	if Ch4Lib.accurate_blending then
        love.graphics.clear(COLORS.black, 0)
		Draw.setColor(1,1,1,1)
		Draw.rectangle("fill", 0, 0, 320, 240)
		love.graphics.setColorMask(false, false, false, true)
		Ch4Lib.setBlendState("add", "oneminusdstalpha", "zero")
        love.graphics.setShader(Kristal.Shaders["Mask"])
		Draw.setColor(1,1,1,1)
	end
    func()
	if Ch4Lib.accurate_blending then
		love.graphics.setShader(last_shader)
		love.graphics.setColorMask(true, true, true, true)
		Ch4Lib.setBlendState("add", "srcalpha", "oneminussrcalpha")
	end
    love.graphics.pop()
    Draw.popScissor()
    Draw.popCanvas()
end

function ProphecySprite:onRemove()
    self.canvas:release()
    self.canvas = nil
end

return ProphecySprite
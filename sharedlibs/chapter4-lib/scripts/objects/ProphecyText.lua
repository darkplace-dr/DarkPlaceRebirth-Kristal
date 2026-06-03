local ProphecyText, super = Class(Object)

function ProphecyText:init(text, xoff, yoff)
    super.init(self, 0, 0, 320, 240)
	
	self.text = text or ""

    self.debug_select = false
	
	self.canvas = love.graphics.newCanvas(320, 240)
	self.xoff = xoff or 0
	self.yoff = yoff or 0
	
	self.font = Assets.getFont("legend")
	
	self.sprite_string = StringUtils.split(self.text, "\n", true)
end

function ProphecyText:onAddToStage(stage)
    self:drawToCanvas(function()
		if self.text then
			local last_shader = love.graphics.getShader()
			if not Ch4Lib.accurate_blending then
				local shader = Kristal.Shaders["AddColor"]
				love.graphics.setShader(shader)
				shader:send("inputcolor", {1, 1, 1})
				shader:send("amount", 1)
			end
			for i, str in ipairs(self.sprite_string) do
				local text_xoff = math.floor(160 - (self.font:getWidth(str) / 2)) - (StringUtils.len(str) / 2)
				text_xoff = math.floor(text_xoff)
				local y_off = (16 / #self.sprite_string)
				love.graphics.setFont(self.font)
				Draw.setColor(1,1,1,1)
				self:drawTextKernLegend(text_xoff, y_off + ((i-1) * 16), str, 1)
			end
			love.graphics.setShader(last_shader)
		end
    end, true)
end

function ProphecyText:drawTextKernLegend(x, y, str, kern)
	local tx = x
	local ty = y
	local txt = str
	local kern = kern
	local tox = x
	for i = 1, StringUtils.len(txt) do
		local ch = StringUtils.sub(txt, i, i)
		
		if ch == "\n" or ch == "#" then
			ty = ty + self.font:getHeight("|")
			tx = tox
		else
			local x_off = 0
			if ch == "L" then
				x_off = 1
			end
			love.graphics.print(ch, tx + x_off, ty)
			tx = tx + self.font:getWidth(ch)
			tx = tx + kern
		end
	end
end

function ProphecyText:drawToCanvas(func, clear)
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

function ProphecyText:onRemove()
    self.canvas:release()
    self.canvas = nil
end

return ProphecyText
local ProphecyPanel, super = Class(Object)

function ProphecyPanel:init(sprite, text, width, height)
    super.init(self)
	self:setOrigin(0,0)
    self.debug_select = true

	self.width = width
	self.height = height
    self.sprite_offset_x = 0
    self.sprite_offset_y = 0
    self.text_offset_x = -160
    self.text_offset_y = -16
	
	self.texture = sprite
	self.texts = text

	self.draw_sprite = true
	self.draw_text = true
	self.draw_back = true
	self.no_back = true
	self.fade_edges = true

    self.bg_surface = nil
    self.siner = 0

    -- the scrolling DEPTHS images used by the panels.
    self.tilespr = Assets.getTexture("backgrounds/IMAGE_DEPTH_EXTEND_MONO_SEAMLESS")
    self.tiletex = Assets.getTexture("backgrounds/IMAGE_DEPTH_EXTEND_SEAMLESS")
    self.gradient20 = Assets.getTexture("backgrounds/gradient20")
    self.propblue = ColorUtils.hexToRGB("#42D0FFFF")
    self.liteblue = ColorUtils.hexToRGB("#FFFFFFFF")
	self.ogbg = ColorUtils.hexToRGB("#A3F8FFFF")
	self.linecol1 = ColorUtils.hexToRGB("#8BE9EFFF")
    self.linecol2 = ColorUtils.hexToRGB("#17EDFFFF")
    self.text_color = {0, 1, 1, 1}
	
	self.panel_alpha = 0
end

function ProphecyPanel:onAddToStage(stage)
    self.sprite = ProphecySprite("world/events/prophecy/"..self.texture or "", self.sprite_offset_x, self.sprite_offset_y)
    self.sprite.debug_select = false
    self:addChild(self.sprite)

    self.text = ProphecyText(self.texts or "", 0, 0)
    self.text.debug_select = false
    self:addChild(self.text)
end


local function draw_sprite_tiled_ext(tex, _, x, y, sx, sy, color, alpha)
    local r,g,b,a = love.graphics.getColor()
    if color then
        Draw.setColor(color, alpha)
    end
    Draw.drawWrapped(tex, true, true, x, y, 0, sx, sy)
    love.graphics.setColor(r,g,b,a)
end

local function draw_set_alpha(a)
    local r,g,b = love.graphics.getColor()
    love.graphics.setColor(r,g,b,a)
end

function ProphecyPanel:draw()
	self.siner = self.siner + DTMULT
    local xsin = 0
    local ysin = math.cos(self.siner / 12) * 4

	local onscreen = true
	if self.panel_alpha <= 0 then
		onscreen = false
	end
	
	local camx = Game.world.camera.x - SCREEN_WIDTH/2
	local camy = Game.world.camera.y - SCREEN_HEIGHT/2
	
	if self.parent.parent then
		if self.parent.parent.x > (camx + SCREEN_WIDTH + (self.width * 2))
		or self.parent.parent.x < (camx - (self.width * 2))
		or self.parent.parent.y > (camy + SCREEN_HEIGHT + (self.height * 2))
		or self.parent.parent.y < (camy - (self.height * 2)) then
			onscreen = false
		end
	end
	
	if onscreen then
		love.graphics.push()

		super.draw(self)
		local sprite_canvas = Draw.pushCanvas(self.sprite.canvas:getWidth(), self.sprite.canvas:getHeight())
		if Ch4Lib.accurate_blending then
			love.graphics.push()
			Ch4Lib.setBlendState("add", "srcalpha", "oneminussrcalpha")
			draw_sprite_tiled_ext(self.tilespr, 0, math.ceil(self.siner / 2), math.ceil(self.siner / 2), 1, 1, self.propblue)
			love.graphics.setBlendMode("alpha", "premultiplied")
			Ch4Lib.setBlendState("add", "zero", "oneminussrccolor")
			Draw.setColor(0,0,0,1)
			Draw.draw(self.sprite.canvas, self.width/2, 28, 0, 1, 1, 199/2, 124/2)
			love.graphics.pop()
		else
			love.graphics.stencil(function()
				local last_shader = love.graphics.getShader()
				love.graphics.setShader(Kristal.Shaders["Mask"])
				Draw.draw(self.sprite.canvas, self.width/2, 28, 0, 1, 1, 199/2, 124/2)
				love.graphics.setShader(last_shader)
			end, "replace", 1)
			love.graphics.setStencilTest("greater", 0)
			draw_sprite_tiled_ext(self.tilespr, 0, math.ceil(self.siner / 2), math.ceil(self.siner / 2), 1, 1, self.propblue)
			love.graphics.setStencilTest()
		end
		Draw.popCanvas(true)
		local back_canvas = Draw.pushCanvas(self.width, self.height)
		love.graphics.push()
		local ogbg = self.ogbg
		local linecol = ColorUtils.mergeColor(self.linecol1, self.linecol2, 0.5 + (math.sin(self.siner / 120) * 0.5))
		local gradalpha = 1
		love.graphics.setBlendMode("alpha")
		if Ch4Lib.accurate_blending then
			Draw.setColor(ogbg[1], ogbg[2], ogbg[3], gradalpha)
			Ch4Lib.setBlendState("add", "srcalpha", "oneminussrcalpha")
		else
			Draw.setColor(ogbg[1], ogbg[2], ogbg[3], gradalpha*0.45)
		end
		Draw.rectangle("fill", 0, 0, 320, 240)
		draw_sprite_tiled_ext(self.tiletex, 0, math.ceil(-self.siner / 2), math.ceil(-self.siner / 2), 1, 1, linecol, gradalpha)
		local gradcol = COLORS.black
		if not self.no_back then
			Draw.setColor(gradcol[1], gradcol[2], gradcol[3], gradalpha)
			Draw.draw(self.gradient20, 0, 0, 0, self.width/20, -3, 0, 20)
			Draw.draw(self.gradient20, 0, self.height, 0, self.width/20, 3, 0, 20)
			Draw.draw(self.gradient20, 0, 0, math.rad(90), self.height/20, 3, 0, 20)
			Draw.draw(self.gradient20, self.width, 0, math.rad(90), self.height/20, -3, 0, 20)
		end
		if self.fade_edges then
			if Ch4Lib.accurate_blending then
				love.graphics.setBlendMode("alpha", "premultiplied")
				Ch4Lib.setBlendState("add", "zero", "oneminussrccolor")
				love.graphics.setColorMask(false, false, false, true)
				Draw.setColor(gradcol, 1)
				Draw.draw(self.gradient20, 0, 0, 0, self.width/20, -3, 0, 20)
				Draw.draw(self.gradient20, 0, self.height, 0, self.width/20, 3, 0, 20)
				Draw.draw(self.gradient20, 0, 0, math.rad(90), self.height/20, 3, 0, 20)
				Draw.draw(self.gradient20, self.width, 0, math.rad(90), self.height/20, -3, 0, 20)
				Draw.setColor(1,1,1,1)
				love.graphics.setColorMask(true, true, true, true)
				Ch4Lib.setBlendState("add", "srcalpha", "oneminussrcalpha")
			else
				local fade_edges_canvas = Draw.pushCanvas(self.width, self.height)
				Draw.setColor(1,1,1,1)
				Draw.draw(self.gradient20, 0, 0, 0, self.width/20, -3, 0, 20)
				Draw.draw(self.gradient20, 0, self.height, 0, self.width/20, 3, 0, 20)
				Draw.draw(self.gradient20, 0, 0, math.rad(90), self.height/20, 3, 0, 20)
				Draw.draw(self.gradient20, self.width, 0, math.rad(90), self.height/20, -3, 0, 20)
				Draw.popCanvas()
				local last_shader = love.graphics.getShader()
				love.graphics.setShader(Ch4Lib.invert_alpha)
				love.graphics.setBlendMode("multiply", "premultiplied")
				Draw.draw(fade_edges_canvas, 0, 0, 0)
				love.graphics.setShader(last_shader)
			end
		end
		if Ch4Lib.accurate_blending then
			Draw.setColor(self.panel_alpha,self.panel_alpha,self.panel_alpha)
		else
			Draw.setColor(self.panel_alpha*0.7,self.panel_alpha*0.7,self.panel_alpha*0.7)
		end
		if self.fade_edges and not Ch4Lib.accurate_blending then
			love.graphics.setBlendMode("alpha")
			Draw.draw(sprite_canvas, 0, 0, 0, 1, 1)
		end
		love.graphics.setBlendMode("add", "alphamultiply")
		if Ch4Lib.accurate_blending then
			Ch4Lib.setBlendState("add", "srcalpha", "one")
		end
		Draw.draw(sprite_canvas, 0, 0, 0, 1, 1)
		Draw.draw(sprite_canvas, 0, 0, 0, 1, 1)
		Draw.draw(sprite_canvas, 0, 0, 0, 1, 1)
		love.graphics.setBlendMode("alpha")
		love.graphics.pop()
		Draw.popCanvas(true)
		for i = 1, 2 do	
			if Ch4Lib.accurate_blending then
				Draw.setColor(1,1,1,self.panel_alpha/4)
			else		
				Draw.setColor(1,1,1,(self.panel_alpha * 0.7)/4)
			end
			Draw.draw(back_canvas, -self.width + ysin * (2 * i), -self.height + ysin * (2 * i), 0, 2, 2)
		end
		if Ch4Lib.accurate_blending then
			Draw.setColor(1,1,1,self.panel_alpha)
		else
			Draw.setColor(1,1,1,self.panel_alpha*0.7)
		end
		Draw.draw(back_canvas, -self.width + xsin, -self.height + ysin, 0, 2, 2)
		love.graphics.setShader(last_shader)
		local text_canvas = Draw.pushCanvas(320, self.text.canvas:getHeight()-10)
		if Ch4Lib.accurate_blending then
			love.graphics.push()
			Ch4Lib.setBlendState("add", "srcalpha", "oneminussrcalpha")
			Draw.setColor(self.text_color)
			Draw.rectangle("fill", 0, 0, 320, 240)
			draw_sprite_tiled_ext(self.tiletex, 0, math.ceil(self.siner / 2), math.ceil(self.siner / 2), 1, 1, COLORS["white"], 0.6)
			Draw.setColor(1, 1, 1, 1)
			love.graphics.setBlendMode("alpha", "premultiplied")
			Ch4Lib.setBlendState("add", "zero", "oneminussrccolor")
			Draw.setColor(0,0,0,1)
			Draw.draw(self.text.canvas, 0, -10, 0, 1, 1)
			love.graphics.pop()
		else
			love.graphics.stencil(function()
				local last_shader = love.graphics.getShader()
				love.graphics.setShader(Kristal.Shaders["Mask"])
				Draw.draw(self.text.canvas, 0, -10, 0, 1, 1)
				love.graphics.setShader(last_shader)
			end, "replace", 1)
			love.graphics.setStencilTest("greater", 0)
			Draw.setColor(self.text_color)
			Draw.rectangle("fill", 0, 0, 320, 240)
			draw_sprite_tiled_ext(self.tiletex, 0, math.ceil(self.siner / 2), math.ceil(self.siner / 2), 1, 1, COLORS["white"], 0.6)
			Draw.setColor(1, 1, 1, 1)
			love.graphics.setStencilTest()
		end
		Draw.popCanvas()
		love.graphics.setBlendMode("add")
		if Ch4Lib.accurate_blending then
			Draw.setColor(self.panel_alpha,self.panel_alpha,self.panel_alpha)
		else
			Draw.setColor(self.panel_alpha*0.7,self.panel_alpha*0.7,self.panel_alpha*0.7)
		end
		Draw.draw(text_canvas, -self.width + xsin + self.text_offset_x, -self.height + ysin + self.text_offset_y, 0, 2, 2)
		Draw.draw(text_canvas, -self.width + xsin + self.text_offset_x, -self.height + ysin + self.text_offset_y, 0, 2, 2)
		love.graphics.setBlendMode("alpha")
		
		love.graphics.pop()
	end
end

return ProphecyPanel

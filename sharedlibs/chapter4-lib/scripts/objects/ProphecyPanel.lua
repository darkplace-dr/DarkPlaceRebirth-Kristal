local ProphecyPanel, super = Class(Object)

function ProphecyPanel:init(sprite, text, width, height)
    super.init(self)
	self:setOrigin(0,0)
    self.debug_select = true

	self.width = width
	self.height = height
    self.sprite_offset_x = 0
    self.sprite_offset_y = 0
    self.text_offset_x = 0
    self.text_offset_y = 0

    self.sprite = ProphecySprite("world/events/prophecy/"..sprite or "", self.sprite_offset_x, self.sprite_offset_y)
    self.sprite.debug_select = false
    self.sprite:setOrigin(0.5,1)
    self:addChild(self.sprite)

    self.text = ProphecyText(nil, self.text_offset_x, -self.sprite.height, {auto_size = true})
    self.text.debug_select = false
    self.text.font = "legend"
    self.text.font_size = 16
    self.text.align = "center"
    self.text:setText(text)
    self.text:setOrigin(0.5,1)
    self:addChild(self.text)

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
    self.propblue = Utils.hexToRgb("#42D0FF")
    self.liteblue = Utils.hexToRgb("#FFFFFF")
	
	self.panel_alpha = 0
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
    --TODO: figure out the scrolling masked texture effect

	self.siner = self.siner + DTMULT
    local xsin = 0
    local ysin = math.cos(self.siner / 12) * 4

    super.draw(self)
    local sprite_canvas = Draw.pushCanvas(320, 240)
	love.graphics.stencil(function()
        local last_shader = love.graphics.getShader()
        love.graphics.setShader(Kristal.Shaders["Mask"])
		Draw.drawCanvas(self.sprite.canvas, 0, 0, 0, 1, 1)
        love.graphics.setShader(last_shader)
    end, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
	draw_sprite_tiled_ext(self.tilespr, 0, math.ceil(self.siner / 2), math.ceil(self.siner / 2), 1, 1, self.propblue)
    love.graphics.setStencilTest()

    local back_canvas = Draw.pushCanvas(self.width, self.height)
	local ogbg = Utils.hexToRgb("#A3F8FF")
	ogbg = {COLORS["black"]}
	local linecol = Utils.mergeColor(Utils.hexToRgb("#8BE9EF"), Utils.hexToRgb("#17EDFF"), 0.5 + (math.sin(self.siner / 120) * 0.5))
	local gradalpha = 1
	Draw.setColor(ogbg, gradalpha*0.5)
	Draw.rectangle("fill", 0, 0, 320, 240)
    love.graphics.setBlendMode("add")
	draw_sprite_tiled_ext(self.tiletex, 0, math.ceil(-self.siner / 2), math.ceil(-self.siner / 2), 1, 1, linecol, 1)
    love.graphics.setBlendMode("alpha")
	local gradcol = COLORS["black"]
	if not self.no_back then
		Draw.setColor(gradcol, gradalpha)
		Draw.draw(self.gradient20, 0, 0, 0, self.width/20, -3, 0, 20)
		Draw.draw(self.gradient20, 0, self.height, 0, self.width/20, 3, 0, 20)
		Draw.draw(self.gradient20, 0, 0, math.rad(90), self.height/20, 3, 0, 20)
		Draw.draw(self.gradient20, self.width, 0, math.rad(90), self.height/20, -3, 0, 20)
	end
	if self.fade_edges then
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
	love.graphics.setBlendMode("alpha", "alphamultiply")
	Draw.setColor(self.panel_alpha,self.panel_alpha,self.panel_alpha)
	if self.fade_edges then
		Draw.draw(sprite_canvas, self.sprite_offset_x, self.sprite_offset_y, 0, 1, 1)
	end
    love.graphics.setBlendMode("add")
	Draw.draw(sprite_canvas, self.sprite_offset_x, self.sprite_offset_y, 0, 1, 1)
	Draw.draw(sprite_canvas, self.sprite_offset_x, self.sprite_offset_y, 0, 1, 1)
	Draw.draw(sprite_canvas, self.sprite_offset_x, self.sprite_offset_y, 0, 1, 1)
    love.graphics.setBlendMode("alpha")
	--[[if self.draw_back then
		local col = COLORS["black"]
		Draw.setColor(col, 1)
		Draw.rectangle("fill", 0, 0, self.width, self.height)
	end]]
	Draw.popCanvas()
	Draw.popCanvas()
	for i = 1, 2 do	
		Draw.setColor(1,1,1,self.panel_alpha * 0.5) -- The alpha isn't accurate to DR's code but fuck it
		Draw.draw(back_canvas, (self.sprite.x - self.x) + ysin * (2 * i), (self.sprite.y - self.y) + ysin * (2 * i), 0, 2, 2)
	end
	Draw.setColor(1,1,1,self.panel_alpha)
	Draw.draw(back_canvas, (self.sprite.x - self.x) + xsin, (self.sprite.y - self.y) + ysin, 0, 2, 2)
    local text_canvas = Draw.pushCanvas(320, 240)
    love.graphics.stencil(function()
        local last_shader = love.graphics.getShader()
        love.graphics.setShader(Kristal.Shaders["Mask"])
		Draw.drawCanvas(self.text.canvas, 0, 0, 0, 1, 1)
        love.graphics.setShader(last_shader)
    end, "replace", 1)
	love.graphics.setStencilTest("greater", 0)
	Draw.setColor(0, 1, 1, 1)
	Draw.rectangle("fill", 0, 0, 320, 240)
	draw_sprite_tiled_ext(self.tiletex, 0, math.ceil(self.siner / 2), math.ceil(self.siner / 2), 1, 1, COLORS["white"], 0.6)
	Draw.setColor(1, 1, 1, 1)
    love.graphics.setStencilTest()
	Draw.popCanvas()
    love.graphics.setBlendMode("add")
	Draw.setColor(self.panel_alpha,self.panel_alpha,self.panel_alpha)
	Draw.draw(text_canvas, (self.text.x - self.x) + xsin + self.text_offset_x, (self.text.y - self.y) + ysin + self.text_offset_y, 0, 2, 2)
	Draw.draw(text_canvas, (self.text.x - self.x) + xsin + self.text_offset_x, (self.text.y - self.y) + ysin + self.text_offset_y, 0, 2, 2)
    love.graphics.setBlendMode("alpha")
end

return ProphecyPanel
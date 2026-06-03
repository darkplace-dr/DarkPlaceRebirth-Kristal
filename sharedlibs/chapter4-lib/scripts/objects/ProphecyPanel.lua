local ProphecyPanel, super = Class(Object)

function ProphecyPanel:init(base_tex, faded_tex, sprite, text, width, height, musichint, bigpiano)
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
	self.draw_back = false
	self.no_back = true
	self.fade_edges = true
	self.music_kind = 0
	self.text_only = false
	self.no_text = false
	self.angel_censor = false

    self.bg_surface = nil
    self.siner = 0

    -- the scrolling DEPTHS images used by the panels.
    self.tilespr = Assets.getTexture(base_tex)
    self.tiletex = Assets.getTexture(faded_tex)
    self.pxwhite = Assets.getTexture("bubbles/fill")
    self.gradient20 = Assets.getTexture("backgrounds/gradient20")
    self.propblue = ColorUtils.hexToRGB("#42D0FFFF")
    self.liteblue = ColorUtils.hexToRGB("#FFFFFFFF")
	self.ogbg = ColorUtils.hexToRGB("#A3F8FFFF")
	self.linecol1 = ColorUtils.hexToRGB("#8BE9EFFF")
    self.linecol2 = ColorUtils.hexToRGB("#17EDFFFF")
	self.musiccol = ColorUtils.hexToRGB("#53DDFFFF")
	self.musiccol2 = ColorUtils.hexToRGB("#203DFFFF")
	self.arrowspr = Assets.getTexture("ui/arrow_9x9")
	self.circlespr = Assets.getTexture("ui/circle_7x7")
	self.musicproparrows = Assets.getFrames("world/events/prophecy/musicproparrows")
    self.text_color = {0, 1, 1, 1}
	
	self.panel_alpha = 0
	self.ignore_onscreen_rules = false
	self.nxpos = 140
	self.nypos = 34
	self.nspace = 28
	self.nyspace = 32
	self.musichint = musichint or nil
	self.bigpianomode = bigpiano or false
	self.note_array = {}
	self.note_array["a"] = {pitch = 1, dir = 0, ind = 2}
	self.note_array["i"] = {pitch = 0.5, dir = 0, ind = 5}
	self.note_array["b"] = {pitch = 1.125, dir = 1, ind = 0}
	self.note_array["j"] = {pitch = 0.5625, dir = 1, ind = 3}
	self.note_array["c"] = {pitch = 1.25, dir = 0, ind = 1}
	self.note_array["k"] = {pitch = 0.625, dir = 0, ind = 4}
	self.note_array["d"] = {pitch = 4/3, dir = 0, ind = 0}
	self.note_array["l"] = {pitch = 2/3, dir = 0, ind = 3}
	self.note_array["e"] = {pitch = 1.5, dir = 3, ind = 1}
	self.note_array["m"] = {pitch = 0.75, dir = 3, ind = 4}
	self.note_array["f"] = {pitch = 1.6666666666666667, dir = 3, ind = 0}
	self.note_array["n"] = {pitch = 0.8333333333333334, dir = 3, ind = 3}
	self.note_array["g"] = {pitch = 1.875, dir = 2, ind = 1}
	self.note_array["o"] = {pitch = 0.9375, dir = 2, ind = 4}
	self.note_array["h"] = {pitch = 2, dir = 2, ind = 0}
	self.hint_units = {}
	if self.musichint then
		self.music_kind = 1
		local i = 1
		while i <= StringUtils.len(self.musichint) do
			local hint_num = tonumber(StringUtils.sub(self.musichint, i, i))
			if self.bigpianomode then
				hint_num = StringUtils.sub(self.musichint, i, i)
			end
			table.insert(self.hint_units, {note = hint_num})
			i = i + 1
		end
	end
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

function ProphecyPanel:setGMBlendMode(blend_mode)
	if blend_mode == "bm_subtract" then
		Ch4Lib.setBlendState("add", "zero", "oneminussrccolor")
	elseif blend_mode == "bm_add" then
		Ch4Lib.setBlendState("add", "srcalpha", "one")
	elseif blend_mode == "bm_normal" then
		Ch4Lib.setBlendState("add", "srcalpha", "oneminussrcalpha")
	end
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
	
	if self.parent.parent and not self.ignore_onscreen_rules then
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
			self:setGMBlendMode("bm_normal")
			draw_sprite_tiled_ext(self.tilespr, 0, math.ceil(self.siner / 2), math.ceil(self.siner / 2), 1, 1, self.propblue)
			self:setGMBlendMode("bm_subtract")
			Draw.setColor(0,0,0,1)
			Draw.draw(self.sprite.canvas, self.width/2, 28, 0, 1, 1, 199/2, 124/2)
			if self.angel_censor then
				Draw.draw(self.pxwhite, 0, 0, 0 ,640, 480)
			end
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
		local ogbg = self.ogbg
		local linecol = ColorUtils.mergeColor(self.linecol1, self.linecol2, 0.5 + (math.sin(self.siner / 120) * 0.5))
		local gradalpha = 1
		if Ch4Lib.accurate_blending then
			Draw.setColor(ogbg[1], ogbg[2], ogbg[3], gradalpha)
			self:setGMBlendMode("bm_normal")
		else
			Draw.setColor(ogbg[1], ogbg[2], ogbg[3], gradalpha*0.45)
		end
		Draw.draw(self.pxwhite, 0, 0, 0, self.width + 1, self.height + 1)
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
				self:setGMBlendMode("bm_subtract")
				love.graphics.setColorMask(false, false, false, true)
				Draw.setColor(gradcol, 1)
				Draw.draw(self.gradient20, 0, 0, 0, self.width/20, -3, 0, 20)
				Draw.draw(self.gradient20, 0, self.height, 0, self.width/20, 3, 0, 20)
				Draw.draw(self.gradient20, 0, 0, math.rad(90), self.height/20, 3, 0, 20)
				Draw.draw(self.gradient20, self.width, 0, math.rad(90), self.height/20, -3, 0, 20)
				Draw.setColor(1,1,1,1)
				love.graphics.setColorMask(true, true, true, true)
				self:setGMBlendMode("bm_normal")
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
			Draw.setColor(1,1,1,1)
		else
			Draw.setColor(1,1,1,0.7)
		end
		if Ch4Lib.accurate_blending then
			self:setGMBlendMode("bm_normal")
			self:setGMBlendMode("bm_add")
		else
			if self.fade_edges then
				love.graphics.setBlendMode("alpha")
				Draw.draw(sprite_canvas, 0, 0, 0, 1, 1)
			end
			love.graphics.setBlendMode("add", "alphamultiply")		
		end
		Draw.draw(sprite_canvas, 0, 0, 0, 1, 1)
		Draw.draw(sprite_canvas, 0, 0, 0, 1, 1)
		Draw.draw(sprite_canvas, 0, 0, 0, 1, 1)
		if Ch4Lib.accurate_blending then
			self:setGMBlendMode("bm_normal")
		else
			love.graphics.setBlendMode("alpha")
		end
		Draw.popCanvas(true)
		if self.draw_back then
			local col = COLORS.black
			if self.church == 2 then
				col = ColorUtils.hexToRGB("#152FFF")
			end
			Draw.setColor(col, 1)
			Draw.draw(self.pxwhite, -self.width + xsin, -self.height + ysin, 0, self.width * 2, self.height * 2)
		end
		local music_canvas
		if self.music_kind ~= 0 then
			music_canvas = Draw.pushCanvas(self.width * 2, self.height * 2)
			if Ch4Lib.accurate_blending then
				self:setGMBlendMode("bm_normal")
				love.graphics.clear(self.musiccol)
				draw_sprite_tiled_ext(self.tiletex, 0, math.ceil(self.siner / 2), math.ceil(self.siner / 2), 1, 1, COLORS["white"], 0.6)
				self:setGMBlendMode("bm_subtract")
				Draw.setColor(0,0,0,1)
				Draw.draw(self.pxwhite, 0, 0, 0, self.width * 2, self.height * 2)
				self:setGMBlendMode("bm_add")
				local nxpos = self.nxpos
				local nypos = self.nypos
				local space = self.nspace
				local yspace = self.nyspace
				if self.bigpianomode then
					for i, unit in ipairs(self.hint_units) do
						local note = self.note_array[unit.note]
						if note then
							local ind = note.ind + 1
							local thisyoff = -85.33333333333333 * (note.pitch - 0.5)
							local txpos = nxpos + (i * space)
							local typos = nypos + (math.sin((self.siner + (i * 24)) / 10) * 2) + thisyoff
							Draw.draw(self.musicproparrows[ind], txpos, typos, math.rad(note.dir * -90), 2, 2, 6, 6)
						end
					end
				else
					for i, unit in ipairs(self.hint_units) do
						local sprangle = 0
						local scale = 2
						local spr = self.arrowspr
						local offx, offy = 4, 4
						local spry = 0
						local num = unit.note or 0
						if num ~= 0 then
							sprangle = math.rad(-(num * 45 - 180 - 45))
							if num == 1 then
								spry = 0
							elseif num == 5 then
								spry = 1
							elseif num == 3 then
								spry = 2
							elseif num == 7 then
								spry = 3
							end
						else
							spr = self.circlespr
							offx, offy = 3, 3
							spry = 4
						end
						Draw.draw(spr, nxpos + ((i - 1) * space), nypos + (yspace * spry) + (math.sin((self.siner + (i * 24)) / 10) * 2), sprangle, 2, 2, offx, offy)
					end
				end
				self:setGMBlendMode("bm_normal")
			else
				love.graphics.stencil(function()
					local last_shader = love.graphics.getShader()
					love.graphics.setShader(Kristal.Shaders["Mask"])
					local nxpos = self.nxpos
					local nypos = self.nypos
					local space = self.nspace
					local yspace = self.nyspace
					if self.bigpianomode then
						local note = self.note_array[unit.note]
						if note then
							local ind = note.ind + 1
							local thisyoff = -85.33333333333333 * (note.pitch - 0.5)
							local txpos = nxpos + (i * space)
							local typos = nypos + (math.sin((self.siner + (i * 24)) / 10) * 2) + thisyoff
							Draw.draw(self.musicproparrows[ind], txpos, typos, math.rad(note.dir * -90), 2, 2, 6, 6)
						end
					else
						for i, unit in ipairs(self.hint_units) do
							local sprangle = 0
							local scale = 2
							local spr = self.arrowspr
							local offx, offy = 4, 4
							local spry = 0
							local num = unit.note or 0
							if num ~= 0 then
								sprangle = math.rad(-(num * 45 - 180 - 45))
								if num == 1 then
									spry = 0
								elseif num == 5 then
									spry = 1
								elseif num == 3 then
									spry = 2
								elseif num == 7 then
									spry = 3
								end
							else
								spr = self.circlespr
								offx, offy = 3, 3
								spry = 4
							end
							Draw.draw(spr, nxpos + ((i - 1) * space), nypos + (yspace * spry) + (yspace * spry) + (math.sin((self.siner + (i * 24)) / 10) * 2), sprangle, 2, 2, offx, offy)
						end
					end
					love.graphics.setShader(last_shader)
				end, "replace", 1)
				love.graphics.setStencilTest("greater", 0)
				Draw.setColor(self.musiccol)
				Draw.rectangle("fill", 0, 0, 320, 240)
				draw_sprite_tiled_ext(self.tiletex, 0, math.ceil(self.siner / 2), math.ceil(self.siner / 2), 1, 1, COLORS["white"], 0.6)
				Draw.setColor(1, 1, 1, 1)
				love.graphics.setStencilTest()
			end
			Draw.popCanvas(true)
		end	
		if not self.text_only then
			for i = 1, 2 do	
				if Ch4Lib.accurate_blending then
					Draw.setColor(1,1,1,self.panel_alpha/4)
				else		
					Draw.setColor(1,1,1,(self.panel_alpha * 0.7)/4)
				end
				if self.music_kind == 0 then
					Draw.draw(back_canvas, -self.width + ysin * (2 * i), -self.height + ysin * (2 * i), 0, 2, 2)
				else
					Draw.draw(music_canvas, -self.width + ysin * (2 * i), -self.height + ysin * (2 * i), 0, 1, 1)				
				end
			end
		end
		if Ch4Lib.accurate_blending then
			Draw.setColor(1,1,1,self.panel_alpha)
		else
			Draw.setColor(1,1,1,self.panel_alpha*0.7)
		end
		if not self.text_only then
			Draw.draw(back_canvas, -self.width + xsin, -self.height + ysin, 0, 2, 2)
		end
		if self.music_kind ~= 0 then
			if Ch4Lib.accurate_blending then
				self:setGMBlendMode("bm_add")
				Draw.setColor(self.musiccol2,self.panel_alpha*0.5)
			else
				if self.fade_edges then
					love.graphics.setBlendMode("alpha")
					Draw.draw(music_canvas, -self.width + xsin, -self.height + ysin, 0, 1, 1)
				end
				love.graphics.setBlendMode("add", "alphamultiply")
				Draw.setColor(self.musiccol2,self.panel_alpha*0.45)
			end
			Draw.draw(music_canvas, -self.width + xsin + 2, -self.height + ysin + 2, 0, 1, 1)
			if Ch4Lib.accurate_blending then
				Draw.setColor(1,1,1,self.panel_alpha)
			else
				Draw.setColor(1,1,1,self.panel_alpha*0.7)
			end
			Draw.draw(music_canvas, -self.width + xsin, -self.height + ysin, 0, 1, 1)
			Draw.draw(music_canvas, -self.width + xsin, -self.height + ysin, 0, 1, 1)
			if Ch4Lib.accurate_blending then
				self:setGMBlendMode("bm_normal")
			else
				love.graphics.setBlendMode("alpha")
			end
		end
		if not self.no_text then
			local text_canvas = Draw.pushCanvas(320, self.text.canvas:getHeight()-10)
			if Ch4Lib.accurate_blending then
				self:setGMBlendMode("bm_normal")
				love.graphics.clear(self.text_color)
				draw_sprite_tiled_ext(self.tiletex, 0, math.ceil(self.siner / 2), math.ceil(self.siner / 2), 1, 1, COLORS["white"], 0.6)
				Draw.setColor(1, 1, 1, 1)
				self:setGMBlendMode("bm_subtract")
				Draw.setColor(0,0,0,1)
				Draw.draw(self.text.canvas, 0, -10, 0, 1, 1)
				self:setGMBlendMode("bm_normal")
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
			if Ch4Lib.accurate_blending then			
				self:setGMBlendMode("bm_add")
			else
				love.graphics.setBlendMode("add")
			end
			if Ch4Lib.accurate_blending then
				Draw.setColor(self.panel_alpha,self.panel_alpha,self.panel_alpha)
			else
				Draw.setColor(self.panel_alpha*0.7,self.panel_alpha*0.7,self.panel_alpha*0.7)
			end
			Draw.draw(text_canvas, -self.width + xsin + self.text_offset_x, -self.height + ysin + self.text_offset_y, 0, 2, 2)
			Draw.draw(text_canvas, -self.width + xsin + self.text_offset_x, -self.height + ysin + self.text_offset_y, 0, 2, 2)
		end
		if Ch4Lib.accurate_blending then			
			self:setGMBlendMode("bm_normal")
		else
			love.graphics.setBlendMode("alpha")
		end
		love.graphics.pop()
	end
end

return ProphecyPanel

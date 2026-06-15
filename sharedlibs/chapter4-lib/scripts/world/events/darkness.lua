local Darkness, super = Class(Event)

function Darkness:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
    -- parallax set to 0 so it's always aligned with the camera
	self:setPosition(0, 0)
    self:setParallax(0, 0)
    -- don't allow debug selecting
    self.debug_select = false

    self.alpha = properties["alpha"] or 1
    self.overlap = true
	self.highlightalpha = 1
	self.draw_highlight = properties["highlight"] ~= false
	self.darkmask_shader = Assets.getShader("addcolormask")
end

function Darkness:onAdd(parent)
    super.onAdd(self, parent)
	-- Gotta love Kristal updates
    self:setParallax(0, 0)
end

function Darkness:drawCharacter(object)
    love.graphics.push()
    object:preDraw()
    object:draw()
    object:postDraw()
    love.graphics.pop()
end

function Darkness:drawLightsA()
    for _,light in ipairs(Game.world.children) do
		if light.light_source and light.light_active then
			light:drawLightA()
		end
		if light:includes(Character) and light.tspawn_circle_light then
			local x, y = light:getScreenPos()
			Draw.setColor(1, 1, 1, 1)
			love.graphics.circle("fill", x, y - light.height/2, 110 + math.sin(self.world.map.tspawn_circle_siner / 12))
		end
    end
    for _,light in ipairs(Game.stage:getObjects(TileObject)) do
		if light.light_area then
			light:drawLightA()
		end
    end
end

function Darkness:drawLightsB()
    for _,light in ipairs(Game.world.children) do
		if light.light_source and light.light_active then
			light:drawLightB()
		end
    end
    for _,light in ipairs(Game.stage:getObjects(TileObject)) do
		if light.light_area then
			light:drawLightB()
		end
    end
end

function Darkness:setGMBlendMode(blend_mode)
	if blend_mode == "bm_subtract" then
		Ch4Lib.setBlendState("add", "zero", "oneminussrccolor")
	elseif blend_mode == "bm_add" then
		Ch4Lib.setBlendState("add", "srcalpha", "one")
	elseif blend_mode == "bm_normal" then
		Ch4Lib.setBlendState("add", "srcalpha", "oneminussrcalpha")
	end
end

function Darkness:draw()
	if Ch4Lib.accurate_blending then
		love.graphics.push()
		local chara_canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
		love.graphics.push()
		love.graphics.clear()
		love.graphics.translate(MathUtils.round(-Game.world.camera.x+SCREEN_WIDTH/2), MathUtils.round(-Game.world.camera.y+SCREEN_HEIGHT/2))
		for _, object in ipairs(Game.world.children) do
			if object.darkness_unlit then
				self:drawCharacter(object)
				Draw.setColor(1, 1, 1, 1)
			end
			if object:includes(Character) and not object.no_highlight and not object.highlight_force_off and self.draw_highlight then
				love.graphics.setShader(Kristal.Shaders["AddColor"])
				
				local col = COLORS["gray"]
				if Game:getPartyMember(object.party) then
					col = Game:getPartyMember(object.party).highlight_color or COLORS["gray"]
				end
				local alpha = self.highlightalpha
				if object:getFX("climb_fade") then -- dumb fix
					alpha = alpha * object:getFX("climb_fade").alpha
				end
				if not object.visible then
					alpha = 0
				end
				Kristal.Shaders["AddColor"]:sendColor("inputcolor", col)
				Kristal.Shaders["AddColor"]:send("amount", alpha)

				if alpha > 0 then
					Draw.setColor(1,1,1,alpha)
					self:drawCharacter(object)
					love.graphics.push()
					love.graphics.translate(0, 2)
					self.darkmask_shader:sendColor("inputcolor", COLORS.black)
					self.darkmask_shader:send("amount", alpha)
					love.graphics.setShader(self.darkmask_shader)
					Ch4Lib.setBlendState("add", "add", "srcalpha", "dstalpha", "oneminussrcalpha", "zero")
					self:drawCharacter(object)
					self:setGMBlendMode("bm_normal")
					love.graphics.setShader()
					love.graphics.pop()
					Draw.setColor(1,1,1,1)
					
				end
				love.graphics.setShader()
			end
		end
		love.graphics.pop()
		Draw.popCanvas(true)
		
		local dim_canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
		self:setGMBlendMode("bm_normal")
		love.graphics.clear(COLORS.black)
		Draw.drawCanvas(chara_canvas)
		self:setGMBlendMode("bm_subtract")
		self:drawLightsA()
		Draw.popCanvas(true)
		
		local dark_canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
		self:setGMBlendMode("bm_normal")
		love.graphics.clear()
		Draw.drawCanvas(dim_canvas)
		self:setGMBlendMode("bm_subtract")
		self:drawLightsB()
		Draw.popCanvas(true)
		
		local final_canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
		love.graphics.setColor(1,1,1,0.5)
		Draw.drawCanvas(dim_canvas)
		love.graphics.setColor(1,1,1,1)
		Draw.drawCanvas(dark_canvas)
		Draw.popCanvas(true)
		love.graphics.setColor(1,1,1,self.alpha)
		Draw.draw(final_canvas)
		love.graphics.setBlendMode("alpha", "alphamultiply")
		love.graphics.pop()
	else
		local dark_canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
		love.graphics.setColor(1-self.alpha, 1-self.alpha, 1-self.alpha)
		love.graphics.rectangle("fill",0,0,SCREEN_WIDTH,SCREEN_HEIGHT)
		if self.overlap then
			love.graphics.setBlendMode("add")
		else
			love.graphics.setBlendMode("lighten", "premultiplied")
		end
		self:drawLightsB()
		self:drawLightsA()
		love.graphics.setBlendMode("alpha", "alphamultiply")
		Draw.popCanvas(true)
		
		love.graphics.setBlendMode("multiply", "premultiplied")
		love.graphics.setColor(1,1,1)
		love.graphics.draw(dark_canvas)
		love.graphics.setBlendMode("alpha", "alphamultiply")
		local base_highlight_canvas = Draw.pushCanvas(SCREEN_WIDTH,SCREEN_HEIGHT)
		love.graphics.clear()

		love.graphics.translate(MathUtils.round(-Game.world.camera.x+SCREEN_WIDTH/2), MathUtils.round(-Game.world.camera.y+SCREEN_HEIGHT/2))

		for _, object in ipairs(Game.world.children) do
			if object.darkness_unlit then
				love.graphics.stencil((function ()
					love.graphics.translate(MathUtils.round(Game.world.camera.x-SCREEN_WIDTH/2), MathUtils.round(Game.world.camera.y-SCREEN_HEIGHT/2))
					love.graphics.setShader(Kristal.Shaders["Mask"])
					self:drawLightsB()
					self:drawLightsA()
					love.graphics.setShader()
					love.graphics.translate(MathUtils.round(-Game.world.camera.x+SCREEN_WIDTH/2), MathUtils.round(-Game.world.camera.y+SCREEN_HEIGHT/2))
				end), "replace", 1)
				love.graphics.setStencilTest("less", 1)
				self:drawCharacter(object)
				Draw.setColor(1, 1, 1, 1)
				love.graphics.setStencilTest()
			end
			if object:includes(Character) and not object.no_highlight and not object.highlight_force_off and self.draw_highlight then
				love.graphics.stencil((function ()
					love.graphics.translate(0, 2)
					love.graphics.setShader(Kristal.Shaders["Mask"])
					self:drawCharacter(object)
					love.graphics.setShader()
					love.graphics.translate(0, -2)
				end), "replace", 1)
				love.graphics.setStencilTest("less", 1)

				love.graphics.setShader(Kristal.Shaders["AddColor"])
				
				local col = COLORS["gray"]
				if Game:getPartyMember(object.party) then
					col = Game:getPartyMember(object.party).highlight_color or COLORS["gray"]
				end
				local alpha = self.highlightalpha
				if object:getFX("climb_fade") then -- dumb fix
					alpha = alpha * object:getFX("climb_fade").alpha
				end
				if not object.visible then
					alpha = 0
				end
				Kristal.Shaders["AddColor"]:sendColor("inputcolor", col)
				Kristal.Shaders["AddColor"]:send("amount", alpha)

				if alpha > 0 then
					Draw.setColor(1,1,1,alpha)
					self:drawCharacter(object)
					Draw.setColor(1,1,1,1)
				end

				love.graphics.setShader()

				love.graphics.setStencilTest()
			end
		end
		Draw.setColor(1,1,1,1)
		Draw.popCanvas(true)
		local fade_highlight_canvas = Draw.pushCanvas(SCREEN_WIDTH,SCREEN_HEIGHT)
		love.graphics.clear()
		love.graphics.setColor(0,0,0,1)
		love.graphics.rectangle("fill",0,0,SCREEN_WIDTH,SCREEN_HEIGHT)
		if self.overlap then
			love.graphics.setBlendMode("add")
		else
			love.graphics.setBlendMode("lighten", "premultiplied")
		end
		love.graphics.setColor(1,1,1)
		self:drawLightsB()
		self:drawLightsA()
		love.graphics.setBlendMode("alpha", "alphamultiply")
		Draw.popCanvas(true)
		local highlight_canvas = Draw.pushCanvas(SCREEN_WIDTH,SCREEN_HEIGHT)
		love.graphics.clear()
		local glowalpha = 1
		for _,roomglow in ipairs(Game.world.map:getEvents("roomglow")) do
			if roomglow then
				glowalpha = 1-roomglow.actind
			end
		end
		Draw.setColor(1,1,1,glowalpha)
		Draw.drawCanvas(base_highlight_canvas)
		love.graphics.setBlendMode("multiply", "premultiplied")
		local last_shader = love.graphics.getShader()
		love.graphics.setShader(Assets.getShader("invert_color"))
		love.graphics.setColor(1,1,1,1)
		Draw.drawCanvas(fade_highlight_canvas, 0, 0, 0)
		love.graphics.setShader(last_shader)
		love.graphics.setBlendMode("alpha", "alphamultiply")
		Draw.popCanvas(true)
		love.graphics.stencil((function ()
			love.graphics.setShader(Kristal.Shaders["Mask"])
			self:drawLightsB()
			love.graphics.setShader()
		end), "replace", 1)
		love.graphics.setStencilTest("less", 1)
		Draw.setColor(1,1,1,self.alpha)
		Draw.draw(highlight_canvas)
		love.graphics.setStencilTest()
	end
end

function Darkness:drawMask()
    for _,light in ipairs(Game.world.children) do
		if light.light_source and light.light_active then
			light:drawLightB()
		end
		if light:includes(Character) and light.tspawn_circle_light then
			local x, y = light:getScreenPos()
			Draw.setColor(1, 1, 1, 1)
			love.graphics.circle("fill", x, y - light.height/2, 110 + math.sin(self.world.map.tspawn_circle_siner / 12))
		end
    end
	for _,light in ipairs(Game.stage:getObjects(TileObject)) do
		if light.light_area then
			light:drawLightB()
		end
	end
end

return Darkness

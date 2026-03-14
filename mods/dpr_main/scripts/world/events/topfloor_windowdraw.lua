local TopFloorWindowDrawer, super = Class(Event)

function TopFloorWindowDrawer:init(data)
    super.init(self, data)
	self.x = 0
	self.y = 0
	self:setParallax(0, 0)
	self.debug_select = false
	self.wall_windows = {}
	self.floor_windows = {}
	self.siner = 0
	self.bg = Assets.getTexture("world/maps/topfloor/IMAGE_DEPTH_LIGHT")
end

function TopFloorWindowDrawer:postLoad()
    super.postLoad(self)
	for _, event in ipairs(Game.world.map.events) do
		if event.layer == Game.world.map.layers["objects_window_wall"] then
			event.visible = false
			table.insert(self.wall_windows, event)
		end
		if event.layer == Game.world.map.layers["objects_window_floor"] then
			event.visible = false
			table.insert(self.floor_windows, event)
		end
	end
end

function TopFloorWindowDrawer:drawCharacter(object)
    love.graphics.push()
    object:preDraw()
    object:draw()
    object:postDraw()
    love.graphics.pop()
end

function TopFloorWindowDrawer:draw()
	super.draw(self)
    local bg = Game.world.map.topfloorbg
	local canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
	if bg then
		love.graphics.translate(-(Game.world.camera.x - SCREEN_WIDTH/2), -(Game.world.camera.y - SCREEN_HEIGHT/2))
		self.siner = self.siner + DTMULT
		love.graphics.stencil(function()
			local last_shader = love.graphics.getShader()
			love.graphics.setShader(Kristal.Shaders["Mask"])
			for _, window in ipairs(self.wall_windows) do
				window:fullDraw()
			end
			love.graphics.setShader(last_shader)
		end, "replace", 1)
		love.graphics.setStencilTest("greater", 0)
		local bg_brightness = bg.bg_brightness
		Draw.setColor(ColorUtils.mergeColor(COLORS.dkgray, COLORS.gray, MathUtils.clamp(bg_brightness, 0, 1)), 0.25)
		Draw.drawWrapped(self.bg, true, true, bg.bg_x, bg.bg_y, 0, 2, 2)
		Draw.setColor(1,1,1,1)
		love.graphics.stencil(function()
			local last_shader = love.graphics.getShader()
			love.graphics.setShader(Kristal.Shaders["Mask"])
			for _, window in ipairs(self.floor_windows) do
				window:fullDraw()
			end
			love.graphics.setShader(last_shader)
		end, "replace", 1)
		love.graphics.setStencilTest("greater", 0)
		Draw.setColor(ColorUtils.mergeColor(COLORS.dkgray, COLORS.gray, MathUtils.clamp(bg_brightness, 0, 1)), 1)
		Draw.drawWrapped(self.bg, true, true, bg.bg_x, bg.bg_y, 0, 2, 4)
		love.graphics.push()
		local last_shader = love.graphics.getShader()
		love.graphics.setShader(Kristal.Shaders["AddColor"])
		Kristal.Shaders["AddColor"]:sendColor("inputcolor", COLORS.black)
		Kristal.Shaders["AddColor"]:send("amount", 1)
		for _, object in ipairs(Game.world.children) do
			if object:includes(Character) then
				local obj_sy = object.scale_y
				object.scale_y = object.scale_y * -2
				self:drawCharacter(object)
				object.scale_y = obj_sy
			end
		end
		love.graphics.setShader(last_shader)
		love.graphics.pop()
		Draw.setColor(1,1,1,1)
		love.graphics.setStencilTest()
	end
	Draw.popCanvas()
	love.graphics.setBlendMode("add")
	Draw.drawCanvas(canvas)
	love.graphics.setBlendMode("alpha")
end

return TopFloorWindowDrawer
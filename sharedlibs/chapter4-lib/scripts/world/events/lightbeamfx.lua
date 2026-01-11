local ChurchLightBeamFX, super = Class(Event, "lightbeamfx")

function ChurchLightBeamFX:init(data)
    super.init(self, data)
	
	self:setPosition(0,0)
	self:setParallax(0,0)
	
    local properties = data.properties or {}
	self.particles = {}
	self.part_timer = 0
	for i = 1, 60 do
		self.part_timer = 1
		self:updateParticles()
	end
	self.part_tex = Assets.getTexture("effects/dw_church_dust")
	self.shader = Assets.newShader("pixelate")
end

function ChurchLightBeamFX:onAdd(parent)
    super.onAdd(self, parent)
	-- Gotta love Kristal updates
    self:setParallax(0, 0)
end

function ChurchLightBeamFX:update()
	super.update(self)
	
	self:updateParticles()
end

function ChurchLightBeamFX:updateParticles()
	self.part_timer = self.part_timer + 1 * DTMULT
	if self.part_timer >= 1 then
		self.part_timer = 0
		for i = 1, 6 do
			table.insert(self.particles, {spd = 0, dir = 0, basespd = MathUtils.random(0.06, 0.2), swiggle = 0.1, basedir = math.rad(MathUtils.random(0, 360)), dwiggle = 0.5, life = love.math.random(50, 350), alpha = 0, size = MathUtils.random(0.7, 3), x = MathUtils.random(0, SCREEN_WIDTH), y = MathUtils.random(0, SCREEN_HEIGHT), age = 0})
		end
	end
    local to_remove = {}
	for i, part in ipairs(self.particles) do
		part.age = part.age + 1 * DTMULT
		local rd = ((part.age+3+love.math.random(100000)) % 24) / 6
		if rd > 2 then
			rd = 4 - rd
		end
		rd = rd - 1
		local rs = ((part.age+4+love.math.random(100000)) % 20) / 4
		if rs > 2 then
			rs = 4 - rs
		end
		rs = rs - 1
		local xspd = math.cos(-(part.basedir+rd * part.dwiggle)) * (part.basespd+rd * part.swiggle)
		local yspd = math.sin(-(part.basedir+rd * part.dwiggle)) * (part.basespd+rd * part.swiggle)
		part.x = part.x + xspd * DTMULT
		part.y = part.y + yspd * DTMULT
		local passed = 2 * part.age/part.life
		
		if passed < 1 then
			part.alpha = 0*(1-passed) + 1*passed
		else		
			part.alpha = 1*(2-passed) + 0*(passed-1)
		end
		
		if part.age >= part.life then
		    table.insert(to_remove, part)
		end
	end
    for _,part in ipairs(to_remove) do
        TableUtils.removeValue(self.particles, part)
    end
end

function ChurchLightBeamFX:drawParticles()
    local last_shader = love.graphics.getShader()
    love.graphics.setShader(self.shader)
    local width, height = SCREEN_WIDTH, SCREEN_HEIGHT
    self.shader:send("size", {width, height})
    self.shader:send("factor", 1)
	love.graphics.setBlendMode("add")
	for i, part in ipairs(self.particles) do
		Draw.setColor(1, 1, 1, part.alpha * self.alpha)
		Draw.draw(self.part_tex, part.x, part.y, 0, part.size, part.size)
	end
	love.graphics.setBlendMode("alpha")
    love.graphics.setShader(last_shader)
end

function ChurchLightBeamFX:draw()
    super.draw(self)
    local mask_canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
	local transformed = false
	if Ch4Lib.accurate_blending then
		love.graphics.push()
		love.graphics.clear(COLORS.white, 1)
		Ch4Lib.setBlendState("add", "zero", "oneminussrccolor")
	end
	for index, value in ipairs(Game.world.stage:getObjects(TileObject)) do
		if value.light_area and value.light_dust then
			if not transformed then
				love.graphics.applyTransform(value.parent:getFullTransform())
				transformed = true
			end
			local tile_width, tile_height = value.tileset:getTileSize(value.tileset:getDrawTile(value.tile))
			local sx = value.width / tile_width * (value.tile_flip_x and -1 or 1)
			local sy = value.height / tile_height * (value.tile_flip_y and -1 or 1)
			if value.tileset.preserve_aspect_fit then
				sx = MathUtils.absMin(sx, sy)
				sy = sx
			end
			love.graphics.setColor(1,1,1,1)
			value.tileset:drawTile(value.tile, value.x + value.width / 2, value.y - value.height + value.height / 2, 0, sx, sy, tile_width/2, tile_height/2)
		end
	end
	if Ch4Lib.accurate_blending then
		love.graphics.pop()
	end
	Draw.popCanvas(true)
	local dust_canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
	self:drawParticles()
	Draw.popCanvas(true)
	local dust_tiled_canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
	love.graphics.setBlendMode("alpha", "premultiplied")
	if Ch4Lib.accurate_blending then
		love.graphics.push()
		Draw.drawWrapped(dust_canvas, true, true, -(Game.world.camera.x - SCREEN_WIDTH/2), -(Game.world.camera.y - SCREEN_HEIGHT/2), 0)
		love.graphics.setBlendMode("alpha", "alphamultiply")
		Ch4Lib.setBlendState("add", "zero", "oneminussrccolor")
		Draw.draw(mask_canvas)
		love.graphics.pop()
		Draw.popCanvas(true)
		Draw.setColor(1, 1, 1, 1)
		Draw.drawCanvas(dust_tiled_canvas)
		Draw.setColor(1, 1, 1, 1)
	else
		Draw.drawWrapped(dust_canvas, true, true, -(Game.world.camera.x - SCREEN_WIDTH/2), -(Game.world.camera.y - SCREEN_HEIGHT/2), 0)
		love.graphics.setBlendMode("multiply", "premultiplied")
		Draw.drawCanvas(mask_canvas)
		love.graphics.setBlendMode("alpha", "alphamultiply")
		Draw.popCanvas(true)
		Draw.setColor(1, 1, 1, 1)
		love.graphics.stencil(function()
			local last_shader = love.graphics.getShader()
			love.graphics.setShader(Kristal.Shaders["Mask"])
			Draw.draw(mask_canvas)
			love.graphics.setShader(last_shader)
		end, "replace", 1)
		--love.graphics.setStencilTest('greater', 1)
		Draw.drawCanvas(dust_tiled_canvas)
		love.graphics.setStencilTest()
		Draw.setColor(1, 1, 1, 1)
	end
	super.draw(self)
end

return ChurchLightBeamFX
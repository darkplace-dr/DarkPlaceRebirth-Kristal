local DarknessOverlayJackenstein, super = Class(Object)

function DarknessOverlayJackenstein:init(x, y, width, height, alpha)
    super.init(self, x, y, width, height)
    -- parallax set to 0 so it's always aligned with the camera
    self:setOrigin(0.5, 0.5)
	self:setParallax(0, 0)
    -- don't allow debug selecting
    self.debug_select = false

    self.alpha = alpha or 1
    self.overlap = Kristal.getLibConfig("darkness", "overlap")
end

function DarknessOverlayJackenstein:draw()
    local canvas = Draw.pushCanvas(self.width, self.height)
    love.graphics.setColor(1-self.alpha, 1-self.alpha, 1-self.alpha)
    love.graphics.rectangle("fill",0,0,self.width,self.height)
    if self.overlap then
        love.graphics.setBlendMode("add")
    else
        love.graphics.setBlendMode("lighten", "premultiplied")
    end
    for _,light in ipairs(Game.stage:getObjects(HeartLightJackenstein)) do
        if light:isFullyVisible() then
            local x, y = light:getRelativePos(0,0, self)
            local color = TableUtils.copy(light.color)
            local alpha = color[4] or light.alpha
            local radius_big, radius_small = light:getRadius()

            love.graphics.setColor(TableUtils.lerp({0,0,0}, color, MathUtils.clamp(alpha, 0, 1)))
            love.graphics.circle("fill", x, y, radius_small)
			for _,beam in ipairs(light.light_beams) do
				local dir1 = beam.dir + beam.width/2
				local dir2 = beam.dir - beam.width/2
				local x0 = x
				local y0 = y
				local x1 = x0 + -math.cos(math.rad(dir1)) * beam.length
				local y1 = y0 + -math.sin(math.rad(dir1)) * beam.length
				local x2 = x0 + -math.cos(math.rad(dir2)) * beam.length
				local y2 = y0 + -math.sin(math.rad(dir2)) * beam.length
				love.graphics.polygon("fill", 
					x0, y0,
					x1, y1,
					x2, y2
				)
			end
            love.graphics.setColor(TableUtils.lerp({0,0,0}, color, MathUtils.clamp(alpha/2, 0, 1)))
            love.graphics.circle("fill", x, y, radius_big)
			for _,beam in ipairs(light.light_beams) do
				local dir1 = beam.dir + beam.width
				local dir2 = beam.dir - beam.width
				local x0 = x
				local y0 = y
				local x1 = x0 + -math.cos(math.rad(dir1)) * beam.length
				local y1 = y0 + -math.sin(math.rad(dir1)) * beam.length
				local x2 = x0 + -math.cos(math.rad(dir2)) * beam.length
				local y2 = y0 + -math.sin(math.rad(dir2)) * beam.length
				love.graphics.polygon("fill", 
					x0, y0,
					x1, y1,
					x2, y2
				)
			end
        end
    end
    for _,light in ipairs(Game.stage:getObjects(LightJackenstein)) do
        if light:isFullyVisible() then
            local x, y = light:getRelativePos(0,0, self)
            local color = TableUtils.copy(light.color)
            local alpha = color[4] or light.alpha
            local radius_big, radius_small = light:getRadius()

            love.graphics.setColor(TableUtils.lerp({0,0,0}, color, MathUtils.clamp(alpha, 0, 1)))
            love.graphics.circle("fill", x, y, radius_small)
            love.graphics.setColor(TableUtils.lerp({0,0,0}, color, MathUtils.clamp(alpha/2, 0, 1)))
            love.graphics.circle("fill", x, y, radius_big)
        end
    end
    for _,arena in ipairs(Game.stage:getObjects(GhostHouseArena)) do
        local x, y = arena.sprite_outer:getRelativePos(0,0, self)
        love.graphics.setColor(TableUtils.lerp({1,1,1}, {0,0,0}, MathUtils.clamp(arena.arena_fade, 0, 1)))
		Draw.draw(arena.sprite_outer:getTexture(), x, y, 0, 2, 2, 0, 0)
		for _,lock in ipairs(Game.stage:getObjects(GhostHouseLock)) do
			x, y = lock:getRelativePos(0,0, self)
			love.graphics.setColor(TableUtils.lerp({1,1,1}, {0,0,0}, MathUtils.clamp(arena.arena_fade, 0, 1)))
			Draw.draw(lock.bar_sprite, x, y, lock.rotation, lock.width, lock.height, lock.offsetx, lock.offsety)
		end
	end
    love.graphics.setBlendMode("alpha")
    Draw.popCanvas()

    love.graphics.setBlendMode("multiply", "premultiplied")
    love.graphics.setColor(1,1,1)
    love.graphics.draw(canvas)
    love.graphics.setBlendMode("alpha")
end

return DarknessOverlayJackenstein
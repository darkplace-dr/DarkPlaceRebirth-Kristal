---@class GreenRoomWall : Event
---@overload fun(...) : Event
local GreenRoomWall, super = Class(Event)

function GreenRoomWall:init(data)
    super.init(self, data)
	self.height = self.height - 10
	-- Change the height since theres the wall thing at the bottom and the original code accounts for that
	-- However, isn't it better if this object is layered behind the layer with the wall thing instead?
	-- Or the height is change in Tiled so the object doesnt exceed the wall thing?

	-- Kristal.Console:log("yeah ok")
    local properties = data.properties or {}
    self.pixel = Assets.getTexture('bubbles/fill')
    self.draw_x = 0
    self.draw_y = 0
	self.from_amt = properties["fromamt"] or 0.4
	self.spawn_vines = properties["vines"] ~= false
	self.spawn_shines = properties["shines"] ~= false
	self.tile_speed = 1

	local can_kill = Game:getFlag("can_kill", false)
    if Game.world.map.id:find("floortv/") and can_kill == true then
		self.tile_speed = 0.4
		self.spawn_shines = false
	end

    self.shine_timer = 0
    self.shine_frame = 0

	self.scale = 2
	self.texture = Assets.getTexture('world/maps/tvland/star_tile')
	self.tex_width = self.texture:getWidth() * self.scale
	self.tex_height = self.texture:getHeight() * self.scale + 5
    self.vine_texture = Assets.getTexture('world/maps/tvland/green_room_vines')
    self.shine_frames = Assets.getFrames('world/maps/tvland/shine_white')

	if not Game.world.map.star_canvas then
		Game.world.map.star_canvas = love.graphics.newCanvas(Game.world:getSize())
        Draw.pushCanvas(Game.world.map.star_canvas)
        for w = 0, Game.world.width / self.tex_width + 2 do
            for h = 0, Game.world.height / self.tex_height + 1 do
                Draw.setColor((w + h) % 2 == 0 and {140/255, 180/255, 151/255} or {160/255, 217/255, 136/255})
                Draw.draw(self.texture, w * self.tex_width, h * self.tex_height, 0, self.scale, self.scale)
            end
        end
        Draw.popCanvas()
    end
end

function GreenRoomWall:update()
    super.update(self)
    self.draw_x = (self.draw_x - DTMULT * self.tile_speed) % (2 * self.tex_width)
    self.draw_y = (self.draw_y + DTMULT * self.tile_speed) % (2 * self.tex_height)

    self.shine_timer = self.shine_timer + DT
    if self.shine_timer >= 1/2.4 then
        self.shine_timer = self.shine_timer - 1/2.4
        self.shine_frame = self.shine_frame % #self.shine_frames + 1
    end
end

function GreenRoomWall:draw()
    super.draw(self)

    -- Draw background
    Draw.setColor({168/255, 228/255, 131/255})
    love.graphics.rectangle("fill", 0, 0, self.width, self.height)

    -- Draw canvas
    love.graphics.stencil(function ()
        love.graphics.rectangle("fill", 0, 0, self.width, self.height)
    end, "replace", 1)
    love.graphics.setStencilTest("equal", 1)
    Draw.setColor(COLORS.white)
    Draw.draw(Game.world.map.star_canvas, -2 * self.tex_width + self.draw_x, -self.tex_height + self.draw_y)

    -- Draw gradient overlay
    Draw.setColor(COLORS.white)
    -- Draw.draw(self.gradient, 0, 0, 0, self.width, self.height / 480)
    Draw.pushShader(Assets.getShader("gradient_a"), {
        -- from = {99/255, 142/255, 152/255},
		from = Utils.mergeColor({102/255, 131/255, 157/255}, {140/255, 180/255, 151/255}, self.from_amt),
        to = {168/255, 228/255, 131/255},
        scale = 1
    })
    Draw.draw(self.pixel, 0, 0, 0, self.width, self.height)
    Draw.popShader()

    -- Draw the vines
	if self.spawn_vines then
		for x = 0, self.width, self.vine_texture:getWidth() * 2 do
			Draw.draw(self.vine_texture, x, 0, 0, 2, 2)
		end
	end
    love.graphics.setStencilTest()

    -- Draw the shine
	if self.spawn_shines then
		local max_amount = self.width / 55

		Draw.setColor(232/255, 1, 200/255)
		for i = 0, max_amount do
			local y_offset = 10
			if i % 2 == 1 then
				y_offset = 4
			end
			local starting_index = 0
			if i % 3 == 1 then
				starting_index = 1
			end
			Draw.draw(self.shine_frames[(self.shine_frame + starting_index - 1) % 4 + 1], (i * 55), y_offset, 0, 2, 2)
		end

		max_amount = self.width / 80

		for i = 0, max_amount do
			local x_offset = 3
			local y_offset = 20
			if i % 2 == 1 then
				y_offset = 14
			end
			local starting_index = 0
			if i % 3 == 1 then
				starting_index = 1
			end
			Draw.draw(self.shine_frames[(self.shine_frame + starting_index - 1) % 4 + 1], 5 + (i * 75) + x_offset, 5 + y_offset, 0, 2, 2)
		end
	end
	
	Draw.setColor(159/255,216/255,135/255,0.3)
	Draw.rectangle("fill", 0, self.height, self.width, 30)
	Draw.setColor(1,1,1,1)
end

return GreenRoomWall

-- Original code is here so someone else can reference it if I missed something

-- function GreenRoomWall:init(data)
--     super.init(self, data)
	
-- 	self.wallstars = Assets.getTexture("world/maps/tvland/green_room_bg_fx_wallrow")
	
-- 	local properties = data.properties or {}
	
-- 	self.from_amt = properties["fromamt"] or 0.4
-- 	self.spawn_vines = properties["vines"] ~= false
-- 	self.spawn_shines = properties["shines"] ~= false
-- 	self.bg_speed = -88
-- 	self.bg_speed_y = 1
-- 	self.tile_speed = 1
-- 	local can_kill = Game:getFlag("can_kill", false)	
--     if Game.world.map.id:find("floortv/") and can_kill == true then
-- 		self.tile_speed = 0.4
-- 		self.spawn_shines = false
-- 	end
	
-- 	if not Game.world.map.star_canvas then
-- 		Game.world.map.star_canvas = love.graphics.newCanvas(1720 * 0.5, 488 * 0.5)
-- 		Draw.pushCanvas(Game.world.map.star_canvas)
-- 		for i = 0, 12 do
-- 			local __x = (i * 40) - 80 - 120
-- 			local __y = -40 + (44 * i)
-- 			love.graphics.setColor(1,0,0,1)
-- 			Draw.draw(self.wallstars, __x * 0.5, __y * 0.5)
-- 			Draw.draw(self.wallstars, (__x + 720) * 0.5, __y * 0.5)
-- 			Draw.draw(self.wallstars, (__x + 1440) * 0.5, __y * 0.5)
-- 			love.graphics.setColor(0,0,1,1)
-- 			Draw.draw(self.wallstars, (__x + 40)* 0.5, __y * 0.5)
-- 			Draw.draw(self.wallstars, (__x + 40 + 720) * 0.5, __y * 0.5)
-- 			Draw.draw(self.wallstars, (__x + 40 + 1440) * 0.5, __y * 0.5)
-- 			love.graphics.setColor(1,1,1,1)
-- 		end
-- 		Draw.popCanvas()
-- 	end
-- end
 
-- function GreenRoomWall:onLoad()
-- 	super.onLoad(self)
	
-- 	if self.spawn_vines == true then
-- 		self.vines = Sprite("world/maps/tvland/green_room_vines", self.x, self.y)
-- 		self.vines:setScale(2,2)
-- 		self.vines.wrap_texture_x = true
-- 		self.vines:setLayer(self.layer + 0.01)
-- 		if Game.world:parseLayer("objects_belowvines") then
-- 			self.vines:setLayer(Game.world:parseLayer("objects_belowvines") + 0.01)
-- 		end
-- 		self.vines:addFX(ScissorFX(0, 0, self.width, self.height))
-- 		Game.world:addChild(self.vines)
-- 	end
	
-- 	if self.spawn_shines == true then
-- 		local max_amount = (self.width) / 55
	
-- 		for i = 0, max_amount do
-- 			local y_offset = 10
-- 			if i % 2 == 1 then
-- 				y_offset = 4
-- 			end
-- 			local starting_index = 0
-- 			if i % 3 == 1 then
-- 				starting_index = 1
-- 			end
-- 			local shine = Sprite("world/maps/tvland/shine_white", self.x + (i * 55), self.y + y_offset)
-- 			shine:setScale(2,2)
-- 			shine.color = {232/255, 1, 200/255}
-- 			shine:play(1/2.4)
-- 			shine:setFrame(starting_index)
-- 			shine:setLayer(self.layer + 0.02)
-- 			if Game.world:parseLayer("objects_belowvines") then
-- 				shine:setLayer(Game.world:parseLayer("objects_belowvines") + 0.02)
-- 			end
-- 			Game.world:addChild(shine)
-- 		end
-- 		max_amount = self.width / 80
		
-- 		for i = 0, max_amount do
-- 			local x_offset = 3
-- 			local y_offset = 20
-- 			if i % 2 == 1 then
-- 				y_offset = 14
-- 			end
-- 			local starting_index = 0
-- 			if i % 3 == 1 then
-- 				starting_index = 1
-- 			end
-- 			local shine = Sprite("world/maps/tvland/shine_white", self.x + 5 + (i * 75) + x_offset, self.y + 5 + y_offset)
-- 			shine:setScale(2,2)
-- 			shine.color = {232/255, 1, 200/255}
-- 			shine:play(1/2.4)
-- 			shine:setFrame(starting_index)
-- 			shine:setLayer(self.layer + 0.02)
-- 			if Game.world:parseLayer("objects_belowvines") then
-- 				shine:setLayer(Game.world:parseLayer("objects_belowvines") + 0.02)
-- 			end
-- 			Game.world:addChild(shine)
-- 		end
-- 	end
-- end
-- function GreenRoomWall:draw()
-- 	super.draw(self)
--     local shader = Kristal.Shaders["GradientV"]
--     local last_shader = love.graphics.getShader()
-- 	love.graphics.setShader(shader)
--     shader:sendColor("from", {99/255, 142/255, 152/255})
--     shader:sendColor("to", {168/255, 228/255, 131/255})
-- 	Draw.draw(Assets.getTexture("bubbles/fill"), 0, 0, 0, self.width, self.height-10)
-- 	love.graphics.setShader(last_shader)
--     Draw.pushScissor()
-- 	Draw.scissor(0, 0, self.width, self.height - 10)
-- 	if Game.world.map.star_canvas then
-- 		self.bg_speed = self.bg_speed - self.tile_speed * DTMULT
-- 		self.bg_speed_y = self.bg_speed_y + self.tile_speed * DTMULT
-- 		if self.bg_speed < -800 then
-- 			self.bg_speed = self.bg_speed + 480
-- 		end
-- 		if self.bg_speed_y > -88 then
-- 			self.bg_speed_y = self.bg_speed_y - 88
-- 		end
-- 		-- This fucking sucks but I don't know how to do it better
-- 		love.graphics.stencil(function()
-- 			if Game.world.map.star_canvas then
-- 				local last_shader = love.graphics.getShader()
-- 				love.graphics.setShader(Assets.getShader("green_room_stencil1"))
-- 				Draw.setColor(1,1,1,1)
-- 				Draw.draw(Game.world.map.star_canvas, self.bg_speed, self.bg_speed_y, 0, 2, 2)
-- 				love.graphics.setShader(last_shader)
-- 			end
-- 		end, "replace", 1)
-- 		love.graphics.setStencilTest("greater", 0)
-- 		Draw.setColor(1,1,1,1)
-- 		love.graphics.setShader(shader)
-- 		shader:sendColor("from", Utils.mergeColor({102/255, 131/255, 157/255}, {140/255, 180/255, 151/255}, self.from_amt))
-- 		shader:sendColor("to", {140/255, 180/255, 151/255})
-- 		Draw.draw(Assets.getTexture("bubbles/fill"), 0, 0, 0, self.width, self.height-10)
-- 		love.graphics.stencil(function()
-- 			if Game.world.map.star_canvas then
-- 				local last_shader = love.graphics.getShader()
-- 				love.graphics.setShader(Assets.getShader("green_room_stencil2"))
-- 				Draw.setColor(1,1,1,1)
-- 				Draw.draw(Game.world.map.star_canvas, self.bg_speed, self.bg_speed_y, 0, 2, 2)
-- 				love.graphics.setShader(last_shader)
-- 			end
-- 		end, "replace", 1)
-- 		love.graphics.setStencilTest("greater", 0)
-- 		Draw.setColor(1,1,1,0.25)
-- 		love.graphics.setShader(shader)
-- 		shader:sendColor("from", Utils.mergeColor({102/255, 131/255, 157/255}, {140/255, 180/255, 151/255}, self.from_amt))
-- 		shader:sendColor("to", {140/255, 180/255, 151/255})
-- 		Draw.draw(Assets.getTexture("bubbles/fill"), 0, 0, 0, self.width, self.height-10)
-- 		love.graphics.setStencilTest()
--         love.graphics.setShader(last_shader)
-- 	end
--     Draw.popScissor()
-- 	Draw.setColor(159/255,216/255,135/255,0.3)
-- 	Draw.rectangle("fill", 0, self.height - 10, self.width, 30)
-- 	Draw.setColor(1,1,1,1)
-- end
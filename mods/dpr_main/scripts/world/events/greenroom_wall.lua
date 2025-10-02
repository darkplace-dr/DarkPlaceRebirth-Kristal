---@class GreenRoomWall : Event
---@overload fun(...) : Event
local GreenRoomWall, super = Class(Event)

function GreenRoomWall:init(data)
    super.init(self, data)
	
	self.wallstars = Assets.getTexture("world/maps/tvland/green_room_bg_fx_wallrow")
	
	local properties = data.properties or {}
	
	self.from_amt = properties["fromamt"] or 0.4
	self.spawn_vines = properties["vines"] ~= false
	self.spawn_shines = properties["shines"] ~= false
	self.bg_speed = -88
	self.bg_speed_y = 1
	self.tile_speed = 1
	local can_kill = Game:getFlag("can_kill", false)	
    if Game.world.map.id:find("floortv/") and can_kill == true then
		self.tile_speed = 0.4
		self.spawn_shines = false
	end
	
	if not Game.world.map.star_canvas then
		Game.world.map.star_canvas = love.graphics.newCanvas(860, 244)
		Draw.pushCanvas(Game.world.map.star_canvas, {
            clear = true
        })
		for i = 0, 12 do
			local __x = (i * 40) - 80 - 120
			local __y = -40 + (44 * i)
			love.graphics.setColor(1,0,0,1)
			Draw.draw(self.wallstars, __x * 0.5, __y * 0.5)
			Draw.draw(self.wallstars, (__x + 720) * 0.5, __y * 0.5)
			Draw.draw(self.wallstars, (__x + 1440) * 0.5, __y * 0.5)
			love.graphics.setColor(0,0,1,1)
			Draw.draw(self.wallstars, (__x + 40)* 0.5, __y * 0.5)
			Draw.draw(self.wallstars, (__x + 40 + 720) * 0.5, __y * 0.5)
			Draw.draw(self.wallstars, (__x + 40 + 1440) * 0.5, __y * 0.5)
			love.graphics.setColor(1,1,1,1)
		end
		Draw.popCanvas()
	end
end
 
function GreenRoomWall:onLoad()
	super.onLoad(self)
	
	if self.spawn_vines == true then
		self.vines = Sprite("world/maps/tvland/green_room_vines", self.x, self.y)
		self.vines:setScale(2,2)
		self.vines.wrap_texture_x = true
		self.vines:setLayer(self.layer + 0.01)
		if Game.world:parseLayer("objects_belowvines") then
			self.vines:setLayer(Game.world:parseLayer("objects_belowvines") + 0.01)
		end
		self.vines:addFX(ScissorFX(0, 0, self.width, self.height))
		Game.world:addChild(self.vines)
	end
	
	if self.spawn_shines == true then
		local max_amount = (self.width) / 55
	
		for i = 0, max_amount do
			local y_offset = 10
			if i % 2 == 1 then
				y_offset = 4
			end
			local starting_index = 0
			if i % 3 == 1 then
				starting_index = 1
			end
			local shine = Sprite("world/maps/tvland/shine_white", self.x + (i * 55), self.y + y_offset)
			shine:setScale(2,2)
			shine.color = {232/255, 1, 200/255}
			shine:play(1/2.4)
			shine:setFrame(starting_index)
			shine:setLayer(self.layer + 0.02)
			if Game.world:parseLayer("objects_belowvines") then
				shine:setLayer(Game.world:parseLayer("objects_belowvines") + 0.02)
			end
			Game.world:addChild(shine)
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
			local shine = Sprite("world/maps/tvland/shine_white", self.x + 5 + (i * 75) + x_offset, self.y + 5 + y_offset)
			shine:setScale(2,2)
			shine.color = {232/255, 1, 200/255}
			shine:play(1/2.4)
			shine:setFrame(starting_index)
			shine:setLayer(self.layer + 0.02)
			if Game.world:parseLayer("objects_belowvines") then
				shine:setLayer(Game.world:parseLayer("objects_belowvines") + 0.02)
			end
			Game.world:addChild(shine)
		end
	end
end
function GreenRoomWall:draw()
	super.draw(self)

    local shader = Kristal.Shaders["GradientV"]
    local last_shader = love.graphics.getShader()

	love.graphics.setShader(shader)
    shader:sendColor("from", {99/255, 142/255, 152/255})
    shader:sendColor("to", {168/255, 228/255, 131/255})
	Draw.draw(Assets.getTexture("bubbles/fill"), 0, 0, 0, self.width, self.height-10)
	love.graphics.setShader(last_shader)

    Draw.pushScissor()
	Draw.scissor(0, 0, self.width, self.height - 10)

	if Game.world.map.star_canvas then
		self.bg_speed = self.bg_speed - self.tile_speed * DTMULT
		self.bg_speed_y = self.bg_speed_y + self.tile_speed * DTMULT
		if self.bg_speed < -800 then
			self.bg_speed = self.bg_speed + 480
		end
		if self.bg_speed_y > -88 then
			self.bg_speed_y = self.bg_speed_y - 88
		end

		-- This fucking sucks but I don't know how to do it better
		love.graphics.stencil(function()
			if Game.world.map.star_canvas then
				local last_shader = love.graphics.getShader()
				love.graphics.setShader(Assets.getShader("green_room_stencil1"))
				Draw.setColor(1,1,1,1)
				Draw.draw(Game.world.map.star_canvas, self.bg_speed, self.bg_speed_y, 0, 2, 2)
				love.graphics.setShader(last_shader)
			end
		end, "replace", 1)
		love.graphics.setStencilTest("greater", 0)
		Draw.setColor(1,1,1,1)
		love.graphics.setShader(shader)
		shader:sendColor("from", Utils.mergeColor({102/255, 131/255, 157/255}, {140/255, 180/255, 151/255}, self.from_amt))
		shader:sendColor("to", {140/255, 180/255, 151/255})
		Draw.draw(Assets.getTexture("bubbles/fill"), 0, 0, 0, self.width, self.height-10)

		love.graphics.stencil(function()
			if Game.world.map.star_canvas then
				local last_shader = love.graphics.getShader()
				love.graphics.setShader(Assets.getShader("green_room_stencil2"))
				Draw.setColor(1,1,1,1)
				Draw.draw(Game.world.map.star_canvas, self.bg_speed, self.bg_speed_y, 0, 2, 2)
				love.graphics.setShader(last_shader)
			end
		end, "replace", 1)
		love.graphics.setStencilTest("greater", 0)
		Draw.setColor(1,1,1,0.25)
		love.graphics.setShader(shader)
		shader:sendColor("from", Utils.mergeColor({102/255, 131/255, 157/255}, {140/255, 180/255, 151/255}, self.from_amt))
		shader:sendColor("to", {140/255, 180/255, 151/255})
		Draw.draw(Assets.getTexture("bubbles/fill"), 0, 0, 0, self.width, self.height-10)

		love.graphics.setStencilTest()
        love.graphics.setShader(last_shader)
	end

    Draw.popScissor()

	Draw.setColor(159/255,216/255,135/255,0.3)
	Draw.rectangle("fill", 0, self.height - 10, self.width, 30)
	Draw.setColor(1,1,1,1)
end

return GreenRoomWall

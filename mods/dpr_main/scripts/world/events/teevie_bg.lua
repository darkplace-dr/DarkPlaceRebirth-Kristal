---@class TeevieBG : Event
---@TeevieBG fun(...) : Event
local TeevieBG, super = Class(Event)

function TeevieBG:init(data)
    super.init(self, data)
	
	self.rect_1 = GradientVRect(0, 0, Game.world.map.width * Game.world.map.tile_width, 80)
	self.rect_1.color_top = {0,0,0}
	self.rect_1.color_bottom = {36/255,38/255,94/255}
	self.rect_1:setLayer(self.layer)
	Game.world:addChild(self.rect_1)
	self.rect_2 = GradientVRect(0, 80, Game.world.map.width * Game.world.map.tile_width, Game.world.map.height * Game.world.map.tile_height)
	self.rect_2.color_top = {36/255,38/255,94/255}
	self.rect_2.color_bottom = {0,0,0}
	self.rect_2:setLayer(self.layer)
	Game.world:addChild(self.rect_2)

	self.star_01 = Sprite("world/maps/tvland/teevie_bg_star_01_tile", 0, 0)
	self.star_01.alpha = 0.6
	self.star_01.color = Utils.mergeColor({36/255,38/255,94/255}, COLORS["black"], 0.5)
	self.star_01:setScale(2,2)
	self.star_01.wrap_texture_x = true
	self.star_01.wrap_texture_y = true
	self.star_01:setLayer(self.layer + 0.01)
	self.star_01:setParallax(0.2, 0)
	Game.world:addChild(self.star_01)
	self.star_02 = Sprite("world/maps/tvland/teevie_bg_star_02_tile", 0, 0)
	self.star_02.alpha = 0.5
	self.star_02.color = {36/255,38/255,94/255}
	self.star_02:setScale(2,2)
	self.star_02.wrap_texture_x = true
	self.star_02.wrap_texture_y = true
	self.star_02:setLayer(self.layer + 0.02)
	self.star_02:setParallax(0.2, 0)
	Game.world:addChild(self.star_02)
	self.star_03 = Sprite("world/maps/tvland/teevie_bg_star_01_tile", 0, 0)
	self.star_03.color = Utils.mergeColor({36/255,38/255,94/255}, {9/255,9/255,22/255}, 0.2)
	self.star_03:setScale(2,2)
	self.star_03.wrap_texture_x = true
	self.star_03.wrap_texture_y = true
	self.star_03:setLayer(self.layer + 0.03)
	self.star_03:setParallax(0.4, 0)
	Game.world:addChild(self.star_03)
	self.star_04 = Sprite("world/maps/tvland/teevie_bg_star_02_tile", 0, 0)
	self.star_04.color = Utils.mergeColor({36/255,38/255,94/255}, {9/255,9/255,22/255}, 0.7)
	self.star_04:setScale(2,2)
	self.star_04.wrap_texture_x = true
	self.star_04.wrap_texture_y = true
	self.star_04:setLayer(self.layer + 0.04)
	self.star_04:setParallax(0.4, 0)
	Game.world:addChild(self.star_04)
	self.star_05 = Sprite("world/maps/tvland/teevie_bg_star_03_tile", 0, 0)
	self.star_05.color = Utils.mergeColor({36/255,38/255,94/255}, COLORS["blue"], 0.2)
	self.star_05.alpha = 0.6
	self.star_05:setScale(2,2)
	self.star_05.wrap_texture_x = true
	self.star_05.wrap_texture_y = true
	self.star_05:setLayer(self.layer + 0.05)
	self.star_05:setParallax(0.4, 0)
	Game.world:addChild(self.star_05)
	self.star_06 = Sprite("world/maps/tvland/teevie_bg_star_03_tile", 0, 0)
	self.star_06.color = Utils.mergeColor({36/255,38/255,94/255}, {9/255,9/255,22/255}, 0.1)
	self.star_06:setScale(2,2)
	self.star_06.wrap_texture_x = true
	self.star_06.wrap_texture_y = true
	self.star_06:setLayer(self.layer + 0.06)
	self.star_06:setParallax(0.4, 0)
	Game.world:addChild(self.star_06)

	self.star_coverrect = GradientVRect(0, 0, Game.world.map.width * Game.world.map.tile_width, Game.world.map.height * Game.world.map.tile_height)
	self.star_coverrect.alpha = 0.5
	self.star_coverrect.color_top = {36/255,38/255,94/255}
	self.star_coverrect.color_bottom = {0,0,0}
	self.star_coverrect:setLayer(self.layer + 0.07)
	Game.world:addChild(self.star_coverrect)
	
	self.girder_1 = {}
	self.girder_2 = {}
	self.girder_3 = {}
	self.girder_4 = {}
	for i = 1, math.floor((Game.world.map.width * Game.world.map.tile_width) / 340) do
		local xpos = (40 + ((i-1) * 300))*2
		self.girder_1[i] = Sprite("world/maps/tvland/teevie_bg_girder_tile", xpos, 0)
		self.girder_1[i]:setLayer(self.layer + 0.08)
		self.girder_1[i]:setScale(2,2)
		self.girder_1[i].color = Utils.mergeColor({30/255,27/255,39/255}, COLORS["black"], 0.15)
		self.girder_1[i].wrap_texture_y = true
		self.girder_1[i]:setParallax(0.5, 1)
		Game.world:addChild(self.girder_1[i])
	end
	for i = 1, math.floor((Game.world.map.width * Game.world.map.tile_width) / 190) do
		local xpos = (20 + ((i-1) * 170))*2
		self.girder_2[i] = Sprite("world/maps/tvland/teevie_bg_girder_medium_tile", xpos, 0)
		self.girder_2[i]:setLayer(self.layer + 0.09)
		self.girder_2[i].color = Utils.mergeColor({30/255,27/255,39/255}, COLORS["black"], 0.15)
		self.girder_2[i]:setScale(2,2)
		self.girder_2[i].wrap_texture_y = true
		self.girder_2[i]:setParallax(0.6, 1)
		Game.world:addChild(self.girder_2[i])
	end
	for i = 1, math.floor((Game.world.map.width * Game.world.map.tile_width) / 430) do
		local xpos = (50 + ((i-1) * 380))*2
		self.girder_3[i] = Sprite("world/maps/tvland/teevie_bg_girder_large_tile", xpos, 0)
		self.girder_3[i]:setLayer(self.layer + 0.1)
		self.girder_3[i].color = Utils.mergeColor({30/255,27/255,39/255}, COLORS["black"], 0.75)
		self.girder_3[i]:setScale(2,2)
		self.girder_3[i].wrap_texture_y = true
		self.girder_3[i]:setParallax(0.4, 1)
		Game.world:addChild(self.girder_3[i])
	end
	for i = 1, math.floor((Game.world.map.width * Game.world.map.tile_width) / 290) do
		local xpos = (100 + ((i-1) * 190))*2
		self.girder_4[i] = Sprite("world/maps/tvland/teevie_bg_girder_small_tile", xpos, 0)
		self.girder_4[i]:setLayer(self.layer + 0.11)
		self.girder_4[i].color = Utils.mergeColor({30/255,27/255,39/255}, COLORS["black"], 0.6)
		self.girder_4[i]:setScale(2,2)
		self.girder_4[i].wrap_texture_y = true
		self.girder_4[i]:setParallax(0.3, 1)
		Game.world:addChild(self.girder_4[i])
	end
	self.girder_lights = Sprite("world/maps/tvland/teevie_bg_girder_lights", 0, 0)
	self.girder_lights:setLayer(self.layer + 0.12)
	self.girder_lights:setScale(2,2)
	self.girder_lights.wrap_texture_x = true
	Game.world:addChild(self.girder_lights)
	self.bg_speed = 1
	self.bg_speed_y = 1
end

function TeevieBG:update()
	super.update(self)

	self.bg_speed = self.bg_speed - (1 * DTMULT) * 0.4
	self.bg_speed_y = self.bg_speed_y + (1 * DTMULT) * 0.4
	if self.bg_speed < -SCREEN_WIDTH then
		self.bg_speed = self.bg_speed + SCREEN_WIDTH
	end
	if self.bg_speed_y > -SCREEN_HEIGHT then
		self.bg_speed_y = self.bg_speed_y - SCREEN_HEIGHT
	end

	self.star_01.x = self.bg_speed * 0.5
	self.star_01.y = self.bg_speed_y * 0.5
	self.star_02.x = self.bg_speed * 0.5
	self.star_02.y = self.bg_speed_y * 0.5 + 20
	self.star_03.x = self.bg_speed
	self.star_03.y = self.bg_speed_y
	self.star_04.x = self.bg_speed
	self.star_04.y = self.bg_speed_y + 20
	self.star_05.x = self.bg_speed
	self.star_05.y = self.bg_speed_y
	self.star_06.x = self.bg_speed + 40
	self.star_06.y = self.bg_speed_y + 20
end

function TeevieBG:draw()
	super.draw(self)
	
    local shader = Kristal.Shaders["GradientV"]
    local last_shader = love.graphics.getShader()
	love.graphics.setShader(shader)
    shader:sendColor("from", {99/255, 142/255, 152/255})
    shader:sendColor("to", {168/255, 228/255, 131/255})
	Draw.draw(Assets.getTexture("bubbles/fill"), 0, 0, 0, self.width, self.height-10)
	love.graphics.setShader(last_shader)
end

return TeevieBG
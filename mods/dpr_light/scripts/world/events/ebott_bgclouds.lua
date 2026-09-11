local EbottBGClouds, super = Class(Event)

function EbottBGClouds:init(data)
    super.init(self, data)

	self:setParallax(1, 0.9)

	self.bg_siner = 0
    self.cloud_1 = Assets.getTexture("world/maps/ebott/cloud")
    self.cloud_2 = Assets.getTexture("world/maps/ebott/cloud")
    self.star_1 = Assets.getTexture("world/maps/ebott/star_small")
    self.star_2 = Assets.getTexture("world/maps/ebott/star_med")
    self.star_3 = Assets.getTexture("world/maps/ebott/star_big")
    self.cloud_back_fill = Assets.getTexture("world/maps/ebott/cloud_back_fill")
    self.overcast_clouds_long_b = Assets.getTexture("world/maps/ebott/overcast_back_clouds_long_b")
    self.overcast_clouds_long_a = Assets.getTexture("world/maps/ebott/overcast_back_clouds_long_a")
    self.overcast_clouds_fore = Assets.getTexture("world/maps/ebott/overcast_back_clouds_fore")
    self.palette_shader = Assets.getShader("palette")
	self.palette_tex = Assets.getTexture("world/maps/ebott/palette_clouds")
	self.clouds_pal = 0
    self.timer = 0

    if Game:getFlag("hometown_time", "day") == "morning" then
        self.clouds_pal = 1
    end
    if Game:getFlag("hometown_time", "day") == "evening" then
        self.clouds_pal = 2
    end
    if Game:getFlag("hometown_time", "day") == "night" then
        self.clouds_pal = 3
		self.stars = {}
		for i = 1, math.floor(SCREEN_WIDTH / 24) do
			local x_offset = i * 24
			local sprite = self.star_1
			if i % 8 == 4 then
				sprite = self.star_2
			elseif i % 8 == 7 then
				sprite = self.star_3
			end
			local star = Sprite(sprite, x_offset, MathUtils.random(0, 240)/2)
			star:setScale(2)
			star:setOrigin(0.5)
			star.siner = MathUtils.random(360)
			star.y_start = star.y
			star:setParallax(1, 0.9)
			star.night_mode = 2
			star:setLayer(self.layer - 0.001)
			Game.world:addChild(star)
			table.insert(self.stars, star)
		end
	else
		for i = 1, math.floor(Game.world.map.width / 8) do
			local cloud_index = ((i - 1) % 4) + 1
			local x_offset = math.floor((i - 1) / 4)
			if cloud_index == 1 then
				self:createCloud(self.cloud_2, x_offset + -244, 238/2, 0.2 , 0.5,  0.9, {1, 1, 1})
			elseif cloud_index == 2 then
				self:createCloud(self.cloud_1, x_offset + 154,  154/2, 0.35, 0.6,  0.9, {1, 1, 1})
			elseif cloud_index == 3 then
				self:createCloud(self.cloud_2, x_offset - 560,  240/2, 0.25, 0.55, 0.9, {1, 1, 1})
			elseif cloud_index == 4 then
				self:createCloud(self.cloud_1, x_offset - 840,  190/2, 0.25, 0.5,  0.9, {1, 1, 1})
			end
		end
	end
end

function EbottBGClouds:createCloud(asset, x, y, speed, parallax_x, parallax_y, color)
    local cloud = EbottCloud(asset, x, y, speed, parallax_x, parallax_y)
    if color then
        cloud:setColor(color)
    end
	cloud:addFX(PaletteFX("world/maps/ebott/palette_clouds", (self.clouds_pal * 2), nil, nil, 1))
	cloud:setLayer(self.layer - 0.001)
    Game.world:addChild(cloud)
    return cloud
end

function EbottBGClouds:draw()
	local overcast_alpha = 0
	local cloud_darken_alpha = 0
	if Game.stage.weather then
		for i, w in ipairs(Game.stage.weather) do
			if w.type == "rain" or w.type == "rain_prewarmed" or w.type == "overcast" then
				overcast_alpha = (w.weathertimer / 120)
				if w.type ~= "overcast" then
					cloud_darken_alpha = (w.weathertimer / 120)			
				end
			end
		end
	end
	if self.stars then
		for _, star in ipairs(self.stars) do
			if overcast_alpha <= 0 then
				star.night_mode = 2
			else
				star.night_mode = 0
			end
			star.siner = star.siner + DTMULT
			star.color = ColorUtils.mergeColor(Game.world.map.bg_color, COLORS["white"], 0.6 + math.sin(star.siner/16) * 0.1)
		end
	end
    super.draw(self)
	love.graphics.setBlendMode("alpha")
	self.bg_siner = self.bg_siner + DTMULT
	local overcast_canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
	love.graphics.clear()
	Draw.pushShader(self.palette_shader)
	self.palette_shader:send("palette_tex", self.palette_tex)
	local palw, palh = self.palette_tex:getWidth(), self.palette_tex:getHeight()
	self.palette_shader:send("palette_uvs", {(1.0 / palw) * 0.5, (1.0 / palh) * 0.5, 1, 1})
	self.palette_shader:send("pixel_size", {1.0 / palw, 1.0 / palh})
	self.palette_shader:send("palette_id", (self.clouds_pal * 2) + cloud_darken_alpha)
	Draw.setColor(1, 1, 1, 1)
	Draw.draw(self.cloud_back_fill, 0, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
	Draw.drawWrapped(self.overcast_clouds_long_b, true, false, self.bg_siner * 0.2, 0, 0, 2, 2)
	Draw.drawWrapped(self.overcast_clouds_long_a, true, false, self.bg_siner * 0.25, 0, 0, 2, 2)
	Draw.drawWrapped(self.overcast_clouds_fore, true, false, self.bg_siner * 0.3, 0, 0, 2, 2)
	Draw.popShader()
	Draw.popCanvas(true)
	Draw.setColor(1, 1, 1, overcast_alpha)
	Draw.draw(overcast_canvas, 0, 0)
	Draw.setColor(1, 1, 1, 1)
end

return EbottBGClouds

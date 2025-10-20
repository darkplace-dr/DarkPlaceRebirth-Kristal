local EbottBGClouds, super = Class(Event)

function EbottBGClouds:init(data)
    super.init(self, data)

    self.cloud_1 = Assets.getTexture("world/maps/ebott/cloud")
    self.cloud_2 = Assets.getTexture("world/maps/ebott/cloud")
    self.star_1 = Assets.getTexture("world/maps/ebott/star_small")
    self.star_2 = Assets.getTexture("world/maps/ebott/star_med")
    self.star_3 = Assets.getTexture("world/maps/ebott/star_big")

    self.timer = 0

	if Game:getFlag("hometown_time", "day") == "night" then
		self.stars = {}
		for i = 1, math.floor(SCREEN_WIDTH / 24) do
			local x_offset = i * 24
			local sprite = self.star_1
			if i % 8 == 4 then
				sprite = self.star_2
			elseif i % 8 == 7 then
				sprite = self.star_3
			end
			local star = Sprite(sprite, x_offset, Utils.random(0, 240)/2)
			star:setScale(2)
			star:setOrigin(0.5)
			star.siner = Utils.random(360)
			star.y_start = star.y
			star:setParallax(1, 0.9)
			star.night_mode = 2
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
    self:addChild(cloud)
    return cloud
end

function EbottBGClouds:draw()
	if self.stars then
		for _, star in ipairs(self.stars) do
			star.siner = star.siner + DTMULT
			star.color = Utils.mergeColor(Game.world.map.bg_color, COLORS["white"], 0.6 + math.sin(star.siner/16) * 0.1)
		end
	end
    super.draw(self)
end

return EbottBGClouds

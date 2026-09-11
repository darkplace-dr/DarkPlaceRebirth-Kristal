local BeachWaterRainOverlay, super = Class(Object)

function BeachWaterRainOverlay:init(x, y)
    super.init(self, x, y)

    self.sprite = Sprite("world/maps/hometown/beachwater_rain", 0, 0)
    self.sprite:setScale(2)
    self:addChild(self.sprite)
    
    self.extleaves_sprite = Sprite("world/maps/hometown/beachwater_rain_extleaves", 0, 0)
    self.extleaves_sprite:setScale(2)
	self.extleaves_sprite.layer = 0.001
	self.extleaves_sprite.alpha = 0
    self:addChild(self.extleaves_sprite)
	
	self.extleaves_color = {
		{ColorUtils.hexToRGB("#8f8c6b"), ColorUtils.hexToRGB("#806040")},
		{ColorUtils.hexToRGB("#a76108"), ColorUtils.hexToRGB("#a73308")}
	}
    
	self.layer = 0

    self.shader = love.graphics.newShader([[
        extern float time; // seconds
extern vec2 texture_dim;
extern vec2 do_dim = vec2(1, 0);
extern int thickness = 1;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec2 chunk = vec2(floor(texture_coords.x * texture_dim.x / thickness) * thickness, floor(texture_coords.y * texture_dim.y / thickness) * thickness);
    if (do_dim.x > 0.0)
        texture_coords.x += sin(time + chunk.x / 30.0) * 2.0 / texture_dim.x;
    if (do_dim.y > 0.0)
        texture_coords.y += sin(time + chunk.y / 30.0) * 2.0 / texture_dim.y;
    return Texel(tex, texture_coords) * color;
}
    ]])
	
	self.siner = 0
	if Game:getFlag("hometown_time", "day") == "morning" then
		self.sprite:setSprite("world/maps/hometown/beachwater_rain_morning")
		self.extleaves_sprite.alpha = 1
		self.extleaves_sprite:setColor(self.extleaves_color[1][1])
	elseif Game:getFlag("hometown_time", "day") == "evening" then
		self.sprite:setSprite("world/maps/hometown/beachwater_rain_evening")
		self.extleaves_sprite.alpha = 1
		self.extleaves_sprite:setColor(self.extleaves_color[2][1])
	end
end

function BeachWaterRainOverlay:update()
	super.update(self)
	local overcast_power = 0
	if Game.stage.weather then
		for i, w in ipairs(Game.stage.weather) do
			if w.type == "rain" or w.type == "rain_prewarmed" or w.type == "overcast" then
				overcast_power = (w.weathertimer / 120)
			end
		end
	end
	if Game:getFlag("hometown_time", "day") == "morning" then
		self.extleaves_sprite:setColor(ColorUtils.mergeColor(self.extleaves_color[1][1], self.extleaves_color[1][2], overcast_power))
	elseif Game:getFlag("hometown_time", "day") == "evening" then
		self.extleaves_sprite:setColor(ColorUtils.mergeColor(self.extleaves_color[2][1], self.extleaves_color[2][2], overcast_power))
	end
end

function BeachWaterRainOverlay:draw()
    love.graphics.setShader(self.shader)

    self.shader:send("time", self.siner)
    self.shader:send("texture_dim", {194, 280})
    super.draw(self)
    love.graphics.setShader()
end

return BeachWaterRainOverlay
local BeachWater, super = Class(Event, "beachwater")

function BeachWater:init(data)
    super.init(self, data)

    self.sprite = Sprite("world/maps/hometown/beachwater", 0, 0)
    self.sprite:setScale(2)
    self:addChild(self.sprite)
    
    self.overcast_sprite = Sprite("world/maps/hometown/beachwater", 0, 0)
    self.overcast_sprite:setScale(2)
	self.overcast_sprite.layer = 0.001
    self:addChild(self.overcast_sprite)
	self.layer = self:setLayer("below_ui")

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
	self.rain_mode = false
	self.timer = 0
	
	self.rain_sprite = BeachWaterRainOverlay(self.x, self.y)
    Game.world:addChild(self.rain_sprite)
end

function BeachWater:onLoad()
	super.onLoad(self)

	self.rain_sprite.layer = self.layer + 0.02
	if Game:getFlag("hometown_time", "day") == "morning" then
		self.sprite:setSprite("world/maps/hometown/beachwater_morning")
		self.overcast_sprite:setSprite("world/maps/hometown/beachwater_morning_overcast")
	elseif Game:getFlag("hometown_time", "day") == "evening" then
		self.sprite:setSprite("world/maps/hometown/beachwater_evening")
		self.overcast_sprite:setSprite("world/maps/hometown/beachwater_evening_overcast")
	end
end

function BeachWater:update()
    super.update(self)
	
    self.siner = self.siner + DT
	self.rain_sprite.siner = self.siner
	if Game.stage:hasWeather("rain") and self.rain_mode == false then
		self.rain_sprite.visible = true
		self.rain_mode = true
	elseif not Game.stage:hasWeather("rain") and self.rain_mode == true then
		self.rain_sprite.visible = false
		self.rain_mode = false
	end
	self.overcast_sprite.alpha = 0
	if Game.stage.weather then
		for i, w in ipairs(Game.stage.weather) do
			if w.type == "rain" or w.type == "rain_prewarmed" or w.type == "overcast" then
				self.overcast_sprite.alpha = (w.weathertimer / 120)
			end
		end
	end
	if self.rain_mode then
		self.timer = self.timer - DTMULT
		if self.timer < 0 then
			self.timer = 2
            local splash = Sprite("effects/rain_splash")
			if Game:getFlag("hometown_time", "day") == "evening" then
				splash:setSprite("effects/rain_splash_evening")
			end
            splash:setOrigin(0.5, 0.5)
            splash:setScale(2, 2)
            splash:setPosition(self.x + MathUtils.random(384) + 20, self.y + MathUtils.random(440) + 20)
			splash.layer = self.layer + 0.01
            splash:play(1/15, false, function(s) s:remove() end)
            Game.world:addChild(splash)
		end
	end
end

function BeachWater:draw()
    super.draw(self)
    love.graphics.setShader(self.shader)

    self.shader:send("time", self.siner)
    self.shader:send("texture_dim", {194, 280})
    super.draw(self)
    love.graphics.setShader()
end

return BeachWater
local BeachWater, super = Class(Event, "beachwater")

function BeachWater:init(data)
    super.init(self, data)

    self.sprite = Sprite("world/maps/hometown/beachwater", 0, 0)
    self.sprite:setScale(2)
    self:addChild(self.sprite)
    
	self.layer = BeachWater:setLayer("below_ui")

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
	if self.rain_mode then
		self.timer = self.timer - DTMULT
		if self.timer < 0 then
			self.timer = 2
            local splash = Sprite("effects/rain_splash")
            splash:setOrigin(0.5, 0.5)
            splash:setScale(2, 2)
            splash:setPosition(self.x + Utils.random(384) + 20, self.y + Utils.random(440) + 20)
			splash.layer = self.layer + 0.01
            splash:play(1/15, false, function(s) s:remove() end)
            Game.world:addChild(splash)
		end
	end
end

function BeachWater:draw()
    love.graphics.setShader(self.shader)

    self.shader:send("time", self.siner)
    self.shader:send("texture_dim", {240, 280})
    super.draw(self)
    love.graphics.setShader()
end

return BeachWater
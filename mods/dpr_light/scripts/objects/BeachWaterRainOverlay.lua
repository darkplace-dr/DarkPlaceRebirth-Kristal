local BeachWaterRainOverlay, super = Class(Object)

function BeachWaterRainOverlay:init(x, y)
    super.init(self, x, y)

    self.sprite = Sprite("world/maps/hometown/beachwater_rain", 0, 0)
    self.sprite:setScale(2)
    self:addChild(self.sprite)
    
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
end

function BeachWaterRainOverlay:draw()
    love.graphics.setShader(self.shader)

    self.shader:send("time", self.siner)
    self.shader:send("texture_dim", {240, 280})
    super.draw(self)
    love.graphics.setShader()
end

return BeachWaterRainOverlay
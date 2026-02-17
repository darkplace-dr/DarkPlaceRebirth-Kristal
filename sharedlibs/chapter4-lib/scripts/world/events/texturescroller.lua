-- Port of obj_texturescroller.
---@class Event.texturescroller : Event
local texturescroller, super = Class(Event, "texturescroller")

function texturescroller:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
    self.surf_textured = love.graphics.newCanvas(SCREEN_WIDTH, SCREEN_HEIGHT);
    self.base_texture = Assets.getTexture "backgrounds/glow_tile_oscillate";
    self.scroll_texture = Assets.getTexture "backgrounds/perlin_noise_darker_looping";
    self.fade_time_seconds = 4;
    self.fade_from = 0;
    self.fade_to = 1;
end

local function draw_set_alpha(a)
    local r,g,b = love.graphics.getColor()
    love.graphics.setColor(r,g,b,a)
end

local function draw_sprite_tiled(tex, _, x, y)
    Draw.drawWrapped(tex, true, true, x, y)
end

function texturescroller:draw()
    local _cx = 0;
    local _cy = 0;

    Draw.pushCanvas(self.surf_textured, {keep_transform = true});
    love.graphics.clear(0, 0, 0, 0);
    love.graphics.setColorMask(true, true, true, false);
    draw_sprite_tiled(self.base_texture, 0, 0, 0);
    draw_set_alpha(Ch4Lib.scr_wave(self.fade_from, self.fade_to, self.fade_time_seconds, 0));
    local _timeoffset = (Kristal.getTime() * 1000) * 0.05;
    love.graphics.setBlendMode("alpha");
    draw_sprite_tiled(self.base_texture, 1, 0, 0);
    draw_sprite_tiled(self.scroll_texture, 0, -_cx - _timeoffset, -_cy - _timeoffset);
    draw_set_alpha(1);
    love.graphics.setColorMask(true, true, true, true);
    love.graphics.setColorMask(false, false, false, true);

    for index, value in ipairs(self.stage:getObjects(Registry.getLegacyEvent("tile_oscillate"))) do
        love.graphics.push()
        love.graphics.replaceTransform(value:getFullTransform())
        love.graphics.rectangle("fill", 0, 0, value.width, value.height)
        love.graphics.pop()
    end

    love.graphics.setColorMask(true, true, true, true);
    Draw.popCanvas();
    love.graphics.origin()
    Draw.draw(self.surf_textured, _cx, _cy);

end

return texturescroller
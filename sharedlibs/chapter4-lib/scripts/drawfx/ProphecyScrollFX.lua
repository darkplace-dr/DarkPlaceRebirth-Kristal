---@class ProphecyScrollFX: FXBase
local ProphecyScrollFX, super = Class(FXBase)

function ProphecyScrollFX:init(texture, priority)
    super.init(self, priority)
    ---@type love.Image
    self.texture = type(texture) == "string" and Assets.getTexture(texture) or (type(texture) == "userdata" and texture)
    self.texture = self.texture or Assets.getTexture("backgrounds/IMAGE_DEPTH_EXTEND_MONO_SEAMLESS_BRIGHTER")
    self.surf_textured = -1;
    self.tile_object = 364;
    self.base_texture = 88;
    self.scroll_texture = 991;
    self.fade_time_seconds = 4;
    self.fade_from = 0;
    self.fade_to = 1;
    self.scroll_speed = 1;
    self.tick = 0;
    self.intro_mode = false;

end

function ProphecyScrollFX:update()
    self.tick = self.tick + ((1/15) * self.scroll_speed * DTMULT)
end

local function draw_sprite_tiled_ext(tex, _, x, y, sx, sy, color, alpha)
    local r,g,b,a = love.graphics.getColor()
    if color then
        Draw.setColor(color, alpha)
    end
    Draw.drawWrapped(tex, true, true, x, y, 0, sx, sy)
    love.graphics.setColor(r,g,b,a)
end

local function draw_set_alpha(a)
    local r,g,b = love.graphics.getColor()
    love.graphics.setColor(r,g,b,a)
end

local function scr_wave(arg0, arg1, arg2, arg3)
    local a4 = (arg1 - arg0) * 0.5;
    return arg0 + a4 + (math.sin((((Kristal.getTime() * 30 * 0.001) + (arg2 * arg3)) / arg2) * (2 * math.pi)) * a4);
end

function ProphecyScrollFX:draw(texture)
    self:drawPart(texture, 0, 0.5, scr_wave(0, 0.4, 4, 0))
    self:drawPart(texture, 0.5, 1.0, 1 or scr_wave(0.4, 0.4, 4, 0))
end

function ProphecyScrollFX:drawPart(texture, min, max, alpha)

    local parent = self.parent
    for i = 1, 4 do
        parent = parent.parent or parent
        if parent:includes(World) then
            ---@cast parent World
            parent = parent.map.tile_layers[1] or parent.map.image_layers[1] or parent.map.events[1]
        end
    end

    local _cx, _cy = parent:getScreenPos()
    _cx, _cy = -_cx, -_cy

    local surf_textured = Draw.pushCanvas(640, 480);
    love.graphics.clear(COLORS.white, 0);
    love.graphics.setColorMask(true, true, true, false);
    local pnl_tex = Assets.getTexture("backgrounds/perlin_noise_looping")
    local pnl_canvas = Draw.pushCanvas(pnl_tex:getDimensions())
    draw_sprite_tiled_ext(pnl_tex, 0, 0, 0, 1, 1, Utils.hexToRgb"#42D0FF", alpha)
    Draw.popCanvas(true)
    self.tick = self.tick + (((1/15) * self.scroll_speed) * DTMULT);
    local x, y = -((_cx * 2) + (self.tick * 15)) * 0.5, -((_cy * 2) + (self.tick * 15)) * 0.5
    draw_sprite_tiled_ext(Assets.getTexture("backgrounds/IMAGE_DEPTH_EXTEND_MONO_SEAMLESS_BRIGHTER"), 0, x, y, 2, 2, Utils.hexToRgb"#42D0FF", 1);
    local orig_bm, orig_am = love.graphics.getBlendMode()
    love.graphics.setBlendMode("add", "premultiplied");
    draw_sprite_tiled_ext(pnl_canvas, 0, x, y, 2, 2, Utils.hexToRgb"#42D0FF", alpha);
    love.graphics.setBlendMode(orig_bm, orig_am);
    love.graphics.setColorMask(true, true, true, true);
    love.graphics.setColorMask(false, false, false, true);

    -- with (tile_object)
    -- {
    --     if (other.intro_mode)
    --     {
    --         local _amt = sin((other.tick / 15) * (2 * pi)) * other.scroll_speed * 6;
    --         draw_sprite_ext(sprite_index, image_index, x - _cx - _amt, y - _cy - _amt, image_xscale, image_yscale, image_angle, image_blend, image_alpha * 0.4);
    --         draw_sprite_ext(sprite_index, image_index, (x - _cx) + _amt, (y - _cy) + _amt, image_xscale, image_yscale, image_angle, image_blend, image_alpha * 0.4);
    --     }
        
    --     draw_sprite_ext(sprite_index, image_index, x - _cx, y - _cy, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
    -- }

    love.graphics.setColorMask(true, true, true, true);
    Draw.popCanvas()


    love.graphics.stencil(function()
        local last_shader = love.graphics.getShader()
        local shader = Assets.getShader("limitedmask")
        shader:send("min", min)
        shader:send("max", max)
        love.graphics.setShader(shader)
        Draw.draw(texture)
        love.graphics.setShader(last_shader)
    end, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
    Draw.drawCanvas(surf_textured);
    love.graphics.setStencilTest()
end


return ProphecyScrollFX
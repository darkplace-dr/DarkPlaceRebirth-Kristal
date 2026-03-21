---@class ProphecyScrollFX: FXBase
local ProphecyScrollFX, super = Class(FXBase)

function ProphecyScrollFX:init(texture, priority, perlin_tex)
    super.init(self, priority)
    ---@type love.Image
    self.texture = type(texture) == "string" and Assets.getTexture(texture) or (type(texture) == "userdata" and texture)
    self.texture = self.texture or Assets.getTexture("backgrounds/IMAGE_DEPTH_EXTEND_MONO_SEAMLESS_BRIGHTER")
    self.perlin_texture = type(perlin_tex) == "string" and Assets.getTexture(perlin_tex) or (type(perlin_tex) == "userdata" and perlin_tex)
	self.perlin_texture = self.perlin_texture or Assets.getTexture("backgrounds/perlin_noise_looping")
    self.surf_textured = -1;
    self.tile_object = 364;
    self.base_texture = 88;
    self.scroll_texture = 991;
    self.fade_time_seconds = 4;
    self.fade = 0
    self.fading_in = true
    self.fade_from = 0;
    self.fade_to = 1;
    self.scroll_speed = 1;
    self.tick = 0;
    self.intro_mode = false;

	self.prophecy_color = ColorUtils.hexToRGB("#42D0FF")
end

function ProphecyScrollFX:update()
    self.tick = self.tick + ((1/15) * self.scroll_speed * DTMULT)
    if self.fading_in then
        self.fade = math.min(self.fade + (DTMULT / 60) / 1, 1)
    end
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

function ProphecyScrollFX:draw(texture)
    self:drawPart(texture, Ch4Lib.scr_wave(0, 0.4, 4, 0))
end

function ProphecyScrollFX:setProphecyColor(r, g, b, a)
    if type(r) == "table" then
        r, g, b, a = unpack(r)
    end
    self.prophecy_color = { r, g, b, a or 1}
end

local function returnAlphaColor(color, value)
    local color = color
    return {
        color[1],
        color[2],
        color[3],
        color[4] * (value or 1),
    }
end

function ProphecyScrollFX:drawPart(texture, alpha)

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
    local pnl_tex = self.perlin_texture
    local pnl_canvas = Draw.pushCanvas(pnl_tex:getDimensions())
    draw_sprite_tiled_ext(pnl_tex, 0, 0, 0, 1, 1, returnAlphaColor(self.prophecy_color, alpha * self.fade))
    Draw.popCanvas(true)
    love.graphics.setColorMask(true, true, true, false);
    local x, y = -((_cx * 2) + (self.tick * 15)) * 0.5, -((_cy * 2) + (self.tick * 15)) * 0.5
    draw_sprite_tiled_ext(self.texture, 0, x, y, 2, 2, returnAlphaColor(self.prophecy_color, self.fade));
    local orig_bm, orig_am = love.graphics.getBlendMode()
    love.graphics.setBlendMode("add", "premultiplied");
    draw_sprite_tiled_ext(pnl_canvas, 0, x, y, 2, 2, COLORS.white);
    love.graphics.setBlendMode(orig_bm, orig_am);
    love.graphics.setColorMask(true, true, true, true);
    Draw.popCanvas()


    love.graphics.stencil(function()
        local last_shader = love.graphics.getShader()
        local shader = Kristal.Shaders["Mask"]
        love.graphics.setShader(shader)
        Draw.draw(texture)
        love.graphics.setShader(last_shader)
    end, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
	Draw.setColor(1,1,1,1)
    Draw.drawCanvas(surf_textured);
    love.graphics.setStencilTest()
end


return ProphecyScrollFX
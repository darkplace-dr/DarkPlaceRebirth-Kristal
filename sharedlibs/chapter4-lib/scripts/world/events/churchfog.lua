---@class Event.churchfog : Event
local event, super = Class(Event, "churchfog")

function event:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
    self.ss = 0.5;
    self.ssy = 0.1;
    self.auto = 0;
    self.autoy = 0;
    self.shadoweffect = 0;
    self.why_call_init = 0;
    self.siner = 0;
    self.accounty = 0;
    self.xoff = ((0 + self.auto) * self.ss) + self.init_x;
    self.yoff = ((0 + self.autoy) * self.ssy) + self.init_y;
    self.mysprite = Assets.getTexture "backgrounds/churchfog";
    self.sprwidth = (self.mysprite):getWidth() * 2;
    self.sprheight = (self.mysprite):getHeight() * 2;

end

local function draw_sprite_tiled_ext(tex, _, x, y, sx, sy, rotation, color, alpha)
    local r,g,b,a = love.graphics.getColor()
    if color then
        Draw.setColor(color, alpha)
    end
    Draw.drawWrapped(tex, true, true, x, y, rotation, sx, sy)
    love.graphics.setColor(r,g,b,a)
end

function event:draw()
    local cx, cy = love.graphics.transformPoint(0, 0)
    love.graphics.origin()
    self.ss = 0.5;
    self.ssy = 0.5;
    self.auto = self.auto + 2;
    self.autoy = self.autoy + 2;
    self.xoff = ((cx + self.auto) * self.ss) + self.init_x;
    self.yoff = ((cy + self.autoy) * self.ssy) + self.init_y;
    self.mytransparency = 0.1;
    local finalxoff = self.xoff % self.sprwidth;
    local finalyoff = self.yoff % self.sprheight;
    local canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
    love.graphics.clear(0,0,0,1)
    draw_sprite_tiled_ext(self.mysprite, 0, cx - finalxoff, cy - finalyoff, 2, 2, 0, COLORS.white, self.mytransparency);
    -- draw_sprite_tiled_ext(self.mysprite, 0, (cx - finalxoff) + self.sprwidth, cy - finalyoff, 2, 2, 0, COLORS.white, self.mytransparency);
    -- draw_sprite_tiled_ext(self.mysprite, 0, cx - finalxoff, (cy - finalyoff) + self.sprheight, 2, 2, 0, COLORS.white, self.mytransparency);
    -- draw_sprite_tiled_ext(self.mysprite, 0, (cx - finalxoff) + self.sprwidth, (cy - finalyoff) + self.sprheight, 2, 2, 0, COLORS.white, self.mytransparency);
    Draw.popCanvas()
    love.graphics.setBlendMode("add", "premultiplied");
    Draw.draw(canvas)
    love.graphics.setBlendMode("alpha", "alphamultiply");

end

return event
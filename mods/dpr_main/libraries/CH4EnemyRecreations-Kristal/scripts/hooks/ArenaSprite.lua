local ArenaSprite, super = HookSystem.hookScript(ArenaSprite)

function ArenaSprite:init(...)
    super.init(self, ...)

    self.shake_ = 0 -- 90 in the original code
    self.shake_dir = 90
    self.shake_speed = 75
    self.splash_x = 0
    self.life_time = 0
end

function ArenaSprite:drawOutline(alpha)
    local r,g,b,a = self:getDrawColor()
    local arena_r,arena_g,arena_b,arena_a = self.arena:getDrawColor()

    Draw.setColor(r * arena_r, g * arena_g, b * arena_b, a * arena_a * (alpha or 1))
    love.graphics.setLineStyle("rough")
    love.graphics.setLineWidth(self.arena.line_width)
    love.graphics.line(unpack(self.arena.border_line))
end

function ArenaSprite:update()
    super.update(self)

    self.shake_dir = self.shake_dir + self.shake_speed * DTMULT
    self.shake_ = math.max(self.shake_ - DTMULT, 0)
end

function ArenaSprite:drawBackground()
    local x, y = 0, 0
    local _shake_dist = math.max((self.shake_ / 10) - 4, (self.shake_ / 20) - 2, 0)
    local _shake_tilt = MathUtils.sign(self.splash_x - x)
    local _box_x = x + MathUtils.lengthDirX(_shake_dist, math.rad(self.shake_dir))
    local _box_y = y + ((MathUtils.lengthDirX(_shake_dist, math.rad(self.shake_dir)) / 3) * _shake_tilt)
    love.graphics.push("transform")
    love.graphics.translate(_box_x, _box_y)
    super.drawBackground(self)
    love.graphics.pop()
end

function ArenaSprite:draw()
    if self.background then
        Draw.setColor(self.arena:getBackgroundColor())
        self:drawBackground()
    end

    super.super.draw(self)

    if self.shake_ == 0 then
        self:drawOutline()
    else
        local x, y = 0, 0
        local _shake_dist = math.max((self.shake_ / 10) - 4, (self.shake_ / 20) - 2, 0)
        local _shake_tilt = MathUtils.sign(self.splash_x - x)
        local _box_x = x + MathUtils.lengthDirX(_shake_dist, math.rad(self.shake_dir))
        local _box_y = y + ((MathUtils.lengthDirX(_shake_dist, math.rad(self.shake_dir)) / 3) * _shake_tilt)
        love.graphics.push("transform")
        love.graphics.translate(x + MathUtils.lengthDirX(_shake_dist, math.rad(self.shake_dir + 180)), y + ((MathUtils.lengthDirX(_shake_dist, math.rad(self.shake_dir + 180)) / 3) * _shake_tilt))
        self:drawOutline(0.5)
        love.graphics.pop()
        love.graphics.push("transform")
        love.graphics.translate(_box_x, _box_y)
        self:drawOutline(1)
        love.graphics.pop()
        -- draw_sprite_ext(sprite_index, 1, x + MathUtils.lengthDirX(_shake_dist, shake_dir + 180), y + ((MathUtils.lengthDirX(_shake_dist, shake_dir + 180) / 3) * _shake_tilt), image_xscale, image_yscale, image_angle, image_blend, 0.5 * image_alpha);
        -- draw_sprite_ext(sprite_index, 1, _box_x, _box_y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
        -- draw_sprite_ext(sprite_index, image_index, x + MathUtils.lengthDirX(_shake_dist, shake_dir + 180), y + ((MathUtils.lengthDirX(_shake_dist, shake_dir + 180) / 3) * _shake_tilt), image_xscale, image_yscale, image_angle, image_blend, 0.5 * image_alpha);
        -- draw_sprite_ext(sprite_index, image_index, _box_x, _box_y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
    end
end

return ArenaSprite
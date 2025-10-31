---@class SpearBlasterBullet : Sprite
---@overload fun(...) : SpearBlasterBullet
local SpearBlasterBullet, super = Class(Sprite)

function SpearBlasterBullet:init(x, y, tx, ty, after)
    super.init(self, "effects/spearblaster_bullet", x, y)

    self:setOrigin(0.5, 0.5)
    self:setScale(2)

    self.target_x = tx
    self.target_y = ty

    self.rotation = Utils.angle(x, y, tx, ty)
    self.physics.speed = 24
    self.physics.match_rotation = true

    self.collided = false

    self.after_func = after
end

function SpearBlasterBullet:update()
    if MathUtils.dist(self.x, self.y, self.target_x, self.target_y) <= 20 and not self.collided then
        self.collided = true
        if self.after_func then
            self.after_func()
        end
    end

    local size = self.width + self.height
    local x, y = self:getScreenPos()
    if (x < -size or y < -size or x > SCREEN_WIDTH + size or y > SCREEN_HEIGHT + size) and self.collided then
        self:remove()
    end

    super.update(self)
end

return SpearBlasterBullet
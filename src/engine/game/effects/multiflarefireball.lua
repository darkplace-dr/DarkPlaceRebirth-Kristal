---@class MultiFlareFireball : Sprite
---@overload fun(...) : MultiFlareFireball
local MultiFlareFireball, super = Class(Sprite)

function MultiFlareFireball:init(x, y, tx, ty, after)
    super.init(self, "effects/multiflare/fireball", x, y)

    self:setOrigin(0.5, 0.5)
    self:setScale(2)

    self.target_x = tx
    self.target_y = ty

    self.rotation = Utils.angle(x, y, tx, ty) + math.rad(20)
    self.physics.speed = 24
    self.physics.friction = -1.5
    self.physics.match_rotation = true

    self.alpha = 0

    self.afterimg_timer = 0
    self.after_func = after
end

function MultiFlareFireball:update()
    self.alpha = Utils.approach(self.alpha, 1, 0.25 * DTMULT)

    local dir = Utils.angle(self.x, self.y, self.target_x, self.target_y)
    self.rotation = self.rotation + (Utils.angleDiff(dir, self.rotation) / 2) * DTMULT


    if Utils.dist(self.x, self.y, self.target_x, self.target_y) <= 40 then
        if self.after_func then
            self.after_func()
        end
        Assets.playSound("explosion_firework")
        self:remove()
        return
    end

    self.afterimg_timer = self.afterimg_timer + DTMULT
    if self.afterimg_timer >= 1 then
        self.afterimg_timer = 0

        local sprite = Sprite("effects/multiflare/fireball", self.x, self.y)
        sprite:fadeOutSpeedAndRemove()
        sprite:setOrigin(0.5, 0.5)
        sprite:setScale(2, 1.8)
        sprite.rotation = self.rotation
        sprite.alpha = self.alpha - 0.2
        sprite.layer = self.layer - 0.01
        sprite.graphics.grow_y = -0.1
        sprite.graphics.remove_shrunk = true
        sprite:play(1/15, true)
        self.parent:addChild(sprite)
    end

    super.update(self)
end

return MultiFlareFireball
---@class RedShape : DarkShapeBullet
---@overload fun(...) : RedShape
local RedShape, super = Class(DarkShapeBullet)

function RedShape:init(x, y)
    super.init(self, x, y, "battle/bullets/titan/red/body")
    
    self.eye_tex = Assets.getTexture("battle/bullets/titan/red/eye")
    self.iris_tex = Assets.getTexture("battle/bullets/titan/red/iris")

    self.radius = 22
    self.light = 0
    self.color = COLORS.red
    self.tracking_val2 = 1
    self.destroy_on_hit = false
    self.speed_max = self.speed_max * 2.5

    self:setScale(1, 1)
    self.scalefactor = 1

    self.can_do_shrivel = false
    self.can_do_pushback = false
    self.can_destroy = false
end

function RedShape:chaseHeart()
    local hx, hy = Game.battle.soul.x, Game.battle.soul.y

    if (MathUtils.dist(self.x, self.y, hx, hy) < (Game.battle.soul.light_radius + 8)) or self.light > 0 then
        self.physics.speed = MathUtils.approach(self.physics.speed, self.speed_max * self.speed_max_multiplier * 0.5, (self.physics.speed * 0.25) * DTMULT)
    else
        self.physics.speed = MathUtils.approach(self.physics.speed, self.speed_max * self.speed_max_multiplier, (self.accel * self.speed_max_multiplier * (1 - self.light)) * DTMULT)
    end
    
    local anglediff = MathUtils.angleDiff(self.physics.direction, Utils.angle(self.x, self.y, hx, hy))
        
    if self.tracking_val2 > 0 then
        self.physics.direction = MathUtils.angleLerp(self.physics.direction, Utils.angle(self.x, self.y, hx, hy), (self.tracking_val2 * 0.3) * DTMULT)
    end
end

function RedShape:update()
    super.update(self)
    
    self.collider = CircleCollider(self, 25, 24, self.radius/2)
end

function RedShape:updateStepZero()
    super.updateStepZero(self)
    self.rotation = self.rotation + -math.rad(2.8125) * DTMULT

    if self.tracking_val2 > 0 then
        self.tracking_val2 = MathUtils.approach(self.tracking_val2, 0, 0.00875*DTMULT)
    end

    -- Spawns the afterimage trail when the bullet's speed reaches 2.
    if self.physics.speed > 2 then
        if self:getFX("wave") then
            -- Wave shader breaks the afterimages for some reason...
            -- and we aren't even spawning in anymore, so it won't be visible.
            self:removeFX("wave")
        end
        local afterimage = AfterImage(self.sprite, 0.3, 0.08)
        afterimage.layer = self.sprite.layer - 20
        afterimage.debug_select = false
        self:addChild(afterimage)
    end
end

function RedShape:updateStepOne()
    return
end

function RedShape:draw()
    super.draw(self)
    
    local ox, oy = self:getRotationOriginExact()
    if floor_x then
        ox, oy = MathUtils.floorToMultiple(ox, 1 / CURRENT_SCALE_X), MathUtils.floorToMultiple(oy, 1 / CURRENT_SCALE_Y)
    end
    love.graphics.translate(ox, oy)
    love.graphics.rotate(-self.rotation)
    Draw.draw(self.eye_tex, 0, 0, 0, 1, 1, 25, 24)
    local hdir = MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
    Draw.draw(self.iris_tex, MathUtils.lengthDirX(2, hdir), MathUtils.lengthDirY(2, -hdir) + 1, 0, 1, 1, 1, 1)
end

function RedShape:updateDrawZero()
    super.updateDrawZero(self)
    self:setScale(self.scalefactor, self.scalefactor)
end

return RedShape
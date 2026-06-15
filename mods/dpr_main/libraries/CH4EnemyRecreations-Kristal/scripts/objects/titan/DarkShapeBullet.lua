---@class DarkShapeBullet : Object
---@overload fun(...) : DarkShapeBullet
local DarkShapeBullet, super = Class(Bullet)

---@param x                number
---@param y                number
---@param texture?         string|love.Image
---@param shrink_texture?  string|love.Image
function DarkShapeBullet:init(x, y, texture, shrink_texture)
    super.init(self, x, y, texture, shrink_texture)
    self.sprite:stop()                      -- equivalent to `image_speed = 0` from OG Deltarune code.

    self.collidable = false
    self.alpha = 0
    self.tp = 0
    self.grazed = true

    self.can_do_shrivel = true              -- Checks if `doShrivel()` can run. defaults to 'true'
    self.can_do_pushback = true             -- Checks if `doPushBack()` can run. defaults to 'true'
    self.can_destroy = true                 -- Checks if `destroy()` can run. defaults to 'true'
    self.can_chase_heart = true             -- Checks if `chaseHeart()` can run. defaults to 'true'

    -- Initial direction of the bullet.
    if self.y >= Game.battle.arena.y then
        self.physics.direction = 250 - MathUtils.randomInt(10)
    else
        self.physics.direction = 110 + MathUtils.randomInt(10)
    end

    -- Speed modifying variables
    self.myspeed = 0                        -- Apparently `obj_darkshape` uses this instead of `speed`.
    self.speed_max = 2.25
    self.speed_max_multiplier = 1
    self.tracking_val = 16
    self.speedfactor = 1
    self.true_timer = 0
    self.fastval = 4
    self.accel = 0.15

    self.canbepushed = true
    self.pushback_radius = 48

    -- Scaling variables
    self.xscale = 0                         -- Default scaling value for x.
    self.yscale = 0                         -- Default scaling value for y.
    self.xface = 1                          -- Facing scaling value for x. Set to "-1" to make it face the opposite direction on its x axis.
    self.yface = 1                          -- Facing scaling value for y. Set to "-1" to make it face the opposite direction on its y axis.
    self.scalefactor = 1                    -- The target scale value.

    self._texture = texture                 -- Callback for the bullet's default texture.
    self._shrink_texture = shrink_texture   -- Callback for the bullet's shrinking texture.
    self.image = 1                          -- Current frame of the bullet's shrinking animation.
    self.radius = 20                        -- Radius to be used for the bullet's CircleCollider.
    self.individuality = MathUtils.randomInt(100)

    self.light = 0                          -- Handles how much the bullet has been exposed to light.
    self.light_rate = 0.05                  -- Rate of how much `self.light` should increase.
    self.light_recover = 0.01               -- Rate of how much `self.light` should decrease.

    -- Glow effect that appears when the bullet is being exposed to light.
    -- FX's amount is determined by `self.light`.
    self.highlight = self:addFX(ColorMaskFX())
    self.highlight:setColor(1, 1, 1)
    self.highlight.amount = 0

    -- Suble wave effect used when the bullet is spawning.
    self.wave = self:addFX(ShaderFX("darkshape_wave", {
        ["wave_timer"] = function() return self.timer end,
        ["wave_mag"] = function() return 4 - (self.alpha * 4) end,
        ["texsize"] = {SCREEN_WIDTH, SCREEN_HEIGHT}
    }), "wave")

    self.shakeme = false
    self.timer = 0
    self.fast_timer = 0
    self.ypush = 0                          -- Unused variable(?)
end

function DarkShapeBullet:onAdd(parent)
    super.onAdd(self, parent)

    Assets.playSound("dark_odd", 0.25, 0.35 + MathUtils.random(0.35))
end

function DarkShapeBullet:getDebugInfo()
    local info = super.getDebugInfo(self)
    table.insert(info, "Speed: " .. self.physics.speed)
    table.insert(info, "MySpeed: " .. self.myspeed)
    table.insert(info, "Scale X: " .. self.scale_x)
    table.insert(info, "Scale Y: " .. self.scale_y)
    table.insert(info, "Light Exposure: " .. self.light)
    return info
end

--- *(Override)* Handles the shrinking effect of the light when exposed to the soul's light.
function DarkShapeBullet:doShrivel()
    if self.light > 0.99 then
        self.image = 6
    elseif self.light > 0.8 then
        self.image = 5
        self.radius = 8
    elseif self.light > 0.6 then
        self.image = 4
        self.radius = 10
    elseif self.light > 0.4 then
        self.image = 3
        self.radius = 13
    elseif self.light > 0.2 then
        self.image = 2
        self.radius = 16
    else
        self.image = 1
        self.radius = 20
    end
end

--- *(Override)* Pushes the bullet back a bit if comes into close range with any other DarkShapeBullet(?)
function DarkShapeBullet:doPushBack()
    for _, bullet in ipairs(Game.stage:getObjects(DarkShapeBullet)) do
        if (bullet.id ~= self and MathUtils.dist(bullet.x, bullet.y, self.x, self.y) < self.pushback_radius) then
            local tempangle = Utils.angle(self.x, self.y, bullet.x, bullet.y)
            bullet.x = bullet.x + MathUtils.lengthDirX(1, tempangle) * DTMULT
            bullet.y = bullet.y + MathUtils.lengthDirY(1, -tempangle) * DTMULT
        end
    end
end

--- *(Override)* Primarily handles the movement of the bullet.
function DarkShapeBullet:chaseHeart()
    local hx, hy = Game.battle.soul.x, Game.battle.soul.y

    if (MathUtils.dist(self.x, self.y, hx, hy) < Game.battle.soul.light_radius) and self.color ~= COLORS.red then
        self.myspeed = MathUtils.approach(self.myspeed, 0.7 + (1 - self.light), (0.15 * self.speedfactor * self.speed_max_multiplier) * DTMULT)
        self.light = MathUtils.approach(self.light, 1, self.light_rate * DTMULT)

        if Game.battle.soul.ominous_loop then
            Game.battle.soul.ominous_decline = false
            Game.battle.soul.ominous_volume = MathUtils.approach(Game.battle.soul.ominous_volume, 1, ((1 - Game.battle.soul.ominous_volume) * 0.15) * DTMULT)
        end

        -- Spawn particles while bullet is shrinking.
        if MathUtils.randomInt(2) == 0 then
            local particle = Game.battle:addChild(TitanSpawnParticleGeneric(self.x + MathUtils.random(-12, 12), self.y + MathUtils.random(-12, 12)))
            particle:setColor(COLORS.white)
            particle.physics.direction = MathUtils.angle(hx, hy, particle.x, particle.y)
            particle.physics.speed = 1 + MathUtils.random(3)
            particle.shrink_rate = 0.2
            particle.layer = self.layer
        end
    else
        self.myspeed = MathUtils.approach(self.myspeed, self.speed_max * self.speed_max_multiplier, (self.accel * self.speed_max_multiplier * (1 - self.light)) * DTMULT)
        self.light = MathUtils.approach(self.light, 0, self.light_recover * DTMULT)
    end
end

--- *(Override)* Destroys the bullet and creates a TP Blob.
function DarkShapeBullet:destroy()
    local tp_blob = self.wave:spawnBullet("titan/greenblob", self.x, self.y)
    tp_blob:setLayer(self.layer - 1)

    tp_blob.size = 1

    for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
        if enemy.id == "titan_spawn" then
            tp_blob.size = 2
        end
    end
    
    tp_blob:prime()

    self:remove()
end

function DarkShapeBullet:update()
    self:updateStepOne()
    self:updateStepZero()
    self:updateDrawZero()
    super.update(self)
end

function DarkShapeBullet:updateStepZero()
    if self.fast_timer >= 1 then
        self.timer = self.timer + self.fastval * DTMULT
        self.fast_timer = self.fast_timer - DTMULT
    else
        self.timer = self.timer + DTMULT
    end

    self.true_timer = self.true_timer + DTMULT

    if not MathUtils.randomInt(20) then
        self.fast_timer = 10 + MathUtils.randomInt(6)
    end

    if self.alpha ~= 1 then
        self.alpha = MathUtils.approach(self.alpha, 1, 0.025 * DTMULT)
    
        if self.alpha == 1 then
            self.physics.direction = MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
        end
    end

    --No idea what this is supposed to do, but it seemingly does nothing since `self.ypush` is set to 0 by default.
    self.y = self.y + self.ypush * DTMULT
    self.ypush = self.ypush * (0.9 ^ DTMULT)

    -- Handles the scaling of the bullet when it first spawns in.
    if self.alpha == 1 then
        self.xscale = self.alpha
        self.yscale = self.alpha
    else
        self.xscale = self.alpha + ((self.timer % 2) * 0.1) * DTMULT
        self.yscale = self.alpha + ((self.timer % 2) * 0.1) * DTMULT
    end

    if self.alpha == 1 then
        self.collidable = true
    else
        return
    end

    self.tracking_val = MathUtils.approach(self.tracking_val, 16, 0.025 * DTMULT)
    if self.can_chase_heart and Game.battle.soul then
        self:chaseHeart()
    end
    if self.can_do_shrivel then
        self:doShrivel()
    end

    -- Remove the bullet if it reaches these x/y coordinates.
    if self.x < -80 then
        self:remove()
    end
    if self.x > 760 then
        self:remove()
    end
    if self.y < -80 then
        self:remove()
    end
    if self.y > 580 then
        self:remove()
    end

    if self.can_do_pushback and self.canbepushed then
        self:doPushBack()
    end
    if self.can_destroy and self.light == 1 then
        self:destroy()
    end
end

function DarkShapeBullet:updateStepOne()
    local eff_speed = self.myspeed * (1 + (math.sin(self.true_timer * 0.15) * 0.6))
    local hx, hy = Game.battle.soul.x, Game.battle.soul.y
    self.x = self.x + MathUtils.lengthDirX(eff_speed * 1, self.physics.direction) * DTMULT
    self.y = self.y + MathUtils.lengthDirY(eff_speed * 1, -self.physics.direction) * DTMULT

    if self.updateimageangle then
        self.rotation = self.physics.direction
    end

    local turning_mult = 0.5 - (math.sin(self.true_timer * 0.15) * 0.5)
    local anglediff = MathUtils.angleDiff(self.physics.direction, MathUtils.angle(self.x, self.y, hx, hy))
    self.physics.direction = self.physics.direction - MathUtils.clamp(MathUtils.sign(anglediff) * self.tracking_val * turning_mult, -math.abs(anglediff), math.abs(anglediff))
end

--- *(Override)* Handles most of the bullet's animation/scaling code.
function DarkShapeBullet:updateDrawZero()
    self:setScale(self.xscale * self.xface * self.scalefactor, self.yscale * self.yface * self.scalefactor)

    local xoff = 0
    local yoff = 0
    if self.shakeme then
        xoff = TableUtils.pick{-1, 0, 1}
        yoff = TableUtils.pick{-1, 0, 1}
    end

    -- If the bullet is shrinking, then set its sprite to its shrinking texture if it exists.
    -- If not, then set its sprite back to its default texture.
    if self._shrink_texture and self.image ~= 1 then
        self:setSprite(self._shrink_texture)
        self.sprite:setFrame(math.floor(self.image))
    else
        self:setSprite(self._texture)
        self.sprite:setFrame(math.floor(self.timer + self.individuality))
    end

    -- If `self.light` is greater than 0, then set the amount of the hightlight FX to `self.light`.
    if self.light > 0 then
        self.highlight.amount = self.light
    else
        self.highlight.amount = 0
    end
end

return DarkShapeBullet
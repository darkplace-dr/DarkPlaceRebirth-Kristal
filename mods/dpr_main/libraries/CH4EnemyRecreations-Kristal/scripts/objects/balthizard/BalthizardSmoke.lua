local BalthizardSmoke, super = Class(Sprite)

function BalthizardSmoke:init(x, y, scale, mode, frame)
    self.frame = frame or 1
    super.init(self, "battle/enemies/balthizard/smoke_"..self.frame, x, y)

    self:setOriginExact(11, 18)
    self.debug_select = false

    self.mode = mode or 0
    self.h_speed = 0

    self.scale_x = scale or 0.5
    self.scale_y = scale or 0.5
    self.physics.friction = 0.1
    self.physics.gravity_direction = -math.rad(90)
    self.physics.gravity = 0.15
    self.rotation = -math.rad(-50 + MathUtils.random(50))
    self:setColor({241/255, 110/255, 170/255})
end

local function remapValue(old_min, old_max, val, new_min, new_max)
    if old_max == old_min then
        return new_min
    end
    local t = (val - old_min) / (old_max - old_min)
    return MathUtils.lerp(new_min, new_max, t)
end

function BalthizardSmoke:update()
    super.update(self)

    self.rotation = self.rotation - math.rad(8) * DTMULT
    self.alpha = self.alpha - 0.02 * DTMULT

    if self.alpha <= 0.8 then
        local _ilerp = remapValue(0.8, 0, self.alpha, 0, 1)
        self.h_speed = MathUtils.lerpEaseIn(0, -8, _ilerp, 1)
    end

    if self.alpha < 0 then
        self:remove()
    end

    if self.mode == 1 then
        self.scale_x = self.scale_x + 0.025 * DTMULT
        self.scale_y = self.scale_y + 0.025 * DTMULT
        self.scale_x = MathUtils.clamp(self.scale_x, 0, 1)
        self.scale_y = MathUtils.clamp(self.scale_y, 0, 1)
    end
end

return BalthizardSmoke
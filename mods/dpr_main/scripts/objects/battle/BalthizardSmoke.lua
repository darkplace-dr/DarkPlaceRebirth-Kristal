local BalthizardSmoke, super = Class(Object)

function BalthizardSmoke:init(x, y, mode, frame)
    super.init(self, x, y)

    self.mode = mode or 0
    self.frame = frame or 1
    self.scale_x = 0.5
    self.scale_y = 0.5
    self.physics.friction = 0.2
    self.physics.gravity_direction = -math.rad(90)
    self.physics.gravity = 0.3
    self.rotation = -math.rad(-50 + MathUtils.random(50))
end

function BalthizardSmoke:update()
    super.update(self)
    self.rotation = self.rotation - math.rad(8) * DTMULT
    self.alpha = self.alpha - 0.02 * DTMULT
    if self.alpha <= 0.8 then
        --var _ilerp = scr_remapvalue(0.8, 0, image_alpha, 0, 1)
        --h_speed = lerp_ease_in(0, -8, _ilerp, 1)
    end
    if self.alpha < 0 then
        self:remove()
    end
    if self.mode == 1 then
        self.scale_x = self.scale_x + 0.05 * DTMULT
        self.scale_y = self.scale_y + 0.05 * DTMULT
        self.scale_x = MathUtils.clamp(self.scale_x, 0, 2)
        self.scale_y = MathUtils.clamp(self.scale_y, 0, 2)
    end
end

function BalthizardSmoke:draw()
    Draw.setColor(241/255, 110/255, 170/255, self.alpha)
    local smoke = Assets.getTexture("battle/enemies/balthizard/smoke_"..self.frame)
    Draw.draw(smoke, 0, 0, 0, 1, 1, 11, 18)

    super.draw(self)
end

return BalthizardSmoke
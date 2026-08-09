local PendulumCH4, super = Class(Bullet)

function PendulumCH4:init(x, y)
    super.init(self, x, y, "battle/bullets/wicabel/pendulum_ball")
	
    self:setScale(1)
    self.sprite:setOriginExact(16, 16)
    self.collider = CircleCollider(self, 0, 0, 16)

    self.timer = 0
    self.extend_spd = 0
    self.extend = 0
    self.angle = 300
    self.angle_spd = 0
    self.centre_x = self.x
    self.centre_y = self.y
    self.destroy_on_hit = false
    self.timer = 0
    self.cut = false
end

function PendulumCH4:update()
    super.update(self)

    if not self.cut then
        self.timer = self.timer + (1 * DTMULT)
    
        if self.angle < 270 then
            self.angle_spd = self.angle_spd + (0.1 * DTMULT)
        elseif self.angle > 270 then
            self.angle_spd = self.angle_spd - (0.1 * DTMULT)
        end
    
        self.angle = self.angle + (self.angle_spd * DTMULT)
    
        if self.timer < 25 then
            self.extend_spd = MathUtils.approachCurve(self.extend_spd, 20, 14)
        elseif self.timer < 32 then
            self.extend_spd = MathUtils.approachCurve(self.extend_spd, -5, 3)
        elseif self.timer < 36 then
            self.extend_spd = MathUtils.approachCurve(self.extend_spd, 3, 3)
        elseif self.timer < 40 then
            self.extend_spd = MathUtils.approachCurve(self.extend_spd, 0, 3)
        end
    
        if self.timer < 45 then
            self.extend = self.extend + (self.extend_spd * DTMULT)
        end
    
        self.x = self.centre_x + MathUtils.lengthDirX(self.extend, math.rad(self.angle)) * DTMULT
        self.y = self.centre_y + MathUtils.lengthDirY(self.extend, math.rad(self.angle)) * DTMULT
    
        if ((self.timer % 4) == 0) then
            self.grazed = false
        end
    
        if self.timer >= 45 then
            self.extend = MathUtils.approach(self.extend, MathUtils.dist(self.centre_x, self.centre_y, Game.battle.soul.x, Game.battle.soul.y), 1)
        end
    end
end

function PendulumCH4:draw()
    if not self.cut then
        self.rotation = MathUtils.angle(self.x, self.y, Game.battle.arena.x, Game.battle.arena.y - 200)

        Draw.setColor(ColorUtils.hexToRGB"#808080")
        love.graphics.setLineWidth(4)
        love.graphics.line(0, 0, Game.battle.arena.x, Game.battle.arena.y - 200)
        Draw.setColor(COLORS.white)
    end

    super.draw(self)
end

return PendulumCH4
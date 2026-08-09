local Smoke, super = Class(Bullet)

function Smoke:init(x, y)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/balthizard/smoke_bullet")
    self.spin = 0
    self.spinspeed = 0
    self.wall_destroy = 1
    self.bottomfade = 1
    self.siner = 0
    self.rotation = MathUtils.random(360)
    self.physics.gravity = -0.01
    self.layer = 600
    self:setHitbox(7, 7, 5, 5)
end

function Smoke:update()
    super.update(self)
    if(self.spin == 1) then
        self.rotation = self.rotation + math.rad(self.spinspeed)
        --self.siner = self.siner + 1
        --self.scale_x = 1 + (math.sin(self.siner / 4) * 10)
        --self.scale_y = self.scale_x
    end
    if(self.bottomfade == 1) then
        if(self.y >= 350) then
            self.alpha = self.alpha * 0.8
        end
    end
    if(self.alpha <= 0) then
        self.remove()
    end
end

function Smoke:draw()
    super.draw(self)
    self.siner = self.siner + 1
    self.scale_x = 1.7 + (math.sin(self.siner / 10) / 10)
    self.scale_y = self.scale_x
end

return Smoke
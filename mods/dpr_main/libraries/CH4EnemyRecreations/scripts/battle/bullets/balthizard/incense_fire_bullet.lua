local Ghostfire_Turtle, super = Class(Bullet)

function Ghostfire_Turtle:init(x, y)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/balthizard/ghostfire_turtle")
    self.spin = 0
    self.spinspeed = 0
    self.wall_destroy = 1
    self.bottomfade = 1
    self.siner = 0
    self.rotation = MathUtils.random(360)
    self.physics.gravity = -0.01
    self.layer = 600
    self:setHitbox(12, 17, 7, 7)
    self.sprite:play(2/30, true)

    self.infect_collider = Hitbox(self, 12, 17, 7, 7)
    self.infecting = false
end

function Ghostfire_Turtle:infect(other)
    if not other.parent or not self.parent then return end
    if(other.fireeeeeee <= 0) then
        other.fireeeeeee = 1
    end

    self:remove()
end

function Ghostfire_Turtle:update()
    super.update(self)
    if(self.bottomfade == 1) then
        if(self.y >= 350) then
            self.alpha = self.alpha * 0.8
        end
    end
    if(self.alpha <= 0) then
        self.remove()
    end
end

function Ghostfire_Turtle:draw()
    super.draw(self)
    if DEBUG_RENDER then
        self.infect_collider:draw(1, 0, 1, 0.5)
    end
end

return Ghostfire_Turtle
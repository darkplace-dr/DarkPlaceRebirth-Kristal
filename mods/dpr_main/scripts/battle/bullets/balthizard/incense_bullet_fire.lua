local Incense_Bullet_Fire, super = Class(Bullet)

function Incense_Bullet_Fire:init(x, y)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/balthizard/rouxls_fire")
    self.bottomfade = 0;
    self.timer = 0;
    self.chainreaction = false;
    self.chainreactiontimer = 0;
    self:setHitbox(27, 5, 20, 8)
    self.sprite:play(2/30, true)

    self.infect_collider = Hitbox(self, 27, 5, 20, 8)
    self.infecting = false
end

function Incense_Bullet_Fire:infect(other)
    if not other.parent or not self.parent then return end
    if(other.fireeeeeee <= 0 and self.chainreactiontimer > 3) then
        other.fireeeeeee = 1
    end
    self:remove()
end

function Incense_Bullet_Fire:update()
    super.update(self)
    self.chainreactiontimer = self.chainreactiontimer + 1
    self.timer = self.timer + 1
    if(self.timer >= 58) then
        self.alpha = self.alpha - 0.25
    end
    if(self.timer == 62) then
        self:remove()
    end
end

function Incense_Bullet_Fire:draw()
    super.draw(self)
    if DEBUG_RENDER then
        self.infect_collider:draw(1, 0, 1, 0.5)
    end
end

return Incense_Bullet_Fire
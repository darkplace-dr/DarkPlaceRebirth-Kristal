local Rouxls_Fire, super = Class(Bullet)

function Rouxls_Fire:init(x, y)
    super.init(self, x, y, "battle/bullets/bibliox/rouxls_fire")
    self.scale_x = 0
    self.scale_y = 1
    self.spin = 0
    self.spinspeed = 0
    self.insidebox = 0
    self.sprite:play(0.1, true)

    self.collidable = false

    self:setHitbox(27, 5, 18, 8)
end

function Rouxls_Fire:update()
    super.update(self)
    if (self.x >= (Game.battle.arena.x - 75) and self.x <= (Game.battle.arena.x + 75) and self.y >= (Game.battle.arena.y - 75) and self.y <= (Game.battle.arena.y + 75)) then
        self.insidebox = self.insidebox + 1
    elseif(self.insidebox > 14) then
        self.alpha = self.alpha - 0.1
        if(self.alpha <= 0) then
            self:remove()
        end
    end
    if(self.scale_x >= 0.7 and not self.collidable) then
        self.collidable = true
    end
end

return Rouxls_Fire

local Book_Fire, super = Class(Bullet)

function Book_Fire:init(x, y)
    super.init(self, x, y, "battle/bullets/bibliox/book_fire")
    self.destroy_on_hit = false
    self.scale_x = 1
    self.scale_y = 1
    self.spin = 0
    self.spinspeed = 0
    self.insidebox = 0
    self.sprite:play(0.03, true)

    self:setHitbox(26, 32, 12, 12)
end

function Book_Fire:update()
    super.update(self)
    if (self.y <= (Game.battle.arena.y - 75)) then
        self.alpha = self.alpha - 0.1
        if(self.alpha <= 0) then
            self:remove()
        end
    end
end

return Book_Fire

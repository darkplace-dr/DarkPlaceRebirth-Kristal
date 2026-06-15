local Book_Wind, super = Class(Bullet)

function Book_Wind:init(x, y)
    super.init(self, x, y, "battle/bullets/bibliox/book_wind")
    self.scale_x = 1
    self.scale_y = 1
    self.spin = 0
    self.spinspeed = 0
    self.insidebox = 0
    self.sprite:play(0.03, true)

    self:setHitbox(24, 26, 10, 10)
end

function Book_Wind:update()
    super.update(self)
    if (self.x >= (Game.battle.arena.x - 75) and self.x <= (Game.battle.arena.x + 75) and self.y >= (Game.battle.arena.y - 75) and self.y <= (Game.battle.arena.y + 75)) then
        self.insidebox = self.insidebox + 1
    elseif(self.insidebox > 14) then
        self.alpha = self.alpha - 0.1
        if(self.alpha <= 0) then
            self:remove()
        end
    end
end

return Book_Wind

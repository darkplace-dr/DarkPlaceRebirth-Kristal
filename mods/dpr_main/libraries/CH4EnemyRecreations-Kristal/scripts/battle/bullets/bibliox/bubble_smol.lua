local Book_Bubble_Smol, super = Class(Bullet)

function Book_Bubble_Smol:init(x, y)
    super.init(self, x, y, "battle/bullets/bibliox/book_bubble_smol")
    self.scale_x = 1
    self.scale_y = 1
    self.spin = 0
    self.spinspeed = 0
    self.insidebox = 0
    self.sprite:play(0.05, true)
    self.anim_timer = 0
    self.image_speed = 0.06
    self.save_frame = 0

    self:setHitbox(14, 14, 8, 8)

end

function Book_Bubble_Smol:update()
    super.update(self)

    if(self.anim_timer == 15 and self.image_speed <= 0.1) then
        self.save_frame = self.sprite.frame
        self.sprite:play(self.image_speed, true)
        self.sprite:setFrame(self.save_frame)
        self.image_speed = self.image_speed + 0.01
        self.anim_timer = 0
    end

    if (self.x >= (Game.battle.arena.x - 75) and self.x <= (Game.battle.arena.x + 75) and self.y >= (Game.battle.arena.y - 75) and self.y <= (Game.battle.arena.y + 75)) then
        self.insidebox = self.insidebox + 1
    elseif(self.insidebox > 14) then
        self.alpha = self.alpha - 0.1
        if(self.alpha <= 0) then
            self:remove()
        end
    end

    self.anim_timer = self.anim_timer + 1 * DTMULT

end

return Book_Bubble_Smol

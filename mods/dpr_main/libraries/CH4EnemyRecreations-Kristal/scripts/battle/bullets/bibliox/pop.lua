local Book_Bubble_Pop, super = Class(Bullet)

function Book_Bubble_Pop:init(x, y)
    super.init(self, x, y, "battle/bullets/bibliox/book_pop")
    self.scale_x = 1
    self.scale_y = 1
    self.collidable = false
    self.anim_timer = 0

end

function Book_Bubble_Pop:update()
    super.update(self)

    if(self.anim_timer == 5) then
        self:remove()
    end

    self.anim_timer = self.anim_timer + 1 * DTMULT

end

return Book_Bubble_Pop

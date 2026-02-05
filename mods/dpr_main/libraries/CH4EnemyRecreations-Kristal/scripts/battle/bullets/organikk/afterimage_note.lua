local Note, super = Class(Bullet)

function Note:init(x, y, index)
    -- Last argument = sprite path
    self.image_index = index
    super.init(self, x, y, "battle/bullets/organikk/musical_notes_"..self.image_index)
    self.sprite:stop()

    self:setScale(1)
    self.layer = 810
    self.collidable = false
end

function Note:update()
    self.scale_x = self.scale_x + 0.2 * DTMULT
    self.scale_y = self.scale_y + 0.2 * DTMULT
    self.alpha = self.alpha - 0.1 * DTMULT

    if(self.alpha <= 0) then
        self:remove()
    end
end

return Note
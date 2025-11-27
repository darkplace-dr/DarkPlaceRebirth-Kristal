local AfterImage_note, super = Class(Sprite) --Sprite

function AfterImage_note:init(x, y, index)
    self:setHitbox(12, 12, 0, 0)
    self.image_index = index
    super.init(self, "bullets/organikk/musical_notes_"..self.image_index, x -12, y - 12)
    self.layer = 810

end

function AfterImage_note:update()
    self.scale_x = self.scale_x + 0.1
    self.scale_y = self.scale_y + 0.1
    self.alpha = self.alpha - 0.1

    if(self.alpha <= 0) then
        self:remove()
    end
    
end



return AfterImage_note
local Cloud, super = Class(Bullet)

function Cloud:init(x, y)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/balthizard/turtle_string")
    self.destroy_on_hit = false
    self.scale_x = 1
    self.scale_y = 1
    self.remove_offscreen = false
    self.layer = -200
end

function Cloud:update()
    super.update(self)
    self.sprite:setFrame(self.wave.image_index)

    if(self.wave.remove_string == true) then
        self:remove()
    end
end

return Cloud
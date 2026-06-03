local Cloud_Mask, super = Class(Bullet)

function Cloud_Mask:init(x, y)
    super.init(self, x, y, "battle/bullets/balthizard/cloud_mask")
    self.destroy_on_hit = false
    self.collidable = false
    self.alpha = 1
end

return Cloud_Mask
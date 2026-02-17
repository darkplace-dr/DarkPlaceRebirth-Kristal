local Heart, super = Class(Bullet)

function Heart:init(x, y)
    super.init(self, x, y, "battle/bullets/hathy/heart")
    self:setScale(1)

    self.alpha = 0
    self.tp = 0.8
    self.time_bonus = 1
    self.remove_offscreen = false
end

return Heart
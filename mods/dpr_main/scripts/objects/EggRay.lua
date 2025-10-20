local Ray, super = Class("EggPart")

function Ray:init(x, y)
    super.init(self, "battle/enemies/egg/ray", x, y, 0.5, 0.5)
    self.sprite:setOrigin(0.5, 0.5)
    self.graphics.spin = 0.05
end

return Ray
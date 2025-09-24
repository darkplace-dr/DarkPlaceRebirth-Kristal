local arrowfinal, super = Class(Bullet)

function arrowfinal:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/annabelle/arrow_chase")
    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    self.rotation = dir
    self.destroy_on_hit = false
    self.remove_offscreen = false
end

return arrowfinal
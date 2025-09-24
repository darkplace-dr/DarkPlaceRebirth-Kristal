local arrowchase, super = Class(Bullet)

function arrowchase:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/annabelle/arrow_chase")
    self.color = {0.9, 0.5, 0.9}
    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    self.rotation = dir
    self.destroy_on_hit = false
end

function arrowchase:update()
    self.physics.direction = Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
    self.rotation = self.physics.direction
    super.update(self)
end

return arrowchase
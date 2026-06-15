local Cloud_Fire, super = Class(Bullet)

function Cloud_Fire:init(x, y)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/balthizard/cloud_fire1")
    self.collidable = false
    self.scale_x = 1
    self.scale_y = 1
    self.sprite:play(2/30, true)
    self.len = 0
    self.dir = 0
end

function Cloud_Fire:update()
    super.update(self)
end

return Cloud_Fire
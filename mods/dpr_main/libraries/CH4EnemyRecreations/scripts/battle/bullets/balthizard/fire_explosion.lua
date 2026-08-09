local Fire_Explosion, super = Class(Bullet)

function Fire_Explosion:init(x, y)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/balthizard/fire_explosion1c")
    self.collidable = false
    self.scale_x = 1
    self.scale_y = 1
    self.sprite:play(2/30, false, function(sprite)
        sprite:remove()
    end)
end

function Fire_Explosion:update()
    super.update(self)
    
end

return Fire_Explosion
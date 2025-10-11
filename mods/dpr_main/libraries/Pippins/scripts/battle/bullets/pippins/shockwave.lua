local Shockwave, super = Class(Bullet)

function Shockwave:init(x, y)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/pippins/shockwave")

    self.destroy_on_hit = false
    self.timer = 0
    self.count = 10
    self:setHitbox(8, 7, 17, 17)
    self.sprite:play(0.05, true)
    self.collidable = false
    self.physics.direction = self.physics.direction
    self.scale_x = 1
    self.scale_y = 1
end

function Shockwave:update()
    local dist = 20 * self.scale_x
    self.timer = self.timer + 1

    

    if(self.timer == 3 and self.count > 0) then
        self.count = self.count - 1
        local dir = self.physics.direction
        local dox = self.x + math.cos(dir) * dist
        local doy = self.y + math.sin(dir) * dist
        local shockwave = self.wave:spawnBullet("pippins/shockwave", dox,doy)
        shockwave.physics.direction = self.physics.direction
        shockwave.scale_x = self.scale_x
        shockwave.scale_y = self.scale_y
        shockwave.count = self.count
    end

    if(self.timer == 3) then
        self.collidable = true
    end

    if(self.timer == 8) then
        self:remove()
    end

    super.update(self)
end

return Shockwave
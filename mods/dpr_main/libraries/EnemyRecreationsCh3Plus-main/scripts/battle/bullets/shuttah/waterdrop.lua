local WaterDrop, super = Class(Bullet)

function WaterDrop:init(x, y, dir, speed)
    super.init(self, x, y, "bullets/shuttah/droplet")

    self:setScale(1, 1)
    self.rotation = dir
    self.physics.speed = speed
	self.physics.match_rotation = true
end

function WaterDrop:update()
    super.update(self)
end

return WaterDrop
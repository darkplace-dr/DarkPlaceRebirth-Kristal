local DiamondWhite, super = Class(Bullet)

function DiamondWhite:init(x, y, dir)
    super.init(self, x, y, "bullets/shuttah/diamond_white")

	self:setScale(1, 1)
    self.rotation = dir
    self.physics.speed = 6
	self.physics.match_rotation = true
    self.dropped = false
    self.dropped_time = 0
    self.spin = 0
end

function DiamondWhite:update()
    super.update(self)
    if self.dropped_time >= 1 then
        self.collider.collidable = false
    end
    if self.dropped then
        self.rotation = self.rotation + self.spin
        self.dropped_time = self.dropped_time + DTMULT
    end
end

function DiamondWhite:drop()
    self.physics.match_rotation = false
    self.physics.speed = 4
    self.physics.direction = math.rad(Utils.pick({-10, 10}) - 90)
    self.physics.gravity = 0.5
    self.physics.gravity_direction = math.rad(90)
    self.dropped = true
    self.spin = math.rad(Utils.pick({-2, 2}))
    self:fadeOutAndRemove(27/30)
end

return DiamondWhite
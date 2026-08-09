local Diamond, super = Class(Bullet)

function Diamond:init(x, y, dir, speed, rot)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/guei/diamond")
    self.rotation = rot
    self.physics.direction = dir
    self.physics.speed = speed
    self.physics.friction = -1
    self:setScale(1)
    self:setOrigin(0.5, 0.5)
    self.collider = PolygonCollider(self, {{8, 15}, {16, 12}, {24, 15}, {16, 18}})
    self.g = 0
end

function Diamond:update()
    -- For more complicated bullet behaviours, code here gets called every update
    super.update(self)
end

return Diamond
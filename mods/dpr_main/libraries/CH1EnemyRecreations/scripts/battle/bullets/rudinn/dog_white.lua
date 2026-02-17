local DogWhite, super = Class(Bullet)

function DogWhite:init(x, y, dir)
    super.init(self, x, y, "battle/bullets/dog")

	self:setScale(1, 1)
    self.rotation = dir
    self.physics.speed = 6
	self.physics.match_rotation = true
    --self.collider = PolygonCollider(self, {{11, 16}, {16, 14}, {21, 16}, {16, 18}, {11, 16}})
end

return DogWhite
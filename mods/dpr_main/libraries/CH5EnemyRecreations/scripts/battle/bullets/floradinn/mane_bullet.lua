local ManeBullet, super = Class(Bullet)

function ManeBullet:init(x, y)
    super.init(self, x, y, "battle/bullets/floradinn/triangle")

	self:setScale(1, 1)
    self.collider = PolygonCollider(self, {{14, 9}, {12.614850625011, 10.327048764858}, {9.157089333146, 10.985675432544}, {5.368358267056, 10.64413588775}, {3.1570059606306, 9.4744604166598}, {3.6368699648248, 8.0658036548087}, {6.5662472521878, 7.1276928870154}, {10.469637779557, 7.132645765527}, {13.380940110813, 8.0781675715891}})
end

function ManeBullet:getTarget()
	return "ANY"
end

function ManeBullet:update()
    super.update(self)
	if self.x < -80 then
		self:remove()
	end
	if self.x > 760 then
		self:remove()
	end
	if self.y < -80 then
		self:remove()
	end
	if self.y > 560 then
		self:remove()
	end
end

return ManeBullet
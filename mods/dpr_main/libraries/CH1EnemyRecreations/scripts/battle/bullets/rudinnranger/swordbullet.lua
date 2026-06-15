local SwordBullet, super = Class(Bullet)

function SwordBullet:init(x, y)
    super.init(self, x, y, "battle/bullets/diamondswordbullet")
    self:setScale(2)
    self:setOriginExact(12, 14)
    self.collider = PolygonCollider(self, {{11, 16}, {16, 14}, {21, 16}, {16, 18}, {11, 16}})

    self.siner = 0
    self.throwernumber = 0
end

return SwordBullet
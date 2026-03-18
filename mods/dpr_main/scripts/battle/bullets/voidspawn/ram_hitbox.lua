local RamHitbox, super = Class(Bullet)

function RamHitbox:init(x, y, voidspawn)
    super.init(self, x, y, nil)

    self.voidspawn = voidspawn
    self.destroy_on_hit = false
    self.collider = CircleCollider(self, self.voidspawn.width/2, self.voidspawn.height/2, self.voidspawn.width/2 - 8)
end

function RamHitbox:update()
    super.update(self)

    self.x = self.voidspawn.x - self.voidspawn.sprite.width
    self.y = self.voidspawn.y - self.voidspawn.sprite.height
end

return RamHitbox
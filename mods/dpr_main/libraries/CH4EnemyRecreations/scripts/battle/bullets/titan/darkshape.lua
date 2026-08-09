---@class DarkShape : DarkShapeBullet
---@overload fun(...) : DarkShape
local DarkShape, super = Class(DarkShapeBullet)

function DarkShape:init(x, y)
    super.init(self, x, y, "battle/bullets/titan/default/idle", "battle/bullets/titan/default/shrink")
end

function DarkShape:update()
    super.update(self)

    self.collider = CircleCollider(self, 15, 17, self.radius/2)
end

return DarkShape
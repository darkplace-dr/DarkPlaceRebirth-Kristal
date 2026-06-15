---@class SmashLightning : Bullet
---@overload fun(...) : SmashLightning
local SmashLightning, super = Class(Bullet, "tenna/smash_lightning")

function SmashLightning:init(x, y)
    super.init(self, x, y, "battle/bullets/tenna/smash_lightning")

    self.collider = PolygonCollider(self, {
        {3, 7},
        {3, 11},
        {6, 11},
        {6, 12},
        {8, 12},
        {8, 8},
        {5, 8},
        {4, 7},
    })
    self:setScale(2)
    self.tp = 0.68
	
    self:setSpeed(0)
    self.remove_offscreen = false
end

function SmashLightning:getTarget()
    return "ALL"
end

return SmashLightning
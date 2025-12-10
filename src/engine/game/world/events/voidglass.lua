--- Void glass are Overworld objects that represents an old and broken version of the magical glass. \
--- `VoidGlass` is an extension of  [`MagicGlass`](lua://MagicGlass.init) - naming an object `voidglass` on an `objects` layer in a map creates this object.
---@class VoidGlass : Event
---
---@field texture           love.Image
---@field tiles_x           integer
---@field tiles_y           integer
---
---@field glass_colliders   Collider[]
---@field tile_alphas       number[]
---
---@field collider          ColliderGroup
---
---@overload fun(...) : VoidGlass
local VoidGlass, super = Class(MagicGlass)

function VoidGlass:init(x, y, rect, isBroken)
    super.init(self, x, y, rect)

    self.texture = Assets.getTexture(isBroken and "world/events/void_glass_broken" or "world/events/void_glass")

    for i,_ in ipairs(self.glass_colliders) do
        self.tile_alphas[i] = MathUtils.random(0.9, 1)
    end
end

function VoidGlass:update()
    Object.startCache()
    for i,collider in ipairs(self.glass_colliders) do
        local any_collided = false
        for _,char in ipairs(Game.stage:getObjects(Character)) do
            if collider:collidesWith(char) then
                any_collided = true
                break
            end
        end
        if any_collided then
            self.tile_alphas[i] = MathUtils.random(0.9, 1.1)
        else
            self.tile_alphas[i] = MathUtils.lerp(self.tile_alphas[i], MathUtils.random(), 0.125 * DTMULT)
        end
    end
    Object.endCache()

    super.super.update(self)
end

function VoidGlass:draw()
    local r,g,b,a = self:getDrawColor()

    local id = 1
    for i = 1, self.tiles_x do
        for j = 1, self.tiles_y do
            Draw.setColor(r, g, b, a * self.tile_alphas[id])
            Draw.draw(self.texture, (i - 1) * 40, (j - 1) * 40, 0, 2, 2)
            id = id + 1
        end
    end

    super.super.draw(self)
end

return VoidGlass
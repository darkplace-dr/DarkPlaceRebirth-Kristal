---@class TileLayer : TileLayer
---@field wrap_x boolean
---@field wrap_y boolean
local TileLayer, super = Utils.hookScript(TileLayer)

function TileLayer:draw()
    if not (self.wrap_x or self.wrap_y) then
        return super.draw(self)
    end
    local canvas = Draw.pushCanvas(self:getSize())
    super.draw(self)
    Draw.popCanvas()
    Draw.drawWrapped(canvas, self.wrap_x, self.wrap_y)
end

return TileLayer
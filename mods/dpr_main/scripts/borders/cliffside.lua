---@class Border.cliffside : ImageBorder
local MyBorder, super = Class(ImageBorder)

function MyBorder:init()
    super.init(self, "cliffside")
    self.shader = Assets.newShader("borders/cliffside")
end

function MyBorder:draw()
    love.graphics.setShader(self.shader)
    self.shader:send("iTime", Kristal.getTime())
    self.shader:send("iResolution", {love.graphics.getWidth(), love.graphics.getHeight()})
    super.draw(self)
    love.graphics.setShader()
end

return MyBorder
---@class SilverMagicEffect : Object
---@overload fun(...) : SilverMagicEffect
local SilverMagicEffect, super = Class(Object)

function SilverMagicEffect:init(x, y, rx, ry)
    super.init(self, x, y, rx * 2, (ry or rx) * 2)
    self:setOrigin(0.5, 0.5)

    self.texture = Assets.getTexture("backgrounds/IMAGE_DEPTH_EXTEND_MONO_SEAMLESS")

    self.counter = 0
    self:setColor(ColorUtils.hexToRGB("#36ffe8"))
    self.alpha = 0.3

    self:addFX(ShaderFX("wave", {
            ["wave_sine"] = function() return self.counter * 500 end,
            ["wave_mag"] = function() return 0.2 end,
            ["wave_height"] = 1,
            ["texsize"] = function() return { self.width, self.height } end,
        }))

    self.gradient_shader = Assets.getShader("radial_gradient")

    self.gradient_alpha = 0.6
end

function SilverMagicEffect:update()
    super.update(self)

    self.counter = self.counter + 1 * DT
end

function SilverMagicEffect:draw()
    super.draw(self)

    local r, g, b, a = self:getDrawColor()
    
    local old_shader = love.graphics.getShader()
    love.graphics.setShader(self.gradient_shader)
    self.gradient_shader:send("center", {self.x, self.y})
    self.gradient_shader:send("radius", math.min(self.width * self.scale_x, self.height * self.scale_y))
    self.gradient_shader:send("startColor", {r, g, b, self.gradient_alpha})
    self.gradient_shader:send("endColor", {r, g, b, 0})
    Draw.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", -self.width/2, -self.height/2, self.width * 2, self.height * 2)

    love.graphics.setShader(old_shader)
    Draw.setColor(r, g, b, a)

    local _a, _b = love.graphics.getBlendMode()
    love.graphics.setBlendMode("lighten", "premultiplied")
    love.graphics.ellipse("fill", self.width / 2, self.height / 2, self.width / 2, self.height / 2)
    love.graphics.setBlendMode("screen", "premultiplied")
    love.graphics.ellipse("fill", self.width / 2, self.height / 2, self.width / 2, self.height / 2)

    love.graphics.setStencilTest("greater", 0)
    love.graphics.stencil(function ()
        love.graphics.ellipse("fill", self.width / 2, self.height / 2, self.width / 2, self.height / 2)
    end)
    love.graphics.setBlendMode(_a, _b)
    Draw.drawWrapped(self.texture, true, true, -self.counter * 80, self.counter * 80, 0, 0.5, 0.5)

    Draw.setColor(1, 1, 1, a)
    love.graphics.setLineWidth(3)
    love.graphics.ellipse("line", self.width / 2, self.height / 2, self.width / 2, self.height / 2)
    Draw.setColor(r, g, b, a)

    love.graphics.setStencilTest()
    Draw.setColor(1, 1, 1, 1)
end

return SilverMagicEffect

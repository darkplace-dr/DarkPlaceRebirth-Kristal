local DarknerProtectionEffect, super = Class(Object)

function DarknerProtectionEffect:init(x, y, foreground)
    super.init(self, x, y, 121, 119)

    self.siner = 0
    self.position_factor = 0

    self.foreground = foreground
    
    self:setOrigin(0.5)
    self:setScale(0.5)
    
    self.debug_select = false
end

function DarknerProtectionEffect:updatePosition(parent)
    local sprite = parent and parent.sprite
    if sprite then
        if Game.state == "BATTLE" then
            self:setPosition(12.5, 25.5)
        else
            local ox, oy = 0, 0
            if sprite.getOffset then
                ox, oy = TableUtils.unpack(sprite:getOffset())
            end
            self:setPosition(sprite.width / 2 + ox, sprite.height / 2 + oy)
        end
    end
end

function DarknerProtectionEffect:onAdd(parent)
    self.layer = parent.sprite.layer + (self.foreground and 1 or -1)
    self:updatePosition(parent)
end

function DarknerProtectionEffect:update()
    self:updatePosition(self.parent)
end

function DarknerProtectionEffect:draw()
    super.draw(self)

    love.graphics.push()
    Draw.pushScissor()
    Draw.scissor(0, 0, 120, 136)

    self.position_factor = math.sin(self.siner / 24)

    self.siner = Kristal.getTime() * 30

    love.graphics.stencil(
        function()
            local last_shader = love.graphics.getShader()
            love.graphics.setShader(Kristal.Shaders["Mask"])
            Draw.draw(Assets.getTexture("effects/darknerprotection/mask"), 0, 0, 0, 2, 2)
            love.graphics.setShader(last_shader)
        end,
        "replace",
        1
    )
    love.graphics.setStencilTest("less", 1)

    if not self.foreground then
        Draw.setColor(1, 1, 1, 0.6 / 2)
        Draw.draw(Assets.getTexture("effects/darknerprotection/background"), 0, 0, 0, 2, 2)

        local rotation = (-20 + (self.siner / 2)) * -1 -- gamemaker is opposite to love2d, so negate

        Draw.setColor(1, 1, 1, 0.5 / 2)
        Draw.draw(Assets.getTexture("effects/darknerprotection/fountain_effect"), 60 + self.position_factor * 5, 60 + self.position_factor * 5, math.rad(rotation + 90), 2, 2, 60, 60)
        Draw.draw(Assets.getTexture("effects/darknerprotection/fountain_effect"), 60 - self.position_factor * 5, 60 - self.position_factor * 5, math.rad(-rotation), 2, 2, 60, 60)
    end

    if self.foreground then
        local r, g, b = ColorUtils.HSLToRGB(self.siner / 30 / 16 % 1, 1, 0.5)
        Draw.setColor(r, g, b, 0.2 / 2)
        Draw.draw(Assets.getTexture("effects/darknerprotection/gradient"), 0, 0, 0, 2, 2)
        --additive blending
        love.graphics.setBlendMode("add") -- bm_add
        Draw.setColor(r, g, b, 0.6 / 2)
        Draw.draw(Assets.getTexture("effects/darknerprotection/gradient"), 0, 0, 0, 2, 2)
        love.graphics.setBlendMode("alpha")
    end

    love.graphics.setStencilTest()

    Draw.popScissor()
    love.graphics.pop()
    Draw.setColor(1, 1, 1, 1)
end

return DarknerProtectionEffect

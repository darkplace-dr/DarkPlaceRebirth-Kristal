Utils.hook(ActorSprite, "init", function(orig, self, actor)
    orig(self, actor)
    self.run_afterimages = 80
    self.run_distance = 200
end)

-- i hope mg gets loaded first lmao
Utils.hook(ActorSprite, "draw", function(orig, self)
    if self.actor:preSpriteDraw(self) then
        return
    end
    
    if self.texture and self.run_away then
        local r, g, b, a = self:getDrawColor()
        for i = 0, self.run_afterimages do
            local alpha = a * 0.4
            Draw.setColor(r, g, b, ((alpha - (self.run_away_timer / 8)) + (i / self.run_distance)))
            Draw.draw(self.texture, i * 2, 0)
        end
        return
    end
    
    if self.texture and self.aura then
        -- Use additive blending if the enemy is not being drawn to a canvas
        if love.graphics.getCanvas() == SCREEN_CANVAS then
            love.graphics.setBlendMode("add")
        end

        local sprite_width = self.texture:getWidth()
        local sprite_height = self.texture:getHeight()

        for i = 1, 5 do
            local aura = (i * 9) + ((self.aura_siner * 3) % 9)
            local aurax = (aura * 0.75) + (math.sin(aura / 4) * 4)
            --var auray = (45 * scr_ease_in((aura / 45), 1))
            local auray = 45 * Ease.inSine(aura / 45, 0, 1, 1)
            local aurayscale = math.min(1, 80 / sprite_height)

            Draw.setColor(1, 0, 0, (1 - (auray / 45)) * 0.5)
            Draw.draw(self.texture, -((aurax / 180) * sprite_width), -((auray / 82) * sprite_height * aurayscale), 0, 1 + ((aurax/36) * 0.5), 1 + (((auray / 36) * aurayscale) * 0.5))
        end

        love.graphics.setBlendMode("alpha")

        local xmult = math.min((70 / sprite_width) * 4, 4)
        local ymult = math.min((80 / sprite_height) * 5, 5)
        local ysmult = math.min((80 / sprite_height) * 0.2, 0.2)

        Draw.setColor(1, 0, 0, 0.2)
        Draw.draw(self.texture, (sprite_width / 2) + (math.sin(self.aura_siner / 5) * xmult) / 2, (sprite_height / 2) + (math.cos(self.aura_siner / 5) * ymult) / 2, 0, 1, 1 + (math.sin(self.aura_siner / 5) * ysmult) / 2, sprite_width / 2, sprite_height / 2)
        Draw.draw(self.texture, (sprite_width / 2) - (math.sin(self.aura_siner / 5) * xmult) / 2, (sprite_height / 2) - (math.cos(self.aura_siner / 5) * ymult) / 2, 0, 1, 1 - (math.sin(self.aura_siner / 5) * ysmult) / 2, sprite_width / 2, sprite_height / 2)

        local last_shader = love.graphics.getShader()
        love.graphics.setShader(Kristal.Shaders["AddColor"])

        Kristal.Shaders["AddColor"]:send("inputcolor", {1, 0, 0})
        Kristal.Shaders["AddColor"]:send("amount", 1)

        Draw.setColor(1, 1, 1, 0.3)
        Draw.draw(self.texture,  1,  0)
        Draw.draw(self.texture, -1,  0)
        Draw.draw(self.texture,  0,  1)
        Draw.draw(self.texture,  0, -1)

        love.graphics.setShader(last_shader)

        Draw.setColor(self:getDrawColor())
    end

    ActorSprite.__super.draw(self)

    if self.texture and self.frozen then
        if self.freeze_progress < 1 then
            Draw.pushScissor()
            Draw.scissorPoints(nil, self.texture:getHeight() * (1 - self.freeze_progress), nil, nil)
        end

        local last_shader = love.graphics.getShader()
        local shader = Kristal.Shaders["AddColor"]
        love.graphics.setShader(shader)
        shader:send("inputcolor", {0.8, 0.8, 0.9})
        shader:send("amount", 1)

        local r,g,b,a = self:getDrawColor()

        Draw.setColor(0, 0, 1, a * 0.8)
        Draw.draw(self.texture, -1, -1)
        Draw.setColor(0, 0, 1, a * 0.4)
        Draw.draw(self.texture, 1, -1)
        Draw.draw(self.texture, -1, 1)
        Draw.setColor(0, 0, 1, a * 0.8)
        Draw.draw(self.texture, 1, 1)

        love.graphics.setShader(last_shader)

        love.graphics.setBlendMode("add")
        Draw.setColor(0.8, 0.8, 0.9, a * 0.4)
        Draw.draw(self.texture)
        love.graphics.setBlendMode("alpha")

        if self.freeze_progress < 1 then
            Draw.popScissor()
        end
    end

    self.actor:onSpriteDraw(self)
end)
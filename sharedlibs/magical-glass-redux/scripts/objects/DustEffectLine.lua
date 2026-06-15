local DustEffectLine, super = Class(Object)

function DustEffectLine:init(texture, x, y, allow_black_pixels, after)
    super.init(self, x, y)
    
    if type(texture) == "string" then
        texture = Assets.getTexture(texture) or (Assets.getFrames(texture)[1])
    end
    self.texture = texture
    
    self.after_func = after
    
    self.width, self.height = texture:getWidth(), texture:getHeight()
    
    -- New canvas
    self.canvas = Draw.pushCanvas(self.width, self.height)

    Draw.setCanvas(self.canvas)
        love.graphics.clear(0, 0, 0, 0)
        love.graphics.setBlendMode("alpha")
        Draw.setColor(1, 1, 1, 1)
        Draw.draw(self.texture)
        Draw.popCanvas()
    Draw.setCanvas()
    
    local data = self.canvas:newImageData()
    local delay = 0
    
    if #Game.stage:getObjects(DustEffectParticle) + #Game.stage:getObjects(DustEffectLineParticle) <= 6400 then -- Prevents your PC from exploding
        for y = 1, self.height do
            local line = {}
            for x = 1, self.width do
                local pixel = {}
                pixel.r, pixel.g, pixel.b, pixel.a = data:getPixel(x - 1, y - 1)
                table.insert(line, pixel)
            end
            local particle = DustEffectLineParticle(line, x + 1, y - 1, allow_black_pixels)
            self:addChild(particle)
            
            if Game.battle then
                Game.battle.timer:after(math.floor(delay / 3) / 30, function()
                    particle:fadeOutAndRemove(0.4)
                    particle.physics.gravity_direction = math.rad(-90)
                    particle.physics.gravity = (MathUtils.random(0.25) + 0.1)
                    particle.physics.speed_x = (MathUtils.random(2) - 1)
                end)
            else
                Game.world.timer:after(math.floor(delay / 3) / 30, function()
                    particle:fadeOutAndRemove(0.4)
                    particle.physics.gravity_direction = math.rad(-90)
                    particle.physics.gravity = (MathUtils.random(0.25) + 0.1)
                    particle.physics.speed_x = (MathUtils.random(2) - 1)
                end)
            end
            
            delay = delay + 1
        end
    end
end

function DustEffectLine:update()
    super.update(self)
    
    if #self.children == 0 then
        if self.after_func then
            self.after_func()
        end
        self:remove()
    end
end

return DustEffectLine
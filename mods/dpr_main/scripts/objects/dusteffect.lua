local DustEffect, super = Class(Object, "DustEffect")

function DustEffect:init(texture, x, y, allow_black_pixels, after)
    super.init(self, x, y)

    if type(texture) == "string" then
        texture = Assets.getTexture(texture) or (Assets.getFrames(texture)[1])
    end
    self.texture = texture
    
    self.after_func = after

    self.width, self.height = texture:getWidth(), texture:getHeight()

    -- New canvas
    self.canvas = love.graphics.newCanvas(self.width, self.height)
    self.canvas:setFilter("nearest", "nearest")

    love.graphics.reset()
    love.graphics.setCanvas(self.canvas)
    love.graphics.draw(self.texture)
    love.graphics.setCanvas()

    local data = self.canvas:newImageData()

    local delay = 0

    if #Game.stage:getObjects(DustEffectParticle) + #Game.stage:getObjects(DustEffectLargeParticle) <= 8000 then -- Prevents your PC from exploding
        for y = 1, self.height do
            for x = 1, self.width do
                local r, g, b, a = data:getPixel(x-1, y-1)
                if (not (r == 0 and g == 0 and b == 0) or allow_black_pixels ~= false) and a > 0 then
                    local particle = DustEffectParticle({r, g, b, a}, x - 1, y - 1)
                    self:addChild(particle)
                    if Game.battle then
                        Game.battle.timer:after(math.floor(delay / 3) / 30, function()
                            particle.activated = true
                            particle.physics.gravity_direction = math.rad(-90)
                            particle.physics.gravity = (Utils.random(0.25) + 0.1)
                            particle.physics.speed_x = (Utils.random(2) - 1)
                        end)
                    else
                        Game.world.timer:after(math.floor(delay / 3) / 30, function()
                            particle.activated = true
                            particle.physics.gravity_direction = math.rad(-90)
                            particle.physics.gravity = (Utils.random(0.25) + 0.1)
                            particle.physics.speed_x = (Utils.random(2) - 1)
                        end)
                    end
                end
            end
            delay = delay + 1
        end
    end
end

function DustEffect:update()
    super.update(self)
    
    if #self.children == 0 then
        if self.after_func then
            self.after_func()
        end
        self:remove()
    end
end

return DustEffect
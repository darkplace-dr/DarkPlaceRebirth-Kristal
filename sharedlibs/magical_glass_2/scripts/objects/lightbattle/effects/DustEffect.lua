local DustEffect, super = Class(Object, "DustEffect")

-- Originally written by Ally. Thank you!

function DustEffect:init(texture, x, y)
    super.init(self, x, y)

    if type(texture) == "string" then
        texture = Assets.getTexture(texture) or (Assets.getFrames(texture)[1])
    end
    self.texture = texture

    self.width, self.height = self.texture:getWidth(), self.texture:getHeight()

    -- New canvas to get data from
    self.canvas = love.graphics.newCanvas(self.width, self.height)
    self.canvas:setFilter("nearest", "nearest")

    love.graphics.setCanvas(self.canvas)
    love.graphics.reset()
    love.graphics.draw(self.texture)
    love.graphics.setCanvas()

    local data = self.canvas:newImageData()
    local delay = 0

    if MagicalGlass.__dust_objects <= MagicalGlass.__DUST_OBJECT_LIMIT then
        for y = 1, self.height do
            for x = 1, self.width do
                local r, g, b, a = data:getPixel(x-1, y-1)
                if not (r == 0 and g == 0 and b == 0) and a > 0 then
                    local particle = DustEffectParticle({r, g, b, a}, x - 1, y - 1)
                    self:addChild(particle)
                    Game.battle.timer:after(math.floor(delay / 3) / 30, function()
                        particle.activated = true
                        particle.physics.gravity_direction = math.rad(-90)
                        particle.physics.gravity = (Utils.random(0.25) + 0.1)
                        particle.physics.speed_x = (Utils.random(2) - 1)
                    end)
                end
            end
            delay = delay + 1
        end
    end
end

function DustEffect:update()
    super.update(self)
    if #self.children == 0 then
        self:remove()
    end
end

return DustEffect
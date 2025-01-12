local DustEffectLargeParticle, super = Class(Sprite, "DustEffectLargeParticle")

function DustEffectLargeParticle:init(line, x, y)
    super.init(self, nil, x, y)

    self.line = line

    local canvas = love.graphics.newCanvas(#self.line, 1)
    canvas:setFilter("nearest", "nearest")

    local image_data = canvas:newImageData()

    for x, color in ipairs(self.line) do
        if color.r > 0 and color.g > 0 and color.b > 0 then
            image_data:setPixel(x - 1, 0, color.r, color.g, color.b, 1)
        else
            image_data:setPixel(x - 1, 0, 0, 0, 0, 0)
        end
    end

    self:setTexture(love.graphics.newImage(image_data))
end

function DustEffectLargeParticle:onAdd()
    MagicalGlass.__dust_objects = MagicalGlass.__dust_objects + 1
end

function DustEffectLargeParticle:onRemove()
    MagicalGlass.__dust_objects = MagicalGlass.__dust_objects - 1
end

return DustEffectLargeParticle
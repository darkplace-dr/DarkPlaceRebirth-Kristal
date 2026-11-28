local SpriteAfterImageFog, super = Class(Sprite)

function SpriteAfterImageFog:init(texture, x, y, fade_speed)
    super.init(self, texture, x, y)

    self.debug_select = false

    self.graphics.fade = fade_speed or 0.04
    self.graphics.fade_callback = function() self:remove() end

    self.type = 0

    self.fog = self:addFX(ColorMaskFX())
end

function SpriteAfterImageFog:getSortPosition()
    return 0, 0
end

function SpriteAfterImageFog:update()
    super.update(self)

    if self.type == 0 then
        self.fog.amount = self.alpha / 3
    else
        self.fog.amount = self.alpha
    end
end

return SpriteAfterImageFog
---@class JackensteinFlashFade : Sprite
---@overload fun(...) : JackensteinFlashFade
local JackensteinFlashFade, super = Class(Sprite)

function JackensteinFlashFade:init(texture, x, y)
    super.init(self, texture, x, y)

    self.siner = 14
    self.target = nil

    self.alpha = 1

    self.color_mask = self:addFX(ColorMaskFX())
end

function JackensteinFlashFade:update()
    self.siner = self.siner - DTMULT

    self.alpha = self.siner / 10
    if self.siner <= 0 then
        self:remove()
    end

    super.update(self)
end

return JackensteinFlashFade
local FlashFadeTower, super = Class(Object)

function FlashFadeTower:init(texture, x, y)
    super.init(self, x, y)

    if type(texture) == "string" then
        texture = Assets.getTexture(texture) or (Assets.getFrames(texture)[1])
    end
    self.texture = texture
    self.flash_speed = 1
    self.siner = 0
    self.target = nil

    self.alpha = 0
end

function FlashFadeTower:update()
    self.siner = self.siner + self.flash_speed * DTMULT

    self.alpha = math.sin(self.siner / 3)

    if self.siner > 4 and math.sin(self.siner / 3) < 0 then
        self:remove()
    end

    super.update(self)
end

return FlashFadeTower
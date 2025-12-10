local Egg, super = Class("EggPart")

function Egg:init(x, y)
    super.init(self, "battle/enemies/egg/idle_1", x, y, 17, 26)
    self.sprite:setOrigin(0.5, 0)
    self:setScale(0.5)
    self.sprite:setScaleOrigin(0.5, 1)
    
    self.cooldown = 0
end

function Egg:update()
    super.update(self)
	
    if self.cooldown > 0 then
        self.cooldown = self.cooldown - 0.1 * DTMULT
    end

    if self.sprite.scale_x > 2 then
        self.sprite.scale_x = MathUtils.lerp(self.sprite.scale_x, 2, 0.3*DTMULT)
    end
	
    if self.sprite.scale_y < 2 then
        self.sprite.scale_y = GeneralUtils:lerpSnap(self.sprite.scale_y, 2, 0.3*DTMULT) --butt-ugly hack to reset the y scale back to its original size
    end

    if self.cooldown <= 0 then
        self.cooldown = 1.525
        self.sprite.scale_x = 5
        self.sprite.scale_y = 0.25
    end
end

return Egg
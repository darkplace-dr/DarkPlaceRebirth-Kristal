local MetalSonicPlush, super = Class(Event)

function MetalSonicPlush:init(data)
    super.init(self, data)
	
    self:setSprite("world/events/metalsonic_plush")
	
	self.solid = true
    self:setHitbox(4, 24, 40, 24)

    self:setScale(1)
    self.sprite:setScaleOrigin(0.5, 1)
    self.sprite.x = self.sprite.width / 2
    self.sprite.y = self.sprite.height
    self:setOrigin(0.5, 1)

    self.cooldown = 0
end

function MetalSonicPlush:update()
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
end

function MetalSonicPlush:onInteract(player, dir)
    if self.cooldown <= 0 then
        Assets.playSound("huehuehue", 0.7)

        self.cooldown = .0
        self.sprite.scale_x = 5
        self.sprite.scale_y = 0.25
    end

    return false
end

return MetalSonicPlush
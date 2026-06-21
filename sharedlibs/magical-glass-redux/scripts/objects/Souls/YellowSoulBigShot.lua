local BigShot, super = Class("YellowSoulShot")

function BigShot:init(x, y, angle)
    super.init(self, x, y, angle)
    
    if Game.battle.soul.undertale then
        self:setSprite("effects/yellowsoul/bigshot_ut")
        self.collider = CircleCollider(self, 30, 12, 12)
    else
        self:setSprite("effects/yellowsoul/bigshot")
        self.collider = CircleCollider(self, 30, 14, 14)
    end
    self.alpha = 0.5
    if Game.battle.light then
        self.layer = LIGHT_BATTLE_LAYERS["above_bullets"]
    else
        self.layer = BATTLE_LAYERS["above_bullets"]
    end
    self:setScale(0.1, 2)

    self.physics.speed = 9
    self.physics.friction = -0.4
    self.damage = 4
    self.big = true
end

function BigShot:update()
    if self.scale_x < 1 then
        self.scale_x = MathUtils.approach(self.scale_x, 1, 0.2 * DTMULT)
    end
    if self.scale_y > 1 then
        self.scale_y = MathUtils.approach(self.scale_y, 1, 0.2 * DTMULT)
    end
    if self.alpha < 1 then
        self.alpha = MathUtils.approach(self.alpha, 1, 0.2 * DTMULT)
    end
    
    super.update(self)
end

return BigShot
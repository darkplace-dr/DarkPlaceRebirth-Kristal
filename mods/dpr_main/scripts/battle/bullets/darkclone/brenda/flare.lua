local Flare, super = Class(Bullet)

function Flare:init(x, y, dir, speed)
    super.init(self, x, y, "battle/bullets/darkclone/brenda/flare")

    self.physics.direction = dir
    self.physics.speed = speed
    self.physics.friction = 0.1

    self.rotation = dir
end

function Flare:onDamage(soul)
    local damage = self:getDamage()
    local brenda = Game.battle:getPartyBattler("brenda")
    if brenda.powder then
        damage = damage * 2
        Assets.playSound("bomb")
        brenda.powder = false
        brenda:removeFX("powder_fx")
    end
    if damage > 0 then
        local battlers = Game.battle:hurt(damage, false, self:getTarget())
        soul.inv_timer = self.inv_timer
        soul:onDamage(self, damage)
        return battlers
    end
    return {}
end

function Flare:update()
    if self.physics.speed <= 0 then
        self.alpha = self.alpha - 0.1 * DTMULT
    end

    super.update(self)
end

return Flare
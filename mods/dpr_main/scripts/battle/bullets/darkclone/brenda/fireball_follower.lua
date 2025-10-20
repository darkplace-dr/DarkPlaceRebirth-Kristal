local FireballFollower, super = Class(Bullet)

function FireballFollower:init(x, y)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/darkclone/brenda/fireball")
    self.sprite:play(0.1)

    self.destroy_on_hit = false

    self.speed_x_ours = 0
    self.speed_y_ours = 0

    self.target = nil
end

function FireballFollower:onDamage(soul)
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

function FireballFollower:update()
    local dtmulti = DT * 90

    local x_diff = self.target.x - self.x
    local y_diff = self.target.y - self.y
    self.speed_x_ours = self.speed_x_ours + (-self.speed_x_ours/2 + x_diff / 100) * dtmulti
    self.speed_y_ours = self.speed_y_ours + (-self.speed_y_ours/2 + y_diff / 100) * dtmulti
    self:move(self.speed_x_ours, self.speed_y_ours, dtmulti)

    super.update(self)
end

return FireballFollower
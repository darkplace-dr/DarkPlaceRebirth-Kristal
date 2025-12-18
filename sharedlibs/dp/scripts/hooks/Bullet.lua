---@class Bullet : Bullet
local Bullet, super = HookSystem.hookScript(Bullet)

function Bullet:init(x,y,texture)
    super.init(self, x, y, texture)

    self.pierce = false
end

function Bullet:onDamage(soul)
    local damage = self:getDamage()
    if damage > 0 then
        if Game.pp > 0 then
            Game.pp = Game.pp - 1
            Game.battle:breakSoulShield()
        else
            local target = self:getTarget()
            if not self.pierce then
                local battlers = Game.battle:hurt(damage, false, target, self:shouldSwoon(damage, target, soul))
                soul.inv_timer = self.inv_timer
                soul:onDamage(self, damage)
                return battlers
            end
            Game.battle:pierce(damage, false, target)
        end
        soul.inv_timer = self.inv_timer
        soul:onDamage(self, damage)
    end
    return {}
end

function Bullet:onCollide(soul)
    if Game.battle.superpower then return end
    return super.onCollide(self, soul)
end

return Bullet
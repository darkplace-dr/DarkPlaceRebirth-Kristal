---@class WorldBullet : WorldBullet
local WorldBullet, super = HookSystem.hookScript(WorldBullet)

function WorldBullet:onDamage(soul)
    if self:getDamage() > 0 then
        if Game.pp > 0 then
            Game.pp = Game.pp - 1
            self.world:breakSoulShield()
        else
            self.world:hurtParty(self.damage)

            soul.inv_timer = self.inv_timer
        end
    end
end

return WorldBullet
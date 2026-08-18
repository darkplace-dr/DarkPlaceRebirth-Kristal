---@class WorldBullet : WorldBullet
local WorldBullet, super = HookSystem.hookScript(WorldBullet)

function WorldBullet:init(x, y, texture)
    super.init(self, x, y, texture)

    -- TP added when you graze this bullet (Also given each frame after the first graze, 30x less at 30FPS)
    self.tp = 1.6
    -- TP added when you graze this bullet when the reduced tension is enabled
    self.tp_reduced = 0.2
    -- Whether you can graze this bullet or not.
    self.can_graze = true
    -- Whether this bullet has already been grazed (reduces graze rewards).
    self.grazed = false
end

function WorldBullet:getGrazeTension()
    if self.world:hasReducedTension() then
        return self.tp_reduced
    end
    return self.tp
end

function WorldBullet:canGraze()
    return self.can_graze
end

function WorldBullet:onDamage(soul)
    if self:getDamage() > 0 then
        if Game.pp > 0 then
            Game.pp = Game.pp - 1
            self.world:breakSoulShield()
        else
            self.world:hurtParty(self.damage)
        end
        local inv_frames = self:getInvulnFrames()
        Game:setInvulnFrames(inv_frames)
        soul:onDamage(self, damage)
    end
end

function WorldBullet:onGraze(first) end

return WorldBullet
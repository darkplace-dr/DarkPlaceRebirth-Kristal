local ArenaHazard, super = Class(Bullet)

function ArenaHazard:init(x, y, rot, timer)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/chloropurr/vines")

    -- Top-center origin point (will be rotated around it)
    self:setOrigin(0.5, 0)
    self.timer = timer
    self.truetimer = timer
    -- The hitbox where the player will be damaged by the bullet (affected by scale and rotation)
    self:setHitbox(0, 0, self.width, 8)

    -- Rotation of the bullet (in radians)
    self.rotation = rot

    -- Don't destroy this bullet when it damages the player
    self.destroy_on_hit = false
end

function ArenaHazard:update()
    -- For more complicated bullet behaviours, code here gets called every update
self.timer = self.timer - 1
if self.timer <= 0 then
    self.timer = MathUtils.random(self.truetimer-3, self.truetimer)
    self.wave:spawnBullet("chloropurr/leafgrow", Game.battle.arena.x+MathUtils.random(-60, 60), Game.battle.arena.top+18, math.rad(90), 0)
end
    super.update(self)
end

return ArenaHazard
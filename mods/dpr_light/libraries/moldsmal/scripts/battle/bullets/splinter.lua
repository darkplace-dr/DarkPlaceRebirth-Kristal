local bullet, super = Class(Bullet)

function bullet:init(x, y)
    super.init(self, x, y, "bullets/froggit/bulletsm")
    self.remove_outside_of_arena = true

    self:setScale(1, 1)
    self:setOrigin(0.5, 0.5)
    self:setHitbox(2, 2, 3, 3)

    local angle = Utils.angle(x, y, Game.battle.soul.x + 2, Game.battle.soul.y + 2)
    self.physics.direction = angle
    self.physics.speed = 2.5
end

return bullet
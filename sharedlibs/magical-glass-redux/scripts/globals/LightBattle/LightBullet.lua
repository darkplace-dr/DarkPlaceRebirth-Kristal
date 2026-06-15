local LightBullet, super = Class(Bullet)

function LightBullet:init(x, y, texture)
    super.init(self, x, y, texture)
    
    self.destroy_on_hit = "alt"
    self.layer = LIGHT_BATTLE_LAYERS["bullets"]
    self.can_collide_while_not_defending = false
end

function LightBullet:onCollide(soul)
    if Game.battle:getState() == "DEFENDING" or self.can_collide_while_not_defending then
        super.onCollide(self, soul)
    end
end

return LightBullet
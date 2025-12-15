local SpotlightBullet, super = Class(Bullet, "mizzle/spotlight")

function SpotlightBullet:init(x, y)
    super.init(self, x, y, "battle/bullets/mizzle/spotlight")


    self:setLayer(BATTLE_LAYERS["below_soul"])
    self:setScale(1.3, 1.3)
    self:setOrigin(0.5, 0.5)
    self.collider = CircleCollider(self, 0, 0, 40)
    self.alpha = 0.2

    self.timer = 0

    self.made = false
end

function SpotlightBullet:update()
    super.update(self)

    if not self.made then
        Game.battle.timer:after(8/30, function()
            Game.battle.timer:lerpVar(self, "alpha", 0.2, 0.4, 16)
        end)
    end

    self.timer = self.timer + DTMULT

    if Game.battle.wave_timer >= Game.battle.wave_length - 1/30 then
        self:remove()
    end

    --flickering effect
    if self.timer % 2 < 1 then
        self.visible = true
    elseif self.timer > 8 then
        self.visible = true
    else
        self.visible = false
    end
end

return SpotlightBullet
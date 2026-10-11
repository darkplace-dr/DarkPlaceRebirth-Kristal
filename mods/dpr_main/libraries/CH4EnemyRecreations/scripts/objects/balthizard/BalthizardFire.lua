local BalthizardFire, super = Class(Sprite)

function BalthizardFire:init(x, y)
    super.init(self, "battle/bullets/balthizard/toriel_flame", x, y)

    self:setOriginExact(8, 10)
    self:play(1 / 15, true)

    self.alpha = 1.2
end

function BalthizardFire:update()
    self.alpha = self.alpha - 0.05 * DTMULT
    if self.alpha <= 0 then
        self:remove()
    end

    super.update(self)
end

return BalthizardFire
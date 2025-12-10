local BalthizardFire, super = Class(Sprite)

function BalthizardFire:init(x, y)
    super.init(self, "battle/bullets/balthizard/toriel_flame", x, y)

    self:play(1/15)

    self.alpha = 1.2
end

function BalthizardFire:update()
    super.update(self)
    self.alpha = self.alpha - 0.05 * DTMULT
    if self.alpha < 0 then
        self:remove()
    end
end

return BalthizardFire
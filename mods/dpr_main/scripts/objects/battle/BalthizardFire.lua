local BalthizardFire, super = Class(Object)

function BalthizardFire:init(x, y)
    super.init(self, x, y)

    self.alpha = 1.2
end

function BalthizardFire:update()
    super.update(self)
    self.alpha = self.alpha - 0.05 * DTMULT
    if self.alpha < 0 then
        self:remove()
    end
end

function BalthizardFire:draw()
    local fire = Assets.getFrames("battle/bullets/toriel_flame")
    local frame = math.floor(Kristal.getTime()) % #fire + 1
    Draw.draw(fire[frame], 0, 0, 0, 1, 1, 8, 10)

    super.draw(self)
end

return BalthizardFire
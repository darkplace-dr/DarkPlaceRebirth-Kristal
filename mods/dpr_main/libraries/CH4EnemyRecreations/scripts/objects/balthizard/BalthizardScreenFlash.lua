local BalthizardScreenFlash, super = Class(Object)

function BalthizardScreenFlash:init(fires)
    super.init(self, 0, 0)
    self:setLayer(BATTLE_LAYERS["top"])

    self.fires = fires
    self.alpha = 0
    self.con = 0
end

function BalthizardScreenFlash:update()
    super.update(self)
    if self.con == 0 then
        self.alpha = self.alpha + 0.05 * DTMULT
        if self.alpha >= 1.1 then
            self.con = 1
        end
    end
    if self.con == 1 then
        for _,fire in ipairs(self.fires) do
            fire:remove()
        end
        self.alpha = self.alpha - 0.02 * DTMULT
        if self.alpha < 0 then
            self:remove()
        end
    end
end

function BalthizardScreenFlash:draw()
    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

    super.draw(self)
end

return BalthizardScreenFlash
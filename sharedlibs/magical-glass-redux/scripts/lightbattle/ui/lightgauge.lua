local LightGauge, super = Class(Object)

function LightGauge:init(type, amount, x, y, enemy, color)
    super.init(self, x, y)

    self.layer = LIGHT_BATTLE_LAYERS["damage_numbers"]
    self.timer = Timer()
    self:addChild(self.timer)

    self.type = type
    self:setOrigin(0.5, 0)

    if not color then
        if self.type == "damage" then
            self.color = PALETTE["action_health"]
        elseif self.type == "mercy" then
            self.color = COLORS["yellow"]
        end
    else
        self.color = color
    end

    self.enemy = enemy
    self.width, self.height = Utils.unpack(self.enemy:getGaugeSize())

    self.amount = math.abs(tonumber(amount))

    if self.type == "damage" then
        self.value = self.enemy.health
        self.real_value = self.enemy.health
        self.max_value = self.enemy.max_health
        self.extra_width = (self.width / self.max_value)
        self.reversed = (Utils.sub(tostring(amount), 1, 1) == "+" or amount < 0) and true or false -- heal
    elseif self.type == "mercy" then
        self.value = self.enemy.mercy
        self.real_value = self.enemy.mercy
        self.max_value = 100
        self.extra_width = (self.width / self.max_value)
        self.reversed = amount >= 0 and true or false -- allows for mercy reduction
    end
    
    if not Kristal.getLibConfig("magical-glass", "enemy_gauge_smoothness") and self.max_value >= self.real_value then
        self.timer:every(2/30, function()
            if self.reversed then
                self.value = self.value + (self.amount / 15)
                if not (self.value < (self.real_value + self.amount)) then
                    self.value = (self.real_value + self.amount)
                end
            else
                self.value = self.value - (self.amount / 15)
                if not (self.value > (self.real_value - self.amount)) then
                    self.value = (self.real_value - self.amount)
                end
            end

            self.value = Utils.clamp(self.value, 0, self.max_value)
        end)
    end
end

function LightGauge:update()
    super.update(self)
    
    if Kristal.getLibConfig("magical-glass", "enemy_gauge_smoothness") and self.max_value >= self.real_value then
        if self.reversed then
            self.value = self.value + (self.amount / 15) * DTMULT / 2
            if not (self.value < (self.real_value + self.amount)) then
                self.value = (self.real_value + self.amount)
            end
        else
            self.value = self.value - (self.amount / 15) * DTMULT / 2
            if not (self.value > (self.real_value - self.amount)) then
                self.value = (self.real_value - self.amount)
            end
        end

        self.value = Utils.clamp(self.value, 0, self.max_value)
    end
end

function LightGauge:draw()
    super.draw(self)
    
    Draw.setColor(COLORS["black"])
    love.graphics.rectangle("fill", -1, 7, self.max_value * self.extra_width + 2, self.height + 2)
    Draw.setColor(64 / 255, 64 / 255, 64 / 255)
    love.graphics.rectangle("fill", 0, 8, self.max_value * self.extra_width, self.height)
    if self.value > 0 then
        Draw.setColor(self.color)
        love.graphics.rectangle("fill", 0, 8, self.value * self.extra_width, self.height)
    end
end

return LightGauge
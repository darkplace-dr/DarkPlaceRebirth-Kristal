local LightEnemyGauge, super = Class(Object, "LightEnemyGauge")

function LightEnemyGauge:init(gauge_type, amount, current, max, x, y, options)
    super.init(self, x, y)
    options = options or {}

    self:setOrigin(0.5)

    self.layer = BATTLE_LAYERS["damage_numbers"]

    self.type = gauge_type
    self.amount = amount

    self.width = options["width"]
    self.height = options["height"] or 13

    self.gauge_color = options["color"]
    self.back_color = options["back_color"] or COLORS.dkgray
    self.outline_color = options["outline_color"] or COLORS.black

    self.smooth = options["smooth"]

    if self.type == "damage" then
        self.gauge_amount = current
        self.gauge_target = current - self.amount
        self.gauge_max = max

        if not self.gauge_color then
            self.gauge_color = MagicalGlass.PALETTE["enemy_health"]
        end
    elseif self.type == "heal" then
        self.gauge_amount = current
        self.gauge_target = current + self.amount
        self.gauge_max = max

        if not self.gauge_color then
            self.gauge_color = MagicalGlass.PALETTE["enemy_health"]
        end  
    elseif self.type == "mercy" then
        self.gauge_amount = current
        self.gauge_target = current + self.amount
        self.gauge_max = max

        if not self.gauge_color then
            self.gauge_color = MagicalGlass.PALETTE["enemy_mercy"]
        end
    end

    self.update_timer = 0
end

function LightEnemyGauge:updateGauge()
    self.update_timer = self.update_timer + DTMULT

    -- this only updates every two frames
    if math.ceil(self.update_timer) % 3 == 0 then
        local amount = ((self.amount / 15) * (DTMULT * 3)) * Utils.sign(tonumber(self.amount))
        if self.gauge_amount ~= self.gauge_target then
            self.gauge_amount = Utils.approach(self.gauge_amount, self.gauge_target, amount)
        end

        self.gauge_amount = Utils.clamp(self.gauge_amount, 0, self.gauge_max)
    end
end

function LightEnemyGauge:updateGaugeSmooth()
    local target = math.ceil(self.gauge_target - self.amount)
    local amount = (self.amount / 15) * DTMULT 
    if self.gauge_amount ~= target then
        self.gauge_amount = Utils.approach(self.gauge_amount, target, amount)
    end

    self.gauge_amount = math.max(0, self.gauge_amount)
end

function LightEnemyGauge:update()
    if self.smooth then
        self:updateGaugeSmooth()
    else
        self:updateGauge()
    end

    super.update(self)
end

function LightEnemyGauge:drawGauge()
    Draw.setColor(self.outline_color)
    love.graphics.rectangle("fill", -1, 7, self.width + 2, self.height)
    Draw.setColor(self.back_color)
    love.graphics.rectangle("fill", 0, 8, self.width, self.height)
    Draw.setColor(self.gauge_color)
    love.graphics.rectangle("fill", 0, 8, (self.gauge_amount / self.gauge_max) * self.width, self.height)
end

function LightEnemyGauge:draw()
    self:drawGauge()
    super.draw(self)
end

return LightEnemyGauge
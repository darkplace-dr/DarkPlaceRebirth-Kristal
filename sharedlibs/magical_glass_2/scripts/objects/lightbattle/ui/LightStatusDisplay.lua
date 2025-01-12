local LightStatusDisplay, super = Class(Object, "LightStatusDisplay")

function LightStatusDisplay:init(x, y, battler)
    super.init(self, x, y)

    self.battler = battler

    self.font = Assets.getFont("namelv", 24)
    self.hp_texture = Assets.getTexture("ui/lightbattle/hp")
    self.tp_texture = Assets.getTexture("ui/lightbattle/tp")

    -- "ALWAYS", "NEVER", "BATTLE"
    self.draw_tension = "BATTLE"

    self.hp_gauge_limit = MagicalGlass:getConfig("lightBattleHPGaugeLimit")

    self.debug_rect = {0, 0, SCREEN_WIDTH + 10, 24}
end

function LightStatusDisplay:draw()
    self:drawStatus()

    super.draw(self)
end

function LightStatusDisplay:drawStatus()
    self:drawNameAndLV(0, 0)
    self:drawHP(245, 0)
    if self.draw_tension == "ALWAYS" or self.draw_tension == "BATTLE" and Game.battle.tension then
        self:drawTP()
    end
end

function LightStatusDisplay:drawNameAndLV(x, y)
    local name = self.battler.chara:getName()
    local level = Game:isLight() and self.battler.chara:getLightLV() or self.battler.chara:getLevel()

    love.graphics.setFont(self.font)
    Draw.setColor(COLORS.white)

    love.graphics.print(name .. "   LV " .. level, x, y)
end

function LightStatusDisplay:drawHP(x, y)
    local current_health = self.battler.chara:getHealth()
    local max_health = self.battler.chara:getStat("health")

    local current_width = current_health * 1.25
    local max_width = max_health * 1.25

    love.graphics.setFont(self.font)
    Draw.setColor(COLORS.white)

    Draw.draw(self.hp_texture, 214, 5)

    if self.hp_gauge_limit then
        current_width = Utils.clamp(current_width, 0, self.hp_gauge_limit)
        max_width = Utils.clamp(max_width, 0, self.hp_gauge_limit)
    end

    Draw.setColor(MagicalGlass.PALETTE["player_health_back"])
    Draw.rectangle("fill", x, y, max_width, 21)
    if current_health > 0 then
        Draw.setColor(MagicalGlass.PALETTE["player_health"])
        Draw.rectangle("fill", x, y, current_width, 21)
    end

    if max_health < 10 and max_health >= 0 then
        max_health = "0" .. tostring(max_health)
    end

    if current_health < 10 and current_health >= 0 then
        current_health = "0" .. tostring(current_health)
    end

    local color = COLORS.white
    if not self.battler.is_down then
        if Game.battle:hasAction(self.battler) and Game.battle:getActionBy(self.battler).action == "DEFEND" then
            color = MagicalGlass.PALETTE["player_status_defend"]
        end
    else
        color = MagicalGlass.PALETTE["player_status_down"]
    end

    Draw.setColor(color)
    love.graphics.print(current_health .. " / " .. max_health, (x + max_width) + 14, y)
end

function LightStatusDisplay:drawTP()
    local x, y = 500, 0

    Draw.setColor(COLORS.white)
    Draw.draw(self.tp_texture, x, y + 5)

    if Game:getTension() < Game:getMaxTension() then
        local tp = math.floor(Game:getTension())

        if Game:getTension() < 10 then
            tp = "0" .. tp
        end

        if Game:getTension() > 0 then
            Draw.setColor(MagicalGlass.PALETTE["tension_fill"])
        else
            Draw.setColor(MagicalGlass.PALETTE["tension_back"])
        end
        love.graphics.print(tp, x + 32, y)
        Draw.setColor(COLORS.white)
        love.graphics.print("%", x + 64, y)
    else
        Draw.setColor(MagicalGlass.PALETTE["tension_maxtext"])
        love.graphics.print("MAX", x + 32, y)
    end
end

return LightStatusDisplay
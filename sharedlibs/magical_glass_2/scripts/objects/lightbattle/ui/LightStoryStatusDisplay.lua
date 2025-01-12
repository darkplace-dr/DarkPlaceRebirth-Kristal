local LightStoryStatusDisplay, super = Class(Object, "LightStoryStatusDisplay")

function LightStoryStatusDisplay:init(x, y, battler)
    super.init(self, x, y)

    self.battler = battler

    self.font = Assets.getFont("namelv", 24)
    self.hp_texture = Assets.getTexture("ui/lightbattle/hp")

    self.hp_gauge_limit = MagicalGlass:getConfig("lightBattleHPGaugeLimit")

    self.debug_rect = {0, 0, SCREEN_WIDTH + 10, 24}
end

function LightStoryStatusDisplay:draw()
    self:drawStatus()

    super.draw(self)
end

function LightStoryStatusDisplay:drawStatus()
    self:drawLV(0, 0)
    self:drawHP(74, 0)
end

function LightStoryStatusDisplay:drawLV(x, y)
    local level = self.battler.chara:getLightLV()

    love.graphics.setFont(self.font)
    Draw.setColor(COLORS.white)

    love.graphics.print("LV " .. level, x, y)
end

function LightStoryStatusDisplay:drawHP(x, y)
    local current_health = self.battler.chara:getHealth()
    local max_health = self.battler.chara:getStat("health")

    local current_amount = current_health * 1.25
    local max_amount = max_health * 1.25

    love.graphics.setFont(self.font)
    Draw.setColor(COLORS.white)

    Draw.draw(self.hp_texture, x, y + 5)

    if self.hp_gauge_limit then
        current_amount = Utils.clamp(current_amount, 0, self.hp_gauge_limit)
        max_amount = Utils.clamp(max_amount, 0, self.hp_gauge_limit)
    end

    Draw.setColor(MagicalGlass.PALETTE["player_health_back"])
    Draw.rectangle("fill", x + 36, y, max_amount, 21)
    Draw.setColor(MagicalGlass.PALETTE["player_health"])
    Draw.rectangle("fill", x + 36, y, current_amount, 21)

    if max_health < 10 and max_health >= 0 then
        max_health = "0" .. tostring(max_health)
    end

    if current_health < 10 and current_health >= 0 then
        current_health = "0" .. tostring(current_health)
    end

    local color = COLORS.white
    if not self.battler.is_down then
        if Game.battle:hasAction(self.battler) and Game.battle:getActionBy(self.battler).action == "DEFEND" then
            color = MagicalGlass.PALETTE["defend"]
        end
    end

    Draw.setColor(color)
    love.graphics.print(current_health .. " / " .. max_health, (x + max_amount) + 55, y)
end

return LightStoryStatusDisplay
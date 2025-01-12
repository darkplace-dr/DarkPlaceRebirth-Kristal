local LightBattleEnemySelectItem, super = Class(Object, "LightBattleEnemySelectItem")

function LightBattleEnemySelectItem:init(x, y, options)
    super.init(self, x, y)

    options = options or {}

    self.name = DynamicGradientText("", 0, 0, {font = options["name_font"] or "main_mono"})
    self.name.debug_rect = {0, 0, 0, 0}
    self:addChild(self.name)

    self.x_act = Text("", 0, 0, {font = options["x_act_font"] or "main_mono"})
    self.x_act.visible = false
    self.x_act.debug_rect = {0, 0, 0, 0}
    self:addChild(self.x_act)

    self.shake = options["shake"] or MagicalGlass.light_battle_text_shake
    self.shake_power = options["shake_power"] or 1

    self.health = nil
    self.max_health = nil

    self.hide_health = nil
end

function LightBattleEnemySelectItem:getDebugRectangle()
    return {0, 0, SCREEN_WIDTH, 32}
end

function LightBattleEnemySelectItem:setName(name)
    name = "* " .. name

    if self.shake then
        self.name:setText("[ut_shake:"..self.shake_power.."]"..name)
    else
        self.name:setText(name)
    end
end

function LightBattleEnemySelectItem:setColors(colors)
    if #colors > 1 then
        self.name:setGradientColors(colors)
    else
        self.name:setColor(Utils.unpackColor(colors[1]))
    end
end

function LightBattleEnemySelectItem:setXAction(name, color)
    self.x_act.visible = true

    local name_width = 0
    for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
        if enemy and string.len(enemy.name) > name_width then
            name_width = string.len(enemy.name)
        end
    end
    self.x_act.x = 90 + (name_width * 16)

    self.x_act:setColor(Utils.unpackColor(color))
    if self.shake then
        self.x_act:setText("[ut_shake:"..self.shake_power.."]"..name)
    else
        self.x_act:setText(name)
    end
end

function LightBattleEnemySelectItem:clear()
    self.name:setText("")
    self.x_act:setText("")

    self.x_act.x = 0
    self.x_act.visible = false

    self.health = nil
    self.max_health = nil
    self.hide_health = nil
end

function LightBattleEnemySelectItem:draw()
    if self.health and not self.hide_health then
        self:drawGauge()
    end

    super.draw(self)
end

function LightBattleEnemySelectItem:drawGauge()
    local name_width = 0
    for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
        if enemy and string.len(enemy.name) > name_width then
            name_width = string.len(enemy.name)
        end
    end

    local gauge_x = 90 + (name_width * 16)
    local gauge_width = 101
    local health_percent = (self.health / self.max_health) * gauge_width

    Draw.setColor(MagicalGlass.PALETTE["menu_health_back"])
    Draw.rectangle("fill", gauge_x, 10, gauge_width, 17)

    Draw.setColor(MagicalGlass.PALETTE["menu_health"])
    Draw.rectangle("fill", gauge_x, 10, health_percent, 17)
end

return LightBattleEnemySelectItem
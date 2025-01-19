local LightBattleEnemySelect, super = Class(Object, "LightBattleEnemySelect")

LightBattleEnemySelect.ENEMIES_PER_PAGE = 3

function LightBattleEnemySelect:init(x, y, cursor_memory)
    super.init(self, x, y)

    self.menu_active = false
    self.visible = false

    self.enemies = {}

    self.text = {}
    self:createText()

    self.current_enemy = 0
    self.page = nil

    self.cursor_memory = cursor_memory

    self.hide_health = nil
    self.show_x_acts = nil

    self.select_callback = nil
    self.cancel_callback = nil

    self.arrow_sprite = Assets.getTexture("ui/lightbattle/item_arrow")
end

function LightBattleEnemySelect:onActivated()
    self.menu_active = true
    self.visible = true
end

function LightBattleEnemySelect:onDeactivated()
    self.menu_active = false
    self.visible = false
end

function LightBattleEnemySelect:hasEnemies()
    return #self.enemies > 0
end

function LightBattleEnemySelect:getCurrentEnemy()
    return self.enemies[self.current_enemy] or {selectable = false}
end

function LightBattleEnemySelect:getCurrentText()
    local index = ((self.current_enemy - 1) % LightBattleEnemySelect.ENEMIES_PER_PAGE) + 1
    return self.text[index]
end

function LightBattleEnemySelect:canSelectEnemy(enemy)
    if not enemy.selectable then
        return false
    end
    return true
end

function LightBattleEnemySelect:createText()
    for i = 0, 2 do
        local text = LightBattleEnemySelectItem(0, i * 32)
        table.insert(self.text, text)
        self:addChild(text)
    end
end

function LightBattleEnemySelect:setup(enemies, options)
    options = options or {}

    self:clear()

    self.visible = true

    self.hide_health = options["hide_health"]
    self.show_x_acts = options["show_x_acts"]

    for _,enemy in ipairs(enemies) do
        self:addEnemy(enemy)
    end

    if self.cursor_memory then
        local give_up = 0
        while not self:canSelectEnemy(self:getCurrentEnemy()) do
            self.current_enemy = self.current_enemy + 1
            give_up = give_up + 1
            if give_up >= 100 then
                self.current_enemy = 1
                break 
            end
        end
    else
        self.current_enemy = 1
    end

    self:refresh()
end

function LightBattleEnemySelect:setCallback(callback)
    self.select_callback = callback
end

function LightBattleEnemySelect:setCancelCallback(callback)
    self.cancel_callback = callback
end

function LightBattleEnemySelect:addEnemy(enemy)
    if type(enemy) == "table" then
        enemy = {
            ["id"] = enemy.id,
            ["name"] = enemy:getName(),
            ["selectable"] = enemy.selectable,
            ["identifier"] = enemy.identifier,
            ["health"] = enemy.health,
            ["max_health"] = enemy.max_health,
            ["mercy"] = enemy.mercy,
            ["colors"] = enemy:getNameColors(),
            ["data"] = enemy
        }
    end
    table.insert(self.enemies, enemy)

    self:refresh()
end

function LightBattleEnemySelect:refresh()
    self:refreshPage()
    self:refreshText()
end

function LightBattleEnemySelect:refreshText()
    for i, text in ipairs(self.text) do
        local enemies_per_page = LightBattleEnemySelect.ENEMIES_PER_PAGE
        local enemy_index = (i - enemies_per_page) + self.page * enemies_per_page
        local enemy = self.enemies[enemy_index]

        if enemy then
            if Game.battle.encounter.enemy_count[enemy.id] > 1 and enemy.identifier then
                text:setName(enemy.name .. " " .. enemy.identifier)
            else
                text:setName(enemy.name)
            end

            if #enemy.colors > 0 then
                text:setColors(enemy.colors)
            end

            if self.show_x_acts then
                local member = Game.battle:getCurrentlySelectingMember()
                text:setXAction(enemy.data:getXAction(member), {member.chara:getXActColor()})
            end

            text.health = enemy.health
            text.max_health = enemy.max_health
            text.hide_health = self.hide_health
        else
            text:clear()
        end
    end
end

function LightBattleEnemySelect:refreshPage()
    self.page = math.ceil(self.current_enemy / LightBattleEnemySelect.ENEMIES_PER_PAGE)
end

function LightBattleEnemySelect:onKeyPressed(key)
    if self.menu_active and self:hasEnemies() then
        if Input.isConfirm(key) then
            self:select(self:getCurrentEnemy(), self:canSelectEnemy(self:getCurrentEnemy()))
        elseif Input.isCancel(key) then
            self:cancel()
        elseif Input.is("up", key) then
            self:previousEnemy()
        elseif Input.is("down", key) then
            self:nextEnemy()
        end
    end
end

function LightBattleEnemySelect:nextEnemy()
    if #self.enemies < 1 then return end

    local last_enemy = self.current_enemy

    local give_up = 0
    repeat
        give_up = give_up + 1
        if give_up > 100 then self.current_enemy = 1; break end

        self.current_enemy = self.current_enemy + 1

        if self.current_enemy > #self.enemies then
            self.current_enemy = 1
        end
    until (self:canSelectEnemy(self:getCurrentEnemy()))

    if last_enemy ~= self.current_enemy then
        Game.battle:playMoveSound()
    end

    self:refresh()
end

function LightBattleEnemySelect:previousEnemy()
    if #self.enemies < 1 then return end

    local last_enemy = self.current_enemy

    local give_up = 0
    repeat
        give_up = give_up + 1
        if give_up > 100 then self.current_enemy = 1; break end

        self.current_enemy = self.current_enemy - 1

        if self.current_enemy < 1 then
            self.current_enemy = #self.enemies
        end
    until (self:canSelectEnemy(self:getCurrentEnemy()))
    
    if last_enemy ~= self.current_enemy then
        Game.battle:playMoveSound()
    end

    self:refresh()
end

function LightBattleEnemySelect:select(enemy, can_select)
    if can_select then
        Game.battle:playSelectSound()
    end

    if self.select_callback then
        self.select_callback(enemy.data, can_select)
    end
end

function LightBattleEnemySelect:cancel()
    if self.cancel_callback then
        self.cancel_callback()
    end

    self:clear()
end

function LightBattleEnemySelect:update()
    if self.menu_active then
        self:snapSoulToItem()
    end

    super.update(self)
end

function LightBattleEnemySelect:snapSoulToItem()
    if Game.battle.soul and self:hasEnemies() then
        if self:getCurrentText() then
            local x, y = self:getCurrentText():getRelativePosFor(Game.battle)
            Game.battle.soul:setPosition(x - 27, y + 16)
        else
            Game.battle.soul:setPosition(0, 0)
        end
    end
end

function LightBattleEnemySelect:clear()
    self.visible = false

    self.enemies = {}

    self.hide_health = nil

    self.select_callback = nil
    self.cancel_callback = nil

    for _,text in ipairs(self.text) do
        text:clear()
    end
end

function LightBattleEnemySelect:drawArrows()
    Draw.setColor(COLORS.WHITE)
    if #self.enemies > 3 then
        local x, y = 477, 10
        local y_offset = Utils.round((math.min((Kristal.getTime() % 1), 0.5) * 6))

        if self.page > 1 then
            Draw.draw(self.arrow_sprite, x - 4.5, -y_offset - 3)
        end

        if self.page < math.ceil((#self.enemies + 1) / LightBattleEnemySelect.ENEMIES_PER_PAGE) then
            Draw.draw(self.arrow_sprite, x - 4.5, 97 + y_offset, 0, 1, -1)
        end
    end
end

function LightBattleEnemySelect:draw()
    self:drawArrows()

    if DEBUG_RENDER then
        if self.menu_active and self.page then
            love.graphics.print(self.page, 0, -62)
        end
    end
    super.draw(self)
end

return LightBattleEnemySelect
local LightHelpWindow, super = Class(Object)

function LightHelpWindow:init(x, y, top)
    super.init(self, x, y)

    self.showing = false
    self.top = top ~= false

    self.box_fill = Rectangle(0, 0, 560, 38)
    self.box_fill:setOrigin(0.5)
    self.box_fill.color = COLORS.black
    self:addChild(self.box_fill)

    self.box_line = Rectangle(0, 0, 560, 38)
    self.box_line.line = true
    self.box_line.line_width = 5
    self.box_fill:addChild(self.box_line)

    self.description_text = Text("", 14, 1, 539, 34, {color = COLORS.gray, font = "main_mono"})
    self.box_fill:addChild(self.description_text)

    self.cost_text = Text("", 10, 1, 539, 34, {align = "right", font = "main_mono"})
    self.box_fill:addChild(self.cost_text)
end

function LightHelpWindow:update()
    local battle = Game.battle
    local item = battle.state == "MENUSELECT" and #battle.menu_items > 0 and Game.battle.menu_items[Game.battle:getItemIndex()]
    if item and (#item.description > 0 or (item.tp and item.tp > 0)) then
        if not self.showing then
            self.showing = true
            if self.top then
                self.y = 272
                Game.battle.timer:tween(6 / 30, self, {y = 235}, "out-cubic")
                if Game.battle.tension_bar then
                    Game.battle.timer:tween(6 / 30, Game.battle.tension_bar, {y = 16}, "out-cubic")
                end
            else
                self.y = 369.5
                Game.battle.timer:tween(6 / 30, self, {y = 407}, "out-cubic")
            end
        end
    else
        if self.showing then
            self.showing = false
            if self.top then
                Game.battle.timer:tween(6 / 30, self, {y = 272}, "out-cubic")
                if Game.battle.tension_bar then
                    Game.battle.timer:tween(6 / 30, Game.battle.tension_bar, {y = 54}, "out-cubic")
                end
            else
                Game.battle.timer:tween(6 / 30, self, {y = 369.5}, "out-cubic")
            end
        end
    end
    
    super.update(self)
end

function LightHelpWindow:draw()
    local arena_ox, arena_oy = Game.battle.arena:getOffset()
    love.graphics.translate(arena_ox, arena_oy)
    local objects = TableUtils.copy(self.box_fill.children)
    table.insert(objects, 1, self.box_fill)
    for _, object in ipairs(objects) do
        object.debug_rect = {arena_ox, arena_oy, object.width, object.height}
    end
    
    self.box_line.color = Game.battle.arena:getBorderColor()
    self.cost_text.color = Game.battle:hasReducedTension() and MG_PALETTE["tension_desc_reduced"] or MG_PALETTE["tension_desc"]
    
    super.draw(self)
end

function LightHelpWindow:setDescription(text)
    local str = text:gsub('\n', ' ')
    self.description_text:setText("[shake:"..Mod.libs["magical-glass"].light_battle_shake_text.."]" .. str)
end

function LightHelpWindow:setTension(tension)
    if tension ~= 0 then
        self.cost_text:setText("[shake:"..Mod.libs["magical-glass"].light_battle_shake_text.."]" .. tostring(tension).."% "..Kristal.getLibConfig("magical-glass", "light_battle_tp_name"))
    else
        self.cost_text:setText("")
    end
end

return LightHelpWindow
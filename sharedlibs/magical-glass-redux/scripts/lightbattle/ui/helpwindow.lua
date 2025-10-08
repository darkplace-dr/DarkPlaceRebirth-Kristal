local HelpWindow, super = Class(Object)

function HelpWindow:init(x, y)
    super.init(self, x, y)

    self.showing = false

    self.box_fill = Rectangle(0, 0, 560, 45)
    self.box_fill:setOrigin(0.5)
    self.box_fill.color = COLORS.black
    self:addChild(self.box_fill)

    self.box_line = Rectangle(0, 0, 560, 45)
    self.box_line.line = true
    self.box_line.line_width = 5
    self.box_fill:addChild(self.box_line)

    self.description_text = Text("", 14, 1, 400, 32, {color = COLORS.gray, font = "main_mono"})
    self.box_fill:addChild(self.description_text)

    self.cost_text = Text("", 10, 1, 539, 32, {color = MG_PALETTE["tension_desc"], align = "right", font = "main_mono"})
    self.box_fill:addChild(self.cost_text)
end

function HelpWindow:toggleVisibility(value)
    if value then
        self.box_fill.visible = true
        self.box_line.visible = true
        self.description_text.visible = true
        self.cost_text.visible = true
    else
        self.box_fill.visible = false
        self.box_line.visible = false
        self.description_text.visible = false
        self.cost_text.visible = false
    end
end

function HelpWindow:update()
    local battle = Game.battle
    self.box_line.color = Game.battle.arena:getBorderColor()
    if (battle.state == "MENUSELECT" and #battle.menu_items > 0) then
        local item = battle.state == "MENUSELECT" and Game.battle.menu_items[Game.battle:getItemIndex()]
        if (#item.description > 0 or (item.tp and item.tp > 0)) then
            if not self.showing then
                self.showing = true
               if Kristal.getLibConfig("magical-glass", "deltatraveler_crits") then
                TweenManager.tween(self, {y = 237}, 10, "outCubic")
                else
                TweenManager.tween(self, {y = 237}, 6, "outCubic")
                end
                if Game.battle.tension_bar then
               if Kristal.getLibConfig("magical-glass", "deltatraveler_crits") then
                    TweenManager.tween(Game.battle.tension_bar, {y = 17}, 10, "outCubic")
               else
                    TweenManager.tween(Game.battle.tension_bar, {y = 17}, 6, "outCubic")
               end
                end
				if Mod.libs["enemy_tension_bar"] and Game.battle.enemy_tension_bar then
					TweenManager.tween(Game.battle.enemy_tension_bar, {y = 17}, 6, "outCubic")
				end
            end
        else
            if self.showing then
                self.showing = false
                TweenManager.tween(self, {y = 280}, 6, "outCubic")
                if Game.battle.tension_bar then
                    TweenManager.tween(Game.battle.tension_bar, {y = 56}, 6, "outCubic")
                end
				if Mod.libs["enemy_tension_bar"] and Game.battle.enemy_tension_bar then
					TweenManager.tween(Game.battle.enemy_tension_bar, {y = 56}, 6, "outCubic")
				end
            end
        end
    else
        if self.showing then
            self.showing = false
            TweenManager.tween(self, {y = 280}, 6, "outCubic")
            if Game.battle.tension_bar then
                TweenManager.tween(Game.battle.tension_bar, {y = 56}, 6, "outCubic")
            end
			if Mod.libs["enemy_tension_bar"] and Game.battle.enemy_tension_bar then
				TweenManager.tween(Game.battle.enemy_tension_bar, {y = 56}, 6, "outCubic")
			end
        end
    end
    
    super.update(self)
end

function HelpWindow:setDescription(text)
    local str = text:gsub('\n', ' ')
    self.description_text:setText("[shake:"..MagicalGlassLib.light_battle_shake_text.."]" .. str)
end

function HelpWindow:setTension(tension)
    if tension ~= 0 then
        self.cost_text:setText("[shake:"..MagicalGlassLib.light_battle_shake_text.."]" .. tostring(tension).."% "..Kristal.getLibConfig("magical-glass", "light_battle_tp_name"))
    else
        self.cost_text:setText("")
    end
end

return HelpWindow
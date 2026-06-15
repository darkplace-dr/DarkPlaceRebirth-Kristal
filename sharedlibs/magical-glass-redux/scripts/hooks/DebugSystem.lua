local DebugSystem, super = HookSystem.hookScript(DebugSystem)

function DebugSystem:init()
    super.init(self)

    self.light_selected_waves = {}
end

function DebugSystem:refresh()
    super.refresh(self)

    self.light_selected_waves = {}
end

function DebugSystem:update()
    super.update(self)

    if self:isMenuOpen() then
        for state, menus in pairs(self.exclusive_battle_menus) do
            if state == "DARKBATTLE" then
                state = false
            elseif state == "LIGHTBATTLE" then
                state = true
            end
            if TableUtils.contains(menus, self.current_menu) and type(state) == "boolean" and Game.battle and Game.battle.light ~= state then
                self:refresh()
            end
        end
        for state, menus in pairs(self.exclusive_world_menus) do
            if state == "DARKWORLD" then
                state = false
            elseif state == "LIGHTWORLD" then
                state = true
            end
            if TableUtils.contains(menus, self.current_menu) and type(state) == "boolean" and Game:isLight() ~= state then
                self:refresh()
            end
        end
    end
end

function DebugSystem:returnMenu()
    super.returnMenu(self)

    if not (#self.menu_history == 0) then
        self.menu_target_y = 0
    end
end

function DebugSystem:enterMenu(menu, soul, skip_history)
    super.enterMenu(self, menu, soul, skip_history)

    self.menu_target_y = 0
end

return DebugSystem
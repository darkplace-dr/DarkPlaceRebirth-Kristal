---@class MainMenuTitle : StateClass
---
---@field menu MainMenu
---
---@field logo love.Image
---@field has_target_saves boolean
---
---@field options table
---@field selected_option number
---
---@overload fun(menu:MainMenu) : MainMenuTitle
local MainMenuTitle, super = Class(StateClass)

function MainMenuTitle:init(menu)
    self.menu = menu

    local str_a, str_b = "Press [bind:confirm]", "to continue"
    self.continue_str = str_a .. " " .. str_b
    -- Same workaround as MainMenuWarning
    self.continue_str_gamepad = str_a .. str_b
    self.continue_text = Text("ass", 0, 360, SCREEN_WIDTH, nil, {
        font = "small",
        align = "center"
    })
    self.continue_text:addFX(OutlineFX_V2({ 0, 0, 0, 1 }, {
        thickness = 2
    }), "outline")

    self.debounce = false
end

function MainMenuTitle:update()
    -- Do nothing?
end

function MainMenuTitle:registerEvents()
    self:registerEvent("enter", self.onEnter)
    self:registerEvent("keypressed", self.onKeyPressed)
    self:registerEvent("update", self.update)
    self:registerEvent("draw", self.draw)
end

-------------------------------------------------------------------------------
-- Callbacks
-------------------------------------------------------------------------------

function MainMenuTitle:onEnter(old_state)
    self.menu.heart_target_x = -40
    self.menu.heart_target_y = -40
    if old_state == "NONE" then
        self.menu.heart.x = self.menu.heart_target_x
        self.menu.heart.y = self.menu.heart_target_y
    end

    if self.menu.kristal_stage_title then
        self.menu.kristal_stage_title:remove()
    end

    self.menu.kristal_stage_title = TitleLogo(320, 180, self.menu.splash)
    MainMenu.stage:addChild(self.menu.kristal_stage_title)

    self.continue_text:setText(Input.usingGamepad() and self.continue_str_gamepad or self.continue_str)
    self.continue_text.alpha = 1
    self.continue_text:setParent(MainMenu.stage)

    self.debounce = false
end

function MainMenuTitle:onKeyPressed(key, is_repeat)
    if Input.isConfirm(key) and not self.debounce then
        self.debounce = true
		self.continue_text:fadeOutAndRemove(0.5)
        MainMenu.stage.timer:tween(
            0.5, self.menu.kristal_stage_title,
            { x = 140, y = 90, scale_x = 0.5, scale_y = 0.5, fade = 0 }, "out-quad",
            function()
                self.menu:setState("SUBTITLE")
            end
        )
	end
end

function MainMenuTitle:draw()
	love.graphics.setColor(1, 1, 1, 1)
end

return MainMenuTitle
